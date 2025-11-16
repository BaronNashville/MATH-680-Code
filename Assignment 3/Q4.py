import torch
import torch.nn as nn
import torch.optim as optim
import torchvision
import torchvision.transforms as transforms
import numpy as np
from torch.utils.data import DataLoader

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print(device)

# Loading the CIFAR 10 train and test dataset with some altering of the pictures

transform = transforms.Compose([
    transforms.RandomCrop(32, padding=4),
    transforms.RandomHorizontalFlip(),
    transforms.ToTensor(),
])

train_dataset = torchvision.datasets.CIFAR10(
    root='./data',
    train=True,
    transform=transform,
    download=True
)

test_dataset = torchvision.datasets.CIFAR10(
    root='./data',
    train=False,
    transform=transform,
    download=True
)

train_loader = DataLoader(train_dataset, batch_size = 256, shuffle=True)
test_loader = DataLoader(test_dataset, batch_size = 256, shuffle=False)


# Define the encoder network

class Encoder(nn.Module):
    def __init__(self, input_dim=3072, hidden_dim=1024, z_dim=64):
        super().__init__()
        self.net = nn.Sequential(
            nn.Linear(input_dim, hidden_dim),
            nn.ReLU(),
            nn.Linear(hidden_dim, z_dim)
        )

    def forward(self, x):
        z = self.net(x)
        # Normalize to hypersphere
        z = z / (z.norm(dim=1, keepdim=True) + 1e-8)
        return z


# Custom loss function

def align_loss(z, labels, alpha):
    # Computing alignment loss on each pair
    distance = torch.cdist(z ,z, p=2)
    alpha_distance = distance ** alpha

    # Creating a mask to only sample the positive pairs
    mask = (labels.unsqueeze(1) == labels.squeeze(0)).float()
    mask.fill_diagonal_(0)

    return (alpha_distance * mask).sum() / mask.sum()

def uniform_loss(z, t):
    distance = torch.cdist(z ,z, p=2)
    square_distance = distance ** 2

    return torch.exp(-t * square_distance).mean().log()

def loss(z, labels, alpha, t, L):
    return (1-L) * align_loss(z, labels, alpha) + L * uniform_loss(z, t)

# Loop over different lambda

L_vals = np.linspace(0,1,11)
accuracy_vals = np.zeros(len(L_vals))

for i, L in enumerate(L_vals):
  print("L = " + str(L))

  # Training loop

  encoder = Encoder().to(device)
  optimizer = optim.Adam(encoder.parameters(), lr=1e-3)
  encoder_epochs = 20

  #print("Begin training encoder")
  for epoch in range(encoder_epochs):
      #print("Epoch " + str(epoch+1))
      for images, labels in train_loader:
        images, labels = images.to(device), labels.to(device)
        z = encoder(images.view(images.size(0), -1))
        batch_loss = loss(z, labels, alpha=2, t=2, L=L)
        optimizer.zero_grad()
        batch_loss.backward()
        optimizer.step()

  #print("Training of encoder complete.")

  # Creating the linear probe

  latent_dim = 64
  num_classes = 10

  linear_probe = nn.Linear(latent_dim, num_classes).to(device)
  criterion = nn.CrossEntropyLoss()
  optimizer = optim.Adam(linear_probe.parameters(), lr=1e-2)
  probe_epochs = 10

  # Freeze my encoder
  encoder.eval()
  for param in encoder.parameters():
      param.requires_grad = False

  #print("Begin training linear probe")

  for epoch in range(probe_epochs):
      #print("Epoch " + str(epoch+1))
      for images, labels in train_loader:
          images, labels = images.to(device), labels.to(device)
          with torch.no_grad():
              z = encoder(images.view(images.size(0), -1))
          batch_loss = criterion(linear_probe(z), labels)
          optimizer.zero_grad()
          batch_loss.backward()
          optimizer.step()

  #print("Training of linear classifier complete.")

  # We now test the accuracy of the linear probe on the test data
  linear_probe.eval()
  for param in linear_probe.parameters():
      param.requires_grad = False

  correct = 0
  total = 0

  for images, labels in test_loader:
      images, labels = images.to(device), labels.to(device)
      with torch.no_grad():
          z = encoder(images.view(images.size(0), -1))
          logits = linear_probe(z)
      predictions = torch.argmax(logits, dim=1)
      correct += (predictions == labels).float().sum()
      total += len(labels)
  accuracy = correct / total * 100
  accuracy_vals[i] = accuracy

  print("Percentage accuracy of the linear probe for L = " + str(L) + " is " + str(float(accuracy)))

import matplotlib.pyplot as plt
plt.plot(L_vals, accuracy_vals)
plt.xlabel("L")
plt.ylabel("Accuracy")
plt.show()
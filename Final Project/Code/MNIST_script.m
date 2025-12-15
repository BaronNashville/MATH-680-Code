% This code will use PCA, PCA+, and PCA++ on the 
% MNIST dataset containing labelled hand written digits
% We will only focus on the '0' and '1' digits. To illustrate the
% strenght of PCA+ and PCA++, we will superimpose each image
% with a strong background

% Figure 6 reproducing figure 4 from the paper

% Load the data from the MNIST dataset and extract the '0' and '1' images
T = readtable("mnist_train.csv", "ReadVariableNames",false);
N = 5000;

labels = table2array(T(:,1));

% Normalize so 0 = white and 1 = black
images = table2array(T(:,2:end))/255;

[labels, ind] = sort(labels, "ascend");
images = images(ind,:);

% See how many zeros we have
first_1 = find(labels == 1, 1);

zero_digits = images(1:N,:);
one_digits = images(first_1:first_1 + N-1,:);

% Create a strong background signal
m = 5;
B = rand(28*28,m);
B = GramSchmidt(B);

lambda_B = 1e2* (ones(1,m) + normrnd(0,1, [1, m]));

B = sqrt(lambda_B) .* B;

% Create the paired data
shared_signal = [zero_digits; one_digits];

background_1 = (B * normrnd(0,1, [m, 2*N]))';
background_2 = (B * normrnd(0,1, [m, 2*N]))';

X = shared_signal + background_1;
Xp = shared_signal + background_2;

% Center the data
center_matrix = (eye(2*N) - 1/(2*N) * ones(2*N));

center_shared = center_matrix * shared_signal;
center_X = center_matrix * X;
center_Xp = center_matrix * Xp;

% Do PCA on the original data to recover true 1st and 2st principal components
[original_components, original_variances] = PCA(center_shared, 2);

% Apply PCA
[reg_components, reg_variance] = PCA([center_X;center_Xp],2);
reg_projections = [center_X;center_Xp] * reg_components;

% Group up the '0' and '1' data points
reg_zeros = [reg_projections(1:N,:); reg_projections(2*N+1:3*N,:)];
reg_ones = [reg_projections(N+1:2*N,:); reg_projections(3*N+1:4*N,:)];

% Apply PCA+
[p_components, p_variance] = PCAp(center_X, center_Xp, 2);
p_projections = [center_X;center_Xp] * p_components;

p_zeros = [p_projections(1:N,:); p_projections(2*N+1:3*N,:)];
p_ones = [p_projections(N+1:2*N,:); p_projections(3*N+1:4*N,:)];

% Apply PCA++ s = 10
[pp_components, pp_variance] = truncated_PCApp(center_X, center_Xp, 2, 10);
pp_projections = [center_X;center_Xp] * pp_components;

pp_zeros = [pp_projections(1:N,:); pp_projections(2*N+1:3*N,:)];
pp_ones = [pp_projections(N+1:2*N,:); pp_projections(3*N+1:4*N,:)];

f = figure(7);
subplot(1,3,1)
hold on
scatter(reg_zeros(:,1), reg_zeros(:,2), 'r', 'filled','DisplayName','Zero')
scatter(reg_ones(:,1), reg_ones(:,2), 'b', 'filled', 'DisplayName','One')
title("PCA on '0' or '1' MNIST Digit Dataset")
xlabel("Projection on PC1")
ylabel("Projection on PC2")
legend

subplot(1,3,2)
hold on
scatter(p_zeros(:,1), p_zeros(:,2), 'r', 'filled','DisplayName','Zero')
scatter(p_ones(:,1), p_ones(:,2), 'b', 'filled', 'DisplayName','One')
title("PCA+ on '0' or '1' MNIST Digit Dataset")
xlabel("Projection on PC1")
ylabel("Projection on PC2")
legend

subplot(1,3,3)
hold on
scatter(pp_zeros(:,1), pp_zeros(:,2), 'r', 'filled','DisplayName','Zero')
scatter(pp_ones(:,1), pp_ones(:,2), 'b', 'filled', 'DisplayName','One')
title("PCA++ (s = 10) on '0' or '1' MNIST Digit Dataset")
xlabel("Projection on PC1")
ylabel("Projection on PC2")
legend

if save_plots
    savefig(f, "../Figures/MNIST.fig")
end

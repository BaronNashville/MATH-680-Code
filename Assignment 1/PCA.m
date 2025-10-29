function [components, eigenvalues]= PCA(X, n)
% Perform PCA on the matrix X to obtain the first n principle components and their associsated eigenvalues

N = size(X,1);

% S = sample covariance matrix
S = 1/N * transpose(X) * X;

% Compute its eigenvectors and eigenvalues
[components, eigenvalues] = eig(S, "vector");

% Sort from largest to smallest
[eigenvalues, ind] = sort(eigenvalues, "descend");
components = components(:, ind);

% Return principal components
components = components(:, 1:n);
eigenvalues = eigenvalues(1:n);
end
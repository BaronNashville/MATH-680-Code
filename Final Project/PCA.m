function [components, variances] = PCA(X, k)
% Computes the normal PCA of dataset X
% Where the rows of X are data points

N = size(X,1);

% Use the SVD of X to compute eigendecomposition of covariance matrix
[U, E, V] = svd(X, "econ", "vector");

variances = 1/N * E(1:k).^2;
components = V(:,1:k);






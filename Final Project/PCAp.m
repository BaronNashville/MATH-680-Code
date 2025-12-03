function [components, variances] = PCAp(X,Xp,k)
% Computes the PCA+ of dataset X
% Where the rows of X are data points

N = size(X,1);

% Use the SVD of X to compute eigendecomposition of covariance matrix
Sp = 1/(2*N) * (X'*Xp + X'*Xp);
[U, E, V] = svd(Sp, "econ", "vector");

variances = E(1:k).^2;
components = V(:,1:k);
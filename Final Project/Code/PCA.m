function [components, variances] = PCA(X, k)
% Computes the normal PCA of dataset X
% Inputs
% - X : Data (each data point is a row)
% - k : number of components
% Outputs
% - components : First k principal components
% - variances : Variance associated to first k principal components

N = size(X,1);

% Compute eigendecomposition of covariance matrix
[vectors, values] = eig(1/N * (X' * X), "vector");
[values, ind] = sort(values, "descend");
vectors = vectors(:, ind);

% Return largest k components
variances = values(1:k);
components = vectors(:,1:k);






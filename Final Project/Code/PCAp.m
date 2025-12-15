function [components, variances] = PCAp(X,Xp,k)
% Computes the PCA+ of dataset X
% Inputs
% - X, Xp : paired data (each data point is a row)
% - k : number of components
% Outputs
% - components : first k principal components
% - variances : variance associated to first k principal components

N = size(X,1);

% Compute eigendecomposition of covariance matrix
Sp = 1/(2*N) * ((X'*Xp) + (Xp'*X));
[vectors, values] = eig(Sp, "vector");
[values, ind] = sort(values, "descend");
vectors = vectors(:, ind);

% Return largest k components
variances = values(1:k);
components = vectors(:,1:k);
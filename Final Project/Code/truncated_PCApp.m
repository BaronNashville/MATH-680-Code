function [components, variances] = truncated_PCApp(X,Xp,k,s)
% Computes the PCA++ of dataset X
% Inputs
% - X, Xp : paired data (each data point is a row)
% - k : number of components
% Outputs
% - components : first k principal components
% - variances : variance associated to first k principal components

epsilon = 1e-1;

[N,p] = size(X);

% Compute eigendecomposition of covariance matrix
S = 1/N * (X' * X);
[U, E, V] = svd(S);
lambdax = zeros(p,p);
lambdax(1:s,1:s) = E(1:s,1:s);
Vx = zeros(p,p);
Vx(:,1:s) = U(:,1:s);
R = Vx*diag((diag(lambdax + epsilon * eye(p))).^(-1/2));
Sp = 1/(2*N) * ((X'*Xp) + (Xp'*X));
M = R' * Sp * R;

% Compute eigendecomposition of M
[U, lambda] = eig(M, "vector");
vectors = Vx * U;

[lambda, ind] = sort(lambda, "descend");
vectors = vectors(:,ind);

% Return largest k components
variances = lambda(1:k);
components = vectors(:,1:k);



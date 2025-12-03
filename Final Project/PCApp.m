function [components, variances] = PCApp(X,Xp,k)
% Implementing PCA++
epsilon = 1e-5;

(N,d) = size(X,1);

[Ux, Ex, Vx] = svd(X, "econ");
Sp = 1/(2*N) * (X'*Xp + X'*Xp);

R = V*(1/Nx * Ex.^2 + epsilon * eye(d)).^(-1/2);
M = R' * Sp * R;

% M is symmetric so can use svd to obtain eigenvectors
[U, E, V] = svd(M, "econ", "vector");
tmp = Vx*V
components = tmp(:,1:k);
variances = E(1:k);


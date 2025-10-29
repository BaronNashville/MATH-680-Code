function [beta] = RidgeOptimization(X,Y,lam)
% Computing the minimization of the problem ||Y - X beta||^2 + lambda ||beta||^2

[n,p] = size(X);

% Computing Y_tilde and X_tilde
Y_bar = 1/n * sum(Y);
Y_tilde = Y - Y_bar;

x_bar = 1/n * ones(1,n)*X(:,2:end);
X_tilde = X(:,2:end) - ones(n,1)*x_bar;

% Computing beta_hat
beta = zeros(p,1);

[U,S,V] = svd(X_tilde, 'econ');


beta(2:end) = V* diag(diag(S) ./ (diag(S).^2 + lam)) *transpose(U)*Y_tilde;
%beta(2:end) = (transpose(X_tilde)*X_tilde + lam*eye(p-1)) \ (transpose(X_tilde)*Y_tilde);
beta(1) = Y_bar - x_bar * beta(2:end);
end

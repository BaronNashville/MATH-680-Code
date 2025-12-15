function [real_components, eigenvalues]= SparsePCA(X, n)
% Perform Sparse PCA on the matrix X to obtain the first n principle components and their associsated eigenvalues

[N,D] = size(X);

% S = sparse PCA matrix
S = 1/N * X * transpose(X);

% Compute its eigenvectors and eigenvalues
[components, eigenvalues] = eig(S, "vector");

% Sort from largest to smallest
[eigenvalues, ind] = sort(eigenvalues, "descend");
components = components(:, ind);

real_components = zeros(D,n);

% Recover eigenvectors of X' X
for i = 1:n
    real_components(:,i) = 1/sqrt(N*eigenvalues(i)) * transpose(X) *  components(:,i);
end

% Return principal components
eigenvalues = eigenvalues(1:n);
end
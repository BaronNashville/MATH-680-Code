function projections = kPCA(X,k,kernel)
% Computes the kernel PCA of dataset X
% Inputs
% - X : Data (each data point is a row)
% - k : number of components
% - kernel : kernel operator (symmetric)
% Outputs
% - projections : projection of each data point along the first k principal components

N = size(X,1);

% Create the kernel matrix
K = zeros(N,N);
for i = 1:N
    for j = 1:N
        K(i,j) = kernel(X(i,:), X(j,:));
    end
end

% Compute eigendecomposition of kernel matrix
[kernel_vectors, kernel_values] = eig(K, "vector");
[kernel_values, ind] = sort(kernel_values, "descend");
kernel_vectors = kernel_vectors(:, ind);

kernel_vectors = kernel_vectors ./ kernel_values';

projections = (kernel_vectors(:,1:k)' * K)';

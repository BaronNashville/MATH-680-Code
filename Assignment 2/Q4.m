% Defining P
W = [
    0 1 1 0 0 0
    0 0 1 0 0 0
    1 1 0 0 1 1
    0 0 0 0 1 1
    0 0 0 1 0 1
    0 0 1 1 1 0  
];
D = diag([2,1,4,2,2,3]);
P = 0.15/6 * ones(6) + 0.85 * (D \ W);
% Computing stationnary distribution using eigendecomposition
[V,values] = eig(transpose(P));
stationnary_eig = transpose(V(:,1));
if stationnary_eig(1) < 0
    stationnary_eig = -stationnary_eig;
end
% Computing stationnary distribution using interation
stationnary_iter = ones(1,6);
while norm(stationnary_iter - stationnary_iter* P) > 1e-15
    stationnary_iter = stationnary_iter * P;
    stationnary_iter = stationnary_iter / norm(stationnary_iter);
end


function dist = principal_angle_distance(A, B)
% Computes the principal angle distance between the subspaces spanned
% subspaces spanned by the orthonormal columns of A and B
[U, S, V] = svd(A' * B, 'econ', 'vector');

dist = max(abs(sin(acos(S))));
end
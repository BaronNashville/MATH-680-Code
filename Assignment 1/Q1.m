V = [
    0   1   -3  -1
    -1  -3  -4  -3
    2   1   1   5
    0   -1  2   0
    2   2   1   7
    ];

x = [
    -1
    -9
    -1
    4
    1
   ];

% Turn into orthonormal basis
Q = GramSchmidt(V);

% Apply projecting formula for orthonormal basis
proj = Q*transpose(Q)*x

% Compute distance to projection
d = norm(proj - x, 2)
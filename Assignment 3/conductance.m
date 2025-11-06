function cond = conductance(S,A,D)
% Computing the conductance of set S in a graph with
% adjacency matrix A and degree matrix D

degree_in = 0;
degree_ext = 0;
degree_out = 0;

n = size(D,1);

for i = 1:n
    for j = 1:n
        if S(i) == 1 && S(j) == 0
            degree_out = degree_out + A(i,j);
        end        
    end
    if S(i) == 1
        degree_in = degree_in + D(i,i);
    else
        degree_ext = degree_ext + D(i,i);
    end
end

cond = degree_out/min(degree_in, degree_ext);

end
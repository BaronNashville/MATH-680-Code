% Download all the data

friend_table = readtable("./cs168mp6.csv", ReadVariableNames=false);
friend_data = table2array(friend_table);

% Verify number of people
head_count = zeros(1495,1);
for i = 1:size(friend_data,1)
    head_count(friend_data(i,1)) = 1;
    head_count(friend_data(i,2)) = 1;
end
find(~head_count,1);

n = 1495;

% Computing the adjacency graph
A = zeros(n);

for i = 1:size(friend_data,1)
    A(friend_data(i,1), friend_data(i,2)) = 1;
    A(friend_data(i,2), friend_data(i,1)) = 1;
end

% Computing degree matrix
D = diag(sum(A,2));

% Computing laplacian matrix
L = D - A;

[vectors, values] = eig(L, "vector");
[values, ind] = sort(values);
vectors = vectors(:, ind);
disp("12 smallest eigenvalues of L")
disp(values(1:12))

% Computing connected components
num_connected = 0;
for i = 1:n
    if values(i) < 1e-13
        num_connected = num_connected + 1;
    end
end
fprintf("We have %d connected components\n", num_connected);

% computing the size of each connected components
component_assignment = zeros(n,1);
groups_created = 0;
for i = 1:num_connected
    group_values = zeros(num_connected,1);
    for j = 1:n
        % Find non zero values
        if abs(vectors(j,i)) > 2e-2
            % If element has already been assigned a group
            if component_assignment(j) ~= 0
                group_values(component_assignment(j)) = vectors(j,i);
            % Otherwise, see if it matches any of the other groups in the current vector
            else
                % If it does, add it to the known group
                for k = 1:num_connected
                    if abs(vectors(j,i) - group_values(k)) <1e-12
                        component_assignment(j) = k;
                    end
                end
                % If it doesn't, create a new group
                if component_assignment(j) == 0
                    group_values(groups_created+1) = vectors(j,i);
                    component_assignment(j) = groups_created + 1;
                    groups_created = groups_created + 1;
                end
            end
        end
    end
end
component_size = zeros(1, num_connected);
for i = 1:n
    component_size(component_assignment(i)) = component_size(component_assignment(i))+1;
end
fprintf("Component %d has size %d\n", [1:num_connected; component_size])

% Creating the almost disjoint Sets S_1, S_2, S_3

S_1 = zeros(1495,1);

for i = 1:1495
    if abs(vectors(i,13) - 0.0045) < 0.001
        S_1(i) = 1;
    end
end

fprintf("Set S_1 has size %d and conductance %d\n", sum(S_1), conductance(S_1, A, D))

S_2 = zeros(1495,1);

for i = 1:1495
    if abs(vectors(i,30) + 0.014) < 0.001
        S_2(i) = 1;
    end
end

fprintf("Set S_2 has size %d and conductance %d\n", sum(S_2), conductance(S_2, A, D));

S_3 = zeros(1495,1);

for i = 1:1495
    if abs(vectors(i,25) + 0.008) < 0.004
        S_3(i) = 1;
    end
end

fprintf("Set S_3 has size %d and conductance %d\n", sum(S_3), conductance(S_3, A, D));
fprintf("Symmetric difference of S_1, S_2 is %d\n", sum(abs(S_1-S_2)))
fprintf("Symmetric difference of S_1, S_3 is %d\n", sum(abs(S_1-S_3)))
fprintf("Symmetric difference of S_2, S_3 is %d\n", sum(abs(S_2-S_3)))



% Download all the data
song_table = readtable("./songs.csv");

song_features = string(song_table.Properties.VariableNames);
song_data = table2array(song_table);

[n,p] = size(song_data);

% Create the adjacency matrix
A = zeros(n);

for i = 1:n
    for j = i+1:n
        if norm(song_data(i,:)-song_data(j,:)) < 1
            A(i,j) = 1;
            A(j,i) = 1;
        end
    end
end

% Create the degree matrix
D = diag(sum(A,2));

% Create the laplacian and normalized laplacian matrix
L = D - A;
L_norm = diag(diag(D).^(-1/2)) * L * diag(diag(D).^(-1/2));

% Computing the second smallest eigenvector of L and x
[vectors, values] = eig(L, "vector");
[values, ind] = sort(values);
vectors = vectors(:,ind);
x = diag(diag(D).^(-1/2)) * vectors(:,2);

% Building the clusters
cluster_values = zeros(n,1);

for i = 1:n
    if x(i) >= 0
        cluster_values(i) = 2;
    else
        cluster_values(i) = 1;
    end
end

disp("Cluster analysis for the first 5 songs")
disp(cluster_values(1:5))

% Analysing the clusters
mean_feature_1 = zeros(1,p);
mean_feature_2 = zeros(1,p);

counter_1 = 0;
counter_2 = 0;

for i = 1:n    
    if cluster_values(i) == 1
        mean_feature_1 = mean_feature_1 + song_data(i,:);
        counter_1 = counter_1 + 1;
    else
        mean_feature_2 = mean_feature_2 + song_data(i,:);
        counter_2 = counter_2 + 1;
    end
end

mean_feature_1 = mean_feature_1 / counter_1;
mean_feature_2 = mean_feature_2 / counter_2;

mean_difference = abs(mean_feature_1 - mean_feature_2);
[mean_difference, ind] = sort(mean_difference, 'descend');

disp("Top 3 features which differ the most between clusters")
disp(song_features(ind(1:3)))

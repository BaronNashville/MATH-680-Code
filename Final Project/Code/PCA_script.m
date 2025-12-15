% Figure 1: Showcasing PCA on a high dimensional data set

% Read p4dataset2023.txt
data = readtable("p4dataset2023.txt", ReadVariableNames=false);
sex_data = string(table2array(data(:,2)));
location_data = string(table2array(data(:,3)));
genome_data = string(table2array(data(:,4:end)));

N = size(data,1);
D = size(data,2)-3;

% Computing mode for each column
mode = string(zeros(1, D));
for j = 1:D
    bases = ["A", "C", "T", "G"];
    count = [0,0,0,0];
    for i = 1:N
        if genome_data(i,j) == "A"
            count(1) = count(1) + 1;
        elseif genome_data(i,j) == "C"
            count(2) = count(2) + 1;
        elseif genome_data(i,j) == "T"
            count(3) = count(3) + 1;
        elseif genome_data(i,j) == "G"
            count(4) = count(4) + 1;
        end
    end

    [M,ind] = max(count);    
    mode(j) = bases(ind);
end

% Building X
X = zeros(N,D);
for i = 1:N
    for j = 1:D
        if genome_data(i,j) ~= mode(j)
            X(i,j) = 1;
        end
    end
end

% Centering the data
Centered_X = (eye(N) - 1/N * ones(N))*X;
% for j = 1:D
%     avg = 0;
%     for i = 1:N
%         avg = avg + X(i,j);
%     end
%     avg = avg/N;
% 
%     for i = 1:N
%         Centered_X(i,j) = Centered_X(i,j) - avg;
%     end
% end

% Applying PCA and sparse PCA to X and computing projected scores
[components, eigenvalues] = SparsePCA(Centered_X, 3);
scores_PCA1 = components(:,1)'* Centered_X';
scores_PCA2 = components(:,2)'* Centered_X';
scores_PCA3 = components(:,3)'* Centered_X';

locations = ["ACB", "ASW", "ESN", "GWD", "LWK", "MSL", "YRI"];

% Plotting projection onto first 2 principal components

% Sorting according to population location
[location_data, ind] = sort(location_data);
sex_data = sex_data(ind,:);
genome_data = genome_data(ind,:);
scores_PCA1 = scores_PCA1(ind);
scores_PCA2 = scores_PCA2(ind);
scores_PCA3 = scores_PCA3(ind);

f = figure(1);
subplot(1,2,1)
i = 1;
j = 1;
for b = 1:7
    while (j <= N && location_data(j) == locations(b))
        j = j+1;
    end

    scatter(scores_PCA1(i:j-1), scores_PCA2(i:j-1), 'filled', 'DisplayName', locations(b))
    hold on

    i = j;

end
xlabel("Projection on PC1")
ylabel("Projection on PC2")
title("2 dimensional representation of our data from PCA")
legend

% Plotting projection onto first 3 principal components

% Separating the data according to sex
[sex_data, ind] = sort(sex_data);
genome_data = genome_data(ind,:);
location_data = location_data(ind);
scores_PCA1 = scores_PCA1(ind);
scores_PCA2 = scores_PCA2(ind);
scores_PCA3 = scores_PCA3(ind);

last_F = 1;
while(sex_data(last_F+1) == "F")
    last_F = last_F+1;
end

% Sorting the separated data according to location
F_genome_data = genome_data(1:last_F, :);
F_location_data = location_data(1:last_F);
F_scores_PCA1 = scores_PCA1(1:last_F);
F_scores_PCA2 = scores_PCA2(1:last_F);
F_scores_PCA3 = scores_PCA3(1:last_F);

M_genome_data = genome_data(last_F+1:end, :);
M_location_data = location_data(last_F+1:end);
M_scores_PCA1 = scores_PCA1(last_F+1:end);
M_scores_PCA2 = scores_PCA2(last_F+1:end);
M_scores_PCA3 = scores_PCA3(last_F+1:end);

subplot(1,2,2)
i = 1;
j = 1;
for b = 1:7
    while (j <= last_F && F_location_data(j) == locations(b))
        j = j+1;
    end

    scatter3(F_scores_PCA1(i:j-1), F_scores_PCA2(i:j-1), F_scores_PCA3(i:j-1), 'DisplayName', strcat("F ", locations(b)))
    hold on

    i = j;

end

i = 1;
j = 1;
for b = 1:7
    while (j <= N - last_F && M_location_data(j) == locations(b))
        j = j+1;
    end

    scatter3(M_scores_PCA1(i:j-1), M_scores_PCA2(i:j-1), M_scores_PCA3(i:j-1), 'filled', 'DisplayName', strcat("M ", locations(b)))
    hold on

    i = j;

end
xlabel("Projection on PC1")
ylabel("Projection on PC2")
zlabel("Projection on PC3")
title("3 dimensional representaiton of our data from PCA")
legend

if save_plots
    savefig(f, "../Figures/PCA.fig")
end


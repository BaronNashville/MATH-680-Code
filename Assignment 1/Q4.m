clear, clc

% Read medals_2008.csv and turning the data into a matrix
T = readtable("medals_2008.csv");
countries = string(table2array(T(:,1)));
X = table2array(T(:,2:4));
[N,D] = size(X);

% Centering the data
Centered_X = X;
for j = 1:D
    avg = 0;
    for i = 1:N
        avg = avg + X(i,j);
    end
    avg = avg/N;

    for i = 1:N
        Centered_X(i,j) = Centered_X(i,j) - avg;
    end
end

% Performing PCA on the data
[components, eigenvalues] = PCA(Centered_X, 3);

% Computing sample variance
var = 0;
for i = 1:N
    var = var + dot(Centered_X(i,:), Centered_X(i,:));
end
var = var / N;

% Analyzing reconstuction error for 1,2,3 principal components
error_1 = var - eigenvalues(1);
error_2 = var - eigenvalues(1) - eigenvalues(2);
error_3 = var - eigenvalues(1) - eigenvalues(2) - eigenvalues(3);

% Computing the projection coordinates onto the first principal components
scores_PCA = components(:,1)'* Centered_X';
[scores_PCA, ind_PCA] = sort(scores_PCA, "descend");

ranked_countries_PCA = countries(ind_PCA, :);

% Computing scores based on total number of medals
scores_total = [1;1;1]' * Centered_X';
[scores_total, ind_total] = sort(scores_total, "descend");

ranked_countries_total = countries(ind_total, :);

% Computing scores based on number of gold medals
scores_gold = [1;0;0]' * Centered_X';
[scores_gold, ind_gold] = sort(scores_gold, "descend");

ranked_countries_gold = countries(ind_gold, :);

% Printing out information for the problem
fprintf('Principal components 1,2,3\n')
fprintf('b%d = [%f, %f, %f]\n', [1:3;components])
fprintf('lambda%d = %f\n', [1:3;eigenvalues'])

fprintf('\nVariance captured using 1,2,3 principal components\n')
fprintf('Error using %d principal component = %f\n', [1:3; eigenvalues(1), eigenvalues(1) + eigenvalues(2), eigenvalues(1) + eigenvalues(2) + eigenvalues(3)])

fprintf('\nReconstruction error using 1,2,3 principal components\n')
fprintf('Error using %d principal component = %f\n', [1:3; error_1 error_2 error_3])

fprintf('\nComputing different rankings\n')
fprintf('\nRanking according to PCA\n')
fprintf('Rank %f: %s, Score = %f\n', [1:10; ranked_countries_PCA(1:10)'; scores_PCA(1:10)])

fprintf('\nRanking according to gold medals\n')
fprintf('Rank %f: %s, Score = %f\n', [1:10; ranked_countries_gold(1:10)'; scores_gold(1:10)])

fprintf('\nRanking according to total medals\n')
fprintf('Rank %f: %s, Score = %f\n', [1:10; ranked_countries_total(1:10)'; scores_total(1:10)])







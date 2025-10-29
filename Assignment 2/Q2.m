% Reading the input data

% number of users
n = 1000;

% number of movies
m = 500;

train_table = readtable("./train.txt");
test_table = readtable("./test.txt");

train_data = table2array(train_table);
test_data = table2array(test_table);

% Average estimator
% d = 1

U_avg = ones(n, 1);
V_avg = zeros(m, 1);

for i = 1:m
    counter = 0;
    for j = 1:size(train_data,1)
        if train_data(j,2) == i
            V_avg(i) = V_avg(i) + train_data(j,3);
            counter = counter + 1;
        end
    end
    V_avg(i) = V_avg(i)/counter;
end

% SVD Estimator
X = zeros(n,m);
svd_errors_train = zeros(2,6);
svd_errors_test = zeros(2,6);

for j = 1:size(train_data,1)
    X(train_data(j,1), train_data(j,2)) = train_data(j,3);
end

[U,S,V] = svd(X);

% d = 1
Usvd_1 = U(:,1)*S(1,1);
Vsvd_1 = V(:,1);
svd_errors_train(1,1) = MeanSquaredError(train_data, Usvd_1, Vsvd_1);
svd_errors_train(2,1) = MeanAbsoluteError(train_data, n, Usvd_1, Vsvd_1);
svd_errors_test(1,1) = MeanSquaredError(test_data, Usvd_1, Vsvd_1);
svd_errors_test(2,1) = MeanAbsoluteError(test_data, n, Usvd_1, Vsvd_1);

% d = 2
Usvd_2 = U(:,1:2)*S(1:2,1:2);
Vsvd_2 = V(:,1:2);
svd_errors_train(1,2) = MeanSquaredError(train_data, Usvd_2, Vsvd_2);
svd_errors_train(2,2) = MeanAbsoluteError(train_data, n, Usvd_2, Vsvd_2);
svd_errors_test(1,2) = MeanSquaredError(test_data, Usvd_2, Vsvd_2);
svd_errors_test(2,2) = MeanAbsoluteError(test_data, n, Usvd_2, Vsvd_2);

% d = 5
Usvd_5 = U(:,1:5)*S(1:5,1:5);
Vsvd_5 = V(:,1:5);
svd_errors_train(1,3) = MeanSquaredError(train_data, Usvd_5, Vsvd_5);
svd_errors_train(2,3) = MeanAbsoluteError(train_data, n, Usvd_5, Vsvd_5);
svd_errors_test(1,3) = MeanSquaredError(test_data, Usvd_5, Vsvd_5);
svd_errors_test(2,3) = MeanAbsoluteError(test_data, n, Usvd_5, Vsvd_5);

% d = 10
Usvd_10 = U(:,1:10)*S(1:10,1:10);
Vsvd_10 = V(:,1:10);
svd_errors_train(1,4) = MeanSquaredError(train_data, Usvd_10, Vsvd_10);
svd_errors_train(2,4) = MeanAbsoluteError(train_data, n, Usvd_10, Vsvd_10);
svd_errors_test(1,4) = MeanSquaredError(test_data, Usvd_10, Vsvd_10);
svd_errors_test(2,4) = MeanAbsoluteError(test_data, n, Usvd_10, Vsvd_10);

% d = 15
Usvd_15 = U(:,1:15)*S(1:15,1:15);
Vsvd_15 = V(:,1:15);
svd_errors_train(1,5) = MeanSquaredError(train_data, Usvd_15, Vsvd_15);
svd_errors_train(2,5) = MeanAbsoluteError(train_data, n, Usvd_15, Vsvd_15);
svd_errors_test(1,5) = MeanSquaredError(test_data, Usvd_15, Vsvd_15);
svd_errors_test(2,5) = MeanAbsoluteError(test_data, n, Usvd_15, Vsvd_15);

% d = 20
Usvd_20 = U(:,1:20)*S(1:20,1:20);
Vsvd_20 = V(:,1:20);
svd_errors_train(1,6) = MeanSquaredError(train_data, Usvd_20, Vsvd_20);
svd_errors_train(2,6) = MeanAbsoluteError(train_data, n, Usvd_20, Vsvd_20);
svd_errors_test(1,6) = MeanSquaredError(test_data, Usvd_20, Vsvd_20);
svd_errors_test(2,6) = MeanAbsoluteError(test_data, n, Usvd_20, Vsvd_20);

% Minimize loss function estimator
lambda = [1e-5,1e6];

loss_errors_train = zeros(2,5);
loss_errors_test = zeros(2,5);

%d = 1
[Uloss_1, Vloss_1] = MinimizeLoss(train_data, lambda, n, m, 1);
loss_errors_train(1,1) = MeanSquaredError(train_data, Uloss_1, Vloss_1);
loss_errors_train(2,1) = MeanAbsoluteError(train_data, n, Uloss_1, Vloss_1);
loss_errors_test(1,1) = MeanSquaredError(test_data, Uloss_1, Vloss_1);
loss_errors_test(2,1) = MeanAbsoluteError(test_data, n, Uloss_1, Vloss_1);

% d = 2
[Uloss_2, Vloss_2] = MinimizeLoss(train_data, lambda, n, m, 2);
loss_errors_train(1,2) = MeanSquaredError(train_data, Uloss_2, Vloss_2);
loss_errors_train(2,2) = MeanAbsoluteError(train_data, n, Uloss_2, Vloss_2);
loss_errors_test(1,2) = MeanSquaredError(test_data, Uloss_2, Vloss_2);
loss_errors_test(2,2) = MeanAbsoluteError(test_data, n, Uloss_2, Vloss_2);

% d = 3
[Uloss_3, Vloss_3] = MinimizeLoss(train_data, lambda, n, m, 3);
loss_errors_train(1,3) = MeanSquaredError(train_data, Uloss_3, Vloss_3);
loss_errors_train(2,3) = MeanAbsoluteError(train_data, n, Uloss_3, Vloss_3);
loss_errors_test(1,3) = MeanSquaredError(test_data, Uloss_3, Vloss_3);
loss_errors_test(2,3) = MeanAbsoluteError(test_data, n, Uloss_3, Vloss_3);

% d = 4
[Uloss_4, Vloss_4] = MinimizeLoss(train_data, lambda, n, m, 4);
loss_errors_train(1,4) = MeanSquaredError(train_data, Uloss_4, Vloss_4);
loss_errors_train(2,4) = MeanAbsoluteError(train_data, n, Uloss_4, Vloss_4);
loss_errors_test(1,4) = MeanSquaredError(test_data, Uloss_4, Vloss_4);
loss_errors_test(2,4) = MeanAbsoluteError(test_data, n, Uloss_4, Vloss_4);

% d = 5
[Uloss_5, Vloss_5] = MinimizeLoss(train_data, lambda, n, m, 5);
loss_errors_train(1,5) = MeanSquaredError(train_data, Uloss_5, Vloss_5);
loss_errors_train(2,5) = MeanAbsoluteError(train_data, n, Uloss_5, Vloss_5);
loss_errors_test(1,5) = MeanSquaredError(test_data, Uloss_5, Vloss_5);
loss_errors_test(2,5) = MeanAbsoluteError(test_data, n, Uloss_5, Vloss_5);


% Plotting errors
figure(1)
hold on
plot([1;2;5;10;15;20], svd_errors_train(1,:), 'DisplayName','SVD Train MSE');
plot([1;2;5;10;15;20], svd_errors_train(2,:), 'DisplayName','SVD Train MAE');
plot([1;2;5;10;15;20], svd_errors_test(1,:), 'DisplayName','SVD Test MSE');
plot([1;2;5;10;15;20], svd_errors_test(2,:), 'DisplayName','SVD Test MAE');

xlabel("d")
ylabel("Error")
title("SVD Error Analysis")
legend

figure(2)
hold on
plot([1;2;3;4;5], loss_errors_train(1,:), 'DisplayName','Minimize Loss Train MSE');
plot([1;2;3;4;5], loss_errors_train(2,:), 'DisplayName','Minimize Loss Train MAE');
plot([1;2;3;4;5], loss_errors_test(1,:), 'DisplayName','Minimize Loss Test MSE');
plot([1;2;3;4;5], loss_errors_test(2,:), 'DisplayName','Minimize Loss Test MAE');

xlabel("d")
ylabel("Error")
title("Loss Minimization Error Analysis")
legend
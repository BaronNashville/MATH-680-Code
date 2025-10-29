function [beta, best_lam, cv_error] = kfold(X,Y,lam_vec,K)
% This function performs K-fold cross-validation to find optimal parameter lamda

n = size(Y,1);
cv_error = zeros(size(lam_vec));

% Step 1: Separate the data into K groups
group_index = zeros(K+1,1);

C = floor(n/K);
r = rem(n,K);

group_index(1) = 0;
for i = 1:K-1
    if i <= r
        group_index(i+1) = group_index(i) + C + 1;
    else
        group_index(i+1) = group_index(i) + C;
    end
end
group_index(K+1) = n;

% Step 2: Find optimal coefficients for K-1 groups and then rest on the remaining group
best_lam = lam_vec(1);
min_error = Inf;
beta = zeros(size(X,2),1);

for i = 1:length(lam_vec)
    lam = lam_vec(i);
    for j = 1:K
        % Learning on K-1 groups
        X_test = X(group_index(j)+1:group_index(j+1),:);
        Y_test = Y(group_index(j)+1:group_index(j+1));

        X_learn = X;
        X_learn(group_index(j)+1:group_index(j+1),:) = [];
        
        Y_learn = Y;
        Y_learn(group_index(j)+1:group_index(j+1)) = [];
    
        beta_learned = RidgeOptimization(X_learn, Y_learn, lam);

        % Testing on remaining group and updating total error     
        cv_error(i) = cv_error(i) + norm(X_test*beta_learned - Y_test)^2;
    end

    % If total error is less than previous minimum, update the best value of lambda
    if cv_error(i) < min_error
        min_error = cv_error(i);
        beta = beta_learned;
        best_lam = lam;
    end
end

end
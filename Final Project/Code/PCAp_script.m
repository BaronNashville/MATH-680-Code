% Figure 3: Showcasing the strength of PCA+ as opposed to PCA

% Generate some data with baked in linear structure and linear background
N_values = 10.^(1:6);
p = 10;
k = 5;
m = 3;

num_iterations = 10;

for ell = 1:num_iterations
    % Generating orthonormal matrices A and B
    AB = rand(p,k+m);
    AB = GramSchmidt(AB);
    A = AB(:,1:k); B = AB(:,k+1:k+m);
    
    % Defining the associated variance of each row of A, B
    lambda_A = [8,5,3,2,1];
    lambda_B = [20,10,5];
    
    PCA_errors = zeros(1,length(N_values));
    PCAp_errors = zeros(1, length(N_values));
    
    for i = 1:length(N_values)
        N = N_values(i);
        % Generate the data
        shared_data = ((sqrt(lambda_A) .* A) * normrnd(0,1,[k,N]))';
        background_1 = ((sqrt(lambda_B) .* B) * normrnd(0,1,[m,N]))';
        background_2 = ((sqrt(lambda_B) .* B) * normrnd(0,1,[m,N]))';
        
        X = shared_data + background_1 + normrnd(0,1,[N,p]);
        Xp = shared_data + background_2 + normrnd(0,1,[N,p]);
        
        % Apply PCA and recover the top 5 components
        [reg_components, reg_variance] = PCA([X;Xp],2);
        
        % Apply PCA+ and recover the top 5 components
        [p_components, p_variance] = PCAp(X, Xp, 2);
        
        PCA_errors(1,i) = PCA_errors(1,i) + principal_angle_distance(A, reg_components);
        PCAp_errors(1,i) = PCAp_errors(1,i) + principal_angle_distance(A, p_components);
    end
end

PCA_errors = PCA_errors / num_iterations;
PCAp_errors = PCAp_errors / num_iterations;

f = figure(3);
xscale('log')
hold on
plot(N_values, PCA_errors, 'DisplayName', 'PCA')
plot(N_values, PCAp_errors, 'DisplayName', 'PCA+')
title("Subspace estimation error from PCA and PCA+")
xlabel("Number of data samples")
ylabel("Subspace estimation error")
legend

if save_plots
    savefig(f, "../Figures/PCAp.fig")
end


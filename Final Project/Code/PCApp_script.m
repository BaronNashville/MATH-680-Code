% Figure 4: Reproducing figure 1 from the paper showcasing the 
% strength of PCA++ as opposed to PCA+ and PCA in a synthetic example

num_points = 20;
num_iterations = 5;

% Varying background strengths
N = 2000;
p = 800;

PCApp_errors = zeros(num_points,2);
PCAp_errors = zeros(num_points,2);
PCA_errors = zeros(num_points,2);

ratios = 0.2:0.8/(num_points-1):1;

A = zeros(p,1); A(1) = 1; lambda_A = 10;
B = zeros(p,1); B(2) = 1; lambda_B_values = (lambda_A ./ ratios).^2;

for i = 1:num_points
    lambda_B = lambda_B_values(i);

    for ell = 1:num_iterations
        % Generate the data
        shared_data = (sqrt(lambda_A)*A * normrnd(0,1,[1,N]))';
        background_1 = (sqrt(lambda_B)*B * normrnd(0,1,[1,N]))';
        background_2 = (sqrt(lambda_B)*B * normrnd(0,1,[1,N]))';
        
        X = shared_data + background_1 + normrnd(0,1,[N,p]);
        Xp = shared_data + background_2 + normrnd(0,1,[N,p]);
        
        % Apply truncated PCA++ and recover the top component
        [pp_components, pp_variance] = truncated_PCApp(X,Xp,1,2);
        PCApp_errors(i,1) = PCApp_errors(i,1) + principal_angle_distance(A, pp_components);
    
        % Apply PCA+ and recover the top component
        [p_components, p_variance] = PCAp(X,Xp,1);
        PCAp_errors(i,1) = PCAp_errors(i,1) + principal_angle_distance(A, p_components);
    
        % Apply PCA and recover the top component
        [reg_components, reg_variance] = PCA([X;Xp],1);
        PCA_errors(i,1) = PCA_errors(i,1) + principal_angle_distance(A, reg_components);
    end
end

N = 500;
aspect_ratios = 0.1:1.7/(num_points-1):1.8;
p_values = ceil(aspect_ratios * N);

lambda_A = 10; lambda_B = 500;

for i = 1:num_points
    p = p_values(i);

    A = zeros(p,1); A(1) = 1;
    B = zeros(p,1); B(2) = 1;

    for ell = 1:num_iterations
        % Generate the data
        shared_data = (sqrt(lambda_A)*A * normrnd(0,1,[1,N]))';
        background_1 = (sqrt(lambda_B)*B * normrnd(0,1,[1,N]))';
        background_2 = (sqrt(lambda_B)*B * normrnd(0,1,[1,N]))';
        
        X = shared_data + background_1 + normrnd(0,1,[N,p]);
        Xp = shared_data + background_2 + normrnd(0,1,[N,p]);
        
        % Apply truncated PCA++ and recover the top component
        [pp_components, pp_variance] = truncated_PCApp(X,Xp,1,2);
        PCApp_errors(i,2) = PCApp_errors(i,2) + principal_angle_distance(A, pp_components);
    
        % Apply PCA+ and recover the top component
        [p_components, p_variance] = PCAp(X,Xp,1);
        PCAp_errors(i,2) = PCAp_errors(i,2) + principal_angle_distance(A, p_components);
    
        % Apply PCA and recover the top component
        [reg_components, reg_variance] = PCA([X;Xp],1);
        PCA_errors(i,2) = PCA_errors(i,2) + principal_angle_distance(A, reg_components);
    end
end

PCApp_errors = PCApp_errors / num_iterations;
PCAp_errors = PCAp_errors / num_iterations;
PCA_errors = PCA_errors / num_iterations;


f = figure(4);
subplot(1,2,1)
hold on
plot(ratios, PCA_errors(:,1), 'DisplayName', 'PCA')
plot(ratios, PCAp_errors(:,1), 'DisplayName', 'PCA+')
plot(ratios, PCApp_errors(:,1), 'DisplayName', 'PCA++ (s = 2)')
title("PCA vs PCA+ vs PCA++ (s = 2)")
xlabel("Relative strength")
ylabel("Subspace estimation error")
legend

subplot(1,2,2)
hold on
plot(aspect_ratios, PCA_errors(:,2), 'DisplayName', 'PCA')
plot(aspect_ratios, PCAp_errors(:,2), 'DisplayName', 'PCA+')
plot(aspect_ratios, PCApp_errors(:,2), 'DisplayName', 'PCA++ (s = 2)')
title("PCA vs PCA+ vs PCA++ (s = 2)")
xlabel("Aspect ratio (p/N)")
ylabel("Subspace estimation error")
legend

if save_plots
    savefig(f, "../Figures/PCApp.fig")
end
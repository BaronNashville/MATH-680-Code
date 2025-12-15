% Figure 5: Reproducing figure 2 from the paper 
% showcasing the performance of PCA++ compared to its truncations

N = 1000;
aspect_ratios = 0.1:0.1:1.8;
p_values = ceil(N*aspect_ratios);
s_values = [2,0,0,0];

num_iterations = 5;

truncated_PCApp_errors = zeros(length(aspect_ratios),length(s_values));
untruncated_PCApp_errors = zeros(length(aspect_ratios),1);

for i = 1:length(aspect_ratios)
    p = p_values(i);    
    s_values(2:end) = ceil([0.1*p; 0.2*p; 0.4*p]);

    A = zeros(p,1); A(1) = 1;
    B = zeros(p,1); B(2) = 1;

    for ell = 1:num_iterations
        % Generate the data
        shared_data = (sqrt(10)*A * normrnd(0,1,[1,N]))';
        background_1 = (sqrt(500)*B * normrnd(0,1,[1,N]))';
        background_2 = (sqrt(500)*B * normrnd(0,1,[1,N]))';
        
        X = shared_data + background_1 + normrnd(0,1,[N,p]);
        Xp = shared_data + background_2 + normrnd(0,1,[N,p]);

        for j = 1:length(s_values)
            s = s_values(j);
            
            % Apply truncated PCA++ and recover the top component
            [truncated_components, truncated_variance] = truncated_PCApp(X,Xp,1,s);
    
            truncated_PCApp_errors(i,j) = truncated_PCApp_errors(i,j) + principal_angle_distance(A, truncated_components);
        end
        % Apply untruncated PCA++ and recover the top component
        [untruncated_components, untruncated_variance] = untruncated_PCApp(X,Xp,1);
        untruncated_PCApp_errors(i) = untruncated_PCApp_errors(i) + principal_angle_distance(A, untruncated_components);
    end
end

truncated_PCApp_errors = truncated_PCApp_errors / num_iterations;
untruncated_PCApp_errors = untruncated_PCApp_errors / num_iterations;

f = figure(5);
subplot(1,2,1)
hold on
plot(aspect_ratios, untruncated_PCApp_errors, 'DisplayName', 'Untruncated')
plot(aspect_ratios, truncated_PCApp_errors(:,1), 'DisplayName', 'Truncated s = 2')
title("Untruncated PCA++ vs truncated PCA++")
xlabel("Aspect ratio (p/N)")
ylabel("Subspace estimation error")
legend

subplot(1,2,2)
hold on
plot(aspect_ratios, truncated_PCApp_errors(:,1), 'DisplayName', 'Truncated s = 2')
plot(aspect_ratios, truncated_PCApp_errors(:,2), 'DisplayName', 'Truncated s = 0.1N')
plot(aspect_ratios, truncated_PCApp_errors(:,3), 'DisplayName', 'Truncated s = 0.2N')
plot(aspect_ratios, truncated_PCApp_errors(:,4), 'DisplayName', 'Truncated s = 0.4N')
title("PCA++ with varying truncation")
xlabel("Aspect ratio (p/N)")
ylabel("Subspace estimation error")
ylim([0 1])
legend

if save_plots
    savefig(f, "../Figures/PCApp_truncations.fig")
end
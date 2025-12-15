% Figure 5 reproducing figure 3 from the paper

N = 1000;
aspect_ratios_fixed = 0.1:0.1:1.8;
aspect_ratios_growth = 5*aspect_ratios_fixed;
p_values_fixed = ceil(N*aspect_ratios_fixed);
p_values_growth = ceil(N*aspect_ratios_growth);
s = 10;

k = 5;
m = 5;

num_iterations = 1;

% Specify the variances such that lambda > sqrt(c)
lambda_A_fixed = [50, 25, 20, 15, 10];
lambda_B_fixed = [500, 400, 300, 200, 100];

lambda_A_growth = 10 * lambda_A_fixed;
lambda_B_growth = 10 * lambda_B_fixed;

p_error_fixed = zeros(length(aspect_ratios_fixed),1);
pp_error_fixed = zeros(length(aspect_ratios_fixed),1);

p_error_growth = zeros(length(aspect_ratios_fixed),1);
pp_error_growth = zeros(length(aspect_ratios_fixed),1);

for i = 1:length(aspect_ratios_fixed)
    p_fixed = p_values_fixed(i);
    p_growth = p_values_growth(i);

    % Generate the orthogonal matrices A, B
    AB_fixed = rand(p_fixed, k+m);
    AB_fixed = GramSchmidt(AB_fixed);
    A_fixed = AB_fixed(:,1:k); B_fixed = AB_fixed(:,k+1:k+m);

    AB_growth = rand(p_growth, k+m);
    AB_growth = GramSchmidt(AB_growth);
    A_growth = AB_growth(:, 1:k); B_growth = AB_growth(:,k+1:k+m);

    for ell = 1:num_iterations
        % Construct the data
        shared_signal_fixed = (sqrt(lambda_A_fixed) .* A_fixed * normrnd(0,1,[k,N]))';
        background_fixed_1 = (sqrt(lambda_B_fixed) .* B_fixed * normrnd(0,1,[m,N]))';
        background_fixed_2 = (sqrt(lambda_B_fixed) .* B_fixed * normrnd(0,1,[m,N]))';

        X_fixed  = shared_signal_fixed + background_fixed_1 + normrnd(0,1,[N,p_fixed]);
        Xp_fixed  = shared_signal_fixed + background_fixed_2 + normrnd(0,1,[N,p_fixed]);

        shared_signal_growth = (sqrt(lambda_A_growth) .* A_growth * normrnd(0,1,[k,N]))';
        background_growth_1 = (sqrt(lambda_B_growth) .* B_growth * normrnd(0,1,[m,N]))';
        background_growth_2 = (sqrt(lambda_B_growth) .* B_growth * normrnd(0,1,[m,N]))';

        X_growth = shared_signal_growth + background_growth_1 + normrnd(0,1,[N,p_growth]);
        Xp_growth  = shared_signal_growth + background_growth_2 + normrnd(0,1,[N,p_growth]);

        % Apply PCA+
        [p_components_fixed , p_variances_fixed] = PCAp(X_fixed , Xp_fixed , k);
        p_error_fixed(i) = p_error_fixed(i) + principal_angle_distance(p_components_fixed, A_fixed);

        [p_components_growth , p_variances_growth] = PCAp(X_growth , Xp_growth , k);
        p_error_growth(i) = p_error_growth(i) + principal_angle_distance(p_components_growth, A_growth);

        % Apply PCA++ (s = 10)
        [pp_components_fixed , pp_variances_fixed] = truncated_PCApp(X_fixed, Xp_fixed, k, s);
        pp_error_fixed(i) = pp_error_fixed(i) + principal_angle_distance(pp_components_fixed, A_fixed);

        [pp_components_growth , pp_variances_growth] = truncated_PCApp(X_growth, Xp_growth, k, s);
        pp_error_growth(i) = pp_error_growth(i) + principal_angle_distance(pp_components_growth, A_growth);
    end

end
% Theory bound
theory_error_fixed = sqrt(1 - (1 - aspect_ratios_fixed /(lambda_A_fixed(k)^2))./(1 + aspect_ratios_fixed /lambda_A_fixed(k)));
theory_error_growth = sqrt((aspect_ratios_growth / lambda_A_growth(k)) ./ (1 + aspect_ratios_growth / lambda_A_growth(k)));

p_error_fixed = p_error_fixed / num_iterations;
pp_error_fixed = pp_error_fixed / num_iterations;

p_error_growth = p_error_growth / num_iterations;
pp_error_growth = pp_error_growth / num_iterations;

f = figure(6);
subplot(1,2,1)
hold on
plot(aspect_ratios_fixed, p_error_fixed, 'DisplayName','PCA+')
plot(aspect_ratios_fixed, pp_error_fixed, 'DisplayName','PCA++ (s = 10)')
plot(aspect_ratios_fixed, theory_error_fixed, 'DisplayName','PCA++ Theoretical error')
title("Fixed aspect ratio regime")
xlabel("Aspect ratio p / N")
ylabel("Subspace estimation error")
legend

subplot(1,2,2)
hold on
plot(aspect_ratios_growth, p_error_growth, 'DisplayName','PCA+')
plot(aspect_ratios_growth, pp_error_growth, 'DisplayName','PCA++ (s = 10)')
plot(aspect_ratios_growth, theory_error_growth, 'DisplayName','PCA++ Theoretical error')
title("Growing spikes regime")
xlabel("Aspect ratio p / N")
ylabel("Subspace estimation error")
legend

if save_plots
    savefig(f, "../Figures/theory.fig")
end


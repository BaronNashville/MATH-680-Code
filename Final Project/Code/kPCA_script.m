%Figure 2: Showcasing the strength of kPCA as opposed to PCA

%We first create some artificial data with a baked in nonlinear pattern
N = 500;

theta_close = unifrnd(0,2*pi,[N/2,1]);
close = abs(normrnd(1,0.5,[N/2,1])) .* [cos(theta_close), sin(theta_close)] + normrnd(0,0.1,[N/2,2]);

theta_far = unifrnd(0,2*pi,[N/2,1]);
far = abs(normrnd(3,0.5,[N/2,1])) .* [cos(theta_far), sin(theta_far)] + normrnd(0,0.1,[N/2,2]);

f = figure(2);
subplot(1,3,1)
hold on
scatter(close(:,1), close(:,2), 'r', 'filled')
scatter(far(:,1), far(:,2), 'b', 'filled')
title("Original data")

%Compute regular PCA
X = [close;far];
[components, variances] = PCA(X, 2);
reg_projections = X * components;


%Choose a suitable kernel function
%kernel = @(x,y) (dot(x,y) + 1)^2;
kernel = @(x,y) exp(- dot(x-y, x-y)/2);
k_projections = kPCA(X, 2, kernel);

subplot(1,3,2)
hold on
scatter(reg_projections(1:N/2,1), reg_projections(1:N/2,2), 'r', 'filled')
scatter(reg_projections(N/2+1:end,1), reg_projections(N/2+1:end,2), 'b', 'filled')
title("PCA")
xlabel("Projection on PC1")
ylabel("Projection on PC2")

subplot(1,3,3)
hold on
scatter(k_projections(1:N/2,1), k_projections(1:N/2,2), 'r', 'filled')
scatter(k_projections(N/2+1:end,1), k_projections(N/2+1:end,2), 'b', 'filled')
title("kPCA with Guassian RBF kernel")
xlabel("Projection on PC1")
ylabel("Projection on PC2")

if save_plots
    savefig(f, "../Figures/kPCA.fig")
end
function error = RidgeOptimizationError(X, Y, beta)
% This function performs the computation of the error in the ridge optimization process

error = norm(X * beta - Y,2)^2;
end
function E = MeanSquaredError(test_data,U,V)
    E = 0;
    for j = 1:size(test_data,1)
        E = E + (dot(U(test_data(j,1),:), V(test_data(j,2),:))-test_data(j,3))^2;
    end
    E = E / size(test_data,1);
end
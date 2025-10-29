function E = MeanAbsoluteError(test_data,n,U,V)
    E = 0;
    for i = 1:n
        user_error = 0;
        user_counter = 0;
        for j = 1:size(test_data,1)
            if test_data(j,1) == i
                user_error = user_error + abs(dot(U(test_data(j,1),:), V(test_data(j,2),:))-test_data(j,3));
                user_counter = user_counter + 1;
            end
        end
        user_error = user_error / user_counter;
        E = E + user_error;
    end
    E = E / n;
end
function Q = GramSchmidt(V)
    % V = (v_1, ..., v_n) matrix of whose columds form non orthogonal basis vectors
    % Apply Gram Schmidt orthogonalization to output Q = (q_1, ..., q_n) a matrix whose colums form an orthonormal basis

    [n,m] = size(V);

    % Initialize Q
    Q = zeros(n,m);

    for j = 1:m
        % Start with the original vector
        Q(:,j) = V(:,j);

        for i = 1:j-1
            % Remove projection onto other vectors
            Q(:,j) = Q(:,j) - dot(V(:,i), Q(:,j)) * Q(:,i);
        end

        % Normalize the vector
        Q(:,j) = Q(:,j) / norm(Q(:,j),2);    
    end
end
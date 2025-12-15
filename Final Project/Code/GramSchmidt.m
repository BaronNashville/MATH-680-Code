function U = GramSchmidt(A)
    k = size(A,2);
    U = A;
    for i = 1:k
        for j = 1:i-1
            U(:,i) = U(:,i) - dot(U(:,i),U(:,j))*U(:,j);
        end
        U(:,i) = U(:,i)/norm(U(:,i));
    end
end
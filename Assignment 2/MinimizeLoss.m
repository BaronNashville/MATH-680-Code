function [U,V] = MinimizeLoss(train_data, lambda, n, m, d)

U = rand(n,d);
V = rand(m,d);

count = 0;
max_iter = 20;
tol = 1e-5;

while (count == 0 || norm(U - old_U) + norm(V - old_V) > tol) && count <= max_iter
    count = count + 1;
    old_U = U;
    old_V = V;

    % Fix V
    sum1 = zeros(d,d,n);
    sum2 = zeros(d,n);
    for j = 1:size(train_data,1)
            sum1(:,:,train_data(j,1)) = sum1(:,:,train_data(j,1)) + transpose(V(train_data(j,2),:))*(V(train_data(j,2),:));
            sum2(:,train_data(j,1)) = sum2(:,train_data(j,1)) + transpose(V(train_data(j,2),:))*train_data(j,3);
    end
    for i = 1:n
        U(i,:) = (sum1(:,:,i) + lambda(1)*eye(d)) \ sum2(:,i);
    end

    % Fix U
    sum1 = zeros(d,d,m);
    sum2 = zeros(d,m);
    for j = 1:size(train_data,1)
            sum1(:,:,train_data(j,2)) = sum1(:,:,train_data(j,2)) + transpose(U(train_data(j,1),:))*(U(train_data(j,1),:));
            sum2(:,train_data(j,2)) = sum2(:,train_data(j,2)) + transpose(U(train_data(j,1),:))*train_data(j,3);
    end
    for i = 1:m
        V(i,:) = (sum1(:,:,i) + lambda(2)*eye(d)) \ sum2(:,i);
    end

end

end

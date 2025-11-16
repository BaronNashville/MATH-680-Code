function loss = L_uniform(class_1, class_2, t)
N_1 = size(class_1, 2);
N_2 = size(class_2, 2);

loss = 0;

for i = 1:N_1
    for j = 1:N_1
        if i ~= j
            loss = loss + exp(-t * norm(class_1(:,i)-class_1(:,j))^2);
        end
    end
end

for i = 1:N_2
    for j = 1:N_2
        if i ~= j
            loss = loss + exp(-t * norm(class_2(:,i)-class_2(:,j))^2);
        end
    end
end

loss = log(loss / (N_1 + N_2));
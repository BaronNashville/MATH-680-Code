% Building all 4 graph laplacians and computing their eigenvectors
n = 100;
% Line graph
L_line = zeros(n);
for i = 1:n
    if i == 1
        L_line(i,i) = 1;
        L_line(i,i+1) = -1;
    elseif i == n
        L_line(i,i) = 1;
        L_line(i,i-1) = -1;
    else
        L_line(i,i) = 2;
        L_line(i,i-1) = -1;
        L_line(i,i+1) = -1;
    end
end
[V_line, D_line] = eig(L_line);
[d_line, ind] = sort(diag(D_line));
V_line = V_line(:,ind);
% Line graph with point
L_line_point = zeros(n);
for i = 1:n
    if i == 1
        L_line_point(i,i) = 2;
        L_line_point(i,i+1) = -1;
        L_line_point(i,n) = -1;
    elseif i == n-1
        L_line_point(i,i) = 2;
        L_line_point(i,i-1) = -1;
        L_line_point(i,n) = -1;
    elseif i == n
        L_line_point(i,i) = n-1;
        L_line_point(i,1:n-1) = -ones(1,n-1);        
    else
        L_line_point(i,i) = 3;
        L_line_point(i,i-1) = -1;
        L_line_point(i,i+1) = -1;
        L_line_point(i, n) = -1;
    end
end
[V_line_point, D_line_point] = eig(L_line_point);
[d_line_point, ind] = sort(diag(D_line_point));
V_line_point = V_line_point(:,ind);
% Circle graph
L_circ = zeros(n);
for i = 1:n
    L_circ(i,i) = 2;
    if i == 1
        L_circ(i, i+1) = -1;
        L_circ(i,n) = -1;
    elseif i == n
        L_circ(i, 1) = -1;
        L_circ(i,i-1) = -1;
    else
        L_circ(i, i+1) = -1;
        L_circ(i, i-1) = -1;
    end
end
[V_circ, D_circ] = eig(L_circ);
[d_circ, ind] = sort(diag(D_circ));
V_circ = V_circ(:,ind);
% Circle graph with point
L_circ_point = zeros(n);
for i = 1:n
    if i == n
        L_circ_point(i,i) = n-1;
        L_circ_point(i,1:n-1) = -ones(1,n-1);
    elseif i == 1
        L_circ_point(i,i) = 3;
        L_circ_point(i, i+1) = -1;
        L_circ_point(i,n-1) = -1;
        L_circ_point(i,n) = -1;
    elseif i == n-1
        L_circ_point(i,i) = 3;
        L_circ_point(i, 1) = -1;
        L_circ_point(i,i-1) = -1;
        L_circ_point(i,n) = -1;
    else
        L_circ_point(i,i) = 3;
        L_circ_point(i, i+1) = -1;
        L_circ_point(i, i-1) = -1;
        L_circ_point(i,n) = -1;
    end
end
[V_circ_point, D_circ_point] = eig(L_circ_point);
[d_circ_point, ind] = sort(diag(D_circ_point));
V_circ_point = V_circ_point(:,ind);
% Plotting the 2 largest and smallest eigenvectors
figure(1)
hold on
plot(1:100, V_line(:,1), '-o','DisplayName', "Smallest Eigenvector")
plot(1:100, V_line(:,2), '-o', 'DisplayName', "Second Smallest Eigenvector")
plot(1:100, V_line(:,end), '-o', 'DisplayName', "Largest Eigenvector")
plot(1:100, V_line(:,end-1), '-o', 'DisplayName', "Second Largest Eigenvector")
xlabel('j')
ylabel('f_j')
title("Largest and Smallest Eigenvectors for Line Graph for n = 100")
legend
figure(2)
hold on
plot(1:100, V_line_point(:,1), '-o', 'DisplayName', "Smallest Eigenvector")
plot(1:100, V_line_point(:,2), '-o', 'DisplayName', "Second Smallest Eigenvector")
plot(1:100, V_line_point(:,end), '-o', 'DisplayName', "Largest Eigenvector")
plot(1:100, V_line_point(:,end-1), '-o', 'DisplayName', "Second Largest Eigenvector")
xlabel('j')
ylabel('f_j')
title("Largest and Smallest Eigenvectors for Line Graph with point for n = 100")
legend
figure(3)
hold on
plot(1:100, V_circ(:,1), '-o', 'DisplayName', "Smallest Eigenvector")
plot(1:100, V_circ(:,2), '-o', 'DisplayName', "Second Smallest Eigenvector")
plot(1:100, V_circ(:,end), '-o', 'DisplayName', "Largest Eigenvector")
plot(1:100, V_circ(:,end-1), '-o', 'DisplayName', "Second Largest Eigenvector")
xlabel('j')
ylabel('f_j')
title("Largest and Smallest Eigenvectors for Circle Graph for n = 100")
legend
figure(4)
hold on
plot(1:100, V_circ_point(:,1), '-o', 'DisplayName', "Smallest Eigenvector")
plot(1:100, V_circ_point(:,2), '-o', 'DisplayName', "Second Smallest Eigenvector")
plot(1:100, V_circ_point(:,end), '-o', 'DisplayName', "Largest Eigenvector")
plot(1:100, V_circ_point(:,end-1), '-o', 'DisplayName', "Second Largest Eigenvector")
xlabel('j')
ylabel('f_j')
title("Largest and Smallest Eigenvectors for Circle Graph with point for n = 100")
legend
% Graph embedding on eigenvector space
figure(5)
hold on
scatter(V_line(:,2), V_line(:,3), 'filled')
for i = 1:n
    for j = 1+1:n
        if L_line(i,j) == -1
            plot([V_line(i,2),V_line(j,2)],[V_line(i,3),V_line(j,3)], 'w')
        end
    end
end
xlabel('f_2')
ylabel('f_3')
title("Graph embedding for Line Graph for n = 100")
figure(6)
hold on
scatter(V_line_point(:,2), V_line_point(:,3), 'filled')
for i = 1:n
    for j = 1+1:n
        if L_line_point(i,j) == -1
            plot([V_line_point(i,2),V_line_point(j,2)],[V_line_point(i,3),V_line_point(j,3)], 'w')
        end
    end
end
xlabel('f_2')
ylabel('f_3')
title("Graph embedding for Line Graph with point for n = 100")
figure(7)
hold on
scatter(V_circ(:,2), V_circ(:,3), 'filled')
for i = 1:n
    for j = 1+1:n
        if L_circ(i,j) == -1
            plot([V_circ(i,2),V_circ(j,2)],[V_circ(i,3),V_circ(j,3)], 'w')
        end
    end
end
xlabel('f_2')
ylabel('f_3')
title("Graph embedding for Circle Graph for n = 100")
figure(8)
hold on
scatter(V_circ_point(:,2), V_circ_point(:,3), 'filled')
for i = 1:n
    for j = 1+1:n
        if L_circ_point(i,j) == -1
            plot([V_circ_point(i,2),V_circ_point(j,2)],[V_circ_point(i,3),V_circ_point(j,3)], 'w')
        end
    end
end
xlabel('f_2')
ylabel('f_3')
title("Graph embedding for Circle Graph with point for n = 100")
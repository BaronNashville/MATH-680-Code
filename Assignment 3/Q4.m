% Aligned but not uniform
theta_1 = -pi/16:0.01:pi/16;
class_1 = [cos(theta_1); sin(theta_1)];

theta_2 = pi-pi/16:0.01:pi+pi/16;
class_2 = [cos(theta_2); sin(theta_2)];

figure(1)
hold on
scatter(class_1(1,:), class_1(2,:), 'r')
scatter(class_2(1,:), class_2(2,:), 'b')
plot(cos(0:0.01:2*pi), sin(0:0.01:2*pi), 'k')
title("Aligned but not uniform")
axis equal

fprintf("Aligned but no uniform\nAligned loss = %f, Uniform loss = %f\n\n", L_align(class_1, class_2, 2), L_uniform(class_1, class_2, 2));

% Uniform but mis-aligned
theta_1 = 2*pi*rand(1,100);
class_1 = [cos(theta_1); sin(theta_1)];

theta_2 = 2*pi*rand(1,100);
class_2 = [cos(theta_2); sin(theta_2)];

figure(2)
hold on
scatter(class_1(1,:), class_1(2,:), 'r')
scatter(class_2(1,:), class_2(2,:), 'b')
plot(cos(0:0.01:2*pi), sin(0:0.01:2*pi), 'k')
title("Uniform but not aligned")
axis equal

fprintf("Uniform but not aligned\nAligned loss = %f, Uniform loss = %f\n\n", L_align(class_1, class_2, 2), L_uniform(class_1, class_2, 2));


% Mix of both
theta_1 = -pi/4:0.01:pi/4;
class_1 = [cos(theta_1); sin(theta_1)];

theta_2 = pi-pi/4:0.01:pi+pi/4;
class_2 = [cos(theta_2); sin(theta_2)];

figure(3)
hold on
scatter(class_1(1,:), class_1(2,:), 'r')
scatter(class_2(1,:), class_2(2,:), 'b')
plot(cos(0:0.01:2*pi), sin(0:0.01:2*pi), 'k')
title("Mix of both")
axis equal

fprintf("Mix of both\nAligned loss = %f, Uniform loss = %f\n\n", L_align(class_1, class_2, 2), L_uniform(class_1, class_2, 2));
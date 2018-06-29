C1=[2 1; 1 2];
C2 = C1;
m1 = [0 2]';
m2=[1.7 2.5]';

w = 2*inv(C)*(m2-m1);
b = m1'*inv(C)*m1 - m2'*inv(C)*m2;

[X,Y] = meshgrid(-6:6,-6:6);
R = -(X*w(1) + Y*w(2)) +b;
i = ones(size(R));
Z= i./(i+exp(R))

figure
surf(X,Y,Z)



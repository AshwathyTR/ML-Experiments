A=[2 1;1 2];
B=[1 2];
C=3;
r=2;
figure(1), clf
syms x y;
X=[x y];
D=B*X';
i=ones(size(D));
Z= (exp(D))
fsurf(Z,[-r r]);
zlim([0 600]);
xlabel('xxx');
ylabel('yyy');
zlabel('zz');

figure(2), clf,
[X,Y] = meshgrid(-r:r,-r:r);
g=2*r+1;
D=ones(g,g);
for x=-r:r
   for y=-r:r
       p=[x y];
       z=B*p';
       D(x+r+1,y+r+1)=z;
   end
end
i = ones(size(D));
Z=(exp(D))
surf(X,Y,Z)
zlim([0 600]);
xlabel('xxx');
ylabel('yyy');
zlabel('zz');

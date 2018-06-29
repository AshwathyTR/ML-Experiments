C1=[2 1; 1 2];
C2 = 1.5*eye(size(C1));
m1 = [0 2]';
m2=[1.7 2.5]';

numGrid=50;
xRange=linspace(-6.0, 6.0, numGrid);
yRange=linspace(-6.0, 6.0, numGrid);
P1=zeros(numGrid,numGrid);
P2=P1;
for i=1:numGrid
    for j=1:numGrid
        x=[yRange(j) xRange(i)]';
        P1(i,j) = mvnpdf(x',m1',C1);
        P2(i,j) = mvnpdf(x',m2',C2);
    end
end
Pmax=max(max([P1 P2]));
figure(1),clf,
contour(xRange, yRange,P1, [0.1*Pmax 0.5*Pmax 0.8*Pmax], 'LineWidth', 1);
hold on;
plot(m1(1), m1(2), 'c*', 'LineWidth',1);

contour(xRange, yRange, P2, [0.1*Pmax 0.5*Pmax 0.8*Pmax],'LineWidth', 1);
plot(m2(1), m2(2), 'm*', 'LineWidth',1);

N= 200;
X1=mvnrnd(m1, C1, N);
X2=mvnrnd(m2,C2,N);
plot(X1(:,1),X1(:,2),'cx',X2(:,1),X2(:,2),'mo');grid on;

A = inv(C2)-inv(C1);
B=(-2*m2'*inv(C2)) + (2*m1'*inv(C1));
C=m2'*inv(C2)*m2 - m1'*inv(C1)*m1 - log(det(C1)/det(C2));
syms x y;
X=[x y];
D=X*A*X'+B*X'+C;

ezplot(D==0);


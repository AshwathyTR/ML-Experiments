C1=[2 1; 1 2];
C2 =[1 0;0 1];
m1 = [0 3]';
m2=[2 1]';
step = 0.1;

%• Compute the posterior probability on a regular grid in the input space and plot the decision 
%boundary for which the posterior probability satisfies P[ω1 | x] = 0.5.
r=10;

xRange=linspace(-r, r);
yRange=linspace(-r,r);
k=size(xRange);
P1=zeros(k(1),k(1));
P2=P1;
numGrid=100;
for i=1:numGrid
    for j=1:numGrid
        x=[yRange(j) xRange(i)]';
        P1(i,j) = mvnpdf(x',m1',C1);
        P2(i,j) = mvnpdf(x',m2',C2);
    end
end
Pmax=max(max([P1 P2]));
figure(1),clf,
%contour(xRange, yRange,P1, [0.1*Pmax 0.5*Pmax 0.8*Pmax], 'LineWidth', 1);
hold on;
plot(m1(1), m1(2), 'c.', 'LineWidth',1);

%contour(xRange, yRange, P2, [0.1*Pmax 0.5*Pmax 0.8*Pmax],'LineWidth', 1);
plot(m2(1), m2(2), 'm.', 'LineWidth',1);

A = inv(C2)-inv(C1);
B=(-2*m2'*inv(C2)) + (2*m1'*inv(C1));
C=m2'*inv(C2)*m2 - m1'*inv(C1)*m1 - log(det(C1)/det(C2));
syms x y;
X=[x y];
D=X*A*X'+B*X'+C;
Z= i./(i+exp(D));
ezplot(Z==0.5);

 N= 1000;
 X1=mvnrnd(m1, C1, N);
 X2=mvnrnd(m2,C2,N);
 plot(X1(:,1),X1(:,2),'c.',X2(:,1),X2(:,2),'m.');grid on;
 
figure(2),clf,
fsurf(Z);
[X,Y] = meshgrid(-r:step:r,-r:step:r);

D=ones(size(X));

for x=1:size(X,1)
        
	for y=1:size(X,2)
                p=[X(x,y) Y(x,y)];
       
		z=p*A*p'+B*p'+C;
       
		D(x,y)=z;
   
	end

end
i = ones(size(D));

Z= i./(i+exp(D));
 surf(X,Y,Z)





figure(3),clf,
plot(X1(:,1),X1(:,2),'c.',X2(:,1),X2(:,2),'m.');hold on;
X=[X1; X2];
N1 = size(X1,1);
N2 = size(X2,1);
y=[ones(N1,1); -1*ones(N2,1)];
Tr=[X y];
ShTr=Tr(randperm(size(Tr,1)),:);
X=[Tr(:,1) Tr(:,2)];
y=Tr(:,3);
net = feedforwardnet(5);
net = train(net, X', y');

[X,Y] = meshgrid(-r:step:r,-r:step:r);

in=ones(size(X,1)*size(X,2),2);
i=0;
for x=1:size(X,1)
   
   for y=1:size(X,2)
     i=i+1;
     p=[X(x,y) Y(x,y)]; 
     in(i,:)=p;
   
   end

end

i=0;
out=net(in');
for x=1:size(X,1)
   
	for y=1:size(X,2)
     i=i+1;
     D(x,y)=out(i);
   
	end

end

i = ones(size(D));
Z= i./(i+exp(D));

surf(X,Y,Z)

figure(5),clf,
plot(X1(:,1),X1(:,2),'c.',X2(:,1),X2(:,2),'m.');hold on;
contour(X, Y, Z, [0.1*max(Z) 0.5*max(Z) 0.8*max(Z)], 'LineWidth', 1);



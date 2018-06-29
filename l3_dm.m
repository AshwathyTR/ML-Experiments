C1=[2 1; 1 2];
C2 = C1;
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
contour(xRange, yRange,P1, [0.1*Pmax 0.5*Pmax 0.8*Pmax], 'LineWidth', 2);
hold on;
plot(m1(1), m1(2), 'b*', 'LineWidth',4);

contour(xRange, yRange, P2, [0.1*Pmax 0.5*Pmax 0.8*Pmax],'LineWidth', 2);
plot(m2(1), m2(2), 'r*', 'LineWidth',4);

N= 200;
X1=mvnrnd(m1, C1, N);
X2=mvnrnd(m2,C2,N);
plot(X1(:,1),X1(:,2),'bx',X2(:,1),X2(:,2),'ro');grid on;

X=[X1; X2];
N1 = size(X1,1);
N2 = size(X2,1);
y=[ones(N1,1); -1*ones(N2,1)];
d=zeros(N1+N2-1,1);
nCE = 0;
nCM=0;
for jst = 1:(N1+N2)
   xst = X(jst,:);
   yst = y(jst);

   eu1 = norm(xst-m1);
   eu2 = norm(xst-m2);
   if(eu1>eu2)
       ytr=-1;
   else
       ytr=1;
   end
   if (ytr*yst>0)
     nCE = nCE+1;
   end 
   mh1 =(xst - m1)'*inv(C)*(xst-m1);
   mh2 =(xst - m2)'*inv(C)*(xst-m2);
   
   if(mh1>mh2)
       ytr=-1;
   else
       ytr=1;
   end
   if (ytr*yst>0)
     nCM = nCM+1;
   
   end
end

pCE=nCE*100/(N1+N2)
pCM=nCM*100/(N1+N2)
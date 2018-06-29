C=[2 -1;-1 2];
A=chol(C);


X=randn(1000,2);
Y=X*A;
plot(X(:,1),X(:,2),'c.');
hold on
plot(Y(:,1),Y(:,2),'mx');


emparray = zeros(N,1);
theoarray = zeros(N,1);
thRange = linspace(0,2*pi,N);
for n=1:N
        theta = thRange(n);
	u=[sin(theta); cos(theta)];
	yp=Y*u;
	emparray(n,1) = var(yp);
	theoarray(n,1)= u'*C*u;
 end
%plot(thRange,emparray);
hold on;
%plot(thRange, theoarray);
hold off;

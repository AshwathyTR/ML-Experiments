C=[2 1;1 2];
A=chol(C);

X=randn(100000,2);
Y=X*A;
plot(X(:,1),X(:,2),'c.',Y(:,1),Y(:,2),'mx');


theta=0.25
u=[sin(theta); cos(theta)]
yp=Y*u;
var_emp = var(yp)
var_theo = u'*C*u
N=100;
C=[2 1; 1 2];
C2 = [1 0;0 1];
A= chol(C);
A2= chol(C2);
x=randn(N,2);
xc=x*A;
x1=randn(N,2);
x1c=x1*A2;
m = [0 5];
m1=[5 0.0];
xcm = xc+kron(ones(N,1),m);
x1cm = x1c+kron(ones(N,1),m1);
plot(xcm(:, 1), xcm(:,2), 'cx',x1cm(:,1),x1cm(:, 2),'mx');
hold on;
w = 2* inv(C) * transpose(m1 - m);
 b= (m * inv(C) *transpose(m) - m1*inv(C)* transpose(m1)) ;
 slp=-w(1)/w(2);
 int = -b/w(2);
 a=-4:4;
 a1=slp*a+int;
 plot(a , a1 ,'b','LineWidth', 2);
X= [xcm ones(N,1); x1cm ones(N,1)];
Y= [ones(N,1); -ones(N,1)];
N=N*2;
ii= randperm(N);
Xtr = X(ii(1:N/2),:);
Ytr = Y(ii(1:N/2),:);
Xts = X(ii(N/2 +1:N),:);
Yts = Y(ii(N/2 +1:N),:);

w=randn(3,1);

eta = 0.001;
for iter = 1:100000
    j = ceil(rand*N/2);
    if(Ytr(j)*Xtr(j,:)*w <0)
           w = w +eta*Ytr(j)*Xtr(j,:)';
    end
slp=-w(1)/w(2);
    int = -w(3)/w(2);
    a=-4:4;
    a1=slp*a+int;
    h=plot(a , a1 ,'r','LineWidth', 2);
pause(0.000001);
delete(h);
end
h=plot(a , a1 ,'r','LineWidth', 2);
yhts = Xts*w;
%disp([Yts yhts])
perror = 100*sum((Yts .* yhts <0))/(N)
    
hold off;

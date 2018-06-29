housing_data=importdata('housing.data');
[N, p1] = size(housing_data);
p = p1-1;
Y = [housing_data(:,1:p) ones(N,1)];
for j=1:p
Y(:,j)=Y(:,j)-mean(Y(:,j));
Y(:,j)=Y(:,j)/std(Y(:,j));
end
f = housing_data(:,p1);
f = f - mean(f);
f = f/std(f);

%Compare your results with the linear regression model of Lab 4. Does the use of a nonlinear model improve predictions?
bpsize=100;
RBF=zeros(bpsize,1);
LR=zeros(bpsize,1);
for r=1:bpsize
 ii =  randperm(N);
    Ntr = ceil(8*N/10);
    Nts = N - Ntr;
    Xtr = Y(ii(1:Ntr),:);
    ftr = f(ii(1:Ntr),:);
    Xts = Y(ii(Ntr+1:N),:);
    fts = f(ii(Ntr+1:N),:);

 %%%%%%%%% Linear %%%%%%%%

w = Xtr\ftr;
ftsh=Xts*w;
LR(r)= (norm(ftsh-fts))/Nts;

%%%%%%%%%%% RBF %%%%%%%%%%%
sig = norm(Xtr(ceil(rand*Ntr),:)-Xtr(ceil(rand*Ntr),:));
K=round(Ntr/2);
[Idx, C] = kmeans(Xtr, K);

A=zeros(Ntr,K);
for i=1:Ntr
for j=1:K
  A(i,j)=exp(-norm(Xtr(i,:) - C(j,:))/sig^2);
end
end

lambda = A \ ftr;

u = zeros(K,1);
yh=zeros(Nts,1);
for n=1:Nts
  for j=1:K
   u(j) = exp(-norm(Xts(n,:) - C(j,:))/sig^2);
  end
yh(n) = lambda'*u;
end
RBF(r) = norm(yh-fts)/Nts;
% ets=sum(Ets);
% RBF(r)=ets;


end


figure(1),clf
boxplot([LR RBF],'notch','on',...
        'labels',{'Linear','RBF'})
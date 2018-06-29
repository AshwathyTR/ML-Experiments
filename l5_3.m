%%%%%%%%%%%%%%%%%%%%%%%%%%% Linear %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

LR=zeros(bpsize,1);
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

for r=1:bpsize
 ii= randperm(N);
 Ytr = Y(ii(1:N/2),:);
 ftr = f(ii(1:N/2),:);
 Yts = Y(ii(N/2 +1:N),:);
 fts = f(ii(N/2 +1:N),:);


 w = Ytr\ftr;
 ftrh = Ytr*w;
 ftsh=Yts*w;



LR(r)= (norm(ftsh-fts))^2/N;

end
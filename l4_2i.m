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
DS = [Y f];

fold=10;
Etr=ones(fold,2);
Ets=ones(fold,2);


for i = 1:fold
    test = (indices == i);
    train = ~test;
    Ytr=DS(train,1:p1);
    ftr=DS(train,p1+1);
    Yts=DS(test,1:p1);
    fts=DS(test,p1+1);
    w = inv(Ytr'*Ytr)*Ytr'*ftr;
    ftrh = Ytr*w;
    ftsh= Yts*w;

[m,n]=size(Ytr);
[mt,nt]=size(Yts);
Etr(i,:) = [(norm(ftrh-ftr)^2)/m i];
Ets(i,:) = [(norm(ftsh-fts)^2)/mt i];

end
figure(1), clf,
  plot(Etr(:,2), Etr(:,1), 'r.', 'LineWidth', 2),
  grid on
  hold on
  plot(Ets(:,2), Ets(:,1), 'g.', 'LineWidth', 2),
  xlabel('Fold', 'FontSize', 14)
  ylabel('Error', 'FontSize', 14)
  
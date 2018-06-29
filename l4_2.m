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
Unc=100;
fold=10;
Etr=ones(fold,1);
Ets=ones(fold,1);
err=ones(Unc,1);
for j=1:Unc

indices = crossvalind('Kfold',N,fold);

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
%     figure(i), clf,
%     grid on
% hold on
% plot(ftr, ftrh, 'r.', 'LineWidth', 2),
% plot(fts, ftsh, 'g.', 'LineWidth', 2),
% 
% xlabel('True House Price', 'FontSize', 14)
% ylabel('Prediction', 'FontSize', 14)
% title('Linear Regression', 'FontSize', 14)
[m,n]=size(Ytr);
[mt,nt]=size(Yts);
Etr(i) = (norm(ftrh-ftr)^2)/m;
Ets(i) = (norm(ftsh-fts)^2)/mt;

end
err(j)= sum(Ets)/fold;
end



figure(2),clf
hist(err);


% ii= randperm(N);
% Ytr = Y(ii(1:N/2),:);
% ftr = f(ii(1:N/2),:);
% Yts = Y(ii(N/2 +1:N),:);
% fts = f(ii(N/2 +1:N),:);


% w = inv(Y'*Y)*Y'*f;
% fh = Y*w;
% figure(1), clf,
% plot(ftr, ftrh, 'r.', 'LineWidth', 2),
% grid on
% hold on
% xlabel('True House Price', 'FontSize', 14)
% ylabel('Prediction', 'FontSize', 14)
% title('Linear Regression', 'FontSize', 14)
% Etr = (norm(ftrh-ftr))^2;
% figure(2), clf,
% plot(fts, ftsh, 'r.', 'LineWidth', 2),
% grid on
% hold on
% xlabel('True House Price', 'FontSize', 14)
% ylabel('Prediction', 'FontSize', 14)
% title('Linear Regression', 'FontSize', 14)
% Ets = (norm(ftsh-fts))^2;






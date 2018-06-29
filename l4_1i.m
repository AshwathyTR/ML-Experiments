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
Etr=zeros(100,1);
Ets=zeros(100,1);

 ii= randperm(N);
 Ytr = Y(ii(1:N/2),:);
 ftr = f(ii(1:N/2),:);
 Yts = Y(ii(N/2 +1:N),:);
 fts = f(ii(N/2 +1:N),:);


 w = inv(Ytr'*Ytr)*Ytr'*ftr;
 ftrh = Ytr*w;
 ftsh=Yts*w;
 figure(1), clf,
  plot(ftr, ftrh, 'r.', 'LineWidth', 2),
  grid on
  hold on
  xlabel('True House Price', 'FontSize', 14)
  ylabel('Prediction', 'FontSize', 14)
  title('Linear Regression', 'FontSize', 14)
Etr(i) = (norm(ftrh-ftr))^2/N;
  plot(fts, ftsh, 'g.', 'LineWidth', 2),

Ets(i) = (norm(ftsh-fts))^2/N;



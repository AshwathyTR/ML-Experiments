%  Load the data, normalize it as done in Lab 4 and get random partitions of traing
% and test sets. Say variable Xtr, a matrix of Ntr × p is inputs of your training set
% and ytr, the corresponding outputs (targets).

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

% Set the widths of the basis functions to a sensibel scale; here I use the distance
% between two randomly chosen items of data:

 ii= randperm(N);
 Xtr = Y(ii(1:N/2),:);
 ytr = f(ii(1:N/2),:);
 Xts = Y(ii(N/2 +1:N),:);
 yts = f(ii(N/2 +1:N),:);
 
% Perform K−means clustering to find centres ck for the basis functions. Use K =
% N tr/10.

 [Ntr,ptr] = size(Xtr);
sig = norm(Xtr(ceil(rand*Ntr),:)-Xtr(ceil(rand*Ntr),:));
[Idx, C] = kmeans(Xtr, round(Ntr/10));

%Construct the design matrix
K=round(Ntr/10);
A=zeros(Ntr,K);
for i=1:Ntr
for j=1:K
  A(i,j)=exp(-norm(Xtr(i,:) - C(j,:))/sig^2);
end
end

%  Solve for the weights
lambda = A \ ytr;

%Compute what the model predict at each of the training data:
u = zeros(K,1);
yh=zeros(Ntr,1);
for n=1:Ntr
  for j=1:K
   u(j) = exp(-norm(Xtr(n,:) - C(j,:))/sig^2);
  end
yh(n) = lambda'*u;
end
figure(1),clf,
plot(ytr, yh, 'rx', 'LineWidth', 2), grid on
title('RBF Prediction on Training Data', 'FontSize', 16);
xlabel('Target', 'FontSize', 14);
ylabel('Prediction', 'FontSize', 14);
Etr = ((yh-ytr).^2)./Ntr;
etr=sum(Etr);
% Adapt the above to calculate what the model predicts at the unseen data (test data)
% and draw a similar scatter plot. How do the training and test errors compare?
% Compute the difference between training and test errors at different values of the
% number of basis functions, K. Briefly comment on any observation you make.
[Nts,pts]=size(Xts);
u = zeros(K,1);
yh=zeros(Nts,1);
for n=1:Nts
  for j=1:K
   u(j) = exp(-norm(Xts(n,:) - C(j,:))/sig^2);
  end
yh(n) = lambda'*u;
end
Ets = ((yh-yts).^2)./Nts;
ets=sum(Ets);
figure(2),clf,
plot(yts, yh, 'rx', 'LineWidth', 2), grid on
title('RBF Prediction on Test Data', 'FontSize', 16);
xlabel('Target', 'FontSize', 14);
ylabel('Prediction', 'FontSize', 14);

%*********************************changing k****************************
kvals=20;
Ektr = zeros(kvals,2);
Ekts = zeros(kvals,2);

for k=1:kvals
[Idx, C] = kmeans(Xtr, round(Ntr/k));

%Construct the design matrix
K=round(Ntr/k);
A=zeros(Ntr,K);
for i=1:Ntr
for j=1:K
  A(i,j)=exp(-norm(Xtr(i,:) - C(j,:))/sig^2);
end
end

%  Solve for the weights
lambda = A \ ytr;

%Compute what the model predict at each of the training data:
u = zeros(K,1);
yh=zeros(Ntr,1);
for n=1:Ntr
  for j=1:K
   u(j) = exp(-norm(Xtr(n,:) - C(j,:))/sig^2);
  end
yh(n) = lambda'*u;
end
Etr = ((yh-ytr).^2)./Ntr;
etr=sum(Etr);
Ektr(k,:)=[etr,round(Ntr/k)];
%test set
u = zeros(K,1);
yh=zeros(Nts,1);
for n=1:Nts
  for j=1:K
   u(j) = exp(-norm(Xts(n,:) - C(j,:))/sig^2);
  end
yh(n) = lambda'*u;
end
Ets = ((yh-yts).^2)./Nts;
ets=sum(Ets);
Ekts(k,:)=[ets,round(Ntr/k)];
end
Ed=[abs(Ekts(:,1)-Ektr(:,1)) Ekts(:,2)];
figure(3),clf,
plot(Ektr(:,2), Ektr(:,1), 'rx', 'LineWidth', 2), grid on
title('Varying K- Training Set', 'FontSize', 16);
xlabel('number of clusters', 'FontSize', 14);
ylabel('Error', 'FontSize', 14);
figure(4),clf,
plot(Ekts(:,2), Ekts(:,1), 'rx', 'LineWidth', 2), grid on
title('Varying K - Test set', 'FontSize', 16);
xlabel('number of clusters', 'FontSize', 14);
ylabel('Error', 'FontSize', 14);
figure(5),clf,
plot(Ed(:,2), Ed(:,1), 'rx', 'LineWidth', 2), grid on
title('Varying K - Difference', 'FontSize', 16);
xlabel('number of clusters', 'FontSize', 14);
ylabel('Error', 'FontSize', 14);


clear
housing_data=importdata('housing.data');
%load('winequalityred')
figure(1), clf
figure(3), clf

% Load Boston Housing Data from UCI ML Repository
% into an array housing_data; Normalize the data to have
% zero mean and unit standard deviation
%
[N, p1] = size(housing_data);
%[N, p1] = size(winequalityred);
p = p1-1;
Y = [housing_data(:,1:p) ones(N,1)];
for j=1:p
Y(:,j)=Y(:,j)-mean(Y(:,j));
Y(:,j)=Y(:,j)/std(Y(:,j));
end
f = housing_data(:,p1);
f = f - mean(f);
f = f/std(f);

ncvi = 20;
nK = 10;
errortrRBF = zeros(ncvi,nK);
errortsRBF = zeros(ncvi,nK);
errorLS = zeros(ncvi,1);
for cvi = 1:ncvi % covalidation index
    
    ii =  randperm(N);
    Ntr = ceil(8*N/10);
    Nts = N - Ntr;
    Ytr = Y(ii(1:Ntr),:);
    ftr = f(ii(1:Ntr),:);
    Yts = Y(ii(Ntr+1:N),:);
    fts = f(ii(Ntr+1:N),:);

    % Least squares
    
    w = inv(Ytr'*Ytr)*Ytr'*ftr;
    fhLS = Yts*w;
    errorLS(cvi) = norm(fhLS - fts)/Nts;
    
    % RBF
    
    sigma = norm(Ytr(ceil(rand*Ntr),:)-Ytr(ceil(rand*Ntr),:));
    
    minK = round(Ntr/Ntr);
    maxK = round(Ntr);
    Kvec = round(linspace(minK, maxK, nK));
    
    iK = 1;
    for K=Kvec
        [Idx, C] = kmeans(Ytr, K);
        
        %sigma = norm(C(ceil(rand*K))-C(ceil(rand*K)))

        A = zeros(Ntr, K);
        for i=1:Ntr
            for j=1:K
                A(i,j)=exp(-norm(Ytr(i,:) - C(j,:))/sigma^2);
            end
        end


        lambda = A \ ftr;

        fh = zeros(Ntr,1);
        u = zeros(K,1);
        for n=1:Ntr
            for j=1:K
                u(j) = exp(-norm(Ytr(n,:) - C(j,:))/sigma^2);
            end
            fh(n) = lambda'*u;
        end
        errortrRBF(cvi, iK) = norm(fh - ftr)/Ntr;

        fhts = zeros(Nts,1);
        u = zeros(K,1);
        for n=1:Nts
            for j=1:K
                u(j) = exp(-norm(Yts(n,:) - C(j,:))/sigma^2);
            end
            fhts(n) = lambda'*u;
        end
        errortsRBF(cvi, iK) = norm(fhts - fts)/Nts;

%         figure(1)
%         subplot(2,nK,iK)
%         %plot(ftr, fh, 'bx', 'LineWidth', 2), grid on
%         title(['Training K = ' num2str(K)]); xlabel('Target'); ylabel('Prediction');
%         axis([-2 3 -2 3])
% 
%         subplot(2,nK,nK+iK)
%         %plot(fts, fhts, 'rx', 'LineWidth', 2), grid on
%         title(['Test K = ' num2str(K)]); xlabel('Target'); ylabel('Prediction');
%         axis([-2 3 -2 3])
        
        iK= iK + 1;
    end
end

figure(2), clf,
subplot(121)
plot(Kvec, errortrRBF(cvi,:), ':bx', Kvec, errortsRBF(cvi,:), ':rx', Kvec, errorLS(cvi)*ones(1, nK), 'g')
legend("Training error for RBF", "Test error for RBF", "Test error for LS")
title("Mean squared error", 'FontSize', 14)
xlabel('value of K', 'FontSize', 14)
ylabel('MSE', 'FontSize', 14)
%axis([minK maxK 0 errorLS(cvi)+0.1])

subplot(122)
boxplot([errorLS errortsRBF(:,5)])
title(["Test MSE with K = ", Kvec(5)], 'FontSize', 14)
xlabel('Linear (left) vs RBF (right)', 'FontSize', 14)
ylabel('MSE', 'FontSize', 14)

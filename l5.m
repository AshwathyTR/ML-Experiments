clear
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

bpsize = 100;
RBF = zeros(bpsize,1);
LS = zeros(bpsize,1);
for r = 1:bpsize % covalidation index
    
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
    LS(r) = norm(fhLS - fts)/Nts;
    
    % RBF
    
    sigma = norm(Ytr(ceil(rand*Ntr),:)-Ytr(ceil(rand*Ntr),:));
    
   K=round(Nts/2);
    
   [Idx, C] = kmeans(Ytr, K);
        
        %sigma = norm(C(ceil(rand*K))-C(ceil(rand*K)))

        A = zeros(Ntr, K);
        for i=1:Ntr
            for j=1:K
                A(i,j)=exp(-norm(Ytr(i,:) - C(j,:))/sigma^2);
            end
        end


        lambda = A \ ftr;

        

        fhts = zeros(Nts,1);
        u = zeros(K,1);
        for n=1:Nts
            for j=1:K
                u(j) = exp(-norm(Yts(n,:) - C(j,:))/sigma^2);
            end
            fhts(n) = lambda'*u;
        end
        RBF(r) = norm(fhts - fts)/Nts;        
        
end

figure(1),clf,
boxplot([LS RBF])


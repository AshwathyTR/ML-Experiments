
M = csvread('fts100.csv',1,2);
in1=M(:,1);
in2=M(:,4);
Ntr=1000;
Nts=100;
Tr1=in1(1:Ntr+1,1);
Tr2=in1(1:Ntr+1,1);
Ts1=in1(Ntr:Ntr+Nts+1,1);
Ts2=in2(Ntr:Ntr+Nts+1,1);
p=10;
DMTr=ones(Ntr-p,p*2);
ytr=ones(Ntr-p,1);
for i=1:Ntr-p
    for j=1:p
        DMTr(i,j)=Tr1(i+j);
        DMTr(i,2*i+j)=Tr2(i+j);
        
    end
    
    a=Tr1(i+j+1);
    ytr(i,1)=a;
end


DMTs=ones(Nts-p,p*2);
yts=ones(Nts-p,1);
for i=1:Nts-p
    for j=1:p
        
        DMTs(i,j)=Ts1(i+j);
        DMTs(i,2*i+j)=Ts2(i+j);
        
    end
    
    a=Ts1(i+j+1);
    yts(i,1)=a;
end



net = feedforwardnet(5);
net.trainParam.showWindow = false;
net = train(net, DMTr', ytr');
fts= net(DMTs');
Ef=norm(yts-fts)/Nts






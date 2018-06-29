
M = csvread('fts100.csv',1,2);
in=M(:,1);
Ntr=1000;
Nts=100;
Tr=in(1:Ntr+1,1);
Ts=in(Ntr:Ntr+Nts+1,1);

p=20;
DMTr=ones(Ntr-p,p);
ytr=ones(Ntr-p,1);
for i=1:Ntr-p
    for j=1:p
        DMTr(i,j)=Tr(i+j);
        
    end
    
    a=Tr(i+j+1);
    ytr(i,1)=a;
end


DMTs=ones(Nts-p,p);
yts=ones(Nts-p,1);
for i=1:Nts-p
    for j=1:p
        
        a=Ts(i+j);
        DMTs(i,j)=a;
        
    end
    
    a=Ts(i+j+1);
    yts(i,1)=a;
end
w=ytr\DMTr;
rts=DMTs*w';
Er=norm(yts-rts)/Nts


net = feedforwardnet(20);
net.trainParam.showWindow = false;
net = train(net, DMTr', ytr');
fts= net(DMTs');
Ef=norm(yts-fts)/Nts






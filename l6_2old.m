Ntr=1500;
Nts=100;
Tr=X(1:Ntr+1,1);
Ts=X(Ntr:Ntr+Nts+1,1);

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
w=inv(DMTr'*DMTr)*DMTr'*ytr;

rts=DMTs*w;
Er=norm(yts-rts)/Nts;
figure(1),clf,
plot(yts,'b')
hold on;
plot(rts,'r')

net = feedforwardnet(25);
net.trainParam.showWindow = false;
net = train(net, DMTr', ytr');
fts= net(DMTs');
Ef=norm(yts-fts)/Nts;
figure(2),clf,
plot(yts,'b')
hold on;
plot(fts,'r')

newin=[];
newout=[];
E=ones(Nts);
pts=ones(Nts);
newin=DMTs(1,:);
newout=net(newin');
last=newout;
pts(1)=newout;
for i=2:size(yts)
    newin=DMTs(i,:);
   
    newin(1,20)=last;
   
    newout=net(newin');
   
    pts(i)=newout;
    last=newout;
    E(i)=norm(yts-pts)/i;
end
figure(1),clf,
plot(yts,'b')
hold on;
plot(pts,'r')
Ntr=1000;
Nts=500;
Tr=X(1:Ntr+1,1);
Ts=X(Ntr-p:Ntr-p+Nts+1,1);

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

LR=ones(10,1);

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
%LR(k,1)=Er;
figure(2),clf,
plot(yts,'b')
axis([0 Nts 0 2]);
hold on;
plot(rts,'r')
axis([0 Nts 0 2]);
NN=ones(10,1);

net = feedforwardnet(20);
net.trainParam.showWindow = false;
net = train(net, DMTr', ytr');
fts= net(DMTs');
Ef=norm(yts-fts)/Nts;
%NN(i,1)=Ef;

figure(3),clf,
plot(yts,'b')
axis([0 Nts 0 2]);
hold on;
plot(fts,'r')
axis([0 Nts 0 2]);

newin=[];
newout=[];
E=ones(Nts,1);
pts=ones(Nts,1);
newin=DMTs(1,:);
newout=net(newin');
last=newout;
pts(1)=newout;

for i=2:size(yts)
    k=newin(2:p);
    newin=[k last];
    
    
    newout=net(newin');
    pts(i,1)=newout;
    
    last=newout;   
end
figure(4),clf,
plot(yts,'b')
axis([0 Nts 0 2]);
hold on;
plot(pts,'r')
axis([0 Nts 0 2]);


% figure(5),clf
% boxplot([LR NN],'Notch','on','Labels',{'LR','NN'});

lrts=ones(Nts,1);
newin=DMTs(1,:);
newout=newin*w;
last=newout;
lrts(1)=newout;

for i=2:size(yts)
    k=newin(2:p);
    newin=[k last];
    
    
    newout=newin*w;
    lrts(i,1)=newout;
    
    last=newout;   
end
figure(6),clf,
plot(yts,'b')
axis([0 Nts 0 2]);
hold on;
plot(lrts,'r')
axis([0 Nts 0 2]);

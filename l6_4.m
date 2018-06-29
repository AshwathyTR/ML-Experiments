%for kkk=1:100
M = csvread('fts100.csv',1,2);
size(M)
in=M(:,1);
Ntr=1000;
Nts=100;
Tr=in(1:Ntr+1,1);
Ts=in(Ntr:Ntr+Nts+1,1);

p=25;
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
for i=0:Nts-p-1
    for j=1:p
        
        a=Ts(i+j);
        DMTs(i+1,j)=a;
        
    end
    
    a=Ts(i+j+1);
    yts(i+1,1)=a;
end
w=inv(DMTr'*DMTr)*DMTr'*ytr;
rts=DMTs*w;
Er=norm(yts-rts)/Nts

% figure(1),clf,
% plot(yts,'b')
% hold on;
% plot(rts,'r')


%net.trainParam.showWindow = false;
%T=tonndata(Tr,false,false);

%[Xs Xsi Asi Ts] = preparets(net,{},{},T);

%net = narnet(1:20);
net=feedforwardnet(10);
%net = train(net,Xs,Ts,Xsi,Asi);
%[Y,Xf,Af] = net(Xs,Xsi,Asi);
net=train(net,DMTr', ytr');
%perf = perform(net,Ts,Y)
%[netc,Xic,Aic] = closeloop(net,Xf,Af);
%y2 = netc(cell(0,20),Xic,Aic);
fts= net(DMTs');
%Ef=norm(yts-fts)/Nts
%size(DMTs)
%fts=fromnndata(Y,true,false,false);
figure(2),clf,
plot(yts,'b')
hold on;

plot(fts,'r')
%end
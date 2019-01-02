
function rew= evalu(inp,para)

%x=para.x;
%net=para.net;
netc=para.netc;

target=para.tar;


inp2(:,1)=inp(:,1);
for i=2:para.stp
    if mod(i,para.cc)==0
        inp2(:,i)=inp(:,fix(i/para.cc)+1);
    else
        inp2(:,i)=inp2(:,i-1);
    end
end
inp2(:,para.stp+1)=0;



X = tonndata(inp2,true,false);
T=para.T;
%T = tonndata(t,true,false);
siz=para.stp;


%[xc,xic,aic] = preparets(netc,X,{},T(1,1:siz));
xic=para.xic;
aic=para.aic;
xc=(X(:,2:end));

yc = netc(xc,xic,aic);

%yc=cell2mat(yc(end));
yc=cell2mat(yc);
% err=0;
%
% for i=10:5:siz
%     ptCloud = pointCloud(yc(4:6,1:i-1)');
%     [indices,dists] = findNearestNeighbors(ptCloud,yc(4:6,i)',1);
%     err=err+dists;
% end
%
% err=-err;

%err=(rssq(yc(1:3,end)-target(:,end))*10)^2;%+sum(rms((inp2)))/1000;


%err=sum(rssq(yc(4,:)-target))*10 -(sum(rms((inp2)))+1)/1000-(sum(rssq(yc(5:6,2:end)-yc(5:6,1:end-1)))+1);

%err=sum(rssq(yc([4,6],:)-target))/100 -(sum(rms((inp2)))+1)/1000-(sum(rssq(yc(5,2:end)-yc(5,1:end-1)))+1);

%err=sum(rssq(yc(4:6,100)-target(:,end)))*10+sum(rssq(yc(4:6,end)-[0;0.2;0]))*10;
valtraj=0;
if para.num>0
for z=1:para.num

ntraj=squeeze(para.test(1:3,:,z))-yc(1:3,1:end-1);

valtraj(z)=sum(rssq(ntraj))+100*std(rssq(ntraj));

end
end
valt=min(valtraj)+1;
err=(rssq(yc(1:2,end)-target(1:2,end)))*10-valt/10;%+sum(rms((inp2)))/1000;
% err= rssq(rssq(yc(1:3,:)-repmat([3.2;-4.5;-247]',200,1)')-20);%-sum(rssq(diff(inp2)));
%err=sum(abs(yc(2,:)-75))*1000-sum(rssq(diff(inp2)));
%err=min(rssq(yc(1:3,1:50)-target(:,1:50)))+min(rssq(yc(1:3,51:100)-target(:,51:100)))+min(rssq(yc(1:3,101:150)-target(:,101:150)))+min(rssq(yc(1:3,151:200)-target(:,151:200)));

%err=min(rssq(yc(1:3,1:50)-target(:,1:50)))+min(rssq(yc(1:3,51:100)-target(:,51:100)))+min(rssq(yc(1:3,101:150)-target(:,101:150)))+min(rssq(yc(1:3,151:200)-target(:,151:200)))+min(rssq(yc(1:3,201:250)-target(:,201:250)))+min(rssq(yc(1:3,251:300)-target(:,251:300)))+min(rssq(yc(1:3,301:350)-target(:,301:350)))+min(rssq(yc(1:3,351:400)-target(:,351:400)));
%err=sum(rssq(((yc(1:2,:)+yc(4:5,:))/2)-target(1:2,:)))*10;
%err=sum(rssq(((yc(1:2,:))-target(1:2,:))))*10;
%err=sum(rssq(((yc(1:2,200:end))-target(1:2,200:end))))*10;
% err=0;
% for zz=1:para.num
%     err=err+sum(rssq(yc(4:6,(para.stp/para.num)*zz)-target(:,zz)))*10;
% end
%err=sum(rssq(yc(4:6,:)-target(:,1:end-1))*10);
%rew=err^2+errvec;
%energ=1/((test(1,i+2)+0.25)*10+0.5*rssq(test(:,i+2)-test(:,i+1)));

%err=sum(rssq(yc(1:3,1:400)-target(:,1:400)));
rew=err;%+ sum(rms((inp)))/5000;%+rms(max(inp2))/10000;%sum(sum((inp2)))/10000;%+rms(max(inp2))/10000  sum(rms((inp2)))/1000

%
% test(:,1)=net(x(:,1));
% test(:,2)=net(x(:,2));
% %target=[0.0495555303072983;0.0202573482751266;0.0914981560750420];
% %target=[-0.25;0.1;0];
% %tarvec=target-test(1:3,1);
%
% for i=1:para.stp
%
%     % test(:,i+2)=net([test(1:3,i);test(1:3,i+1);inp(:,i);test(4:6,i);test(4:6,i+1)]);
%     if mod(i,para.cc)==0
%         test(:,i+2)=net([test(1:6,i);test(1:6,i+1);inp(:,fix(i/para.cc)+1);test(7:12,i);test(7:12,i+1)]);
%     else
%         test(:,i+2)=net([test(1:6,i);test(1:6,i+1);zeros(6,1);test(7:12,i);test(7:12,i+1)]);
%     end
%
%     %test(:,i+2)=net([test(1:3,i);test(1:3,i+1);ini(:,i+3)]);
%     % test(:,i+2)=net([test(1:3,i);test(1:3,i+1);ini(:,i+2);x(13:end,i+2)]);
%     % test(:,i+2)=net([test(1:3,i);test(1:3,i+1);ini(:,i+3);test(4:6,i);test(4:6,i+1);test(7:9,i);test(7:9,i+1)]);
%     %target(:,i)=[-0.25+i/(10*para.stp);i/(10*para.stp);0];
%     target(:,i)=para.tar;
%     cerr(i)=rssq(test(4:6,i+2)-target(:,i))*i^2;
% end
% %actvec=target-test(1:3,para.stp+2);
%
% %errvec=abs(atan2d(norm(cross(tarvec,actvec)),dot(tarvec,actvec)))/50;
% err=rssq(test(4:6,i+2)-target(:,i))*10;
% %rew=err^2+errvec;
% energ=1/((test(1,i+2)+0.25)*10+0.5*rssq(test(:,i+2)-test(:,i+1)));
% rew=err+0*energ;
% %rew=sum(cerr);

end
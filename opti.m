%% optimization process for obtaining unique trajectories (to be used for direct policy learning)

para.stp=100;
para.cc=2;
para.num=0;
for kk= 1:100
    %inp1=zeros(6,para.stp);
    inp1=zeros(3,fix(para.stp/para.cc)+1);
    ang=1:1:para.stp;
    pk=randi(5000,1,1);
      targetact(:,1:100)=repmat(squeeze(Posi2(pk,:,1)),100,1)';
     
    
    para.tar=targetact;
    for ii=1:20 %% 20 UNIQUE TRAJECTORIES 
   % parpool
    A=1*ones(1,3*(para.stp+1));
    b=1;
    lb=25*ones(1,3*(para.stp+1));
    ub=85*ones(1,3*(para.stp+1));
    para.aic=aic;
    para.xic=xic;
    
    f = @(inp)evalu(inp,para);
    
    
    options =  optimoptions (@fmincon,'Display','iter','MaxIterations',15,'algorithm','sqp');
    %options =  optimset ('Display','iter');
    %options =  optimoptions (@fmincon,'MaxIterations',5,'algorithm','sqp','UseParallel',false);
    %options =  optimset ('Display','iter');
    
    
    
    tic
    [inp,fval] = fmincon(f,inp1,[],[],[],[],lb,ub,[],options);%fminsearch%fminunc
    
    %[x,fval] = fmincon(@evalu,inp1,[],[],[],[],lb,ub,[],options);%fminsearch%fminunc
    
    %[inp,fval] = ga(f,inp1,[],[],[],[],lb,ub,[],options)
    toc
    
   % delete(gcp('nocreate'))
    
    tim=(para.stp)/100;
    inp2(:,1)=inp(:,1);
    for i=2:para.stp
        if mod(i,para.cc)==0
            inp2(:,i)=inp(:,fix(i/para.cc)+1);
        else
            inp2(:,i)=inp2(:,i-1);
        end
    end
    inp2(:,para.stp+1)=0;
    %
    % inp3(1,:,:)=inp2(1:4,:);
    % inp3(2,:,:)=inp2(5:8,:);
    
    
    %pos = piecewise_driver(inp2,tim,ini_cond);
    
    
    % test(:,1)=net(x(:,1));
    %  test(:,2)=net(x(:,2));
    target=targetact;
    %
    % for i=1:para.stp
    %
    %     test(:,i+2)=net([test(1:6,i);test(1:6,i+1);inp2(:,i);test(7:12,i);test(7:12,i+1)]);
    %
    % end
    
    siz=length(inp2);
    
    X = tonndata(inp2,true,false);
    T=para.T;
    %T = tonndata(t,true,false);
    [xc,xic,aic] = preparets(netc,X,{},T(1,1:siz));
    yc = netc(xc,xic,aic);
    test=cell2mat(yc);
    %testdyn(kk,:)=[test(4,para.stp-1),test(5,para.stp-1),test(6,para.stp-1)];
    run ('testopennvicon.m')
    
    testall(:,:,ii,kk)=test;
    inpall(:,:,ii,kk)=inp;
    Posiall(:,:,:,ii,kk)=Posi(1:100,:,:);
    
    para.num=para.num+1;
    para.test(:,:,ii)=test;
    end
    
   
    clear para.test
    para.num=0;
    %posdyn(kk,:)=[pos(1,end,end-1,2),pos(2,end,end-1,2),pos(3,end,end-1,2)];
end

     
%   for i=1:1
%     asd=cross((squeeze(posall(:,end,1:end-2,2,i)-posall(:,end,2:end-1,2,i)))',(squeeze(posall(:,end,2:end-1,2,i)-posall(:,end-1,2:end-1,2,i)))')';
%     %plot(  rssq(asd))
%     plot(  rssq(asd)/max(rssq(asd)))
%      %/max(rssq(squeeze(testall(4:6,2:end-1,i))-(testall(4:6,1:end-2,i)))))
% 
%    % plot(  rssq(squeeze(testall(4:6,2:end-1,i))-(testall(4:6,1:end-2,i))))%/max(rssq(squeeze(testall(4:6,2:end-1,i))-(testall(4:6,1:end-2,i)))))
%     hold on
%   end
% 
%   
% 
% scatter3(test(4,1:para.stp-1),test(5,1:para.stp-1),test(6,1:para.stp-1))
% hold on
% scatter3(pos(1,end,1:end-1,2),pos(2,end,1:end-1,2),pos(3,end,1:end-1,2))
% hold on
% scatter3(target(1,:),target(2,:),target(3,:),'g')
% scatter3(endpos(4,:),endpos(5,:),endpos(6,:),'.')
% scatter3(endpos(4,1),endpos(5,1),endpos(6,1),'k')
% toc
% % for i=1:100
% %
% %     scatter3(inipos(1,:,i),inipos(2,:,i),inipos(3,:,i),'r')
% %     pause(0.1)
% %     hold on
% %     if mod(i,10)==0
% %         clear figure;
% %     end
% % end
% 
% 
% 
% 
% 
% for i=1:para.stp-1
%     
%     scatter3(pos(1,:,i,1),pos(2,:,i,1),pos(3,:,i,1),'r')
%     hold on
%     scatter3(pos(1,:,i,2),pos(2,:,i,2),pos(3,:,i,2),'b')
%     pause(0.2)
%     hold on
%     
% end
% 
% 
% for kk=1:8
%     targetact(kk,:)=[def(kk,1);0.16;def(kk,2)];
% end
% 
% 
% 
% 
% 
% scatter3(test(4,1:para.stp-1),test(5,1:para.stp-1),test(6,1:para.stp-1))
% hold on
% scatter3(pos(1,end,1:end-1,2),pos(2,end,1:end-1,2),pos(3,end,1:end-1,2))
%  scatter3(targetact(1),targetact(2),targetact(3))
% 
% scatter3(para.obs(:,1),para.obs(:,2),para.obs(:,3))
% 
% plot(  rssq(squeeze(pos(:,end,2:end-1,2))-squeeze(pos(:,end,1:end-2,2))))
% 
% 
%  
% kl=5000;
% R1       =13.8e-3*kl;                       % [m] Raggio sezione 1
% R2       =11.1e-3*kl;                       % [m] Raggio sezione 2
% R3       =8.2e-3*kl;                        % [m] Raggio sezione 3
% R4       =5.4e-3*kl;                        % [m] Raggio sezione 4
% 
% 
% 
% 
%   h=scatter3(pos(1,:,i,1),pos(2,:,i,1),pos(3,:,i,1),R1,'r');
%     hold on
%     h1=scatter3(pos(1,:,i,2),pos(2,:,i,2),pos(3,:,i,2),R2,'b');
%     
%     
%     
%     
%     
%     
%     
% for i=1:49
%     inp2(:,i,:,:)=tarall;
% end



%% Learning the forward dynamic model 
new=4700;
srt=1;
x=[inp(:,srt:new+srt-1)];
%x=[inp2(:,srt:new+srt-1)];


%t=[Orin(2:new+1,:)'];
%t=[Pos(2:new+1,:)'];
% for zz=length(Posi):-1:1
%     Posi(zz,:,:)=Posi(zz,:,:)-Posi(1,:,:);
%    
% end

t=[squeeze(Posi(1+srt:new+srt,:,1)');squeeze(Posi(1+srt:new+srt,:,2)');squeeze(Posi(1+srt:new+srt,:,3)')];


%t=[squeeze(Posi(1+srt:new+srt,:,1)');squeeze(Posi(1+srt:new+srt,:,2)');squeeze(Posi(1+srt:new+srt,:,3)');squeeze(Posi(1+srt:new+srt,:,4)');squeeze(Posi(1+srt:new+srt,:,5)')];

%t=[squeeze(Posi(1+srt:new+srt,:,1)');squeeze(Posi(1+srt:new+srt,:,2)');squeeze(Posi(1+srt:new+srt,:,3)')];


%t=[Pos(1+srt:new+srt,:)';Orin(1+srt:new+srt,:)'];


X = tonndata(x,true,false);
T = tonndata(t,true,false);

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainbr';  % Levenberg-Marquardt backpropagation.

% Create a Nonlinear Autoregressive Network with External Input
inputDelays = 0:1;
feedbackDelays = 1:1;
hiddenLayerSize = [60];
net = narxnet(inputDelays,feedbackDelays,hiddenLayerSize,'open',trainFcn);
net.trainParam.epochs=5;
% Choose Input and Feedback Pre/Post-Processing Functions
% Settings for feedback input are automatically applied to feedback output
% For a list of all processing functions type: help nnprocess
% Customize input parameters at: net.inputs{i}.processParam
% Customize output parameters at: net.outputs{i}.processParam
net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
net.inputs{2}.processFcns = {'removeconstantrows','mapminmax'};

% Prepare the Data for Training and Simulation
% The function PREPARETS prepares timeseries data for a particular network,
% shifting time by the minimum amount to fill input states and layer
% states. Using PREPARETS allows you to keep your original time series data
% unchanged, while easily customizing it for networks with differing
% numbers of delays, with open loop or closed loop feedback modes.
[x,xi,ai,t] = preparets(net,X,{},T);

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivide
net.divideFcn = 'divideblock';  % Divide data randomly
net.divideMode = 'time';  % Divide up every sample
net.divideParam.trainRatio = 80/100;
net.divideParam.valRatio = 10/100;
net.divideParam.testRatio = 10/100;

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Mean Squared Error

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate', 'ploterrhist', ...
    'plotregression', 'plotresponse', 'ploterrcorr', 'plotinerrcorr'};

%net.layers{2}.transferFcn = 'satlins';
% Train the Network
[net,tr] = train(net,x,t,xi,ai);

% Test the Network
y = net(x,xi,ai);
e = gsubtract(t,y);
performance = perform(net,t,y)

% Recalculate Training, Validation and Test Performance
trainTargets = gmultiply(t,tr.trainMask);
valTargets = gmultiply(t,tr.valMask);
testTargets = gmultiply(t,tr.testMask);
trainPerformance = perform(net,trainTargets,y)
valPerformance = perform(net,valTargets,y)
testPerformance = perform(net,testTargets,y)

% View the Network
%view(net)



% Closed Loop Network
% Use this network to do multi-step prediction.
% The function CLOSELOOP replaces the feedback input with a direct
% connection from the outout layer.
netc = closeloop(net);
%[netc,xi,ai] = closeloop(netc,xi,ai);
netc.name = [net.name ' - Closed Loop'];
%view(netc)
[xc,xic,aic,tc] = preparets(netc,X,{},T);
yc = netc(xc,xic,aic);

%netc.performFcn = 'mse';
asd3=cell2mat(yc);

%netc.performParam.normalization = 'standard';
%netc.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
%netc.inputs{2}.processFcns = {'removeconstantrows','mapminmax'};


closedLoopPerformance = perform(net,tc,yc)



%  netc.divideFcn = 'divideblock';  % Divide data randomly
%  netc.divideMode = 'time';  % Divide up every sample
% netc.divideParam.trainRatio = 70/100;
% netc.divideParam.valRatio = 15/100;
% netc.divideParam.testRatio = 15/100;
 netc.trainFcn = 'trainlm';
% netc.trainParam.mu_max=10000000000000000000;
netc.trainParam.epochs=600;
% netc.trainParam.max_fail = 60;
[netc,tr] = train(netc,xc,tc,xic,aic);
% netcn=netc;
% for i=1:50
% hope=bttderiv('de_dwb',netcn,xc,tc,xic,aic);
% wb=getwb(netcn);
% newwb=wb+0.0000001*hope;
% netcn=setwb(netcn,newwb);
% yc = netcn(xc,xic,aic);
% asfgs(i) = perform(netcn,tc,yc)
% end
tic
yc = netc(xc,xic,aic);
toc
closedLoopPerformance = perform(net,tc,yc)


asd=cell2mat(yc);
asd2=cell2mat(t);
% asd3=cell2mat(y);
% asd4=cell2mat(tc);
% 
plot(asd2(1,:),'b')
hold on
plot(asd(1,:),'r')
 hold on
 plot(asd3(1,:),'g')

% for i=1:8
%     numTimesteps = size(x,2)-i*100;
%     knownOutputTimesteps = 1:(numTimesteps-100);
%     predictOutputTimesteps = (numTimesteps-99):numTimesteps;
%     X1 = X(:,knownOutputTimesteps);
%     T1 = T(:,knownOutputTimesteps);
%     [x1,xio,aio] = preparets(net,X1,{},T1);
%     [y1,xfo,afo] = net(x1,xio,aio);
%     % Next the the network and its final states will be converted to
%     % closed-loop form to make five predictions with only the five inputs
%     % provided.
%     x2 = X(1,predictOutputTimesteps);
%     [netc,xic,aic] = closeloop(net,xfo,afo);
%     [y2,xfc,afc] = netc(x2,xic,aic);
%     multiStepPerformance(i) = perform(net,T(1,predictOutputTimesteps),y2);
%     
%     asd(:,100*i-99:i*100)=cell2mat(T(1,predictOutputTimesteps));
%     asd2(:,100*i-99:i*100)=cell2mat(y2);
% end
% 
% plot(asd2(4,:))
% hold on
% plot(asd(4,:))



% para.xic=xic;
% para.aic=aic;
% para.netc=netc;
% para.T=T;
% para.x=x;
% 



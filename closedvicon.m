
%% for testing the closed loop policy
tar=(itar(:,1));
clear ('Pos');
clear ('Posi');
clear ('pos');
clear ('ori')

try
    ard=serial('COM3','BaudRate',9600,'Timeout',10);
    fopen(ard);
    
    
    
    % Program options
    TransmitMulticast = false;
    EnableHapticFeedbackTest = false;
    HapticOnList = {'ViconAP_001';'ViconAP_002'};
    bReadCentroids = false;
    bReadRays = false;
    % A dialog to stop the loop
    MessageBox = msgbox( 'Stop DataStream Client', 'Vicon DataStream SDK' );
    
    % Load the SDK
    fprintf( 'Loading SDK...' );
    Client.LoadViconDataStreamSDK();
    fprintf( 'done\n' );
    
    % Program options
    HostName = 'localhost:801';
    
    % Make a new client
    MyClient = Client();
    
    % Connect to a server
    fprintf( 'Connecting to %s ...', HostName );
    while ~MyClient.IsConnected().Connected
        % Direct connection
        MyClient.Connect( HostName );
        
        % Multicast connection
        % MyClient.ConnectToMulticast( HostName, '224.0.0.0' );
        
        fprintf( '.' );
    end
    fprintf( '\n' );
    
    % Enable some different data types
    MyClient.EnableSegmentData();
    MyClient.EnableMarkerData();
    MyClient.EnableUnlabeledMarkerData();
    MyClient.EnableDeviceData();
    if bReadCentroids
        MyClient.EnableCentroidData();
    end
    if bReadRays
        MyClient.EnableMarkerRayData();
    end
    
    fprintf( 'Segment Data Enabled: %s\n',          AdaptBool( MyClient.IsSegmentDataEnabled().Enabled ) );
    fprintf( 'Marker Data Enabled: %s\n',           AdaptBool( MyClient.IsMarkerDataEnabled().Enabled ) );
    fprintf( 'Unlabeled Marker Data Enabled: %s\n', AdaptBool( MyClient.IsUnlabeledMarkerDataEnabled().Enabled ) );
    fprintf( 'Device Data Enabled: %s\n',           AdaptBool( MyClient.IsDeviceDataEnabled().Enabled ) );
    fprintf( 'Centroid Data Enabled: %s\n',         AdaptBool( MyClient.IsCentroidDataEnabled().Enabled ) );
    fprintf( 'Marker Ray Data Enabled: %s\n',       AdaptBool( MyClient.IsMarkerRayDataEnabled().Enabled ) );
    
    % Set the streaming mode
    MyClient.SetStreamMode( StreamMode.ClientPull );
    % MyClient.SetStreamMode( StreamMode.ClientPullPreFetch );
    % MyClient.SetStreamMode( StreamMode.ServerPush );
    
    % Set the global up axis
    MyClient.SetAxisMapping( Direction.Forward, ...
        Direction.Left,    ...
        Direction.Up );    % Z-up
    % MyClient.SetAxisMapping( Direction.Forward, ...
    %                          Direction.Up,      ...
    %                          Direction.Right ); % Y-up
    
    Output_GetAxisMapping = MyClient.GetAxisMapping();
    fprintf( 'Axis Mapping: X-%s Y-%s Z-%s\n', Output_GetAxisMapping.XAxis.ToString(), ...
        Output_GetAxisMapping.YAxis.ToString(), ...
        Output_GetAxisMapping.ZAxis.ToString() );
    
    
    % Discover the version number
    Output_GetVersion = MyClient.GetVersion();
    fprintf( 'Version: %d.%d.%d\n', Output_GetVersion.Major, ...
        Output_GetVersion.Minor, ...
        Output_GetVersion.Point );
    
    if TransmitMulticast
        MyClient.StartTransmittingMulticast( 'localhost', '224.0.0.0' );
    end
    Samps=22000;
    Counter = 1;
    pause(1);
    
    
    
    
    % Loop until the message box is dismissed
    fprintf(ard,'%d/n' ,256);
    
    tic
    for Counter = 10:500
        
        
        
        
        % Get a frame
        %  fprintf( 'Waiting for new frame...' );
        while MyClient.GetFrame().Result.Value ~= Result.Success
            fprintf( '.' );
        end% while
        %    fprintf( '\n' );
        
        SubjectCount = MyClient.GetSubjectCount().SubjectCount;
        
        SubjectName = MyClient.GetSubjectName( SubjectCount ).SubjectName;
        % Get the frame number
        Output_GetFrameNumber = MyClient.GetFrameNumber();
        %fprintf( 'Frame Number: %d\n', Output_GetFrameNumber.FrameNumber );
        
        % Get the frame rate
        Output_GetFrameRate = MyClient.GetFrameRate();
        
        SegmentCount = MyClient.GetSegmentCount( SubjectName ).SegmentCount;
        SegmentName = MyClient.GetSegmentName( SubjectName, SegmentCount ).SegmentName;
        
        
        
        for LatencySampleIndex = 1:MyClient.GetLatencySampleCount().Count
            SampleName  = MyClient.GetLatencySampleName( LatencySampleIndex ).Name;
            SampleValue = MyClient.GetLatencySampleValue( SampleName ).Value;
            
            %fprintf( '  %s %gs\n', SampleName, SampleValue );
        end% for
        % fprintf( '\n' );
        
        % Count the number of subjects
        SubjectCount = MyClient.GetSubjectCount().SubjectCount;
        % fprintf( 'Subjects (%d):\n', SubjectCount );
        
        MarkerCount = MyClient.GetMarkerCount( SubjectName ).MarkerCount;
        
        for MarkerIndex = 1:MarkerCount
            % Get the marker name
            MarkerName = MyClient.GetMarkerName( SubjectName, MarkerIndex ).MarkerName;
            
            % Get the marker parent
            MarkerParentName = MyClient.GetMarkerParentName( SubjectName, MarkerName ).SegmentName;
            
            % Get the global marker translation
            Output_GetMarkerGlobalTranslation = MyClient.GetMarkerGlobalTranslation( SubjectName, MarkerName );
            Output_GetSegmentStaticTranslation = MyClient.GetSegmentStaticTranslation( SubjectName, SegmentName );
            %  trans(1,Counter,kk)=Output_GetSegmentStaticTranslation.Translation( 1 );
            %   trans(2,Counter,kk)=Output_GetSegmentStaticTranslation.Translation( 2 );
            %    trans(3,Counter,kk)=Output_GetSegmentStaticTranslation.Translation( 3 );
            
            
            Output_GetSegmentStaticRotationEulerXYZ = MyClient.GetSegmentStaticRotationEulerXYZ( SubjectName, SegmentName );
            %             rot(1,Counter,kk)= Output_GetSegmentStaticRotationEulerXYZ.Rotation( 1 );
            %             rot(2,Counter,kk)= Output_GetSegmentStaticRotationEulerXYZ.Rotation( 2 );
            %             rot(3,Counter,kk)= Output_GetSegmentStaticRotationEulerXYZ.Rotation( 3);
            %             %         fprintf( '      Marker #%d: %s (%g, %g, %g) %s\n',                     ...
            %             MarkerIndex - 1,                                    ...
            %             MarkerName,                                         ...
            %             Output_GetMarkerGlobalTranslation.Translation( 1 ), ...
            %             Output_GetMarkerGlobalTranslation.Translation( 2 ), ...
            %             Output_GetMarkerGlobalTranslation.Translation( 3 ), ...
            %             AdaptBool( Output_GetMarkerGlobalTranslation.Occluded ) );
            
            Pos(1,MarkerIndex,Counter)=Output_GetMarkerGlobalTranslation.Translation( 1 );
            Pos(2,MarkerIndex,Counter)=Output_GetMarkerGlobalTranslation.Translation( 2 );
            Pos(3,MarkerIndex,Counter)=Output_GetMarkerGlobalTranslation.Translation( 3 );
            tim(Counter)=toc;
            
            if Counter > 13&&mod(Counter,2)==0
                
                qwe=[squeeze(Pos(:,1,Counter));squeeze(Pos(:,2,Counter));squeeze(Pos(:,1,Counter-1));squeeze(Pos(:,2,Counter-1));tar(:)];
                
                
                hop=net(qwe);
                
                
                
                hop(hop>90)=90;
                hop(hop<20)=20;
                vals(:,Counter)=hop;
                pnu=(vals(:,Counter)-vals(:,Counter-2))*1+vals(:,Counter-2);
                fprintf(ard,'%d/n' ,round(pnu(1)));
            
                fprintf(ard,'%d/n' ,round(pnu(2)));
            
                fprintf(ard,'%d/n' ,round(pnu(3)));
                
            end

            
            %             x = (P1+P2)/2 -P3
            %             v1=P2-P1
            %             v2=P3-P1
            %             z=cross(v1,v2)
            %             y=cross(z,x);
            %             alpha= atan2(-Z2, Z3)
            %             beta= asin(Z1)
            %             gamma = atan2(-Y1,X1)
            
            
            %                  normal = cross(P1-P2, P1-P3) ;
            %                  b=[1 0 0 ];
            %                      theta = acos(dot(normal,b));
            
            if bReadRays
                % Get the ray contributions for this marker
                Output_GetMarkerRayContributionCount = MyClient.GetMarkerRayContributionCount( SubjectName, MarkerName );
                if( Output_GetMarkerRayContributionCount.Result.Value == Result.Success )
                    fprintf('      Contributed to by: ');
                    
                    MarkerRayContributionCount = Output_GetMarkerRayContributionCount.RayContributionsCount;
                    for ContributionIndex = 1: MarkerRayContributionCount
                        Output_GetMarkerRayContribution = MyClient.GetMarkerRayContribution(SubjectName, MarkerName, ContributionIndex);
                        fprintf( '%d %d ', Output_GetMarkerRayContribution.CameraID, Output_GetMarkerRayContribution.CentroidIndex);
                    end
                    
                    fprintf('\n' );
                end
            end% bReadRays
        end% MarkerIndex
        
        % Get the unlabeled markers
        
        %         UnlabeledMarkerCount = MyClient.GetUnlabeledMarkerCount().MarkerCount;
        %         % fprintf( '    Unlabeled Markers (%d):\n', UnlabeledMarkerCount );
        %         for UnlabeledMarkerIndex = 1:UnlabeledMarkerCount
        %             % Get the global marker translation
        %             Output_GetUnlabeledMarkerGlobalTranslation = MyClient.GetUnlabeledMarkerGlobalTranslation( UnlabeledMarkerIndex );
        %             %             fprintf( '      Marker #%d: (%g, %g, %g)\n',                                    ...
        %             %                 UnlabeledMarkerIndex - 1,                                    ...
        %             %                 Output_GetUnlabeledMarkerGlobalTranslation.Translation( 1 ), ...
        %             %                 Output_GetUnlabeledMarkerGlobalTranslation.Translation( 2 ), ...
        %             %                 Output_GetUnlabeledMarkerGlobalTranslation.Translation( 3 ) );
        %             %
        %
        %             Pos2(1,UnlabeledMarkerIndex,Counter)=Output_GetUnlabeledMarkerGlobalTranslation.Translation( 1 );
        %             Pos2(2,UnlabeledMarkerIndex,Counter)=Output_GetUnlabeledMarkerGlobalTranslation.Translation( 2 );
        %             Pos2(3,UnlabeledMarkerIndex,Counter)=Output_GetUnlabeledMarkerGlobalTranslation.Translation( 3 );
        %             tim(Counter)=toc;
        %             %
        %             %             x = (P1+P2)/2 -P3
        %             %             v1=P2-P1
        %             %             v2=P3-P1
        %             %             z=cross(v1,v2)
        %             %             y=cross(z,x);
        %             %             alpha= atan2(-Z2, Z3)
        %             %             beta= asin(Z1)
        %             %             gamma = atan2(-Y1,X1)
        %         end% UnlabeledMarkerIndex
        
        
        
        
        
        Counter = Counter + 1;
        
        
        % Count the number of devices
        DeviceCount = MyClient.GetDeviceCount().DeviceCount;
        % fprintf( '  Devices (%d):\n', DeviceCount );
        
        for DeviceIndex = 1:DeviceCount
            
            %     fprintf( '    Device #%d:\n', DeviceIndex - 1 );
            
            % Get the device name and type
            Output_GetDeviceName = MyClient.GetDeviceName( DeviceIndex );
            %  fprintf( '      Name: %s\n', Output_GetDeviceName.DeviceName );
            %   fprintf( '      Type: %s\n', Output_GetDeviceName.DeviceType.ToString() );
            
            % Count the number of device outputs
            DeviceOutputCount = MyClient.GetDeviceOutputCount( Output_GetDeviceName.DeviceName ).DeviceOutputCount;
            %     fprintf( '      Device Outputs (%d):\n', DeviceOutputCount );
            for DeviceOutputIndex = 1:DeviceOutputCount
                % Get the device output name and unit
                Output_GetDeviceOutputName = MyClient.GetDeviceOutputName( Output_GetDeviceName.DeviceName, DeviceOutputIndex );
                
                % Get the number of subsamples associated with this device.
                Output_GetDeviceOutputSubsamples = MyClient.GetDeviceOutputSubsamples( Output_GetDeviceName.DeviceName, Output_GetDeviceOutputName.DeviceOutputName );
                
                %     fprintf( '      Device Output #%d:\n', DeviceOutputIndex - 1 );
                
                %      fprintf( '      Samples (%d):\n', Output_GetDeviceOutputSubsamples.DeviceOutputSubsamples );
                
                
                for DeviceOutputSubsample = 1:Output_GetDeviceOutputSubsamples.DeviceOutputSubsamples
                    %    fprintf( '        Sample #%d:\n', DeviceOutputSubsample - 1 );
                    % Get the device output value
                    Output_GetDeviceOutputValue = MyClient.GetDeviceOutputValue( Output_GetDeviceName.DeviceName, Output_GetDeviceOutputName.DeviceOutputName, DeviceOutputSubsample );
                    
                    fprintf( '          ''%s'' %g %s %s\n',                                    ...
                        Output_GetDeviceOutputName.DeviceOutputName,            ...
                        Output_GetDeviceOutputValue.Value,                      ...
                        Output_GetDeviceOutputName.DeviceOutputUnit.ToString(), ...
                        AdaptBool( Output_GetDeviceOutputValue.Occluded ) );
                end% DeviceOutputSubsample
            end% DeviceOutputIndex
            
        end% DeviceIndex
        
        
        
        
        
    end% while true
    
    fclose(ard);
    delete(ard);
    clear ard;
    save closeres.mat
    
    
    
    
    if TransmitMulticast
        MyClient.StopTransmittingMulticast();
    end
    
    % Disconnect and dispose
    MyClient.Disconnect();
    
    % Unload the SDK
    fprintf( 'Unloading SDK...' );
    Client.UnloadViconDataStreamSDK();
    fprintf( 'done\n' );
    
catch
    
    fclose(ard);
    delete(ard);
    clear ard;
    instrreset
end


run ('porcessing.m')

for i=1:199
    scatter3(tar(1),tar(2),tar(3),'g')
    hold on
    scatter3(squeeze(Posi(i,1,1)),squeeze(Posi(i,2,1)),squeeze(Posi(i,3,1)),'r')
    
    pause(0.1)
end

%  scatter3(target(1,:),target(2,:),target(3,:),'g')
%  hold on
%  scatter3((test(1,:)+test(4,:))/2,(test(2,:)+test(5,:))/2,(test(3,:)+test(6,:))/2,'b')
%  hold on
%  scatter3(squeeze(Posi(1:199,1,1)+Posi(1:199,1,2))/2,squeeze(Posi(1:199,2,1)+Posi(1:199,2,2))/2,squeeze(Posi(1:199,3,1)+Posi(1:199,3,2))/2,'r')


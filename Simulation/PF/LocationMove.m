function [Traslation, Rotation] = LocationMove (RobotScan, Param)

    minValue=0; % 0
    maxValue=360; % 2*pi
    angles=minValue:(maxValue-minValue)/Param.ScanRays:maxValue;
    %Traslation =0;
    %if ((AcumRotOut>Param.ScanRays))
        i=1;
        while RobotScan(i)~= max(RobotScan)
            i=i+1;
        end
        if angles(i) < (maxValue-minValue)/2
            Rotation = mod(angles(i),(maxValue-minValue)/2); % Max: half of the way (180 or pi)
        else
            Rotation = -180+mod(angles(i),(maxValue-minValue)/2);
        end
        Traslation = max(RobotScan)*((0.1*rand)+0.2);
    %else
    %    Rotation = (360/Param.ScanRays);
    %    AcumRotOut=AcumRotOut+1;
    %    Traslation = 0;
    %end
    %Rotation = (i-1)*(2*pi)/Param.ScanRays;
    %plot((1:size(RobotScan,2)).*(maxValue-minValue)/Param.ScanRays,RobotScan);
    Rotation=Rotation*pi/180;
    %figure;
    %fprintf('The rotation in degrees is: %f\n',Rotation*180/pi);
end

% function [Traslation, Rotation] = LocationMove (RobotScan, Param)
%     i=1;
%     Traslation=0;
%     while RobotScan(i)~= max(RobotScan)
%         i=i+1;
%     end
%     Rotation = (i-1)*(2*pi)/Param.ScanRays;
%     if Param.CurrentStayIterations > Param.StayIterations
%         Traslation = max(RobotScan)*0.5*rand();
%         Param.CurrentStayIterations = 0;
%     else
%         Param.CurrentStayIterations = Param.CurrentStayIterations + 1;
%     end
% 
% end
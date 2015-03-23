function [Traslation, Rotation] = LocationMove (RobotScan, Param)
    i=1;
    while RobotScan(i)~= max(RobotScan)
        i=i+1;
    end
    Rotation = (i-1)*(2*pi)/Param.ScanRays;
    Traslation = max(RobotScan)*0.5*rand();

end
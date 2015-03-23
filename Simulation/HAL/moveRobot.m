function [ myRobot ] = moveRobot( distance, myRobot, debug)

%%%%% MATTHIAS: 18.03.2015 10.22 --> adapt forward motion

%%%%%%%%%%%%%%%%% NO BACKWARD MOTION INCLUDED!!!!!!!!!!!!

calibratedDistances = [5,10,20,40,60,80];
calibratedDistancesCommand = [4.98,9.9209,19.8235,39.7724,59.6968,79.157];

%%% below 5 cm
if abs(distance) <= calibratedDistances(1)
    distanceCommand = calibratedDistancesCommand/calibratedDistances(1)*distance;
%%% between 5 & 10 cm
elseif abs(distance) > calibratedDistances(1) && abs(distance) <= calibratedDistances(2)
    distanceCommand = calibratedDistancesCommand(1) + (calibratedDistancesCommand(2)-calibratedDistancesCommand(1))/(calibratedDistances(2)-calibratedDistances(1))*(distance-calibratedDistances(1));
%%% between 10 & 20 cm
elseif abs(distance) > calibratedDistances(2) && abs(distance) <= calibratedDistances(3)
    distanceCommand = calibratedDistancesCommand(2) + (calibratedDistancesCommand(3)-calibratedDistancesCommand(2))/(calibratedDistances(3)-calibratedDistances(2))*(distance-calibratedDistances(2));
%%% between 20 & 40 cm
elseif abs(distance) > calibratedDistances(3) && abs(distance) <= calibratedDistances(4)
    distanceCommand = calibratedDistancesCommand(3) + (calibratedDistancesCommand(4)-calibratedDistancesCommand(3))/(calibratedDistances(4)-calibratedDistances(3))*(distance-calibratedDistances(3));
%%% between 40 & 60 cm
elseif abs(distance) > calibratedDistances(4) && abs(distance) <= calibratedDistances(5)
    distanceCommand = calibratedDistancesCommand(4) + (calibratedDistancesCommand(5)-calibratedDistancesCommand(4))/(calibratedDistances(5)-calibratedDistances(4))*(distance-calibratedDistances(4));
%%% above 60 cm
elseif abs(distance) > calibratedDistances(5)
    distanceCommand = calibratedDistancesCommand(5) + (calibratedDistancesCommand(6)-calibratedDistancesCommand(5))/(calibratedDistances(6)-calibratedDistances(5))*(distance-calibratedDistances(5));
end

tachoLimit=abs(round(myRobot.oneMilimiterAngle*distanceCommand*10));
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%tachoLimit=abs(round(myRobot.oneMilimiterAngle*distance*10));

if distance > 0
    myRobot.bothMotors.Power=myRobot.drivingPower;
    myRobot.currentDistance = myRobot.currentDistance + tachoLimit/myRobot.oneMilimiterAngle/10;
else
    myRobot.bothMotors.Power=-myRobot.drivingPower;
    myRobot.currentDistance = myRobot.currentDistance - tachoLimit/myRobot.oneMilimiterAngle/10;
end
myRobot.bothMotors.TachoLimit = tachoLimit;

if debug == 0
    myRobot.bothMotors.SendToNXT();
    myRobot.bothMotors.WaitFor();
    bothMotorData = myRobot.bothMotors.ReadFromNXT; %reads state of motor
end

end
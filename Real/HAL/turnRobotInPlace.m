function [ myRobot ] = turnRobotInPlace( turnAngle, myRobot, debug)

%%%%% MATTHIAS: 17.03.2015 23.37 --> adapt turning
calibratedAngles = [3,5,10,20,45,90,180];
calibratedAnglesCommand = [2.5388,4.6548,9.5821,19.088,42.8798,85.6237,171.0214];

%%%%%%%%%%%%%%%% NOT CALIBRATED FOR TURNS OVER 180 DEGREES!!!!!!!!!!!

%%% below 3 degrees
if abs(turnAngle) <= calibratedAngles(1)
    turnAngleCommand = calibratedAnglesCommand(1)/calibratedAngles(1)*turnAngle;
%%% between 3 & 5 degrees
elseif abs(turnAngle) > calibratedAngles(1) && abs(turnAngle) <= calibratedAngles(2)
    turnAngleCommand = calibratedAnglesCommand(1) + (calibratedAnglesCommand(2)-calibratedAnglesCommand(1))/(calibratedAngles(2)-calibratedAngles(1))*(turnAngle-calibratedAngles(1));
%%% between 5 & 10 degrees
elseif abs(turnAngle) > calibratedAngles(2) && abs(turnAngle) <= calibratedAngles(3)
    turnAngleCommand = calibratedAnglesCommand(2) + (calibratedAnglesCommand(3)-calibratedAnglesCommand(2))/(calibratedAngles(3)-calibratedAngles(2))*(turnAngle-calibratedAngles(2));    
%%% between 10 & 20 degrees
elseif abs(turnAngle) > calibratedAngles(3) && abs(turnAngle) <= calibratedAngles(4)
    turnAngleCommand = calibratedAnglesCommand(3) + (calibratedAnglesCommand(4)-calibratedAnglesCommand(3))/(calibratedAngles(4)-calibratedAngles(3))*(turnAngle-calibratedAngles(3));
%%% between 20 & 45 degrees
elseif abs(turnAngle) > calibratedAngles(4) && abs(turnAngle) <= calibratedAngles(5)
    turnAngleCommand = calibratedAnglesCommand(4) + (calibratedAnglesCommand(5)-calibratedAnglesCommand(4))/(calibratedAngles(5)-calibratedAngles(4))*(turnAngle-calibratedAngles(4));
%%% between 45 & 90 degrees
elseif abs(turnAngle) > calibratedAngles(5) && abs(turnAngle) <= calibratedAngles(6)
    turnAngleCommand = calibratedAnglesCommand(5) + (calibratedAnglesCommand(6)-calibratedAnglesCommand(5))/(calibratedAngles(6)-calibratedAngles(5))*(turnAngle-calibratedAngles(5));
%%% above 90 degrees
elseif abs(turnAngle) > calibratedAngles(6) %&& abs(turnAngle) <= calibratedAngles(7)
    turnAngleCommand = calibratedAnglesCommand(6) + (calibratedAnglesCommand(7)-calibratedAnglesCommand(6))/(calibratedAngles(7)-calibratedAngles(6))*(turnAngle-calibratedAngles(6));
end

tachoLimit=abs(round(myRobot.oneDegAngle*turnAngleCommand));
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%tachoLimit=abs(round(myRobot.oneDegAngle*turnAngle));

if turnAngle > 0
    %Turn left
    myRobot.leftMotor.Power=-myRobot.turningPower;
    myRobot.rightMotor.Power=myRobot.turningPower;
    myRobot.leftMotor.TachoLimit = tachoLimit;
    myRobot.rightMotor.TachoLimit = tachoLimit;
    if debug == 1
        myRobot.currentAngle = myRobot.currentAngle + tachoLimit/myRobot.oneDegAngle;
    end
elseif turnAngle < 0
    %Turn right
    myRobot.leftMotor.Power=myRobot.turningPower;
    myRobot.rightMotor.Power=-myRobot.turningPower;
    myRobot.leftMotor.TachoLimit = tachoLimit;
    myRobot.rightMotor.TachoLimit = tachoLimit;
    if debug == 1
        myRobot.currentAngle = myRobot.currentAngle - tachoLimit/myRobot.oneDegAngle;
    end
else
    %Angle equals 0: don't move
    return;
end

if debug == 0
    
    if turnAngle > 0
        myRobot.leftMotor.SendToNXT();
        myRobot.rightMotor.SendToNXT();
        myRobot.leftMotor.WaitFor();
        myRobot.rightMotor.WaitFor();
    elseif turnAngle < 0
        myRobot.rightMotor.SendToNXT();
        myRobot.leftMotor.SendToNXT();
        myRobot.rightMotor.WaitFor();
        myRobot.leftMotor.WaitFor();
    end
    
    leftMotorData = myRobot.leftMotor.ReadFromNXT; %reads state of motor
    rightMotorData = myRobot.rightMotor.ReadFromNXT; %reads state of motor
    tachoCombined = (leftMotorData.TachoCount + rightMotorData.TachoCount)/2;
    myRobot.currentAngle = myRobot.currentAngle - tachoCombined/myRobot.oneDegAngle;
end

end


function [Robot]=IniOps (Robot)
    global debug;
    if debug == 0
        COM_CloseNXT('all'); %prepares workspace
        h=COM_OpenNXT(); %look for USB devices
        COM_SetDefaultNXT(h); %sets default handle
    end
    % Motor config fixed
    sensorConfig=SENSOR_4;
    leftMotor='A';
    sensorMotor='B';
    rightMotor='C';
    min=1;
    max=2;
    bothMotors=strcat(leftMotor,rightMotor);
    myRobot.drivingPower = 60;
    myRobot.turningPower = 40;
    % Axis size
    axisRadius=[65 87]; % [min max] In milimiters
    wheelRadius=21; % In milimiters
    wheelPerimeter=wheelRadius*pi*2;
    oneDegTurnDistance=(axisRadius(min)*pi*2+axisRadius(max)*pi*2)/2/360;
    oneDegRobotTurnAngle=oneDegTurnDistance*1/wheelPerimeter*360;
    oneMilimeterRobotAngle=1/wheelPerimeter*360;
    if debug == 0
        OpenUltrasonic(sensorConfig(1)); %open usensor on port sensorConfig(1)
    end
    Robot.bothMotors=NXTMotor(bothMotors,'Power', myRobot.drivingPower);
    Robot.leftMotor=NXTMotor(leftMotor);
    Robot.rightMotor=NXTMotor(rightMotor);
    Robot.sensorMotor=NXTMotor(sensorMotor, 'SpeedRegulation', false);
    if debug == 0
        Robot.handle=h;
    end
    Robot.ultrasonicPort=sensorConfig;
    Robot.oneDegAngle=oneDegRobotTurnAngle;
    Robot.oneMilimiterAngle=oneMilimeterRobotAngle;
    Robot.currentAngle=NaN;
    Robot.currentDistance=0;
end

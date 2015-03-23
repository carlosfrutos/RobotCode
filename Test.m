clf;        %clears figures
clc;        %clears console
clear all;  %clears workspace

currentMapIndex=1;
maps = cell(7,1); %needed for making jagged arrays
% maps{1} = [0,0;60,0;60,45;45,45]; %Quadrilateral Map
maps{1} = [0,0;60,0;60,45;45,45;45,59;106,59;106,105;0,105]; %default map
maps{2} = [0,0;20,0;20,60;0,60]; %Small rectangular
maps{3} = [0,0;60,0;60,50;100,50;70,0;110,0;150,80;30,80;30,40;0,80]; %long map
maps{4} = [-30,0;-30,40;30,40;30,60;5,60;45,90;85,60;60,60;60,40;120,40;120,60;95,60;135,90;175,60;150,60;150,40;210,40;210,60;185,60;225,90;265,60;240,60;240,40;300,40;300,0]; %repeated features
maps{5} = [0,0;0,70;40,70;40,80;0,80;0,110;70,110;70,40;30,40;30,30;70,30;70,0]; %repeated features
maps{6} = [0,0;0,30;20,30;20,60;30,60;30,30;40,30;40,60;50,60;50,30;60,30;60,60;70,60;70,30;90,30;90,0];     %Repeated partterns 
maps{7} = [0,0;0,70;40,70;40,80;0,80;0,110;70,110;70,40;30,40;30,30;120,30;120,40;80,40;80,110;150,110;150,80;110,80;110,70;150,70;150,0]; %repeated features

Map=maps{currentMapIndex};

SimSdvMeas = 2;

TestType = 'Real';
if strcmp(TestType,'Sim')
    addpath(genpath([pwd '\Sim']));
    Robot = BotSim(Map,[0,0,0]);        %Defines an object of BotSim class, and dfines its map is the input Map, and sets debug mode on (by adding [0, 0, 0])
    Robot.randomPose(0);                        %Locates robot in a random position
    Robot.setBotAng(2*pi*rand);
    Robot.setSensorNoise(SimSdvMeas);
    Target = Robot.getRndPtInMap(0);   %Defines Target as al randon position within the map
    tic;            
    LocalisedRobot = localise(Robot, Map, Target);
    ResultsTimeRobotLocalise = toc;
    rmpath(genpath([pwd '\Sim']));
else
    addpath(genpath([pwd '\Real']));
    Robot = BotSim(Map,[0,0,0]);        %Defines an object of BotSim class, and dfines its map is the input Map, and sets debug mode on (by adding [0, 0, 0])
    Robot.randomPose(0);             %Locates robot in a random position
    Robot.setBotAng(2*pi*rand);
    Robot.setSensorNoise(SimSdvMeas);
    Target = Robot.getRndPtInMap(0);   %Defines Target as al randon position within the map
    LocalisedRobot = localise(Robot, Map, Target);
    tic;
    ResultsTimeRobotLocalise = toc;
    rmpath(genpath([pwd '\Real']));
end
ResultsDist = distance(Target,LocalisedRobot.getBotPos());





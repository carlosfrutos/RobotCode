function [MoveObjectOut, MoveObjectArrayOut] = MoveVirtualRobotSim(Traslation, Rotation, VirtualRobot, MoveObjectArrayIn, Param)
MoveObjectOut=VirtualRobot;
MoveObjectArrayOut=MoveObjectArrayIn;
MoveObjectOut.turn(Rotation); %turn the real robot
MoveObjectOut.move(Traslation); %move the real robot
%We can't access the real robot's position and angle
% MoveObjectArrayOut(i,Param.XCoord:Param.YCoord)= MoveObjectOut(i).getBotPos();   
% MoveObjectArrayOut(i, Param.Orientation) = MoveObjectOut(i).getBotAng(); 
end

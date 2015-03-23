function [MoveObjectOut, MoveObjectArrayOut] = MoveReal(Translation, Rotation, MoveObjectIn, MoveObjectArrayIn, Param)
global debug;
MoveObjectOut=MoveObjectIn;
MoveObjectArrayOut=MoveObjectArrayIn;
for i =1:size(MoveObjectArrayIn,1) %for all the particles. 
        if (size(MoveObjectArrayIn,1) ==1);
            [a ] = turnRobotInPlace(Rotation, MoveObjectIn, debug);
            [b ] = moveRobot(Translation, MoveObjectIn, debug);  %debug=0 -->robot connectod
        else    
            ActualRotation = Rotation-(2*pi*floor((MoveObjectOut(i).getBotAng()+Rotation)/(2*pi)));
            MoveObjectOut(i).turn(normrnd(ActualRotation,Param.SdvRot)); %turn the particle in the same way as the real robot
            MoveObjectOut(i).move(normrnd(Translation,Param.SdvTrns)); %move the particle in the same way as the real robot
            MoveObjectArrayOut(i,Param.XCoord:Param.YCoord)= MoveObjectOut(i).getBotPos();   
            MoveObjectArrayOut(i, Param.Orientation) = MoveObjectOut(i).getBotAng();
        end
end
end


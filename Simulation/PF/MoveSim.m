function [MoveObjectOut, MoveObjectArrayOut] = MoveSim(Traslation, Rotation, MoveObjectIn, MoveObjectArrayIn, Param)
MoveObjectOut=MoveObjectIn;
MoveObjectArrayOut=MoveObjectArrayIn;
for i =1:size(MoveObjectArrayIn,1) %for all the particles. 
        %ActualRotation = mod(floor((MoveObjectOut(i).getBotAng()+Rotation)*180/pi),180)*pi/180;
        % Uncomment for noise in rotation
        MoveObjectOut(i).turn(normrnd(Rotation,Param.SdvRot/2)); %turn the particle in the same way as the real robot
        % Uncomment for no noise in rotation
        %MoveObjectOut(i).turn(Rotation); %turn the particle in the same way as the real robot
        MoveObjectOut(i).move(normrnd(Traslation,Param.SdvTrns)); %move the particle in the same way as the real robot
        MoveObjectArrayOut(i,Param.XCoord:Param.YCoord)= MoveObjectOut(i).getBotPos();   
        MoveObjectArrayOut(i, Param.Orientation) = MoveObjectOut(i).getBotAng(); 
end
end

% function [MoveObjectOut, MoveObjectArrayOut] = MoveSim(Translation, Rotation, MoveObjectIn, MoveObjectArrayIn, Param)
% MoveObjectOut=MoveObjectIn;
% MoveObjectArrayOut=MoveObjectArrayIn;
% for i =1:size(MoveObjectArrayIn,1) %for all the particles. 
%     ActualRotation = Rotation-(2*pi*floor((MoveObjectOut(i).getBotAng()+Rotation)/(2*pi)));
%     MoveObjectOut(i).turn(normrnd(ActualRotation,Param.SdvRot)); %turn the particle in the same way as the real robot
%     MoveObjectOut(i).move(normrnd(Translation,Param.SdvTrns)); %move the particle in the same way as the real robot
%     MoveObjectArrayOut(i,Param.XCoord:Param.YCoord)= MoveObjectOut(i).getBotPos();   
%     MoveObjectArrayOut(i, Param.Orientation) = MoveObjectOut(i).getBotAng();
% end
% end


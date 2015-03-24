function [ParticlesOut, ParticlesArrayOut] = CheckInMap(ParticlesIn, ParticlesArrayIn, Iteration, Param, minDistance)
ParticlesOut=ParticlesIn;
ParticlesArrayOut=ParticlesArrayIn;
for i =1:size(ParticlesArrayIn,1) 
    if (ParticlesOut(i).pointInsideMap(ParticlesOut(i).getBotPos)==0)
        ParticlesOut(i).randomPose(minDistance*Param.minDistanceToWallWeigth);
        ParticlesOut(i).setBotAng(2*pi*rand);
        ParticlesArrayOut(i,Param.XCoord:Param.YCoord)= ParticlesOut(i).getBotPos();   
        ParticlesArrayOut(i, Param.Orientation) = ParticlesOut(i).getBotAng(); 
    end   
end
end
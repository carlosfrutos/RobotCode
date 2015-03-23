function [ParticlesOut, ParticlesArrayOut]=Populate (ParticlesIn, ParticlesArrayIn, Iteration, Param)
ParticlesOut=ParticlesIn;
ParticlesArrayOut=ParticlesArrayIn;
if Iteration == 1 
    for i = 1:size(ParticlesOut,1)
        ParticlesOut(i).randomPose(0); 
        ParticlesOut(i).setBotAng(2*pi*rand);
        ParticlesArrayOut(i,Param.XCoord:Param.YCoord)= ParticlesOut(i,1).getBotPos();
        ParticlesArrayOut(i, Param.Orientation) = ParticlesOut(i,1).getBotAng();
    end
else
    ParticlesSorted = sortrows(ParticlesArrayOut, -Param.Weight);
    iSort0 = 0;
    iSort1 = 0;
    ParticAcum = 0;
    for i = 1:size(ParticlesOut,1)
        if (ParticAcum <= 0.5)
            iSort0 = iSort1+1;   
        end   
        while (ParticAcum < 0.5)
            iSort1= iSort1 + 1;
            ParticAcum = ParticAcum + size(ParticlesOut,1) * ParticlesSorted(iSort1,Param.Weight);
        end
        ParticlesArrayOut(i,:) = ParticlesSorted(iSort0,:);
        ParticlesOut(i).setBotPos(ParticlesSorted(iSort0, [Param.XCoord Param.YCoord]));
        ParticlesOut(i).setBotAng(ParticlesSorted(iSort0, Param.Orientation));
        ParticAcum = ParticAcum -1;
    end    
end
end

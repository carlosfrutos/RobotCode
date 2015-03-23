function [ParticlesOut, ParticlesArrayOut] = UWeight(RobotScan, ParticlesIn, ParticlesArrayIn,Param)
ParticlesArrayOut=ParticlesArrayIn;
ParticlesOut=ParticlesIn;
for i = 1:size(ParticlesArrayOut,1)
    ParticlesArrayOut (i, Param.Weight) = prod (normpdf(ParticlesArrayOut(i,Param.Scan:Param.Scan+Param.ScanRays-1),RobotScan(:)',Param.SimSdvMeas));    %Probability of each particle
end
K=Param.PerK/(100*size(ParticlesArrayOut,1));                                                                     %Parameter utilisen in noprmalisation to reduce removal low-weighted particles
ParticlesArrayOut(:,Param.Weight)=(ParticlesArrayOut(:,Param.Weight)+K)/(sum(ParticlesArrayOut(:,Param.Weight)+K));   %Probability normalised and addapted with K
for i = 1:size(ParticlesArrayOut,1)
    if (ParticlesArrayOut(i,Param.Weight)<Param.PerRot/(100*size(ParticlesArrayOut,1)))
        Selected = 0;
        MaxWeight = -1;
        for j = 1:size((ParticlesArrayOut),2)-4;
            WeightDoomy = prod (normpdf(ParticlesArrayOut(i,Param.Scan:Param.Scan+Param.ScanRays-1),RobotScan(:)',Param.SimSdvMeas));    %Probability of each particle
            if (WeightDoomy> MaxWeight)
                Selected = j;
                MaxWeight = WeightDoomy;
            end    
        end
        ParticlesArrayOut(i,Param.Orientation)=ParticlesArrayOut(i,Param.Orientation)-((Selected*2*pi)/Param.ScanRays);
        ParticlesArrayOut(i,Param.Weight)=MaxWeight;
        ParticlesOut(i).turn(((-1)*Selected*2*pi)/Param.ScanRays);
    end
end
ParticlesArrayOut(:,Param.Weight)=(ParticlesArrayOut(:,Param.Weight)+K)/(sum(ParticlesArrayOut(:,Param.Weight)+K));   %Probability normalised and addapted with K
end      
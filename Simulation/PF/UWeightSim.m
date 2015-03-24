function [ParticlesOut, ParticlesArrayOut] = UWeightSim(RobotScan, ParticlesIn, ParticlesArrayIn,Param, Converged)
ParticlesArrayOut=ParticlesArrayIn;
ParticlesOut=ParticlesIn;
measurementColumns = Param.Scan:Param.ScanRays+Param.Scan-1;
for i = 1:size(ParticlesArrayOut,1)
    ParticlesArrayOut (i, Param.Weight) = prod (normpdf(ParticlesArrayOut(i,measurementColumns),RobotScan(:)',Param.SimSdvMeas));    %Probability of each particle
end
K=Param.PerK/(100*size(ParticlesArrayOut,1));                                                                     %Parameter utilisen in noprmalisation to reduce removal low-weighted particles
ParticlesArrayOut(:,Param.Weight)=(ParticlesArrayOut(:,Param.Weight)+K)/(sum(ParticlesArrayOut(:,Param.Weight)+K));   %Probability normalised and addapted with K
for i = 1:size(ParticlesArrayOut,1)
    if (ParticlesArrayOut(i,Param.Weight)<Param.PerRot/(100*size(ParticlesArrayOut,1)))
        Selected = 0;
        MaxWeight = -1;
%         for j = 1:size((ParticlesArrayOut),2)-4;
%             WeightDoomy = prod (normpdf(ParticlesArrayOut(i,Param.Scan:Param.Scan+Param.ScanRays-1),RobotScan(:)',Param.SimSdvMeas));    %Probability of each particle
%             if (WeightDoomy> MaxWeight)
%                 Selected = j;
%                 MaxWeight = WeightDoomy;
%             end    
%         end
        % Scan shifting against particle angles: check if a rotation in the
        % particle increases the probability of matching the robot's
        % position
        for j = 1:Param.ScanRays
            tempColumns=circshift(measurementColumns,[0 j]);
            if ~Converged
                WeightDummy = prod (normpdf(ParticlesArrayOut(i,tempColumns),RobotScan(:)',Param.SimSdvMeas));    %Probability of each particle
            else
                WeightDummy = prod (normpdf(ParticlesArrayOut(i,tempColumns),RobotScan(:)',Param.SimSdvMeasConverged));    %Probability of each particle
            end
            if (WeightDummy> MaxWeight)
                Selected = j;
                MaxWeight = WeightDummy;
            end    
        end
        particleTurning=-Selected*2*pi/Param.ScanRays;
        ParticlesArrayOut(i,Param.Orientation)=ParticlesArrayOut(i,Param.Orientation)+particleTurning;
        ParticlesArrayOut(i,Param.Weight)=MaxWeight;
        ParticlesOut(i).turn(particleTurning);
    end
end
ParticlesArrayOut(:,Param.Weight)=(ParticlesArrayOut(:,Param.Weight)+K)/(sum(ParticlesArrayOut(:,Param.Weight)+K));   %Probability normalised and addapted with K
end      
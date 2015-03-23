function [returnedBot] = localise(Robot, Map, Target)
clf;        %clears figures
clc;        %clears console
clearvars -except Robot Target Map
global debug;
debug = 1;
addpath(genpath(pwd));

Param = ParametersSim (Map);
[Particles, ParticlesArray] = IniParticles (Param.PIniPartic);
InTarget = 0;
Converged = 0;
n = 0;
APathPlan = 0;
while ((InTarget == 0) && (n < Param.MaxIterations))
    n=n+1;
    [Particles, ParticlesArray] = Populate(Particles, ParticlesArray, n, Param.PPopulate);
    
    if n~=1
        if Converged == 0
            [NextTranslation, NextRotation] = LocationMove (RobotScan, Param.PLocationMove);
        else
            [NextTranslation, NextRotation, APathPlan] = PathPlan(PFLocEstim, PFOriEstim,ParticlesSubset, Target, Param.PPPlan.Map, APathPlan, Param.PPPlan.Figure); 
        end
        [Robot, ] = MoveSim(NextTranslation, NextRotation, Robot, [1 1 1 1], Param.PMove);
        [Particles, ParticlesArray] = MoveSim(NextTranslation, NextRotation, Particles, ParticlesArray, Param.PMove);
        [Particles, ParticlesArray] = CheckInMap (Particles, ParticlesArray, n, Param.PCheckInMap);
        if debug
            PlotScenario(Param.PPlot, Robot, Particles, Target);
        end
    end
    [returnedBot, Converged, ParticlesSubset] = CheckConvergence(Particles, ParticlesArray,Param.PCheckConv);
    PFLocEstim = mean(ParticlesArray(:,Param.XCoord : Param.YCoord));
    PFOriEstim = mean(ParticlesArray(:,Param.Orientation));
    if (Converged == 1)
        display (PFLocEstim);
    end
    ParticlesArray(:,Param.Scan:(Param.Scan+Param.ScanRays-1)) = UltraScanSim(Particles, Param.PUScan);
    RobotScan = UltraScanSim(Robot,Param.PUScan);
    InTarget = (distance(Target,returnedBot.getBotPos())<Param.InTgtThd);
    [Particles, ParticlesArray] = UWeightSim(RobotScan, Particles, ParticlesArray, Param.PUWeight);
end
rmpath(genpath(pwd));
end

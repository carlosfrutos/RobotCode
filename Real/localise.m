function [LocalisedRobot] = localise(Robot, Target, Map)
clf;        %clears figures
clc;        %clears console
clearvars -except Robot Target Map
global debug;
debug = 1;
addpath(genpath(pwd));
% IniOps uses debug
Robot=IniOps();
Param = ParametersReal (Map);
[Particles, ParticlesArray] = IniParticles (Param.PIniPartic);
InTarget = 0;
Converged = 0;
n = 0;
APathPlan = 0;
while ((InTarget == 0) && (n < Param.MaxIterations))
    n=n+1;
    [Particles, ParticlesArray] = PopulateReal(Particles, ParticlesArray, n, Param.PPopulate);
    PlotScenario(Param.PPlot, Robot, Particles, Target);
    if n~=1
        if Converged == 0
            [NextTranslation, NextRotation] = LocationMove (RobotScan, Param.PLocationMove);
        else
            [NextTranslation, NextRotation, APathPlan] = pathPlan(PFLocEstim, PFOriEstim,ParticlesSubset, Target, Param.PPPlan.Map, APathPlan, Param.PPPlan.Figure);
        end
        % MoveReal uses debug
        [Robot, ] = MoveReal(NextTranslation, NextRotation, Robot, [1 1 1 1], Param.PMove);
        [Particles, ParticlesArray] = MoveReal(NextTranslation, NextRotation, Particles, ParticlesArray, Param.PMove);
        [Particles, ParticlesArray] = CheckInMap (Particles, ParticlesArray, n, Param.PCheckInMap);
    end
    [LocalisedRobot, Converged, ParticlesSubset] = CheckConvergence(Particles, ParticlesArray,Param.PCheckConv);
    PFLocEstim = mean(ParticlesArray(:,Param.XCoord : Param.YCoord));
    PFOriEstim = mean(ParticlesArray(:,Param.Orientation));
    if (Converged == 1)
        Display (PFLocEstim);
    end
    ParticlesArray(:,Param.Scan:(Param.Scan+Param.ScanRays-1)) = UltraScanReal(Particles, Param.PUScan);
    RobotScan = UltraScanReal(Robot,Param.PUScan);
    InTarget = (distance(Target,LocalisedRobot.getBotPos())<Param.InTgtThd);
    [Particles, ParticlesArray] = UWeight(RobotScan, Particles, ParticlesArray, Param.PUWeight);
end
rmpath(genpath(pwd));
if debug == 0
    CloseOps();
end
end

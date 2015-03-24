function [returnedBot] = localise(Robot, Map, Target)
clf;        %clears figures
%clc;        %clears console
%clearvars -except Robot Target Map
global debug mainFigure auxFigure;
debug = 1;
mainFigure = gcf;
%auxFigure = figure;
%set(mainFigure);

addpath(genpath(pwd));

Param = ParametersSim (Map);
[Particles, ParticlesArray] = IniParticles (Param.PIniPartic);
InTarget = 0;
Converged = 0;
n = 0;
APathPlan = 0;
RobotScan = zeros(size(Robot,1),Param.PUScan.ScanRays);
while ((InTarget == 0) && (n < Param.MaxIterations))
    n=n+1;
    [Particles, ParticlesArray] = Populate(Particles, ParticlesArray, n, Param.PPopulate,RobotScan);
    
    if n~=1
        if Converged == 0
            [NextTranslation, NextRotation] = LocationMove (RobotScan, Param.PLocationMove);
            fprintf('Next translation/rotation: %f/%f\n',NextTranslation(1),NextRotation*180/pi);
        else
            [NextTranslation, NextRotation, APathPlan] = PathPlan(PFLocEstim, PFOriEstim,ParticlesSubset, Target, Param.PPPlan.Map, APathPlan, Param.PPPlan.Figure); 
            fprintf('Next translation/rotation: %f/%f\n',NextTranslation(1),NextRotation*180/pi);
        end
        % Move the real robot
        [Robot, ] = MoveVirtualRobotSim(NextTranslation, NextRotation, Robot, [1 1 1 1], Param.PMove);
        % Move the particles
        [Particles, ParticlesArray] = MoveSim(NextTranslation, NextRotation, Particles, ParticlesArray, Param.PMove);
        % Check which of them are inside map. Regenerate particles that
        % went outside
        [Particles, ParticlesArray] = CheckInMap (Particles, ParticlesArray, n, Param.PCheckInMap, min(RobotScan));
        if debug
            PlotScenario(Param.PPlot, Robot, Particles, Target);
        end
    end
    [returnedBot, Converged, ParticlesSubset] = CheckConvergence(Particles, ParticlesArray,Param.PCheckConv);
    PFLocEstim = mean(ParticlesArray(:,Param.XCoord : Param.YCoord));
    PFOriEstim = mean(ParticlesArray(:,Param.Orientation));
    if (Converged == 1)
        fprintf('Converged estimated Robot position/orientation: [%f %f]/%f\n',PFLocEstim(1),PFLocEstim(2),PFOriEstim*180/pi);
    end
    ParticlesArray(:,Param.Scan:(Param.Scan+Param.ScanRays-1)) = UltraScanSim(Particles, Param.PUScan);
    RobotScan = UltraScanSim(Robot,Param.PUScan);
    InTarget = (distance(Target,returnedBot.getBotPos())<Param.InTgtThd);
    [Particles, ParticlesArray] = UWeightSim(RobotScan, Particles, ParticlesArray, Param.PUWeight, Converged);
end
fprintf('END OF SIMULATION - ESTIMATED POSITION: [%f %f] AFTER %d ITERATIONS\n',PFLocEstim(1),PFLocEstim(2), n);
end

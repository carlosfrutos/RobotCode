function []=PlotScenario(Param, Robot, Particles, Target)
if strcmp(Param.PlotMode,'Plot')
    hold off
    figure(Param.Figure);
    set(gca,'FontSize',12);
    Robot.drawMap();
    DoomyRobotTarget=BotSim(Robot.getMap(),[0,0,0]);
    DoomyRobotTarget.setBotPos(Target);
    if strcmp(Param.Mode, 'Sim')
        Robot.drawBot(30,'r');
    end
    DoomyRobotTarget.drawBot(30,'g');
    for i =1:size(Particles,1)
        Particles(i).drawBot(3); %draw particle with line length 3 and default color
    end
    drawnow;
end
end

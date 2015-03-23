function [Robot, Convergence, ParticlesSubset] = CheckConvergence(Particles, ParticlesArray, Param)
SDX=std(ParticlesArray(:,Param.XCoord));
SDY=std(ParticlesArray(:,Param.YCoord));
SDO=std(ParticlesArray(:,Param.Orientation));
Robot=Particles(1);
ParticlesSubset(floor(size(ParticlesArray,1)*(Param.PerTransm/100)),1)=Particles(1);
if ((SDX<Param.ConvThd) && (SDY<Param.ConvThd) && (SDO<Param.ConvThd))
    Convergence = 1;
    Robot.setBotAng(mean(ParticlesArray(:,Param.Orientation)));
    Robot.setBotPos([mean(ParticlesArray(:,Param.XCoord)), mean(ParticlesArray(:,Param.YCoord))]);
    ParticlesSorted = sortrows(ParticlesArray, -Param.Weight);
    ParticlesSubset (floor(size(ParticlesArray,1))*(Param.PerTransm/100),1)=Particles(1);
    i=1;
    j=1;
    while ((j<=floor(size(ParticlesArray,1))*Param.PerTransm/100) &&(i<=size(ParticlesArray,1)))
        if (ParticlesArray(j,Param.Weight)>= ParticlesSorted (floor(size(ParticlesArray,1))*(Param.PerTransm/100), Param.Weight))
            ParticlesSubset(i)=Particles(j); 
            i=i+1;
        end
        j=j+1;
    end
else
    Convergence = 0;
end
end  
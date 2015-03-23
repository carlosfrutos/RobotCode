function [Particles, ParticlesArray] = IniParticles(Param)
[Particles(Param.NumParticles,1)] = BotSim;
for i = 1: Param.NumParticles
    Particles(i)=BotSim(Param.Map,[0,0,0]);
    Particles(i).setScanConfig(Particles.generateScanConfig(Param.ScanRays));
end
[ParticlesArray(Param.NumParticles,4+Param.ScanRays)] = 0;
end


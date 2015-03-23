function [ maxDistance ] = maxParticleDistance( centre, Particles )

maxDistance = inf;
for i=1:size(Particles,1)
    currentParticlePos=Particles(i).getBotPos();
end
currentDistance = sqrt((currentParticlePos(:,1)-centre(1,1))^2+(currentParticlePos(:,2)-centre(1,2))^2);
maxDistance = max(currentDistance);

end


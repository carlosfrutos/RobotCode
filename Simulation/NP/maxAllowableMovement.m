function [ turnCommand, moveCommand] = maxAllowableMovement( map, particles, nextPoint, movement, bubbleSize )
%  Checks which is the maximum movement achievable by the given particles
%  in order to keep all of them inside the map

particlePositions=zeros(size(particles,1),2);
particleAngles=zeros(size(particles,1),1);

tempLinks=zeros(size(particles,1),4);
diffAngle=zeros(size(particles,1),3); % [diffAngle isLeftIn isRightIn]
maxAngle=0; % Initialise the maximum angle that make the robot be outside of the map

for i=1:size(particles,1)
    particlePositions(i,:)=particles(i).getBotPos();
    %First we turn to face the corner
    particles(i).turn(movement(1));
    particleAngles(i)=particles(i).getBotAng();
    tempLinks(i)=[nextPoint particlePositions(i,:)];
    % Then check if the move command is letting the robot outside of the
    % map.
    tempParticlePos=particles(i).getBotPos();
    particles(i).move(movement(2));
    result=inpolygon(tempParticlePos(1),tempParticlePos(2),map(:,1),map(:,2));
    if result == 0
        % The point is outside
        realMovementVector=[tempParticlePos(1)-particlePositions(i,1) tempParticlePos(2)-particlePositions(i,2)];
        expectedMovementVector=[nextPoint(1)-particlePositions(i,1) nextPoint(2)-particlePositions(i,2)];
        diffAngle(i,1)=vectorAngle(realMovementVector)-vectorAngle(expectedMovementVector);
        % Update the maxAngle value
        if abs(diffAngle(i,1)) > abs(maxAngle)
            maxAngle = diffAngle(i,1);
        end
        if diffAngle(i,1) > 0
            diffAngle(i,2)=0;
            otherPosition=3; % Index to store the value of the symetric point
        else %diffAngle(i,1) < 0
            diffAngle(i,3)=0;
            otherPosition=2; % Index to store the value of the symetric point
        end
        % Now check if the symetric one is also outside
        tempParticle=particles(i);
        tempParticle.move(-movement(2)); % Return to the previous position
        tempParticle.move(-2*movement(1)); % Turn to symetric angle
        tempParticle.move(movement(2)); % Move forwards
        symetricPosition=tempParticle.getBotPos();
        result=inpolygon(symetricPosition(1),symetricPosition(2),map(:,1),map(:,2));
        diffAngle(i,otherPosition)=result;
        if result == 0
            % Both points are outside the map: remove the modulus of the
            % sum vector from the movement
        end
        
        particles(i).drawBot(3); %draw particle with line length 3 and default color
    end
end




end


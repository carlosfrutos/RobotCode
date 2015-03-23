function [ safetyMap ] = calcSafetyMovementMap( map, safetyDistance,maxSafetyHypotenuse)
global debug;
if isinf(safetyDistance)
    safetyDistance = 15; % Default value
end
mapLinks=map-circshift(map,1);

mapAngles=vectorAngle(mapLinks);

A=zeros(size(mapAngles,1),1); %Start link angle
for i=1:size(mapAngles,1)
    if mapAngles(i) < 0
        A(i)=360+mapAngles(i);
    else
        A(i)=mapAngles(i);
    end
end

diffAngles=zeros(size(mapAngles,1),1);
shiftedA=circshift(A,-1); %End link angle
for i=1:size(mapAngles,1)
    if A(i) > shiftedA(i)
        shiftedA(i)=shiftedA(i)+360;
    end
    if shiftedA(i)-A(i) < 180
        diffAngles(i) = shiftedA(i)-A(i);
        if diffAngles(i) < -180
            diffAngles(i)=diffAngles(i)+180;
        end
    else
        diffAngles(i) = -360+shiftedA(i)-A(i);
        if diffAngles(i) > 180
            diffAngles(i)=diffAngles(i)-180;
        end
        
    end
end

B=diffAngles;

bisectors=mod((2*A+180+B)/2,360);
c_side = zeros(size(bisectors,1),1);
for i=1:size(bisectors)
    if abs(diffAngles(i))< 90
        c_side(i)=safetyDistance.*cosd(bisectors(i))./sind(bisectors(i));
    else
        c_side(i)=safetyDistance.*max([abs(cosd(bisectors(i))) abs(sind(bisectors(i)))])./min([abs(sind(bisectors(i))) abs(cosd(bisectors(i)))]);
    end
end
h=sqrt(safetyDistance.^2+c_side.^2);
if h > maxSafetyHypotenuse
    h = maxSafetyHypotenuse;
end
safetyMap=[map map(:,1)+h.*cosd(bisectors) map(:,2)+h.*sind(bisectors)];


if lineInPolygon([map(1,:) safetyMap(1,[3 4])],map) == 1
    %mapSide = 'left';
else
    %mapSide = 'right';
    % we have to fix the bisectors
    bisectors=mod(bisectors-180,360);
    c_side = zeros(size(bisectors,1),1);
    for i=1:size(bisectors)
        if abs(diffAngles(i))< 90
            c_side(i)=safetyDistance.*cosd(bisectors(i))./sind(bisectors(i));
        else
            c_side(i)=safetyDistance.*max([abs(cosd(bisectors(i))) abs(sind(bisectors(i)))])./min([abs(sind(bisectors(i))) abs(cosd(bisectors(i)))]);
        end
    end
    h=sqrt(safetyDistance.^2+c_side.^2);
    if h > maxSafetyHypotenuse
        h = maxSafetyHypotenuse;
    end
    safetyMap=[map map(:,1)+h.*cosd(bisectors) map(:,2)+h.*sind(bisectors)];
end


lines=[safetyMap(:,[3 4]) circshift(safetyMap(:,[3 4]),-1)];
if debug
    drawLines( lines,'b' );
end

end


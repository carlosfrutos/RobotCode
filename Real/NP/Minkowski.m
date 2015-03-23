function [ mkMap ] = Minkowski( map, robotSize )
% Function to calculate the inner map considering the Minkowski space
mkMap=zeros(size(map));

%% Create a map set of the reduced map position considering the following
%parameters for each point in the map:
%   map side (overall sum of angles might be positive or negative)
%   previous angle (considering the previous point position)
%   current angle (considering the next point position)
keySet =   {'left/0/90', 'left/0/-90', 'left/90/90', 'left/90/-90', ...
            'left/180/90', 'left/180/-90', 'left/270/90', 'left/270/-90', ...
            'right/0/90', 'right/0/-90', 'right/90/90', 'right/90/-90', ...
            'right/180/90', 'right/180/-90', 'right/270/90', 'right/270/-90'};
valueSet = {[-1, 1],[1, 1],[-1, -1],[-1, 1],[1, -1],[-1, -1],[1, 1],[1, -1], ...
    [1, -1],[-1, -1],[1, 1],[1, -1],[-1, 1],[1, 1],[-1, -1],[-1, 1]};
mapObj = containers.Map(keySet,valueSet);
%% Create the map vectors
vectorEnds=[map(2:size(map,1),:); map(1,:)];
myvectors=vectorEnds-map;

%% Calculate angles between them
mapAngles=vectorAngle(myvectors);
secondMapAngles=[mapAngles(2:size(mapAngles),:); mapAngles(1,:)];
angleDiff=zeros(size(mapAngles,1),1);
for i=1:size(mapAngles)
    if secondMapAngles(i)<0
        secondMapAngles(i)=secondMapAngles(i)+360;
    end
    angleDiff(i)=secondMapAngles(i)-mapAngles(i);
    if mapAngles(i)<0
        mapAngles(i)=mapAngles(i)+360;
    end
end

%% Correct angle offsets to start from first point
previousAngles=[mapAngles(size(mapAngles,1),:); mapAngles(1:size(mapAngles,1)-1,:)];
tempAngleDiff=[angleDiff(size(angleDiff,1),:); angleDiff(1:size(angleDiff,1)-1,:)];
angleDiff=tempAngleDiff;
%Check if the map is on the left or in the right side, starting from the
%beginning
if sum(angleDiff) > 0
    side='left';
else
    side='right';
end
%Find the desired positions
for i=1:size(map,1)
    currentKey=sprintf('%s/%d/%d',side,previousAngles(i),angleDiff(i));
    multipliers = mapObj(currentKey);
    mkMap(i,:)=map(i,:)+robotSize*multipliers;
end

%plot(map(:,1),map(:,2),'s',mkMap(:,1),mkMap(:,2),'+') 

%display vectors
%bot.pointInsideMap(bot,points);

end


function [ safetyPathPoint ] = getSafetyPoint( safetyMap, optimalPathPoint )
% This function obtains the associated safety point from the calculated
% safetyMap. This map needs to have the following format:
%   [mapPointX mapPointY safetyMapPointX safetyMapPointY]

safetyPathPoint=optimalPathPoint; % Needed in case that the point is the target
for i=1:size(safetyMap,1)
    if isequal(safetyMap(i,[1 2]),optimalPathPoint)
        safetyPathPoint = safetyMap(i,[3 4]);
        break;
    end
end

end


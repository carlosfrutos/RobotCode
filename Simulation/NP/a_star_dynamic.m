function [ nextLink ] = a_star_dynamic( configSpace, currentLink, target, staticPathPlan )
% Function to calculate the next step during the various movements through
% the configuration space (it might be just a safety map, but the main
% issue is to avoid trying to cross walls, since the configSpace size is
% dynamic (i.e. may change at every iteration) and we are not calculating
% the optimal path to target every iteration, since it will be too heavy.
%   configSpace: contains the configuration space as well as original map
%   coordinates.
%   currentLink: the real map link
%   target: contains the target point
%   links: contains all the visible links between map points and target

% The return value is the next link

%% First check if the end point is visible
if isVisibleCorner( configSpace(:,[3 4]),currentLink )
    if isequal(currentLink([3 4]),target)
        % If it is the target, we are done
        nextLink=currentLink;
        return;
    end
end

%% If it is not visible, we need to check the nearest path to the
% configuration space

% First check: the start point is inside the safety map? otherwise, it will
% detect many false visible points. Once detected the path, make the move.
% This function will then be called again in the next iteration to find the
% next step.
if ~min(pointInPolygon(currentLink(1,[1 2]),configSpace(:,[3 4])))
    % This function allways returns a value
    endPoint=getNearestSafetyPoint(currentLink(1,[1 2]), configSpace(:,[3 4]), configSpace(:,[1 2]));
    if isVisibleCorner( configSpace(:,[1 2]),[currentLink(1,[1 2]) endPoint] )
        nextLink=[currentLink(1,[1 2]) endPoint; endPoint [NaN NaN]];
        return;
    end
end

currentVisibleLinks=getVisibleCorners( currentLink(1,[1 2]), configSpace(:,[3 4]), target );
% Second check: sometimes target and position are out of the configuration
% space, so we restrict that they also have to be visible considering the
% real map
i=1;
while i<size(currentVisibleLinks,1)
    if ~isVisibleCorner(configSpace(:,[1 2]),currentVisibleLinks(i,:))
        currentVisibleLinks(i,:)=[]; % Delete it
    end
    i=i+1;
end
%Now translate the points to real map coordinates (path plan is based on
%these)
currentVisibleLinks=[currentVisibleLinks, zeros(size(currentVisibleLinks,1),2)];
for i=1:size(currentVisibleLinks,1)
    for j=1:size(configSpace,1)
        if isequal(currentVisibleLinks(i,[3 4]),configSpace(j,[3 4]))
            currentVisibleLinks(i,[5 6])=configSpace(j,[1 2]);
            break;
        end
    end
end

%Find it on the plan, but return the safe point link instead for the end
%position
found=0;
for i=1:size(staticPathPlan,1)
    for j=1:size(currentVisibleLinks,1)
        if isequal(staticPathPlan{i,3}(1,[1 2]),currentVisibleLinks(j,[5 6]))
            nextLink=currentVisibleLinks(j,[1 2 3 4]);
            found = 1;
            break;
        end
    end
    if found
        break;
    end
end


end


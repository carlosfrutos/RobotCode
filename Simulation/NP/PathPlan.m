function [ turnInstructions, moveInstructions, plan ] = PathPlan( currentPos,currentAng,ParticlesSubset,target,map,previousPlan,fMap )
% [mean(ParticlesArray(:,Param.XCoord : Param.YCoord))], mean(ParticlesArray(:,Param.Orientation)),ParticlesSubset
% stateChange is a variable containing the information needed to make the
% next movement:
%   [turnCommands moveCommandsMotor1 moveCommandsMotor2]
global debug;
figure(fMap);
% fMap=figure('Name','Map');
% hold on;

%lines=[map circshift(map,-1)];

%drawLines( lines,'k' );

if debug
    plot(target(1),target(2),'r.','MarkerSize',20);
    plot(currentPos(1),currentPos(2),'g.','MarkerSize',20);
end

% If the previous plan is null, then is the first iteration. In this case
% everything has to be calculated.
if ~isstruct(previousPlan)
    % Calculate heuristics (distance to target in straight line)
    %heuristics=[map;currentPos];
    %heuristics(:,3)=calcHeuristics(heuristics,target);
    % Calculate target visibility
    targetVisibleCorners=getVisibleCorners( target, map, target );
    if debug
        drawLines( targetVisibleCorners,'r' );
    end
    % Calculate full map visibility
    [mapVisibleCorners,maxSafetyHypotenuse]=getMapVisibleCorners( map );
	%drawLines( mapVisibleCorners(((size(map,1)+1):size(mapVisibleCorners,1)),:),'b' );
    links=[targetVisibleCorners; mapVisibleCorners];
    %%%%%% A-STAR FUNCTION CALL %%%%%%%%
    plan.paths=a_star_static(map, target, links); 
    plan.target=target;
    plan.maxSafetyHypotenuse = maxSafetyHypotenuse;
else
    plan=previousPlan;
end

%Calculate particle max dispersion from the centre:
maxPartDistance = maxParticleDistance( currentPos, ParticlesSubset );
%maxPartDistance=20;

% Once we verify that the plan exists we can focus on reaching one of the
% visible map points. The point to reach should always be the one with the
% lowest weight value.

%Help indexes to get information from path plan:
startPt=3;
endPt=4;
nodeCost=2;

% Calculate current position visibility
currPosVisibleCorners=getVisibleCorners( currentPos, map, target );
if debug
    drawLines( currPosVisibleCorners,'g' );
end

% ...and the shortest way to target 
currentLinkToTarget=[NaN NaN NaN NaN inf];
for i=1:size(currPosVisibleCorners,1)
    currPosSegmentSize=segmentSize(currPosVisibleCorners(i,:));
    for j=1:size(plan.paths,1)
        % The visible corner has to be visible, but also has to be
        % different of the current robot position
        if isequal(plan.paths{j,startPt}(1,[1 2]),currPosVisibleCorners(i,[3 4])) && ...
                ~isequal(plan.paths{j,startPt}(1,[1 2]),currPosVisibleCorners(i,[1 2]))
            tempCost=plan.paths{j,nodeCost}+currPosSegmentSize;
            if tempCost < currentLinkToTarget(5)
                currentLinkToTarget=[currPosVisibleCorners(i,[1 2]) plan.paths{j,startPt}(1,[1 2]) tempCost];
            end
        end
    end
end
% Create a new subconfiguration space for the allowed movements
safetyMap=calcSafetyMovementMap( map, maxPartDistance,plan.maxSafetyHypotenuse);
plan.optimalPath=currentLinkToTarget;
% Check if we are getting outside the safety map due to security
% corrections of the path
plan.safetyPath=a_star_dynamic( safetyMap, currentLinkToTarget(1,1:4), target, plan.paths );
%plan.safetyPath=[currentLinkToTarget(1,[1 2]) getSafetyPoint(safetyMap, plan.optimalPath(1,[3 4]))];
plan.nextStop=plan.safetyPath(1,[3 4]);
% Finally we reconstruct the optimal path to target from current position:
% While the cost of the last step of the optimal path is bigger than 0...
while plan.optimalPath(size(plan.optimalPath,1),5) > 0
    for i=1:size(plan.paths,1)
        % Finding next step's information about the cost and the following 
        % step
        if isequal(plan.paths{i,startPt}(1, [1 2]),plan.optimalPath(size(plan.optimalPath,1),[3 4]))
            plan.optimalPath=[plan.optimalPath; plan.paths{i,startPt}(1, [1 2]) plan.paths{i,endPt}(1, [1 2]) plan.paths{i,nodeCost}];
            if isnan(plan.safetyPath(size(plan.safetyPath,1),[3 4]))
                plan.safetyPath(size(plan.safetyPath,1),[3 4])=getSafetyPoint(safetyMap, plan.paths{i,startPt}(1, [1 2]));
                plan.safetyPath=[plan.safetyPath; getSafetyPoint(safetyMap, plan.paths{i,startPt}(1, [1 2]))...
                    getSafetyPoint(safetyMap, plan.paths{i,endPt}(1, [1 2]))];
            else
                plan.safetyPath=[plan.safetyPath; getSafetyPoint(safetyMap, plan.paths{i,startPt}(1, [1 2]))...
                    getSafetyPoint(safetyMap, plan.paths{i,endPt}(1, [1 2]))];
            end
            break;
        end
    end
end

if debug
    drawLines( plan.optimalPath(:,1:4),'m' );
    drawLines( plan.safetyPath(:,1:4),'b' );
end

% Last step: create the movements
movementVectors=[plan.safetyPath(:,3)-plan.safetyPath(:,1) plan.safetyPath(:,4)-plan.safetyPath(:,2)];
% Very specific case: when the target is outside the safety map, it will
% iterate forever.
if size(plan.safetyPath,1) == 2 && isequal(plan.safetyPath(1, 1:2),...
        plan.safetyPath(1, 3:4)) && ...
        isequal(plan.safetyPath(size(plan.safetyPath,1), 1:2),target)
    plan.safetyPath(1,3:4)=target;
    plan.nextStop=target;
    movementVectors=[plan.safetyPath(:,3)-plan.safetyPath(:,1) plan.safetyPath(:,4)-plan.safetyPath(:,2)];
end
% Remove the last 'NaN NaN' from movement vectors
movementVectors(size(movementVectors,1),:)=[];
robotAngles=vectorAngle(movementVectors);
robotAngles(1)=robotAngles(1)-currentAng*180/pi;
% turnInstructions=zeros(size(plan.optimalPath,1),1);
turnInstructions=robotAngles(1)*pi/180;
%moveInstructions=zeros(size(movementVectors,1),1);
% for i=1:size(movementVectors,1)
%     value=norm(movementVectors(i,:));
%     moveInstructions(i)=value;
% end

value=norm(movementVectors(1,:));
moveInstructions=value;

end


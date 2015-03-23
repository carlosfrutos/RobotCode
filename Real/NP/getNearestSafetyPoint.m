function [ nextPoint ] = getNearestSafetyPoint( point, safetyMap, map )
% This function calculates the nearest point inside the safetyMap polygon.
% Useful to avoid detecting false visible points, and of course, to avoid
% the robot to get outside the map

currentMinCost=inf;
safetyLinks=[safetyMap circshift(safetyMap,-1)];
mapLinks=[map circshift(map,-1)];
for  i=1:size(safetyLinks,1)
    %Find the perpendicular vector to the link
    v=[safetyLinks(i,4)-safetyLinks(i,2) -(safetyLinks(i,3)-safetyLinks(i,1))];
    v=v./norm(v(1,:));
    % Create a link using this vector and crosses the robot position
    vLink=[point point+v];
    result=vectorIntersection(vLink,safetyLinks(i,:));
    %plot(result(1,1),result(1,2),'k.','MarkerSize',5);
    if ~isnan(result)
        if isInSegment(result,safetyLinks(i,:))==1
            % It crosses the link: calculate distance
            tempCost=sqrt((result(1)-point(1))^2 + (result(2)-point(2))^2);
            if tempCost < currentMinCost
                currentMinCost=tempCost;
                currentNearestLink=[point result];
                %drawLines( currentNearestLink,'k' );
            end
        else
            %Calculate the distance of the intersection to the segment: it
            %might be small
            offsetVectors(1,:)=[safetyLinks(i,1)-result(1) safetyLinks(i,2)-result(2)];
            offsetVectors(2,:)=[safetyLinks(i,3)-result(1) safetyLinks(i,4)-result(2)];
            
            % Pick the smallest distance vector
            if norm(offsetVectors(1,:)) < norm(offsetVectors(2,:))
                connectionVector=[result(1)-point(1) result(2)-point(2)]+offsetVectors(1,:);
            else
                connectionVector=[result(1)-point(1) result(2)-point(2)]+offsetVectors(2,:);
            end
            
            %And now create the link to check the distance
            connectionLink=[point point+connectionVector];
            
            % Remove those possible links that have intersections with the
            % map
            mapIntersection=max(segmentIntersection(connectionLink,mapLinks));
            if isnan(mapIntersection)
                tempCost=sqrt((connectionLink(1,3)-connectionLink(1,1))^2 + ...
                    (connectionLink(1,4)-connectionLink(1,2))^2);
                if tempCost < currentMinCost
                    currentMinCost=tempCost;
                    currentNearestLink=connectionLink;
                    %drawLines( currentNearestLink,'k' );
                end
            else
                % If the robot is right on the edge of the map (risky, but
                % possible)
                in=lineInPolygon(connectionLink,map);
                if min(in)==1
                    tempCost=sqrt((connectionLink(1,3)-connectionLink(1,1))^2 + ...
                        (connectionLink(1,4)-connectionLink(1,2))^2);
                    if tempCost < currentMinCost
                        currentMinCost=tempCost;
                        currentNearestLink=connectionLink;
                        %drawLines( currentNearestLink,'k' );
                    end
                end
            end
        end
    end
    
    
end

nextPoint = currentNearestLink(1,3:4);

end


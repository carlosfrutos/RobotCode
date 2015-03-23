function [ visibilityLines ] = getVisibleCorners( point, map, target )
% Function to calculate the visible corners from "map" looking from
% "point". Target is included to check also its visibility.
mapLines=[map circshift(map,-1)];
%Calculate target visibility
%visibilityLines=zeros(size(map,1),4);
%otherEdgeLines=zeros(size(map,1)-2,4);
visibilityLinesCounter=0;
visibilityLines=NaN;
if ~isequal(point,target)
    maxIterations=size(map,1)+1;
else
    maxIterations=size(map,1);
end
for i=1:maxIterations
    if i > size(map,1)
        % In this case we are considering the straight line between the
        % current position of the robot and the target. That means that we
        % have to consider all the lines from the map.
        tempVisibilityLine=[point target];
        otherEdgeLines=mapLines;
    else
        %Get the tentatives
        tempVisibilityLine=[point map(i,:)];
        % Check if that tentative has any intersection with any of the
        % edges of the map. If there is any then discard the tentative.
        % We have to remove before the 2 lines ending in the tentative
        % corner. Otherwise, it will discard it since the corner is also an
        % intersection for both edges.
        temp = circshift(mapLines,-i);
        otherEdgeLines=temp(1:(size(mapLines,1)-2),:);
    end
    count=0;
    for j=1:size(otherEdgeLines,1)
        result=intersection(tempVisibilityLine,otherEdgeLines(j,:));
        if isnan(result)
            count=count+1;
        else
            in=lineInPolygon(tempVisibilityLine,map);
            if isInSegment(result,tempVisibilityLine)==0 && min(in)==1
                count=count+1;
            else
                %line(tempVisibilityLine([1 3]),tempVisibilityLine([2 4]),'lineWidth',1,'color','k', 'LineStyle',':');
                %plot(result(1),result(2),'k.','MarkerSize',20);
                break;
            end
        end
    end
    %If there was no intersection with other lines, then it is visible
    if count== size(otherEdgeLines,1)
        visibilityLinesCounter=visibilityLinesCounter+1;
        if isnan(visibilityLines)
            visibilityLines=zeros(visibilityLinesCounter,4);
        end
        visibilityLines(visibilityLinesCounter,:)=tempVisibilityLine;
        %line(tempVisibilityLine([1 3]),tempVisibilityLine([2 4]),'lineWidth',1,'color','r', 'LineStyle','--');
    end
    
end

end


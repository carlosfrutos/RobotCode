function [ visibilityLines,maxSafetyHypotenuse ] = getMapVisibleCorners( map )
% Function to calculate the visible corners between map points seen from
% map(index,:)
mapLines=[map circshift(map,-1)];
%Calculate target visibility
%visibilityLines=zeros(size(map,1),4);
%otherEdgeLines=zeros(size(map,1)-2,4);
visibilityLinesCounter=size(mapLines,1);
visibilityLines=mapLines;
maxSafetyHypotenuse = inf;
if size(mapLines,1) < 3
    return
end
%First loop: checking the visibility of every point in the map
for i=1:size(map,1)
    % We ignore the current point and the ones inmediately next to it. It's
    % useless, they are already visible corners! (unless the lines linking
    % them are curved)
    tentativeEndPoints=circshift(map,-(i+1));
    tentativeEndPoints=tentativeEndPoints(1:size(map,1)-3,:);
%     otherMapLines=circshift(mapLines,-(i+1));
%     otherMapLines=otherMapLines(1:size(mapLines,1)-3,:);
    checkMapLines=circshift(mapLines,-(i));
    checkMapLines=checkMapLines(1:size(mapLines,1)-2,:);
    for j=1:size(tentativeEndPoints,1)
        % Create the tentative visibility vector
        tentativeLine=[map(i,:) tentativeEndPoints(j,:)];
        % Now we have to check if these lines has any intersection with any
        % other edge of the map. If there is any then discard the line.
        count=0;
        for k=1:size(checkMapLines,1)
            result=intersection(tentativeLine,checkMapLines(k,:));
            if isnan(result)
                count=count+1;
            else
                in=lineInPolygon(tentativeLine,map);
                if isInSegment(result,tentativeLine)==0 && min(in)==1
                    count=count+1;
                else
                    %line(tentativeLine([1 3]),tentativeLine([2 4]),'lineWidth',1,'color','k', 'LineStyle',':');
                    %plot(result(1),result(2),'k.','MarkerSize',20);
                    break;
                end
            end
        end
        %If there was no intersection with other lines, then it is visible
        if count== size(checkMapLines,1)
            visibilityLinesCounter=visibilityLinesCounter+1;
            visibilityLines(visibilityLinesCounter,:)=tentativeLine;
            lineFound = 0;
            for kk=1:size(mapLines,1)
                if isequal(tentativeLine,mapLines(kk,:))
                    lineFound = 1;
                end
            end
            if ~lineFound
                linkLength = sqrt((tentativeLine(3)-tentativeLine(1))^2+(tentativeLine(4)-tentativeLine(2))^2);
                if maxSafetyHypotenuse > linkLength/2
                    maxSafetyHypotenuse = linkLength/2;
                end
            end
            %line(tentativeLine([1 3]),tentativeLine([2 4]),'lineWidth',1,'color','r', 'LineStyle','--');
        end
    end
end

end



function [ isVisible ] = isVisibleCorner( map,link )
% Function to check if the next optimal point (link) is actually visible in
% the given map. It's meant to check if it's colliding with a submap
% smaller than the orginal.
mapLines=[map circshift(map,-1)];

isVisible = 0;
if size(mapLines,1) < 3
    return
end

count=0;
for j=1:size(mapLines,1)
    % Now we have to check if these lines has any intersection with any
    % other edge of the map. If there is any then discard the line.
    
    result=intersection(link,mapLines(j,:));
    if isnan(result)
        count=count+1;
    else
        in=lineInPolygon(link,map);
        if isInSegment(result,link)==0 && min(in)==1
            count=count+1;
        else
            %line(tentativeLine([1 3]),tentativeLine([2 4]),'lineWidth',1,'color','k', 'LineStyle',':');
            %plot(result(1),result(2),'k.','MarkerSize',20);
            break;
        end
    end
end

%If there was no intersection with other lines, then it is visible
if count== size(mapLines,1)
    isVisible = 1;
    %line(tentativeLine([1 3]),tentativeLine([2 4]),'lineWidth',1,'color','r', 'LineStyle','--');
end

end



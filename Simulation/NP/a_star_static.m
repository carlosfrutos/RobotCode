function [ paths ] = a_star_static( map, target, links )
% Function to calculate the path from every corner of the map to a
% specific target.
%   map: contains all the points of the map
%   target: contains the target point
%   links: contains all the visible links between map points and target
% Every node has the following sets of values:
%   -{1}: the set of links.
%   -{2}: the current distance-to-target that is being updated
%   -{3}: the node is open (still pending to visit)
%   -{4}: current position coordinates
%   -{5}: next step coordinates
% The return value has the open-node column deleted:
%   -{1}: the set of links.
%   -{2}: the minimum distance-to-target
%   -{3}: current position coordinates
%   -{4}: next step coordinates
global debug;
debug = 1;
% needed for making jagged arrays. +1 because we need to add the target as
% another point in the graph.
nodes = cell(size(map,1)+1,5);

%% Find neighbors for target node.
clear nodeLinks;
nodeLinks=[NaN NaN NaN NaN];
counter=1;
keySet=cell(size(map,1)+1,1);
valueSet=1:(size(map,1)+1);
for j=1:size(links,1)
    if isequal(links(j,[1 2]),target)
        nodeLinks(counter,:)=links(j,:);
        counter=counter+1;
    end
end
keySet{1} = sprintf('%d/%d',target(1),target(2));
nodes{1,1}=nodeLinks;
nodes{1,2}=0;
nodes{1,3}=1;
nodes{1,4}=target;
nodes{1,5}=[NaN NaN]; % Next step for target is NaN

%% Calculate possible paths
clear nodeLinks;
nodeLinks=[NaN NaN NaN NaN];
counter=1;
% For every point in the map, find other link nodes
for i=1:size(map,1)
    keySet{i+1} = sprintf('%d/%d',map(i,1),map(i,2));
    
    for j=1:size(links,1)
        if isequal(links(j,[1 2]),map(i,:))
            nodeLinks(counter,:)=links(j,:);
            counter=counter+1;
        end
        if isequal(links(j,[3 4]),map(i,:))
            found=0;
            for k=1:size(links,1)
                if isequal(links(k,:),links(j,[3 4 1 2]))
                    found=1;
                    break;
                end
            end
            if found==0
                nodeLinks(counter,:)=links(j,[3 4 1 2]);
                counter=counter+1;
            end
        end
    end
    
    nodes{i+1,1}=nodeLinks;
    nodes{i+1,2}=inf;
    nodes{i+1,3}=1;
    nodes{i+1,4}=[map(i,1),map(i,2)];
    nodes{i+1,5}=[NaN NaN]; % Temporally
    clear nodeLinks;
    nodeLinks=[NaN NaN NaN NaN];
    counter=1;
end
mapObj = containers.Map(keySet',valueSet);

%% Calculate weigths for each node, starting from target
openNodesCount=size(nodes,1);
% This variable will contain the current reachable nodes from the visited
% nodes. This will allow us to be able to cover all the nodes in the map.
openVisibleNodes=[1 0]; % The only open node at the beginning is the target
currentNodeIndex = 1; % We start from node 1: the target
if debug
    plot(nodes{currentNodeIndex,1}(1,1),nodes{currentNodeIndex,1}(1,2),'g.','MarkerSize',20);
end
while openNodesCount > 0
    currentNodeLinks = nodes{currentNodeIndex,1};
    currentNodeCost = nodes{currentNodeIndex,2};
    for i=1:size(currentNodeLinks,1)
        tempKey = sprintf('%d/%d',currentNodeLinks(i,3),currentNodeLinks(i,4));
        nextNodeIndex = mapObj(tempKey);
        nextNodeOpen = nodes{nextNodeIndex,3};
        nextNodeCost = nodes{nextNodeIndex,2};
        if debug
            if nextNodeOpen == 1
                plot(nodes{nextNodeIndex,1}(1,1),nodes{nextNodeIndex,1}(1,2),'c.','MarkerSize',10);
            end
        end
        openNodeAlreadyExistIndex = NaN;
        for j=1:size(openVisibleNodes,1)
            tempOpenNode=openVisibleNodes(j,1);
            if tempOpenNode == nextNodeIndex && ~(nextNodeIndex == currentNodeIndex)
                openNodeAlreadyExistIndex = j;
                newPathCost = currentNodeCost + segmentSize([nodes{tempOpenNode,1}(1,[1 2]) nodes{currentNodeIndex,1}(1,[1 2])]);
                if newPathCost < openVisibleNodes(j,2)
                    openVisibleNodes(j,2) = newPathCost;
                    openVisibleNodes = sortrows(openVisibleNodes,2);
                end
                break;
            end
        end
        tempCost = currentNodeCost + segmentSize(currentNodeLinks(i,:));
        if isnan(openNodeAlreadyExistIndex) == 1 && nextNodeOpen == 1
            insertPosition = size(openVisibleNodes,1)+1;
            openVisibleNodes(insertPosition,:)=[nextNodeIndex tempCost];
            openVisibleNodes = sortrows(openVisibleNodes,2);
        end
        if nextNodeCost > tempCost
            nodes{nextNodeIndex,2} = tempCost;
            nodes{nextNodeIndex,5} = nodes{currentNodeIndex,1}(1,[1 2]);
        end
    end
    nodes{currentNodeIndex,3}=0; %set node closed
    openVisibleNodes=removeOpenNode(openVisibleNodes,currentNodeIndex);
    if debug
        plot(nodes{currentNodeIndex,1}(1,1),nodes{currentNodeIndex,1}(1,2),'k.','MarkerSize',20);
        textString = [ '   ' num2str(nodes{currentNodeIndex,2})];
        text(nodes{currentNodeIndex,1}(1,1),nodes{currentNodeIndex,1}(1,2),textString,'HorizontalAlignment','left');
    end
    if size(openVisibleNodes,1) > 0
        currentNodeIndex = openVisibleNodes(1,1);
        if debug
            for j=1:size(openVisibleNodes,1)
                auxNodeIndex = openVisibleNodes(j,1);
                plot(nodes{auxNodeIndex,1}(1,1),nodes{auxNodeIndex,1}(1,2),'k.','MarkerSize',10);
            end
            plot(nodes{currentNodeIndex,1}(1,1),nodes{currentNodeIndex,1}(1,2),'g.','MarkerSize',20);
        end
    end
    openNodesCount=openNodesCount-1;
end

%% Reconstruct the optimal path for every node

%% Set return value
nodes=sortrows(nodes,2);
nodes(:,3) = [];
paths=nodes;

end


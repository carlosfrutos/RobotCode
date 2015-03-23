function [ openNodes ] = removeOpenNode( openNodes, itemToRemove )
% Remove a specific row from a matrix using its first column as reference

indexToRemove = NaN;
for i = 1:size(openNodes,1)
    if openNodes(i,1) == itemToRemove
        indexToRemove = i;
        break;
    end
end

if isnan(indexToRemove) == 0
    index = true(1, size(openNodes, 1));
    index(indexToRemove) = false;
    openNodes = openNodes(index, :);
end

end


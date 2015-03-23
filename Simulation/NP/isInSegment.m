function [ result ] = isInSegment( point, segment )
% Returns 1 if the point is between the limits of the line segment
sortedSegment=[sort(segment([1 3])) sort(segment([2 4]))];
result=0;
if point(1) >= sortedSegment(1) && point(1) <= sortedSegment(2) && ...
        point(2) >= sortedSegment(3) && point(2) <= sortedSegment(4) && ...
        ~isequal(point,segment([1 2])) && ~isequal(point,segment([3 4]))
    result=1;
end

end


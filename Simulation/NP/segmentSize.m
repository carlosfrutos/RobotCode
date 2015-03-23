function [ size ] = segmentSize( segment )

size = sqrt((segment(3)-segment(1))^2+(segment(4)-segment(2))^2);

end


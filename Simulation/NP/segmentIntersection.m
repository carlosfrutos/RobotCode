function [ crossingPoint] = segmentIntersection(line1,line2)
%INTERSECTION calculates the intersection point between two line segments
%   line1Point1 = [0 0];
%   line1Point2 = [1 2];
%   line1 = [line1Point1 line1Point2];
%   line2Point1 = [2 3];
%   line2Point2 = [1 0];
%   line2 = [line2Point1 line2Point2];
%   crossingpoint = [1.5 3];
ua = ((line2(:,3)-line2(:,1)).*(line1(:,2)-line2(:,2))-(line2(:,4)-line2(:,2)).*(line1(:,1)-line2(:,1)))./(((line2(:,4)-line2(:,2)).*(line1(:,3)-line1(:,1))-(line2(:,3)-line2(:,1)).*(line1(:,4)-line1(:,2))));
ub = ((line1(:,3)-line1(:,1)).*(line1(:,2)-line2(:,2))-(line1(:,4)-line1(:,2)).*(line1(:,1)-line2(:,1)))./(((line2(:,4)-line2(:,2)).*(line1(:,3)-line1(:,1))-(line2(:,3)-line2(:,1)).*(line1(:,4)-line1(:,2))));
% filter = ub >= 0 & ub <= 1 & ua >= 0 & ua <= 1
filter = ub >= 0 & ub <= 1 & ua >= 0 & ua <= 1; %
crossingPoint =[line1(:,1)+ua.*(line1(:,3)-line1(:,1)) line1(:,2)+ua.*(line1(:,4)-line1(:,2))];
for i = 1:length(filter)
    if filter(i) == 0
        crossingPoint(i,:) = NaN(1,2);
    end
end
end
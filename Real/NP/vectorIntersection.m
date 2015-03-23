function [ crossingPoint] = vectorIntersection(infVec1,line2)
%INTERSECTION calculates the intersection point between two infinite
%vectors
%   infVec1Point1 = [0 0];
%   infVec1Point2 = [1 2];
%   infVec1 = [infVec1Point1 infVec1Point2];
%   infVec2Point1 = [2 3];
%   infVec2Point2 = [1 0];
%   infVec1 = [infVec2Point1 infVec2Point2];
%   crossingpoint = [1.5 3];
ua = ((line2(:,3)-line2(:,1)).*(infVec1(:,2)-line2(:,2))-(line2(:,4)-line2(:,2)).*(infVec1(:,1)-line2(:,1)))./(((line2(:,4)-line2(:,2)).*(infVec1(:,3)-infVec1(:,1))-(line2(:,3)-line2(:,1)).*(infVec1(:,4)-infVec1(:,2))));
ub = ((infVec1(:,3)-infVec1(:,1)).*(infVec1(:,2)-line2(:,2))-(infVec1(:,4)-infVec1(:,2)).*(infVec1(:,1)-line2(:,1)))./(((line2(:,4)-line2(:,2)).*(infVec1(:,3)-infVec1(:,1))-(line2(:,3)-line2(:,1)).*(infVec1(:,4)-infVec1(:,2))));
% filter = ub >= 0 & ub <= 1 & ua >= 0 & ua <= 1
%filter = 0; %
crossingPoint =[infVec1(:,1)+ua.*(infVec1(:,3)-infVec1(:,1)) infVec1(:,2)+ua.*(infVec1(:,4)-infVec1(:,2))];
% for i = 1:length(filter)
%     if filter(i) == 0
%         crossingPoint(i,:) = NaN(1,2);
%     end
% end
end

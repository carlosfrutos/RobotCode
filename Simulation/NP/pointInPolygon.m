function [in] = pointInPolygon( point, polygon )
% Function to check that a set of points are inside the given polygon

xv=polygon(:,1);
yv=polygon(:,2);

[in] = inpolygon(point(:,1),point(:,2),xv,yv);

end
function [in] = lineInPolygon( line, polygon )
% Function to check that 20 points of the line given are inside the
% polygon given

stopSpots = 0:(1/20):1;
xq=(line(3)-line(1)).*stopSpots+line(1);
yq=(line(4)-line(2)).*stopSpots+line(2);
xv=polygon(:,1);
yv=polygon(:,2);

[in] = inpolygon(xq,yq,xv,yv);

end


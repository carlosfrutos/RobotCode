function [ theta ] = vectorAngle( v )
%degrees
theta = atan2d(v(:,2),v(:,1));
end


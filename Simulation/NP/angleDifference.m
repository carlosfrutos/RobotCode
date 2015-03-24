function [ angleDiff ] = angleDifference( angle1, angle2 )
% Function to make safer the difference of two angles (angle1-angle2) in
% a resulting range of -180/180 degrees. ALL THE ANGLES MUST BE PROVIDED IN
% DEGREES

% Seems like there is a lot of dicussion about mod/rem, but in our case,
% rem is the most suitable function to use, since it keeps the sign of the
% first parameter. Obviously, mod does the other way around.
angle1=rem(angle1, 360); % remove full loops    
angle2=rem(angle2, 360); % remove full loops

if angle1 < 0
    angle1=360+angle1;
end
if angle2 < 0
    angle2=360+angle2;
end

angleDiff = angle1 - angle2;

if angleDiff < -180
    angleDiff = angleDiff + 360;
end

end


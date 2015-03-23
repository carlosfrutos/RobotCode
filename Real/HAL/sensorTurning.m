%%%%%%%%%%%%%%%%%%%%%%% MUST BE CHANGED

%%% Turn the sensor motor

% Notes:    - at beginning of main program initialise turn_state to 0 (make
%             sure the sensor of the real robot points in direction of
%             wheels)
%           - after use of function, set turn_state = turn_state_new
%           - turning always with 50% of motor power
%           - clockwise turn positive degree of turn value
%           - counter-clockwise turn negative degree of turn value

% Input: turn --> degree of turn (relative to previous position

% Output:   - turn_state_new --> absolute state of sensor turn

function [turn_state_new] = sensorTurning(turn_state,turn) % ALSO: mB as an input
    
    calibratedAngles = [5,10,20,45,90,180,360];
    calibratedCommands = [4.9834,10.0840,20.4895,46.445,92.6244,185.6734,371.7728;5.1049,10.2681,20.5597,46.5785,92.6773,185.2487,370.4974];
    
    turn_angle = abs(turn);    
    
    %%% below 10 degrees
    if (turn_angle <= calibratedAngles(2))
        if (turn >= 0)
            turn_command = turn_angle;
            mB_power = -10;
        elseif (turn < 0)
            turn_command = turn_angle;
            mB_power = 10;
        end
    %%% between 10 & 20 degrees
    elseif (turn_angle > calibratedAngles(2) && turn_angle <= calibratedAngles(3))
        if (turn >= 0)
            turn_command = calibratedCommands(1,2) + (calibratedCommands(1,3) - calibratedCommands(1,2))/(calibratedAngles(3) - calibratedAngles(2))*(turn_angle - calibratedAngles(2));
            mB_power = -turn_angle;
        elseif (turn < 0)
            turn_command = calibratedCommands(2,2) + (calibratedCommands(2,3) - calibratedCommands(2,2))/(calibratedAngles(3) - calibratedAngles(2))*(turn_angle - calibratedAngles(2));
            mB_power = turn_angle;
        end
    %%% between 20 & 45 degrees
    elseif (turn_angle > calibratedAngles(3) && turn_angle <= calibratedAngles(4))
        if (turn >= 0)
            turn_command = calibratedCommands(1,3) + (calibratedCommands(1,4) - calibratedCommands(1,3))/(calibratedAngles(4) - calibratedAngles(3))*(turn_angle - calibratedAngles(3));
            mB_power = -turn_angle;
        elseif (turn < 0)
            turn_command = calibratedCommands(2,3) + (calibratedCommands(2,4) - calibratedCommands(2,3))/(calibratedAngles(4) - calibratedAngles(3))*(turn_angle - calibratedAngles(3));
            mB_power = turn_angle;
        end
    %%% between 45 & 90 degrees
    elseif (turn_angle > calibratedAngles(4) && turn_angle <= calibratedAngles(5))
        if (turn >= 0)
            turn_command = calibratedCommands(1,4) + (calibratedCommands(1,5) - calibratedCommands(1,4))/(calibratedAngles(5) - calibratedAngles(4))*(turn_angle - calibratedAngles(4));
            if (turn_angle < 50)
                mB_power = -turn_angle;
            else
                mB_power = -50;
            end
        elseif (turn < 0)
            turn_command = calibratedCommands(2,4) + (calibratedCommands(2,5) - calibratedCommands(2,4))/(calibratedAngles(5) - calibratedAngles(4))*(turn_angle - calibratedAngles(4));
            if (turn_angle < 50)
                mB_power = turn_angle;
            else
                mB_power = 50;
            end
        end
    %%% between 90 & 180 degrees
    elseif (turn_angle > calibratedAngles(5) && turn_angle <= calibratedAngles(6))
        if (turn >= 0)
            turn_command = calibratedCommands(1,5) + (calibratedCommands(1,6) - calibratedCommands(1,5))/(calibratedAngles(6) - calibratedAngles(5))*(turn_angle - calibratedAngles(5));
            mB_power = -50;
        elseif (turn < 0)
            turn_command = calibratedCommands(2,5) + (calibratedCommands(2,6) - calibratedCommands(2,5))/(calibratedAngles(6) - calibratedAngles(5))*(turn_angle - calibratedAngles(5));
            mB_power = 50;
        end
        %%% between 180 & 360 degrees
    elseif (turn_angle > calibratedAngles(6) && turn_angle <= calibratedAngles(7))
        if (turn >= 0)
            turn_command = calibratedCommands(1,6) + (calibratedCommands(1,7) - calibratedCommands(1,6))/(calibratedAngles(7) - calibratedAngles(6))*(turn_angle - calibratedAngles(6));
            mB_power = -50;
        elseif (turn < 0)
            turn_command = calibratedCommands(2,6) + (calibratedCommands(2,7) - calibratedCommands(2,6))/(calibratedAngles(7) - calibratedAngles(6))*(turn_angle - calibratedAngles(6));
            mB_power = 50;
        end
    %%% above 360 degrees
    elseif (turn_angle > calibratedAngles(7))
        if (turn >= 0)
            turn_command = calibratedCommands(1,6) + (calibratedCommands(1,7) - calibratedCommands(1,6))/(calibratedAngles(7) - calibratedAngles(6))*(turn_angle - calibratedAngles(6));
            mB_power = -50;
        elseif (turn < 0)
            turn_command = calibratedCommands(2,6) + (calibratedCommands(2,7) - calibratedCommands(2,6))/(calibratedAngles(7) - calibratedAngles(6))*(turn_angle - calibratedAngles(6));
            mB_power = 50;
        end
    end
    
    disp(turn_command);
    turn_command = round(turn_command);
    mB_power = round(mB_power);
    
    %%% Should be moved out of the function
    mB = NXTMotor('B','Power',mB_power,'TachoLimit',turn_command,'SpeedRegulation',false);
    mB.SendToNXT();
    mB.WaitFor();
    mB.Stop('off');
    %%%
    
    turn_state_new = turn_state + turn;
    
    
    %%%%%%%%%% CAN MAYBE LEFT OUT
    % in case the amount of the angle is greater than 180 degrees
    if(abs(turn_state_new) > 180)
        turn_state_new = turn_state_new - sign(turn_state_new)*360;
    end
    %%%%%%%%%%%%%%%%
    
end
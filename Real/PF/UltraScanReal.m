function [ObjectArrayOut] = UltraScanReal(ObjectIn, Param)
ObjectArrayOut = zeros(size(ObjectIn,1),Param.ScanRays);
if (size(ObjectIn,1) ==1)
    turn_state = 0;                 %%%%%%%%%%%%%%%%%%%%%%%%%%% initialisation?
    for i = 1:Param.ScanRays
        turn_state = sensorTurning(turn_state,(360/Param.ScanRays));
        ObjectArrayOut(1,i) = GetUltrasonic(ObjectIn.ultrasonicPort);
    end
    for i=1:Param.ScanRays
        turn_state = sensorTurning(turn_state,((-360)/Param.ScanRays));
        ObjectArrayOut(1,i) = (ObjectArrayOut(1,(Param.ScanRays-i+1)) + GetUltrasonic(ObjectIn.ultrasonicPort))/2;
    end
else
    for i = 1:size(ObjectIn,1)
        Offset = [-8 8];
        ObjectIn(i).setScanConfig(ObjectIn(i).generateScanConfig(Param.ScanRays));
        ObjectIn(i).setBotPos(ObjectIn(i).getBotPos + Offset)
        Acum = 0;
    for j=1:Param.SimAntiNoise
        Acum = Acum + ObjectIn(i).ultraScan();
    end
    Acum = Acum/Param.SimAntiNoise;
    for k =1:Param.ScanRays
        ObjectArrayOut(i,k) = Acum(k);
    end
end
end
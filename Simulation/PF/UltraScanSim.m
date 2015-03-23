function [ObjectArrayOut] = UltraScanSim(ObjectIn, Param)
ObjectArrayOut = zeros(size(ObjectIn,1),Param.ScanRays);
for i = 1:size(ObjectIn,1)
    Offset = [0 0];
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
function [Param] = ParametersReal(Map)
%Particle filter
NumParticles = 300;
ScanRays = 8;
ConvThd = 4;    %Convergence threshold
PerDecMov = 10; %Utilised to decide next move in proces to self locate in map
PerK = 1E-30;   %Dumping factor
PerRot = 100*NumParticles;  %Percentage of particles with the rotation applied
MaxIterations = 30; 
SdvTrns = 0.001;  %Forced sdev of translation
SdvTrnOffset = 0.001;   %Forcen sdev of rotation
SdvRot = 0.001;   %Forcen sdev of rotation
%Navegation    
PerTransm = 75;
InTgtThd = 4;   %In target decission
%Dispersion/noise of the robot measurement in Real code
MeasCorrA = 0.001;  %Slope of correction of measurement
MeasCorrB = 0;      %Origin of correction of measurement
MeasSdvA = 0.001;  %Slope of measuremnet sdev  
MeasSdvB = 0;      %Origin of measurement sdev
SimSdvMeas = 0;
SdvTrns = 0;    %Sdev of translation movement
SdvOffset = 0;   %Offset of translation movement
SdvRot = 0;      %Sdev of rotation
%Lables to reference particle data array columns
XCoord = 1;
YCoord = 2;
Orientation = 3;
Weight = 4;
Scan = 5;

%Parameters for funtionality IniOps
ParamIniOps.Map = Map;
ParamIniOps.SimSdvMeas = SimSdvMeas;


%Parameters for localise and subfuntions
%---------------------------------------
%Parameters for InitialiseParticles
ParamIniPartic.NumParticles = NumParticles;
ParamIniPartic.ScanRays = ScanRays;
ParamIniPartic.SimSdvMeas = SimSdvMeas;
ParamIniPartic.Map = Map;
%Parameters for funtionality Populate
ParamPopulate.Map=Map;
ParamPopulate.ScanRays = ScanRays;
ParamPopulate.XCoord = XCoord;
ParamPopulate.YCoord =YCoord;
ParamPopulate.Orientation = Orientation;
ParamPopulate.Weight = Weight;
%Parameters for LocationMove
ParamLocationMove.PerDecMov = PerDecMov;
ParamLocationMove.ScanRays = ScanRays;
%Parameters for Move
ParamMove.SdvTrns = SdvTrns;  %Forced sdev of translation
ParamMove.SdvRot = SdvRot;   %Forcen sdev of rotation
ParamMove.SdvTrns = SdvTrns;  %Forced sdev of offset in trasnlation
ParamMove.XCoord = XCoord;
ParamMove.YCoord = YCoord;
ParamMove.Orientation = Orientation;
%Parameters for Check in map
ParamCheckInMap.XCoord = XCoord;
ParamCheckInMap.YCoord = YCoord;
ParamCheckInMap.Orientation = Orientation;
%Parameters for Ultrascan
ParamUScan.ScanRays = ScanRays;
ParamUScan.SimAntiNoise = SimAntiNoise;
%Parameteris for weigth
ParamUWeight.PerK = PerK;
ParamUWeight.PerRot = PerRot;
ParamUWeight.ScanRays = ScanRays;
ParamUWeight.SimSdvMeas = SimSdvMeas;
ParamUWeight.SdvTrns = SdvTrns;
ParamUWeight.SdvOffset = SdvOffset;
ParamUWeight.SdvRot = SdvRot;
ParamUWeight.Orientation = Orientation;
ParamUWeight.Weight = Weight;
ParamUWeight.Scan = Scan;
ParamUWeight.PScanModel.MeasCorrA = MeasCorrA;
ParamUWeight.PScanModel.MeasCorrB = MeasCorrB;
ParamUWeight.PScanModel.MeasSdvA = MeasSdvA;  
ParamUWeight.PScanModel.MeasSdvB = MeasSdvB;
ParamUWeight.PScanModel.Map = Map;
%Parameters for check convergence
ParamCheckConv.ConvThd = ConvThd;
ParamCheckConv.XCoord = XCoord;
ParamCheckConv.YCoord = YCoord;
ParamCheckConv.Orientation = Orientation;
ParamCheckConv.Weight = Weight;
ParamCheckConv.PerTransm = PerTransm;
%Parameters for PathPlan
ParamPathPlan.Figure = Figure;
ParamPathPlan.Map = Map;
%Parameters for localise
%Single parameters
ParamLocalise.MaxIterations = MaxIterations;
ParamLocalise.ScanRays = ScanRays;
ParamLocalise.InTgtThd = InTgtThd;
ParamLocalise.XCoord = XCoord;
ParamLocalise.YCoord = YCoord;
ParamLocalise.Orientation = Orientation;
ParamLocalise.Scan = Scan;
%Parameters for subfuntions
ParamLocalise.PIniPartic = ParamIniPartic;
ParamLocalise.PPopulate = ParamPopulate;
ParamLocalise.PLocationMove = ParamLocationMove;
ParamLocalise.PPPlan = ParamPathPlan;
ParamLocalise.PMove = ParamMove;
ParamLocalise.PCheckInMap = ParamCheckInMap;
ParamLocalise.PCheckConv = ParamCheckConv;
ParamLocalise.PUScan = ParamUScan;
ParamLocalise.PUWeight = ParamUWeight;
end
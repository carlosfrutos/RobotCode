function [Param] = ParametersSim (Map)
NumParticles = 300;
ScanRays = 16;
ConvThd = 4;
PerDecMov = 10;
PerK = 1E-30;
PerRot = 100*NumParticles;
MaxIterations = 30;
%Navegation
PerTransm = 75;
InTgtThd = 4;   %In target decission
%Noise in measurement
SimSdvMeas = 1;
SdvTrns = 0.1;    %Sdev of translation movement
SdvOffset = 0;   %Offset of translation movement
SdvRot = 0.2;      %Sdev of rotation
SimAntiNoise = 1;          %Scan repetitions to supress noise effect
Figure = 1;
%Labels to reference particle data array column
XCoord = 1;
YCoord = 2;
Orientation = 3;
Weight = 4;
Scan = 5;

%Parameters plotiong
ParamPlot.Figure = Figure;
ParamPlot.PlotMode = 'Plot';
ParamPlot.Mode = 'Sim';
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
Param.MaxIterations = MaxIterations;
Param.ScanRays = ScanRays;
Param.InTgtThd = InTgtThd;
Param.XCoord = XCoord;
Param.YCoord = YCoord;
Param.Orientation = Orientation;
Param.Scan = Scan;
%Parameters for subfuntions
Param.PIniPartic = ParamIniPartic;
Param.PPopulate = ParamPopulate;
Param.PLocationMove = ParamLocationMove;
Param.PPPlan = ParamPathPlan;
Param.PMove = ParamMove;
Param.PCheckInMap = ParamCheckInMap;
Param.PCheckConv = ParamCheckConv;
Param.PUScan = ParamUScan;
Param.PUWeight = ParamUWeight;
Param.PPlot = ParamPlot;
end
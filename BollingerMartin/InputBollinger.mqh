//+------------------------------------------------------------------+
//|                                                        Input.mqh |
//|                                     Copyright 2020, Michael Wade |
//|                                             michaelwade@yeah.net |
//+------------------------------------------------------------------+
//| All BollingerMartin input variables should be defined here.
//+------------------------------------------------------------------+
#property strict
input string BigperiosSection            = ""; // ==  big period indicator ==
// Parameters for big period indicator
input int BigFastEMA= 4800;
input int BigSlowEMA= 10368;
input int BigSignalSMA= 432;
input string BBandsSection            = ""; // == Bollinger Bands indicator ==
// Parameters for Bollinger Bands indicator
input int BollingerPeriod= 20;
input int BollingerDeviation= 2;
input int BollingerCrossBars=2;
input string MartinSection            = ""; // == martin orders ==
// Points between two adjacent martin orders
input int MartinInitPoints=350;
input int MartinMinProfitPoints = 400;
input double MartinPointsMultiple = 1.6;

//+------------------------------------------------------------------+

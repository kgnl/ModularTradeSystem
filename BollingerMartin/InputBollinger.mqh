//+------------------------------------------------------------------+
//|                                                        Input.mqh |
//|                                     Copyright 2020, Michael Wade |
//|                                             michaelwade@yeah.net |
//+------------------------------------------------------------------+
//| All BollingerMartin input variables should be defined here.
//+------------------------------------------------------------------+
#property strict

input string bperiod            = ""; // == Big period indicator ==
// Parameters for big period indicator
input int BigFastEMA= 4800;
input int BigSlowEMA= 10368;
input int BigSignalSMA= 432;
input string speriod            = ""; // == Bollinger Bands indicator ==
// Parameters for Bollinger Bands indicator
input int BollingerPeriod= 20;
input int BollingerDeviation= 2;
input int BollingerCrossBars=2;
input string martinsettings            = ""; // == Martingale orders settings==
// Points between two adjacent martin orders
input int MartinInitPoints=350;
input int MartinMinProfitPoints = 400;
input double MartinPointsMultiple = 1.6;

//+------------------------------------------------------------------+

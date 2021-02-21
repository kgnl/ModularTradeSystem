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
input string MartinSection            = ""; // == martingale orders ==
// Points between two adjacent martin orders
input int MartinInitPoints=350;             // Minimum distance for first martingale
input string MartinATRSection            = ""; // == martingale ATR ==
input bool AllowMartingaleATR = true;  
input ENUM_TIMEFRAMES grid_atr_tf = PERIOD_CURRENT; // Timeframe
input int grid_atr_period = 14; // ATR Period
input double grid_atr_mult = 2.5; // ATR Multiplicator

input int MartinMinProfitPoints = 400;
input double MartinPointsMultiple = 1.6;



//+------------------------------------------------------------------+

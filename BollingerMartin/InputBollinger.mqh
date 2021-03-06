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
input double rsiunder = 40; // RSI oversold
input double rsiupper = 60; // RSI overbought
input int MartinMinProfitPoints = 600;
input double MartinPointsMultiple = 1.6;

// ichimoku D1 just to be sure
int tenkan_sen=9;
int kijun_sen=26;
int senkou_span = 52;
int shift = 1;         

//+------------------------------------------------------------------+

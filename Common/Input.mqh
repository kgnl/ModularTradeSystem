//+------------------------------------------------------------------+
//|                                                        Input.mqh |
//|                                     Copyright 2020, Michael Wade |
//|                                             michaelwade@yeah.net |
//+------------------------------------------------------------------+
//| All input variables should be defined here.
//+------------------------------------------------------------------+
#property strict
#include "Const.mqh"

input string special1 = " ---- General Settings ----------------------------------- "; // ----------------------------------------------------------------------------

bool IsDebugMode = true;             // Choose running mode,debug or release
input bool AllowAutoTrade = true;          // Allow automated trading
input int Magic = 20152345;                    // Magic number
input bool Notifications = true;
bool AllowMail = false;              // Allow email
input bool AllowHedge = true;              // Allow hedge
input bool AllowMartin = true;             // Allow using Martingale strategy
input int MinIntervalPoints = 350;         // Minimum points between 2 same type orders
input int Slippage = 50;                   // Maximum acceptable slippage
input double MoneyAtLeast = 1000.0;        // Minimum Free Margin for new trade
input double MoneyEveryLot = 100000.0;     // How much money is needed for opening one lot position (leverage)
input double DefaultLots = 0.01;           // Default initial lot
input double Risk = 0.5;                     // Order Risk Percent
input double AddLotsMultiple = 2;        // The lot multiple to add positions
input double MaxAccountRiskPercent = -2.0; // Max Account Risk Percent
input int MaxOrderCounts = 4;             // Max Order per pair
input int MinFreeMargin = 1000;              // Min Margin to open new order
input string special2 = " ---- SL settings --------------------------------- "; // ----------------------------------------------------------------------------
input string  MSLA                          = "---- Add a missing Stop Loss ----";
input bool    AddMissingStopLoss            = true;//Add a stop loss to trades that do not have one.
input int     MissingStopLossPips           = 200;//Stop loss size in pips.
input bool    UseSlAtr                      = true;//Use ATR to calculate the stop loss.
input int     AtrSlPeriod                   = 14;//ATR stop loss period.
input ENUM_TIMEFRAMES AtrSlTimeFrame        = PERIOD_H4;//ATR stop loss time frame.
input double  AtrSlMultiplier               = 2;//ATR stop loss multiplier.

input double         MissingStopLoss=0;
double         AtrVal=0;

input string special5 = " ----  Grid builder  ------------------------------ "; // ----------------------------------------------------------------------------
input bool UseADRForGrid = true;                                                 // use ATR for grid
input ENUM_TIMEFRAMES atrGridTF = PERIOD_CURRENT;                                  // ATR For grid TF
input double GridAtrDivisor = 2.5;                                      // ATR Multiplicator For grid steps
input int GridAtrPeriod = 8;     
input string special6 = " ----  Signal specific settings ------------------- "; // ----------------------------------------------------------------------------

double         MissingTakeProfit=0;
enum Orientation
  {
   ORI_NO = ORIENTATION_NO,
   ORI_UP = ORIENTATION_UP,
   ORI_DW = ORIENTATION_DW,
   ORI_HOR = ORIENTATION_HOR
  };
// The orientation which is confirmed manually.
// Default option ORI_NO: let machine determine the orientation.
input Orientation ArtificialOrientation = ORI_NO;
//+------------------------------------------------------------------+

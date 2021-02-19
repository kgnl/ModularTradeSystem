//+------------------------------------------------------------------+
//|                                                        Input.mqh |
//|                                     Copyright 2020, Michael Wade |
//|                                             michaelwade@yeah.net |
//+------------------------------------------------------------------+
//| All input variables should be defined here.
//+------------------------------------------------------------------+
#property strict
#include "Const.mqh"

#define STOP_LOSS_FEATURE
#define NET_STOP_LOSS_FEATURE

input string special1            = ""; // == General Settings ==
bool IsDebugMode = true;             // Choose running mode,debug or release
bool AllowAutoTrade = true;          // Allow automated trading                 // Magic number
input ENUM_TIMEFRAMES TradingTimeframe = PERIOD_H1; // TradingTimeframe
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

enum TrailingType
{
   TrailingDontUse, // No trailing
   TrailingPips, // Use trailing in pips
   TrailingATR, // Use trailing with ATR start
   TrailingSLPercent, // Use trailing, in % of stop loss
};
#include "../Sibvic/StopLossType.mq4"
#include "../Sibvic/StopLimitType.mq4"
#include "../Sibvic/MATypes.mq4"
enum TrailingTargetType
{
   TrailingTargetStep, // Move each n pips
   TrailingTargetMA, // Sync with MA
};

#ifdef STOP_LOSS_FEATURE
   input string StopLossSection            = ""; // == Stop loss ==
   input StopLossType stop_loss_type = SLDoNotUse; // Stop loss type
   input double stop_loss_value = 10; // Stop loss value
   input double stop_loss_atr_multiplicator = 1; // Stop loss multiplicator (for ATR SL)
   input TrailingType trailing_type = TrailingDontUse; // Trailing start type
   input double trailing_start = 0; // Min distance to order to activate the trailing
   input TrailingTargetType trailing_target_type = TrailingTargetStep; // Trailing target
   input double trailing_step = 10; // Trailing step
   input int trailing_ma_length = 14; // Trailing MA Length
   input MATypes trailing_ma_type = ma_sma; // Trailing MA Type
#else
   StopLossType stop_loss_type = SLDoNotUse; // Stop loss type
   double stop_loss_value = 10;
#endif
input string BreakevenSection = ""; // == Breakeven ==
input StopLimitType breakeven_type = StopLimitDoNotUse; // Trigger type for the breakeven
input double breakeven_value = 10; // Trigger for the breakeven
input double breakeven_level = 0; // Breakeven target
#ifdef NET_STOP_LOSS_FEATURE
   input string NetStopSection = ""; // == Net stop ==
   input StopLimitType net_stop_loss_type = StopLimitDoNotUse; // Net stop loss type
   input double net_stop_loss_value = 10; // Net stop loss value
#endif

#include  "../Sibvic/DayOfWeek.mq4"
input string OtherSection            = ""; // == Other ==
input int magic_number        = 43532; // Magic number
input string trade_comment = "No Money no Honey"; // Comment for orders
#ifdef TRADING_TIME_FEATURE
   input string start_time = "000000"; // Start time in hhmmss format
   input string stop_time = "000000"; // Stop time in hhmmss format
   input bool mandatory_closing = false; // Mandatory closing for non-trading time
#else
   string start_time = "000000"; // Start time in hhmmss format
   string stop_time = "000000"; // Stop time in hhmmss format
   bool mandatory_closing = false;
#endif
#ifdef WEEKLY_TRADING_TIME_FEATURE
   input bool use_weekly_timing = false; // Weekly time
   input DayOfWeek week_start_day = DayOfWeekSunday; // Start day
   input string week_start_time = "000000"; // Start time in hhmmss format
   input DayOfWeek week_stop_day = DayOfWeekSaturday; // Stop day
   input string week_stop_time = "235959"; // Stop time in hhmmss format
#else
   bool use_weekly_timing = false; // Weekly time
   DayOfWeek week_start_day = DayOfWeekSunday; // Start day
   string week_start_time = "000000"; // Start time in hhmmss format
   DayOfWeek week_stop_day = DayOfWeekSaturday; // Stop day
   string week_stop_time = "235959"; // Stop time in hhmmss format
#endif
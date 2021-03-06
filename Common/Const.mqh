//+------------------------------------------------------------------+
//|                                                        Const.mqh |
//|                                     Copyright 2020, Michael Wade |
//|                                             michaelwade@yeah.net |
//+------------------------------------------------------------------+
//| All constants should be defined here
//+------------------------------------------------------------------+
#property strict

// TODO: make the versioning up to date please
// EA's name
#define EA_NAME  "KGNL"
#define VERSION "1.0"

// Trend constant
#define TREND_NO  0
#define TREND_UP  1
#define TREND_DW  -1

// Cross constant
#define CROSS_NO    0
#define CROSS_GLOD  1
#define CROSS_DEAD  -1

// Orientation constant
#define ORIENTATION_NO  0    // unknown orientation
#define ORIENTATION_UP  1    // up orientation
#define ORIENTATION_DW -1    // down orientation
#define ORIENTATION_HOR 2    // horizontal orientation

// Signal constant
#define SIGNAL_NO  0
#define SIGNAL_OPEN_BUY  1
#define SIGNAL_CLOSE_BUY  -1
#define SIGNAL_OPEN_SELL  2
#define SIGNAL_CLOSE_SELL  -2

// Order type constant
#define ORDER_BUY        "BUY"
#define ORDER_SELL       "SELL"
#define ORDER_BUYLIMIT   "BUYLIMIT"
#define ORDER_BUYSTOP    "BUYSTOP"
#define ORDER_SELLLIMIT  "SELLLIMIT"
#define ORDER_SELLSTOP   "SELLSTOP"
#define ORDER_UNKNOWN    "UNKNOWN"

// Position safe state
#define POSITION_STATE_SAFE    0
#define POSITION_STATE_WARN    1
#define POSITION_STATE_DANG    2

#define SIGNAL_NO_HEDGE 0
#define SIGNAL_HEDGE 1 
#define SIGNAL_CLOSE_HEDGE 2
//+------------------------------------------------------------------+

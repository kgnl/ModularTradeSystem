// Supported stop loss types v1.0

#ifndef StopLossType_IMP
#define StopLossType_IMP

enum StopLossType
{
   SLDoNotUse, // Do not use
   SLPercent, // Set in %
   SLPips, // Set in Pips
   SLDollar, // Set in $,
   SLAtr, // Set in ATR(value) * mult,
   SLHighLow, // High/low of X bars
   SLRiskBalance, // Set in % of risked balance
};

#endif
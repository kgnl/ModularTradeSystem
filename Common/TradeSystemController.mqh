//+------------------------------------------------------------------+
//|                                        TradeSystemController.mqh |
//|                                     Copyright 2020, Michael Wade |
//|                                             michaelwade@yeah.net |
//+------------------------------------------------------------------+
#property strict

//+------------------------------------------------------------------+
//| CTradeSystemController is an abstract class, you have to implement it with
//| a new class which is the main logical part of the trading system.
//| It processes the original signal datas from several signal enginines and
//| combines it with other data for comprehensive analysis, and finally 
//| outputs the execution signal.                                                             |
//+------------------------------------------------------------------+
class CTradeSystemController
  {
public:
   // Compute Signal Data，called in onTick() function.
   // ATTENTION: It must be called before calling controller's other member functions.
   virtual int       ComputeTradeSignal()=0;
   // Get the safe state of your positions
   virtual int       GetSafeState()=0;
   // You must set a signal consumed after doing some actions according to it,
   // otherwise the signal will continuously trigger your actions.                                                             |
   virtual void      SetSingalConsumed(const bool isConsumed)=0;
   // Check the hedge state
   virtual int       GetHedgeSignal()=0;
  };

//+------------------------------------------------------------------+

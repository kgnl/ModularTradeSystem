//+------------------------------------------------------------------+
//|                                                        clvz.mq4 |
//|                                     Copyright 2020, Michael Wade |
//|                                             michaelwade@yeah.net |
//+------------------------------------------------------------------+
#property strict

#property copyright "Copyright © 2021"
#property link      "http://clvz.hu"
#property version   "1.0"
#property description "ver 20210810"
#property description "restr.: D'1.5.2021"
// TODO: make these features working
//#define BREAKEVEN_FEATURE
#define STOP_LOSS_FEATURE
//#define TRADING_TIME_FEATURE
//#define WEEKLY_TRADING_TIME_FEATURE


#include "Common\OrderManager.mqh"
#include "Common\EnvChecker.mqh"
#include "Common\TradeSystemController.mqh"
#include "Common\Display.mqh"
#include "Common\TSControllerFactory.mqh"

datetime ValidTo = D'1.5.2021';//What date to deactivate expert adviser
int      Acc     = 21169055;       //Account number restriction to use in real account mode
bool DateRestriction=true;////////Use Date expiration(both real and demo mode)
bool RealAccRestriction=false;/////Use Real Account restrictions(Do not use with DemoRestriction)

CTradeSystemController *controller = NULL;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(RealAccRestriction)
     {
      if(AccountNumber()!=Acc)//Is account real? If yes, do check and see if account number match or not
        {
         Alert("Real account number do not match!");//Alert user if account number don't match
         ExpertRemove();//Remove adviser from chart
         return(INIT_FAILED);//Initiation failed due to wrong account number
        }
     }

//--Adviser will stop working in trading mode when reaching set date
   if(DateRestriction)//Is Date restriction in use and trading mode, if yes do check else skip and continue
     {
      if(TimeCurrent()>ValidTo)//Has current date exceeded set date?If yes continue do alert, else skip and continue
        {
         Alert("Licence Expired");//Alert user if date exceeded
         ExpertRemove();//Remove adviser from chart
         return(INIT_FAILED);//Initiation failed due to exceeded date
        }
     }
//---

   LogR("OnInit...");
   controller = CTSControllerFactory::Create();
   EventSetTimer(60);   // Trigger timer every 60 seconds
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   LogR("OnDeinit...reason=",IntegerToString(reason));
   delete(controller);
   EventKillTimer();
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   LogR("OnTimer...");
   CheckSafe();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   CheckHedge();
// Check the runtime environment
   if(!CheckEnv())
      return;
// Update the max equity
   CMoneyManager::UpdateMaxEquity();
// Process trade signals
   ProcessTradeSignals();
// Show some info on screen
   if(Display)
      ShowAccountStatus();

  }

//+------------------------------------------------------------------+
//| Process trade signals, and check when to open or close orders
//+------------------------------------------------------------------+
void ProcessTradeSignals()
  {
   int signal = controller.ComputeTradeSignal();
   switch(signal)
     {
      case SIGNAL_OPEN_BUY:
         if(OpenBuy())
            controller.SetSingalConsumed(true);
         break;
      case SIGNAL_OPEN_SELL:
         if(OpenSell())
            controller.SetSingalConsumed(true);
         break;
      case SIGNAL_CLOSE_BUY:
      case SIGNAL_CLOSE_SELL:
         CloseOrder();
     }

// CheckStopLoss(); // TODO
// CheckTakeProfit(); // TODO
  }

//+------------------------------------------------------------------+
//| Check the safety of the position regularly,
//| to see if there is no need for manual intervention                                                              |
//+------------------------------------------------------------------+
void CheckSafe()
  {
//Print("checkSafe");
   int state = controller.GetSafeState();
   string msg = "";
   switch(state)
     {
      case POSITION_STATE_WARN:
         msg = "Your "+_Symbol+" position is NOT SAFE! Pls check.";
         Print(msg);
         break;
      case POSITION_STATE_DANG:
         msg = "Your "+_Symbol+" position is DANGEROUS! Pls check.";
         Print(msg);
         if(AllowHedge)
            OpenHedgePosition(true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckHedge()
  {
/// Print("checking hedge");
   int hedge = controller.GetHedgeSignal();

   switch(hedge)
     {
      case SIGNAL_HEDGE:
         OpenHedgePosition(true);
         break;
      case SIGNAL_CLOSE_HEDGE:
         CloseOrder();
     }

  }
//+------------------------------------------------------------------+

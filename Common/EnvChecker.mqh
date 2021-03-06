//+------------------------------------------------------------------+
//|                                                   EnvChecker.mqh |
//|                                     Copyright 2020, Michael Wade |
//|                                             michaelwade@yeah.net |
//+------------------------------------------------------------------+
//| Responsible for checking the operating environment
//+------------------------------------------------------------------+
#property strict
#include "MoneyManager.mqh"

//+------------------------------------------------------------------+
//| Check environment                                                                 |
//+------------------------------------------------------------------+
bool CheckEnv()
  {
   return  CMoneyManager::HasEnoughMoney() && isBarsEnough() && IsAllowedTrade() && CMoneyManager::HasEnoughMargin();
  }

//+------------------------------------------------------------------+
//| Check bars                                                                |
//+------------------------------------------------------------------+
bool isBarsEnough()
  {
   if(Bars<100)
     {
      Print("Bars less than 100! PLS check");
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//| Check if the allow automatic trading option is checked                                                                |
//+------------------------------------------------------------------+
bool IsAllowedTrade()
  {
   if(!IsTradeAllowed())
     {
      Print("Automatic trading isn't allowed! PLS check");
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+

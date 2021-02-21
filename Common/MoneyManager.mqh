//+------------------------------------------------------------------+
//|                                                 MoneyManager.mqh |
//|                                     Copyright 2020, Michael Wade |
//|                                             michaelwade@yeah.net |
//+------------------------------------------------------------------+
//| Money Manager : Responsible for money-related operations                                                             |
//+------------------------------------------------------------------+
#property strict
#include "Const.mqh"
#include "Input.mqh"
#include "Log.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMoneyManager
  {
private:
   static const string TAG;
   static double     MaxEquity;

public:
                     CMoneyManager(void);
                    ~CMoneyManager(void);
   static bool       HasEnoughMoney(void);
   static bool       HasEnoughMargin(void);
   static double     GetInitLots(void);
   static double     GetAddLots(void);
   static double     GetOpenLots(void);
   static double     GetSymbolProfit(void);
   static void       UpdateMaxEquity(void);
   static double     GetDrawdownPercent(void);
   static double     GetProfitPercent(void);
  };

const string CMoneyManager::TAG = "CMoneyManager";
double CMoneyManager::MaxEquity = 0;
//+------------------------------------------------------------------+
//| Check if your money is enough                                                                 |
//+------------------------------------------------------------------+
bool CMoneyManager::HasEnoughMoney(void)
  {
   if(AccountFreeMargin()< MoneyAtLeast)
     {
      //LogR(TAG,"Your money is not enough! FreeMargin = ",DoubleToStr(AccountFreeMargin()));
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//| Check if your money is enough                                                                 |
//+------------------------------------------------------------------+
bool CMoneyManager::HasEnoughMargin(void)
  {
   if(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL) != 0 && AccountInfoDouble(ACCOUNT_MARGIN_LEVEL) < MinFreeMargin)
     {
      //LogR(TAG,"Your margin % is not enough! Margin = ",DoubleToStr(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL)));
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//| Calculate the lots to open                                                                    |
//+------------------------------------------------------------------+
double CMoneyManager::GetOpenLots(void)
  {
   return GetAddLots(); //GetInitLots();
  }

double GetLots(const PositionSizeType lotsType, const double lotsValue, const double stopDistance)
{
   switch (lotsType)
   {
      case PositionSizeAmount:
      // TODO: PositionSizeAmount
        // return GetLotsForMoney(lotsValue);
      case PositionSizeContract:
          return NormalizeLots(lotsValue);
      case PositionSizeEquity:
      // TODO: PositionSizeEquity
        // return GetLotsForMoney(AccountEquity() * lotsValue / 100.0);
      case PositionSizeRiskBalance:
      {
        // TODO: PositionSizeRiskBalance
        //  double affordableLoss = AccountBalance() * lotsValue / 100.0;
        //  double unitCost = MarketInfo(_symbol.GetSymbol(), MODE_TICKVALUE);
        //  double tickSize = _symbol.GetTickSize();
        //  double possibleLoss = unitCost * stopDistance / tickSize;
        //  if (possibleLoss <= 0.01)
        //  {
        //     return 0;
        //  }
        //  return _symbol.NormalizeLots(affordableLoss / possibleLoss);
      }
      case PositionSizeRisk:
      {
        // TODO: PositionSizeRisk
        //  double affordableLoss = AccountEquity() * lotsValue / 100.0;
        //  double unitCost = MarketInfo(_symbol.GetSymbol(), MODE_TICKVALUE);
        //  double tickSize = _symbol.GetTickSize();
        //  double possibleLoss = unitCost * stopDistance / tickSize;
        //  if (possibleLoss <= 0.01)
        //  {
        //     return 0;
        //  }
        //  return _symbol.NormalizeLots(affordableLoss / possibleLoss);
      }
      case PositionSizeRiskCurrency:
      {
        // TODO: PositionSizeRiskCurrency
        //  double unitCost = MarketInfo(_symbol.GetSymbol(), MODE_TICKVALUE);
        //  double tickSize = _symbol.GetTickSize();
        //  double possibleLoss = unitCost * stopDistance / tickSize;
        //  if (possibleLoss <= 0.01)
        //  {
        //     return 0;
        //  }
        //  return _symbol.NormalizeLots(lotsValue / possibleLoss);
      }
   }
   return lotsValue;
}
   double NormalizeLots(const double lots)
   {
      return NormalizeDouble(lots, 2);
   }

//+------------------------------------------------------------------+
//| Calculate the initial lots to open                                                            |
//+------------------------------------------------------------------+
double CMoneyManager::GetInitLots(void)
  {
// TODO: get lots from caculator
    double lots = GetLots(lots_type, lots_Value, EmergencyStop);
   
    if(lots < 0.01)
      lots = 0.01;
    else
      if(lots > 100)
        lots = 100;
    //LogR(TAG,StringConcatenate("AccountBalance = ",AccountBalance(),",lots = ",lots));
    return lots;
  }

//+------------------------------------------------------------------+
//| Calculate the add lots to open                                                                  |
//+------------------------------------------------------------------+
double CMoneyManager::GetAddLots(void)
  {
   double maxLots = 0;
   int total = OrdersTotal();
   for(int i=0; i<total; i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderSymbol()!=_Symbol)
         continue;
      double orderLots = OrderLots();
      if(orderLots>maxLots)
         maxLots = orderLots;
     }
   return maxLots == 0? GetInitLots():maxLots*AddLotsMultiple;
  }

//+------------------------------------------------------------------+
//| Get the total profit of the current symbol                                                                 |
//+------------------------------------------------------------------+
double CMoneyManager::GetSymbolProfit()
  {
   double totalProfit = 0;
   int  total = OrdersTotal();
   for(int i=0; i<total; i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderSymbol()!=_Symbol)
         continue;
      totalProfit+=OrderProfit();
     }
   return totalProfit;
  }

//+------------------------------------------------------------------+
//| Updating the max equity, which should be called in onTick()                                                                 |
//+------------------------------------------------------------------+
void CMoneyManager::UpdateMaxEquity()
  {
   MaxEquity = AccountEquity()>MaxEquity? AccountEquity():MaxEquity;
  }

//+------------------------------------------------------------------+
//| Get the drawdown percentage                                                                  |
//+------------------------------------------------------------------+
double CMoneyManager::GetDrawdownPercent()
  {
   return 100*(AccountEquity()-MaxEquity)/MaxEquity;
  }

//+------------------------------------------------------------------+
//| Get the profit percentage                                                                    |
//+------------------------------------------------------------------+
double CMoneyManager::GetProfitPercent()
  {
   return AccountProfit()/AccountBalance();
  }
//+------------------------------------------------------------------+

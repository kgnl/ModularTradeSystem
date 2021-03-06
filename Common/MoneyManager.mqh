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
        return GetLotsForMoney(lotsValue);
      case PositionSizeContract:
        return NormalizeLots(lotsValue);
      case PositionSizeEquity:
      // TODO: PositionSizeEquity
        return GetLotsForMoney(AccountEquity() * lotsValue / 100.0);
      case PositionSizeRiskBalance:
      {
        // TODO: PositionSizeRiskBalance
         double affordableLoss = AccountBalance() * lotsValue / 100.0;
         double unitCost = MarketInfo(Symbol(), MODE_TICKVALUE);
         double tickSize = MarketInfo(Symbol(), MODE_TICKSIZE);
         double possibleLoss = unitCost * stopDistance / tickSize;
         if (possibleLoss <= 0.01)
         {
            return 0;
         }
         return NormalizeLots(affordableLoss / possibleLoss);
      }
      //case PositionSizeRisk:
      //{
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
      //}
      //case PositionSizeRiskCurrency:
      //{
        // TODO: PositionSizeRiskCurrency
        //  double unitCost = MarketInfo(_symbol.GetSymbol(), MODE_TICKVALUE);
        //  double tickSize = _symbol.GetTickSize();
        //  double possibleLoss = unitCost * stopDistance / tickSize;
        //  if (possibleLoss <= 0.01)
        //  {
        //     return 0;
        //  }
        //  return _symbol.NormalizeLots(lotsValue / possibleLoss);
      //}
   }
   return lotsValue;
}


   double GetLotsForMoney(const double money)
   {
      double marginRequired = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
      if (marginRequired <= 0.0)
      {
         Print("Margin is 0. Server misconfiguration?");
         return 0.0;
      }
      return NormalizeLots(money / marginRequired);
   }

// https://www.mql5.com/en/forum/146370#comment_3693988 
double NormalizeLots(double lots, string pair=""){
    if (pair == "") pair = Symbol();
    double  lotStep     = MarketInfo(pair, MODE_LOTSTEP),
            minLot      = MarketInfo(pair, MODE_MINLOT);
    lots            = MathRound(lots/lotStep) * lotStep;
    if (lots < minLot) lots = 0;    // or minLot
    return(lots);
}

double NormalizePrice(double p, string pair=""){
        // https://forum.mql4.com/43064#515262 zzuegg reports for non-currency DE30:
        // MarketInfo(chart.symbol,MODE_TICKSIZE) returns 0.5
        // MarketInfo(chart.symbol,MODE_DIGITS) return 1
        // Point = 0.1
        // Prices to open must be a multiple of ticksize 
    if (pair == "") pair = Symbol();
    double ts = MarketInfo(pair, MODE_TICKSIZE);
    return( MathRound(p/ts) * ts );
}

//+------------------------------------------------------------------+
//| Calculate the initial lots to open                                                            |
//+------------------------------------------------------------------+
double CMoneyManager::GetInitLots(void)
  {
// TODO: get lots from caculator
    double lots = GetLots(lots_type, lots_Value, EmergencyStop);

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

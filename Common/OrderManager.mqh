//+------------------------------------------------------------------+
//|                                                 OrderManager.mqh |
//|                                     Copyright 2020, Michael Wade |
//|                                             michaelwade@yeah.net |
//+------------------------------------------------------------------+
//| Order Manager:
//| It provides several normal operations about orders.
//+------------------------------------------------------------------+
#property strict
#include "MoneyManager.mqh"
//#include "StoplossStrategy.mqh"
static const string TAG = "OrderManager";

//+------------------------------------------------------------------+
//| The wrapper of a order                                                                 |
//+------------------------------------------------------------------+
struct COrder
  {
   int               ticket;
   string            symbol;
   string            type;
   double            lots;
   double            openPrice;
   double            closePrice;
   double            profit;
   //--- Constructor
                     COrder(void):ticket(0),symbol(""),type(""),lots(0),openPrice(0),closePrice(0),profit(0) {}
                     COrder(const int p_ticket);
   //--- Destructor
                    ~COrder() {}
   string            ToString(void);
  };

//+------------------------------------------------------------------+
//| Create a COrder instance with a ticket                                                                |
//+------------------------------------------------------------------+
COrder::COrder(const int p_ticket):ticket(0),symbol(""),type(""),lots(0),openPrice(0),closePrice(0),profit(0)
  {
   if(!OrderSelect(p_ticket,SELECT_BY_TICKET,MODE_TRADES))
     {
      LogD("COrder object creating failed: cant find this ticket:",IntegerToString(p_ticket));
      return;
     }
   ticket = p_ticket;
   symbol = OrderSymbol();
   type = OrderType2Str(OrderType());
   lots = OrderLots();
   openPrice = OrderOpenPrice();
   closePrice = OrderClosePrice();
   profit = OrderProfit();
  }

//+------------------------------------------------------------------+
//| Transform a COrder object to a string.                                                                   |
//+------------------------------------------------------------------+
string COrder::ToString()
  {
   return StringConcatenate("{ticket:",ticket,
                            ",symbol:",symbol,
                            ",type:",type,
                            ",lots:",lots,
                            ",openPrice:",openPrice,
                            ",closePrice:",closePrice,
                            ",profit:",profit,
                            "}");
  }
//+------------------------------------------------------------------+
//| Get a COrder instance by a ticket                                                                 |
//+------------------------------------------------------------------+
COrder GetOrderByTicket(int p_ticket)
  {
   COrder order(p_ticket);
   return order;
  }

//+------------------------------------------------------------------+
//| Convert int order type to string                                                              |
//+------------------------------------------------------------------+
string OrderType2Str(int orderTypeInt)
  {
   switch(orderTypeInt)
     {
      case OP_BUY:
         return ORDER_BUY;
      case OP_SELL:
         return ORDER_SELL;
      case OP_BUYLIMIT:
         return ORDER_BUYLIMIT;
      case OP_BUYSTOP:
         return ORDER_BUYSTOP;
      case OP_SELLLIMIT:
         return ORDER_SELLLIMIT;
      case OP_SELLSTOP:
         return ORDER_SELLSTOP;
     }
   return ORDER_UNKNOWN;
  }

//+------------------------------------------------------------------+
//| Check if automatic trading is allowed                                                         |
//+------------------------------------------------------------------+
bool IsAutoTradeAllowed()
  {
   if(!AllowAutoTrade)
      Print("Error opening/closing order : PLS Set AllowAutoTrade true !");
   return AllowAutoTrade;
  }

//+------------------------------------------------------------------+
//| Check if there are the current symbol positions.(pending orders are not counted)                                                                |
//+------------------------------------------------------------------+
bool IsEmptyPositionsCurSymbol()
  {
   int total = OrdersTotal();
   //Print("total=",total);
   for(int i=0; i<total; i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderSymbol()!=_Symbol)
         continue;
      if(OrderType()==OP_BUY || OrderType()==OP_SELL)
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Open a order
//| return true: open successfully                                                                 |
//+------------------------------------------------------------------+
bool OpenOrder(const bool isBuy,double lots, const bool hedge)
  {
   if(!IsAutoTradeAllowed() || (!IsRiskControllable() || hedge ))
      return false;
   int ticket=OrderSend(_Symbol,isBuy?OP_BUY:OP_SELL,lots,isBuy?Ask:Bid,Slippage,0,0,EA_NAME,0,876478,isBuy?Green:Red);
   // TODO: set stop and profit ECN style ( after market order sent)
   // setStopLoss(ticket, isBuy, stop_loss_type);
   if(ticket<0)
     {
      LogR(TAG,StringConcatenate("Failed to open order : {",_Symbol,isBuy?" BUY ":" SELL ",lots,"}, err : ",GetLastError()));
      return false;
     }
   if(Notifications)SendNotification(StringConcatenate("Order opened : ",ticket));   
   return true;
  }

bool OpenHedgeOrder(const bool isBuy,double lots, const bool hedge)
  {
   if(!IsAutoTradeAllowed() && hedge )
      return false;
   int ticket=OrderSend(_Symbol,isBuy?OP_BUY:OP_SELL,lots,isBuy?Ask:Bid,Slippage,0,0,"#Hedge "EA_NAME,876479,0,isBuy?Green:Red);
   // TODO: set stop and profit ECN style ( after market order sent)
   // setStopLoss(ticket, isBuy, stop_loss_type);
   if(ticket<0)
     {
      LogR(TAG,StringConcatenate("Failed to open order : {",_Symbol,isBuy?" BUY ":" SELL ",lots,"}, err : ",GetLastError()));
      return false;
     }
   if(Notifications)SendNotification(StringConcatenate("Order opened : ",ticket));   
   return true;
  }
//+------------------------------------------------------------------+
//| Close specified order by ticket                                                               |
//+------------------------------------------------------------------+
void CloseOrderByTicket(const int ticket)
  {
   Print("CloseOrderByTicket...ticket=",ticket);
   if(!IsAutoTradeAllowed())
      return;
   if(!OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
      return;
   COrder order(ticket);
   if(!OrderClose(ticket,OrderLots(),OrderType()==OP_BUY?Bid:Ask,Slippage,Violet))
     {
      LogR(TAG,"Failed to close order : ",order.ToString(),", err : ",IntegerToString(GetLastError()));
      return;
     }
   if(Notifications)SendNotification(string("New closed order!"));

  }

//+------------------------------------------------------------------+
//| Close position                                                                   |
//+------------------------------------------------------------------+
void CloseOrder()
  {
   CloseAllOrders();
  }

//+------------------------------------------------------------------+
//| Close all this symbol orders at once.
//| (Note: Closing one order will affect the result of the OrdersTotal() function
//| and the index of each order.Therefore, when closing all orders at once,
//| you must only call OrdersTotal() once and then close orders from the end of the orders list.
//| In this way, the index of the unclosed order will not change, and the "for loop" will not be affected.)
//+------------------------------------------------------------------+
void CloseAllOrders()
  {
   int total = OrdersTotal();
   Print("CloseAllOrders...total=",total);
   for(int i= total-1; i>=0; i--)
     {
      //Print("CloseAllOrders1...i=",i);
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;
      //Print("CloseAllOrders2...i=",i);
      if(OrderSymbol()!=_Symbol)
         continue;
      //Print("CloseAllOrders3...i=",i,",type=",OrderType());
      if(OrderType()==OP_BUY || OrderType()==OP_SELL)
         CloseOrderByTicket(OrderTicket());
     }
  }

//+------------------------------------------------------------------+
//| Open BUY order                                                           |
//+------------------------------------------------------------------+
bool OpenBuy()
  {
   return OpenOrder(true, CMoneyManager::GetOpenLots(), false);
  }

//+------------------------------------------------------------------+
//| Open SELL order                                                              |
//+------------------------------------------------------------------+
bool OpenSell()
  {
   return OpenOrder(false,CMoneyManager::GetOpenLots(), false);
  }

//+------------------------------------------------------------------+
//| Get the comprehensive information of all orders of the current symbol.                                                                 |
//+------------------------------------------------------------------+
COrder GetAllOrdersAsOne()
  {
   double buyLots = 0;
   double sellLots = 0;
   double buyProfit = 0;
   double sellProfit = 0;
   int total = OrdersTotal();
   for(int i=0; i<total; i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderSymbol()!=_Symbol)
         continue;
      switch(OrderType())
        {
         case OP_BUY:
            buyLots+=OrderLots();
            buyProfit+=OrderProfit();
            break;
         case OP_SELL:
            sellLots+=OrderLots();
            sellProfit+=OrderProfit();
            break;
        }
     }
   COrder totalOrder;
   totalOrder.symbol = _Symbol;
   totalOrder.type = (buyLots==sellLots?ORDER_UNKNOWN:(buyLots>sellLots?ORDER_BUY:ORDER_SELL));
   totalOrder.profit = buyProfit+sellProfit;
   totalOrder.lots = MathAbs(buyLots-sellLots);
   return totalOrder;
  }

//+------------------------------------------------------------------+
//| Check if it is too close to other orders of the same type in price.
//+------------------------------------------------------------------+
bool IsCloseToSameTypeOrders(bool isBuy)
  {
   int total = OrdersTotal();
   for(int i=0; i<total; i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderSymbol()!=_Symbol)
         continue;
      int type = OrderType();
      double openPrice = OrderOpenPrice();
      if((isBuy && type==OP_BUY && MathAbs(Ask-openPrice)<MinIntervalPoints*Point) ||
         (!isBuy && type==OP_SELL && MathAbs(Bid-openPrice)<MinIntervalPoints*Point))
         return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
//| Check if Martingale strategy is allowed to add positions                                                            |
//+------------------------------------------------------------------+
bool CheckMartinAllowed(bool isBuy)
  {
// if martin is allowed ,never mind
   if(AllowMartin)
      return true;
// if martin is not allowed,you can only open a position when there are no same type orders.
   int total = OrdersTotal();
   for(int i=0; i<total; i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderSymbol()!=_Symbol)
         continue;
      int type = OrderType();
      if((isBuy && type==OP_BUY) || (!isBuy && type==OP_SELL))
         return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//| Open positions for hedging risks
//| param isReverse: true: not noly hedging, but also reversing positions.
//| false: just hedging.
//+------------------------------------------------------------------+
void OpenHedgePosition(bool isReverse)
  {
   Print("OpenHedgePosition...");
   COrder totalOrder = GetAllOrdersAsOne();
   if(totalOrder.type==ORDER_BUY)
      OpenHedgeOrder(false,totalOrder.lots + (!isReverse?0:CMoneyManager::GetOpenLots()), true);
   else
      if(totalOrder.type==ORDER_SELL)
         OpenHedgeOrder(true,totalOrder.lots + (!isReverse?0:CMoneyManager::GetOpenLots()), true);
  }

//+------------------------------------------------------------------+
//| Get the last martin order                                                              |
//+------------------------------------------------------------------+
COrder GetLastMartinOrder(bool isBuy)
  {
   int ticket = 0;
   double buyPrice = 10000;
   double sellPrice = 0;
   int total = OrdersTotal();
   for(int i=0; i<total; i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderSymbol()!=_Symbol)
         continue;
      if(isBuy && OrderType()==OP_BUY && OrderOpenPrice() < buyPrice)
        {
         buyPrice = OrderOpenPrice();
         ticket = OrderTicket();
         continue;
        }
      if(!isBuy && OrderType()==OP_SELL && OrderOpenPrice() > sellPrice)
        {
         sellPrice = OrderOpenPrice();
         ticket = OrderTicket();
        }
     }
   COrder order(ticket);
   return order;
  }

//+------------------------------------------------------------------+
//| Get  Order Counts                                                             |
//+------------------------------------------------------------------+
int GetOrderCountsCurSymbol(bool isBuy)
  {
   int count = 0;
   int total = OrdersTotal();
   for(int i=0; i<total; i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderSymbol()!=_Symbol)
         continue;
      if((isBuy && OrderType()==OP_BUY) ||
         (!isBuy && OrderType()==OP_SELL))
         count++;
     }
   return count;
  }

//+------------------------------------------------------------------+
//| if Risk is Controllable                                                                  |
//+------------------------------------------------------------------+
bool IsRiskControllable()
  {
// check order counts
   if(GetOrderCountsCurSymbol(true) >= MaxOrderCounts ||
      GetOrderCountsCurSymbol(false) >= MaxOrderCounts)
     {
      //Print("Risk warn: too many orders!");
      return false;
     }
// check profit
   if(CMoneyManager::GetProfitPercent() < MaxAccountRiskPercent)
     {
     // Print("Risk warn: the account risk is too large!");
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+


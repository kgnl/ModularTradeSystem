//+------------------------------------------------------------------+
//|                                        TSControllerBollinger.mqh |
//|                                     Copyright 2020, Michael Wade |
//|                                             michaelwade@yeah.net |
//+------------------------------------------------------------------+
#property strict
#include "..\Common\TradeSystemController.mqh"
#include "..\Common\ISignalEngine.mqh"
#include "..\Common\OrderManager.mqh"
#include "..\Common\Log.mqh"
#include "..\Common\Const.mqh"
#include "SignalEngineBollinger.mqh"
#include "SignalEngineMartin.mqh"


//+------------------------------------------------------------------+
//| The controller is the main logical part of the trading system.
//| It processes the original signal data and combines it with other data
//| for comprehensive analysis, and finally outputs the execution signal.                                                             |
//+------------------------------------------------------------------+
class CTSControllerBollinger:public CTradeSystemController
  {
private:
   static const string  TAG;
   ISignalEngine     *m_signal_engine;
   ISignalEngine     *m_signal_engine_martin;
   CSignalData       m_signal_data;
   CSignalData       m_signal_data_martin;
   bool              ShouldOpenBuy();
   bool              ShouldOpenSell();
   bool              ShouldCloseBuy();
   bool              ShouldCloseSell();
public:
                     CTSControllerBollinger();
                    ~CTSControllerBollinger();
   int               ComputeTradeSignal();
   int               GetSafeState();
   int               GetHedgeSignal();
   void              SetSingalConsumed(const bool isConsumed);
  };

const string CTSControllerBollinger::TAG = "CTSControllerBollinger";
//+------------------------------------------------------------------+
//| Constructor with initialization list                                                           |
//+------------------------------------------------------------------+
CTSControllerBollinger::CTSControllerBollinger():m_signal_engine(NULL),m_signal_engine_martin(NULL)
  {
   m_signal_engine = new CSignalEngineBollinger;
   m_signal_engine_martin = new CSignalEngineMartin;
   LogR(TAG,"Controller Object is created");
  }
//+------------------------------------------------------------------+
//| Destructor                                                                 |
//+------------------------------------------------------------------+
CTSControllerBollinger::~CTSControllerBollinger()
  {
   delete(m_signal_engine);
   delete(m_signal_engine_martin);
   LogR(TAG,"Controller Object is deleted");
  }

//+------------------------------------------------------------------+
//| Compute Signal Data，called in onTick() function.
//| ATTENTION: It must be called before calling controller's other member functions
//+------------------------------------------------------------------+
int CTSControllerBollinger::ComputeTradeSignal()
  {
   m_signal_data_martin = m_signal_engine_martin.GetSignalData();
   CSignalData new_signal_data = m_signal_engine.GetSignalData();
// if the ArtificialOrientation input variable is set, then choose the manual signal,
// Otherwise choose the machine signal.
   if(ArtificialOrientation != ORI_NO)
      new_signal_data.orientation = ArtificialOrientation;
// The new signal is taken only if the signal content changes,
// otherwise keep holding the old signal.
   if(m_signal_data != new_signal_data)
     {
      m_signal_data = new_signal_data;
     }
   LogD(TAG,"ComputeSignalData..."+m_signal_data.ToString());
   if(ShouldOpenBuy())
      return SIGNAL_OPEN_BUY;
   if(ShouldOpenSell())
      return SIGNAL_OPEN_SELL;
   if(ShouldCloseBuy())
      return SIGNAL_CLOSE_BUY;
   if(ShouldCloseSell())
      return SIGNAL_CLOSE_SELL;
   return SIGNAL_NO;
  }

//+------------------------------------------------------------------+
//| When to open BUY order: no orders,see open signal;more than one order,see martin signal                                                                |
//+------------------------------------------------------------------+
bool CTSControllerBollinger::ShouldOpenBuy()
  {
   bool isOrientationRight = (m_signal_data.orientation == ORIENTATION_UP || m_signal_data.orientation == ORIENTATION_HOR);
   if(IsEmptyPositionsCurSymbol())
     {
      LogD(TAG,"IsEmptyPositionsCurSymbol = true");
      return !m_signal_data.is_consumed && m_signal_data.open_signal == SIGNAL_OPEN_BUY && isOrientationRight;
     }
   else
     {
      LogD(TAG,"IsEmptyPositionsCurSymbol = false"+StringConcatenate(",open_signal=",m_signal_data_martin.open_signal));
      return m_signal_data_martin.open_signal == SIGNAL_OPEN_BUY && isOrientationRight;
     }
  }

//+------------------------------------------------------------------+
//| When to open SELL order                                                                   |
//+------------------------------------------------------------------+
bool CTSControllerBollinger::ShouldOpenSell()
  {
   bool isOrientationRight = (m_signal_data.orientation == ORIENTATION_DW || m_signal_data.orientation == ORIENTATION_HOR);
   if(IsEmptyPositionsCurSymbol())
     {
      //Log(TAG,"IsEmptyPositionsCurSymbol = true");
      return !m_signal_data.is_consumed && m_signal_data.open_signal == SIGNAL_OPEN_SELL && isOrientationRight;
     }
   else
     {
      //Log(TAG,"IsEmptyPositionsCurSymbol = false"+StringConcatenate(",open_signal=",m_signal_data_martin.open_signal));
      return m_signal_data_martin.open_signal == SIGNAL_OPEN_SELL && isOrientationRight;
     }
  }

//+------------------------------------------------------------------+
//| When to close BUY order
//+------------------------------------------------------------------+
bool CTSControllerBollinger::ShouldCloseBuy()
  {
   return m_signal_data_martin.close_signal == SIGNAL_CLOSE_BUY;
  }

//+------------------------------------------------------------------+
//| When to close SELL order
//+------------------------------------------------------------------+
bool CTSControllerBollinger::ShouldCloseSell()
  {
   return m_signal_data_martin.close_signal == SIGNAL_CLOSE_SELL;
  }

//+------------------------------------------------------------------+
//| You must set a signal consumed after doing some actions according to it,
//| otherwise the signal will continuously trigger your actions.                                                             |
//+------------------------------------------------------------------+
void CTSControllerBollinger::SetSingalConsumed(const bool isConsumed)
  {
   m_signal_data.is_consumed = isConsumed;
  }

//+------------------------------------------------------------------+
//| Get the position safe state                                                             |
//+------------------------------------------------------------------+
int  CTSControllerBollinger::GetSafeState()
  {
   COrder totalOrder = GetAllOrdersAsOne();
//Log(TAG,"IsPositionDangerous..."+totalOrder.ToString());
   int state = POSITION_STATE_SAFE;
// if total profit is positive, never mind.
   if(totalOrder.profit>=0)
      return state;
// when totalorder's type is BUY
   if(totalOrder.type==ORDER_BUY && m_signal_data.close_signal == SIGNAL_CLOSE_BUY)
     {
      state = POSITION_STATE_WARN;  // level warn
      if(m_signal_data.orientation==ORIENTATION_DW)
         state = POSITION_STATE_DANG;
     }
// when totalorder's type is SELL
   if(totalOrder.type==ORDER_SELL && m_signal_data.close_signal == SIGNAL_CLOSE_SELL)
     {
      state = POSITION_STATE_WARN;
      if(m_signal_data.orientation==ORIENTATION_UP)
         state = POSITION_STATE_DANG; // level dangerous
     }
   return state;
  }

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CTSControllerBollinger::GetHedgeSignal()
  {
   COrder totalOrder = GetAllOrdersAsOne();

   double ssA1 = iIchimoku(Symbol(), PERIOD_H1, tenkan_sen, kijun_sen, senkou_span, MODE_SENKOUSPANA, 1);
   double ssB1 = iIchimoku(Symbol(), PERIOD_H1, tenkan_sen, kijun_sen, senkou_span, MODE_SENKOUSPANB, 1);
   double close2 = iClose(Symbol(), PERIOD_H1, 1);

   int hedge = SIGNAL_NO_HEDGE;
   int total = OrdersTotal();
   int buyCounts = GetOrderCountsCurSymbol(true);
   int sellCounts = GetOrderCountsCurSymbol(false);

   if((buyCounts == MaxOrderCounts) && totalOrder.type==ORDER_BUY && totalOrder.profit < 0 && (close2 < ssA1))
     {
      Print(TAG,"SIGNAL_HEDGE_BUY");
      hedge = SIGNAL_HEDGE;
     }

   if((sellCounts == MaxOrderCounts) && totalOrder.type==ORDER_SELL && totalOrder.profit < 0 && (close2 > ssA1))
     {
      Print(TAG,"SIGNAL_HEDGE_SELL");
      hedge = SIGNAL_HEDGE;
     }

   if(totalOrder.profit > MartinMinProfitPoints*totalOrder.lots && MaxOrderCounts == total+1 )
     {
      Print(TAG,"SIGNAL_CLOSE_HEDGE");
      hedge = SIGNAL_CLOSE_HEDGE;
     }

   return hedge;

  }
  
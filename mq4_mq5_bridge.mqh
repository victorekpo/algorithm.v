//+------------------------------------------------------------------+
//|                                               mq4_mq5_bridge.mqh |
//|                                                                  |
//+------------------------------------------------------------------+
/*

This file goes into your MT5 "Open Data Folder",  then into -> MQL5\Include\ 
Your main code (near the very top) would then call it using:
   #include <mq4_mq5_bridge.mqh>

VERSION HISTORY:

2017-JUN-05 v1_00 by bodi0
   mq4.mqh file posted here:  https://www.forexfactory.com/showthread.php?p=9943614#post9943614

2019-OCT-13 v1_01 by pips4life
   Renamed to mq4_mq5_bridge.mqh, posted this version in the above thread.


(Increment the version and always document dates!  Recognize that mutiple people might edit an old version
and choose a conflicting number, but not likely the same date also.   There will be some effort required
to "merge" diverging versions).

FUTURE ENHANCEMENTS/FIXES:

NEXT(2019-OCT): Plenty of opportunities to define equivalent functions/#define's/etc. based on:
   https://www.mql5.com/en/articles/81  (2010 Article, but still useful).
   
NEXT(2019-OCT): From https://www.mql5.com/en/articles/81, incorporate Sergey Pavlov's "initmql4.mqh" file, as appropriate.


*/

#property strict

#ifdef __MQL5__

#define show_inputs script_show_inputs

#define extern input

#define init OnInit

#define Point _Point
#define Digits _Digits

#define Bid (::SymbolInfoDouble(_Symbol, ::SYMBOL_BID))
#define Ask (::SymbolInfoDouble(_Symbol, ::SYMBOL_ASK))

#define True true
#define False false
#define TRUE true
#define FALSE false

#define TimeToStr TimeToString
#define DoubleToStr DoubleToString

#define StrToTime StringToTime

#define CurTime TimeCurrent

#define HistoryTotal OrdersHistoryTotal

#define LocalTime TimeLocal

#define MODE_OPEN 0
#define MODE_CLOSE 3
#define MODE_VOLUME 4 
#define MODE_REAL_VOLUME 5
#define MODE_LOW 1
#define MODE_HIGH 2
#define MODE_TIME 5
#define MODE_SWAPLONG 18
#define MODE_SWAPSHORT 19
#define MODE_STARTING 20
#define MODE_EXPIRATION 21
#define MODE_TRADEALLOWED 22
#define MODE_SWAPTYPE 26
#define MODE_BID 9
#define MODE_ASK 10
#define MODE_DIGITS 12
#define MODE_SPREAD 13
#define MODE_STOPLEVEL 14
#define MODE_LOTSIZE 15
#define MODE_MINLOT 16
#define MODE_MAXLOT 17
#define MODE_LOTSTEP 18
#define MODE_MARGINREQUIRED 19
#define MODE_POINT 20
#define MODE_TICK_SIZE 21
#define MODE_TICK_VALUE 22
#define MODE_FREEZELEVEL 33
#define MODE_PROFITCALCMODE 27
#define MODE_MARGINCALCMODE 28
#define MODE_MARGININIT 29
#define MODE_MARGINMAINTENANCE 30
#define MODE_MARGINHEDGED 31
#define EMPTY -1

//Graph Object constants

#define OBJPROP_TIME1 0
#define OBJPROP_PRICE1 1
#define OBJPROP_TIME2 2
#define OBJPROP_PRICE2 3
#define OBJPROP_TIME3 4
#define OBJPROP_PRICE3 5
#define OBJPROP_COLOR 6
#define OBJPROP_STYLE 7
#define OBJPROP_WIDTH 8
#define OBJPROP_BACK 9
#define OBJPROP_RAY 10
#define OBJPROP_ELLIPSE 11
#define OBJPROP_SCALE 12
#define OBJPROP_ANGLE 13
#define OBJPROP_ARROWCODE 14
#define OBJPROP_TIMEFRAMES 15
#define OBJPROP_DEVIATION 16
#define OBJPROP_FONTSIZE 100
#define OBJPROP_CORNER 101
#define OBJPROP_XDISTANCE 102
#define OBJPROP_YDISTANCE 103
#define OBJPROP_FIBOLEVELS 200
#define OBJPROP_LEVELCOLOR 201
#define OBJPROP_LEVELSTYLE 202
#define OBJPROP_LEVELWIDTH 203



// fix
#ifndef POSITION_TICKET
#define POSITION_TICKET 1
#endif 

#ifndef ORDER_TICKET
#define ORDER_TICKET 1
#endif 

#ifndef DEAL_TICKET
#define DEAL_TICKET 1
#endif 

#ifndef TRADE_ACTION_CLOSE_BY
#define TRADE_ACTION_CLOSE_BY 1
#endif 

#ifndef PositionSelectByTicket
#define PositionSelectByTicket PositionSelectByTickets
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool PositionSelectByTickets(ulong ticket)
  {
   return (true);
  }
#endif 

#ifndef PositionGetTicket
#define PositionGetTicket PositionGetTickets
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool PositionGetTickets(ulong ticket)
  {
   return (true);
  }
#endif
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*
#ifndef MqlTradeRequest
#define MqlTradeRequest MqlTradeRequests

struct MqlTradeRequests
{

};

#endif 
*/
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MarketInfo(const string Symb,const int Type)
  {
   switch(Type)
     {
      case MODE_BID:
         return(::SymbolInfoDouble(Symb, ::SYMBOL_BID));
      case MODE_ASK:
         return(::SymbolInfoDouble(Symb, ::SYMBOL_ASK));
      case MODE_DIGITS:
         return((double)::SymbolInfoInteger(Symb, ::SYMBOL_DIGITS));
      case MODE_SPREAD:
         return((double)::SymbolInfoInteger(Symb, ::SYMBOL_SPREAD));
      case MODE_STOPLEVEL:
         return((double)::SymbolInfoInteger(Symb, ::SYMBOL_TRADE_STOPS_LEVEL));
      case MODE_LOTSIZE:
         return(::SymbolInfoDouble(Symb, ::SYMBOL_TRADE_CONTRACT_SIZE));
      case MODE_LOTSTEP:
         return(::SymbolInfoDouble(Symb, ::SYMBOL_VOLUME_STEP));
      case MODE_MINLOT:
         return(::SymbolInfoDouble(Symb, ::SYMBOL_VOLUME_MIN));
      case MODE_MAXLOT:
         return(::SymbolInfoDouble(Symb, ::SYMBOL_VOLUME_MAX));
      case MODE_POINT:
         return(::SymbolInfoDouble(Symb, ::SYMBOL_POINT));
      case MODE_TICK_SIZE:
         return(::SymbolInfoDouble(Symb, ::SYMBOL_TRADE_TICK_SIZE));
      case MODE_TICK_VALUE:
         return(::SymbolInfoDouble(Symb, ::SYMBOL_TRADE_TICK_VALUE));
     }

   return(-1);
  }

#define StringGetChar StringGetCharacter
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string  StringSetChar(const string &String_Var,const int iPos,const ushort Value)
  {
   string Str=String_Var;

   ::StringSetCharacter(Str,iPos,Value);

   return(Str);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int TimeDayOfWeek(const datetime Date)
  {
   MqlDateTime mTime;

   ::TimeToStruct(Date,mTime);

   return(mTime.day_of_week);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Hour()
  {
   MqlDateTime mHour;
   TimeCurrent(mHour);

   return (mHour.hour);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Minute()
  {
   MqlDateTime mMinute;
   TimeCurrent(mMinute);

   return (mMinute.min);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Day()
  {
   MqlDateTime mDay;
   TimeCurrent(mDay);

   return (mDay.day);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsTesting(void)
  {
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsTradeContextBusy(void)
  {
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsTradeAllowed(void)
  {
   return((bool) ::MQLInfoInteger(::MQL_TRADE_ALLOWED));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsOptimization()
  {
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool RefreshRates(void)
  {
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string WindowExpertName(void)
  {
   return(::MQLInfoString(::MQL_PROGRAM_NAME));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string AccountName(void)
  {
   return(::AccountInfoString(::ACCOUNT_NAME));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int AccountNumber(void)
  {
   return((int)::AccountInfoInteger(::ACCOUNT_LOGIN));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double AccountFreeMargin(void)
  {
   return(::AccountInfoDouble(::ACCOUNT_MARGIN_FREE));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double AccountFreeMarginCheck(const string Symb,const int Cmd,const double dVolume)
  {
   double Margin;

   return(::OrderCalcMargin((ENUM_ORDER_TYPE)Cmd, Symb, dVolume,
          ::SymbolInfoDouble(Symb,(Cmd==::ORDER_TYPE_BUY) ? ::SYMBOL_ASK : ::SYMBOL_BID),Margin) ?
          ::AccountInfoDouble(::ACCOUNT_MARGIN_FREE) - Margin : -1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double AccountBalance()
  {
   return(::AccountInfoDouble(ACCOUNT_BALANCE));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double AccountEquity(void)
  {
   return(::AccountInfoDouble(::ACCOUNT_EQUITY));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int MT4Bars(void)
  {
   return(::Bars(_Symbol, _Period));
  }

#define Bars (::MT4Bars())


#define DEFINE_TIMESERIE(NAME,FUNC,T)                                                                         \
  class CLASS##NAME                                                                                           \
  {                                                                                                           \
  public:                                                                                                     \
    static T Get(const string Symb,const int TimeFrame,const int iShift) \
    {                                                                                                         \
      T tValue[];                                                                                             \
                                                                                                              \
      return((Copy##FUNC((Symb == NULL) ? _Symbol : Symb, _Period, iShift, 1, tValue) > 0) ? tValue[0] : -1); \
    }                                                                                                         \
                                                                                                              \
    T operator[](const int iPos) const                                                                        \
    {                                                                                                         \
      return(CLASS##NAME::Get(_Symbol, _Period, iPos));                                                       \
    }                                                                                                         \
  };                                                                                                          \
                                                                                                              \
  CLASS##NAME NAME;                                                                                           \
                                                                                                              \
  T i##NAME(const string Symb,const int TimeFrame,const int iShift) \
  {                                                                                                           \
    return(CLASS##NAME::Get(Symb, TimeFrame, iShift));                                                        \
  }

DEFINE_TIMESERIE(Volume,TickVolume,long)
DEFINE_TIMESERIE(Time,Time,datetime)
DEFINE_TIMESERIE(Open,Open,double)
//DEFINE_TIMESERIE(ThisHigh,High,double)
//DEFINE_TIMESERIE(ThisLow,Low,double)
DEFINE_TIMESERIE(Close,Close,double)

#endif // __MQL5__

#ifdef __MQL5__
#ifndef __MT4ORDERS__

#define __MT4ORDERS__

#define RESERVE_SIZE 1000
#define DAY (24 * 3600)
#define HISTORY_PAUSE (MT4HISTORY::IsTester ? 0 : 5)
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MT4HISTORY
  {
private:
   static const bool IsTester;

   long              Tickets[];
   uint              Amount;

   datetime          LastTime;

   int               LastTotalDeals;
   int               LastTotalOrders;

   datetime          LastInitTime;

#define GETNEXTPOS_FUNCTION(NAME)                                    \
  static int GetNextPosMT4##NAME(int iPos) \
  {                                                                  \
    const int Total=::History##NAME##sTotal();                     \
                                                                     \
    while(iPos<Total) \
    {                                                                \
      if(MT4HISTORY::IsMT4##NAME(::History##NAME##GetTicket(iPos))) \
        break;                                                       \
                                                                     \
      iPos++;                                                        \
    }                                                                \
                                                                     \
    return(iPos);                                                    \
     }

   GETNEXTPOS_FUNCTION(Order)
   GETNEXTPOS_FUNCTION(Deal)

#undef GETNEXTPOS_FUNCTION

   bool RefreshHistory(void)
     {
      bool Res=false;

      const datetime LastTimeCurrent=::TimeCurrent();

      if((!MT4HISTORY::IsTester) && (LastTimeCurrent>=this.LastInitTime+DAY))
        {
         this.LastTime=0;

         this.LastTotalOrders= 0;
         this.LastTotalDeals = 0;

         this.Amount=0;

         ::ArrayResize(this.Tickets,this.Amount,RESERVE_SIZE);

         this.LastInitTime=LastTimeCurrent;
        }

      if(::HistorySelect(this.LastTime,::MathMax(LastTimeCurrent,this.LastTime)+DAY)) // суточный запас
        {
         const int TotalOrders= ::HistoryOrdersTotal();
         const int TotalDeals = ::HistoryDealsTotal();

         Res=((TotalOrders!=this.LastTotalOrders) || (TotalDeals!=this.LastTotalDeals));

         if(Res)
           {
            int iOrder= MT4HISTORY::GetNextPosMT4Order(this.LastTotalOrders);
            int iDeal = MT4HISTORY::GetNextPosMT4Deal(this.LastTotalDeals);

            long TimeOrder=(iOrder<TotalOrders) ? ::HistoryOrderGetInteger(::HistoryOrderGetTicket(iOrder),ORDER_TIME_DONE/*_MSC*/) : LONG_MAX; // ORDER_TIME_DONE_MSC returns NULL (build 1470)
            long TimeDeal =(iDeal<TotalDeals) ? ::HistoryDealGetInteger(::HistoryDealGetTicket(iDeal),DEAL_TIME/*_MSC*/) : LONG_MAX;

            while((iDeal<TotalDeals) || (iOrder<TotalOrders))
               if(TimeOrder<TimeDeal)
                 {
                  this.Amount=::ArrayResize(this.Tickets,this.Amount+1,RESERVE_SIZE);

                  this.Tickets[this.Amount-1]=-(long)::HistoryOrderGetTicket(iOrder);

                  iOrder=MT4HISTORY::GetNextPosMT4Order(iOrder+1);

                  TimeOrder=(iOrder<TotalOrders) ? ::HistoryOrderGetInteger(::HistoryOrderGetTicket(iOrder),ORDER_TIME_DONE/*_MSC*/) : LONG_MAX; // ORDER_TIME_DONE_MSC returns NULL (build 1470)
                 }
            else
              {
               this.Amount=::ArrayResize(this.Tickets,this.Amount+1,RESERVE_SIZE);

               this.Tickets[this.Amount-1]=(long)::HistoryDealGetTicket(iDeal);

               iDeal=MT4HISTORY::GetNextPosMT4Deal(iDeal+1);

               TimeDeal=(iDeal<TotalDeals) ? ::HistoryDealGetInteger(::HistoryDealGetTicket(iDeal),DEAL_TIME/*_MSC*/) : LONG_MAX;
              }

            TimeOrder=(TotalOrders>0) ? ::HistoryOrderGetInteger(::HistoryOrderGetTicket(TotalOrders-1),ORDER_TIME_DONE/*_MSC*/) : 0;
            TimeDeal =(TotalDeals>0) ? ::HistoryDealGetInteger(::HistoryDealGetTicket(TotalDeals-1),DEAL_TIME/*_MSC*/) : 0;

            const long MaxTime=::MathMax(TimeOrder,TimeDeal);

            this.LastTotalOrders= 0;
            this.LastTotalDeals = 0;

            if(LastTimeCurrent-HISTORY_PAUSE>MaxTime)
               this.LastTime=LastTimeCurrent-HISTORY_PAUSE;
            else
              {
               this.LastTime=(datetime)MaxTime;

               if(TimeOrder== MaxTime)
                  for(int i = TotalOrders-1; i>= 0; i--)
                    {
                     if(TimeOrder>::HistoryOrderGetInteger(::HistoryOrderGetTicket(i),ORDER_TIME_DONE/*_MSC*/))
                        break;

                     this.LastTotalOrders++;
                    }

               if(TimeDeal == MaxTime)
                  for(int i = TotalDeals - 1; i >= 0; i--)
                    {
                     if(TimeDeal!=::HistoryDealGetInteger(::HistoryDealGetTicket(TotalDeals-1),DEAL_TIME/*_MSC*/))
                        break;

                     this.LastTotalDeals++;
                    }
              }
           }
         else if(LastTimeCurrent-HISTORY_PAUSE>this.LastTime)
           {
            this.LastTime=LastTimeCurrent-HISTORY_PAUSE;

            this.LastTotalOrders= 0;
            this.LastTotalDeals = 0;
           }
        }

      return(Res);
     }

public:
   static bool IsMT4Deal(const ulong Ticket)
     {
      const ENUM_DEAL_TYPE Type=(ENUM_DEAL_TYPE)::HistoryDealGetInteger(Ticket,DEAL_TYPE);

      return(((Type != DEAL_TYPE_BUY) && (Type != DEAL_TYPE_SELL)) || ((ENUM_DEAL_ENTRY)::HistoryDealGetInteger(Ticket, DEAL_ENTRY) == DEAL_ENTRY_OUT));
     }

   static bool IsMT4Order(const ulong Ticket)
     {
      return((::HistoryOrderGetDouble(Ticket, ORDER_VOLUME_CURRENT) > 0) || (::HistoryOrderGetInteger(Ticket, ORDER_POSITION_ID) == 0));
     }

                     MT4HISTORY(void) : Amount(0),LastTime(0),LastTotalDeals(0),LastTotalOrders(0),LastInitTime(0)
     {
      ::ArrayResize(this.Tickets,this.Amount,RESERVE_SIZE);

      this.RefreshHistory();
     }

   int GetAmount(void)
     {
      this.RefreshHistory();

      return((int)this.Amount);
     }

   long operator[](const uint Pos)
     {
      long Res=0;

      if(Pos>=this.Amount)
        {
         this.RefreshHistory();

         if(Pos< this.Amount)
            Res=this.Tickets[Pos];
        }
      else
         Res=this.Tickets[Pos];

      return(Res);
     }
  };

static const bool MT4HISTORY::IsTester=(::MQLInfoInteger(MQL_TESTER) || ::MQLInfoInteger(MQL_OPTIMIZATION) || 
                                        ::MQLInfoInteger(MQL_VISUAL_MODE) || ::MQLInfoInteger(MQL_FRAME_MODE));

#undef HISTORY_PAUSE
#undef DAY
#undef RESERVE_SIZE
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct MT4_ORDER
  {
   int               Ticket;
   int               Type;

   double            Lots;

   string            Symbol;
   string            Comment;

   double            OpenPrice;
   datetime          OpenTime;

   double            StopLoss;
   double            TakeProfit;

   double            ClosePrice;
   datetime          CloseTime;

   datetime          Expiration;

   int               MagicNumber;

   double            Profit;

   double            Commission;
   double            Swap;

   string ToString(void) const
     {
      static const string Types[]={"buy","sell","buy limit","sell limit","buy stop","sell stop","balance"};
      const int digits=(int)::SymbolInfoInteger(this.Symbol,SYMBOL_DIGITS);

      return("#" + (string)this.Ticket + " " +
             (string)this.OpenTime+" "+
             ((this.Type<::ArraySize(Types)) ? Types[this.Type]: "unknown")+" "+
             ::DoubleToString(this.Lots,2)+" "+
             this.Symbol+" "+
             ::DoubleToString(this.OpenPrice, digits) + " " +
             ::DoubleToString(this.StopLoss, digits) + " " +
             ::DoubleToString(this.TakeProfit, digits) + " " +
             ((this.CloseTime>0) ?((string)this.CloseTime+" ") : "")+
             ::DoubleToString(this.ClosePrice, digits) + " " +
             ::DoubleToString(this.Commission, 2) + " " +
             ::DoubleToString(this.Swap, 2) + " " +
             ::DoubleToString(this.Profit, 2) + " " +
             ((this.Comment=="") ? "" :(this.Comment+" "))+
             (string)this.MagicNumber+
             (((this.Expiration>0) ?(" expiration "+(string)this.Expiration): "")));
     }
  };

#define OP_BUY ORDER_TYPE_BUY
#define OP_SELL ORDER_TYPE_SELL
#define OP_BUYLIMIT ORDER_TYPE_BUY_LIMIT
#define OP_SELLLIMIT ORDER_TYPE_SELL_LIMIT
#define OP_BUYSTOP ORDER_TYPE_BUY_STOP
#define OP_SELLSTOP ORDER_TYPE_SELL_STOP
#define OP_BALANCE 6

#define SELECT_BY_POS 0
#define SELECT_BY_TICKET 1

#define MODE_TRADES 0
#define MODE_HISTORY 1
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MT4ORDERS
  {
private:
   static MT4_ORDER  Order;
   static MT4HISTORY History;

   static const bool IsTester;

   static ulong GetPositionDealIn(const ulong PositionIdentifier=0)
     {
      ulong Ticket=0;

      if((PositionIdentifier==0) ? ::HistorySelectByPosition(::PositionGetInteger(POSITION_IDENTIFIER)) : ::HistorySelectByPosition(PositionIdentifier))
        {
         const int Total=::HistoryDealsTotal();

         for(int i=0; i<Total; i++)
           {
            const ulong TicketDeal=::HistoryDealGetTicket(i);

            if(TicketDeal>0)
               if((ENUM_DEAL_ENTRY)::HistoryDealGetInteger(TicketDeal,DEAL_ENTRY)==DEAL_ENTRY_IN)
                 {
                  Ticket=TicketDeal;

                  break;
                 }
           }
        }

      return(Ticket);
     }

   static double GetPositionCommission(void)
     {
      double Commission=::PositionGetDouble(POSITION_COMMISSION);

      if(Commission==0)
        {
         const ulong Ticket=MT4ORDERS::GetPositionDealIn();

         if(Ticket>0)
           {
            const double LotsIn=::HistoryDealGetDouble(Ticket,DEAL_VOLUME);

            if(LotsIn>0)
               Commission=::HistoryDealGetDouble(Ticket,DEAL_COMMISSION)*::PositionGetDouble(POSITION_VOLUME)/LotsIn;
           }
        }

      return(Commission);
     }

   static string GetPositionComment(void)
     {
      string comment=::PositionGetString(POSITION_COMMENT);

      if(comment=="")
        {
         const ulong Ticket=MT4ORDERS::GetPositionDealIn();

         if(Ticket>0)
            comment=::HistoryDealGetString(Ticket,DEAL_COMMENT);
        }

      return(comment);
     }

   static void GetPositionData(void)
     {
      MT4ORDERS::Order.Ticket=(int)::PositionGetInteger(POSITION_TICKET);
      MT4ORDERS::Order.Type=(int)::PositionGetInteger(POSITION_TYPE);

      MT4ORDERS::Order.Lots=::PositionGetDouble(POSITION_VOLUME);

      MT4ORDERS::Order.Symbol=::PositionGetString(POSITION_SYMBOL);
      MT4ORDERS::Order.Comment=MT4ORDERS::GetPositionComment();

      MT4ORDERS::Order.OpenPrice= ::PositionGetDouble(POSITION_PRICE_OPEN);
      MT4ORDERS::Order.OpenTime =(datetime)::PositionGetInteger(POSITION_TIME);

      MT4ORDERS::Order.StopLoss=::PositionGetDouble(POSITION_SL);
      MT4ORDERS::Order.TakeProfit=::PositionGetDouble(POSITION_TP);

      MT4ORDERS::Order.ClosePrice= ::PositionGetDouble(POSITION_PRICE_CURRENT);
      MT4ORDERS::Order.CloseTime = 0;

      MT4ORDERS::Order.Expiration=0;

      MT4ORDERS::Order.MagicNumber=(int)::PositionGetInteger(POSITION_MAGIC);

      MT4ORDERS::Order.Profit=::PositionGetDouble(POSITION_PROFIT);

      MT4ORDERS::Order.Commission=MT4ORDERS::GetPositionCommission();
      MT4ORDERS::Order.Swap=::PositionGetDouble(POSITION_SWAP);

      return;
     }

   static void GetOrderData(void)
     {
      MT4ORDERS::Order.Ticket=(int)::OrderGetInteger(ORDER_TICKET);
      MT4ORDERS::Order.Type=(int)::OrderGetInteger(ORDER_TYPE);

      MT4ORDERS::Order.Lots=::OrderGetDouble(ORDER_VOLUME_CURRENT);

      MT4ORDERS::Order.Symbol=::OrderGetString(ORDER_SYMBOL);
      MT4ORDERS::Order.Comment=::OrderGetString(ORDER_COMMENT);

      MT4ORDERS::Order.OpenPrice= ::OrderGetDouble(ORDER_PRICE_OPEN);
      MT4ORDERS::Order.OpenTime =(datetime)::OrderGetInteger(ORDER_TIME_SETUP);

      MT4ORDERS::Order.StopLoss=::OrderGetDouble(ORDER_SL);
      MT4ORDERS::Order.TakeProfit=::OrderGetDouble(ORDER_TP);

      MT4ORDERS::Order.ClosePrice= ::OrderGetDouble(ORDER_PRICE_CURRENT);
      MT4ORDERS::Order.CloseTime =(datetime)::OrderGetInteger(ORDER_TIME_DONE);

      MT4ORDERS::Order.Expiration=(datetime)::OrderGetInteger(ORDER_TIME_EXPIRATION);

      MT4ORDERS::Order.MagicNumber=(int)::OrderGetInteger(ORDER_MAGIC);

      MT4ORDERS::Order.Profit=0;

      MT4ORDERS::Order.Commission=0;
      MT4ORDERS::Order.Swap=0;

      return;
     }

   static void GetHistoryOrderData(const ulong Ticket)
     {
      MT4ORDERS::Order.Ticket=(int)::HistoryOrderGetInteger(Ticket,ORDER_TICKET);
      MT4ORDERS::Order.Type=(int)::HistoryOrderGetInteger(Ticket,ORDER_TYPE);

      MT4ORDERS::Order.Lots=::HistoryOrderGetDouble(Ticket,ORDER_VOLUME_CURRENT);

      if(MT4ORDERS::Order.Lots== 0)
         MT4ORDERS::Order.Lots = ::HistoryOrderGetDouble(Ticket,ORDER_VOLUME_INITIAL);

      MT4ORDERS::Order.Symbol=::HistoryOrderGetString(Ticket,ORDER_SYMBOL);
      MT4ORDERS::Order.Comment=::HistoryOrderGetString(Ticket,ORDER_COMMENT);

      MT4ORDERS::Order.OpenPrice= ::HistoryOrderGetDouble(Ticket,ORDER_PRICE_OPEN);
      MT4ORDERS::Order.OpenTime =(datetime)::HistoryOrderGetInteger(Ticket,ORDER_TIME_SETUP);

      MT4ORDERS::Order.StopLoss=::HistoryOrderGetDouble(Ticket,ORDER_SL);
      MT4ORDERS::Order.TakeProfit=::HistoryOrderGetDouble(Ticket,ORDER_TP);

      MT4ORDERS::Order.ClosePrice= 0;
      MT4ORDERS::Order.CloseTime =(datetime)::HistoryOrderGetInteger(Ticket,ORDER_TIME_DONE);

      MT4ORDERS::Order.Expiration=(datetime)::HistoryOrderGetInteger(Ticket,ORDER_TIME_EXPIRATION);

      MT4ORDERS::Order.MagicNumber=(int)::HistoryOrderGetInteger(Ticket,ORDER_MAGIC);

      MT4ORDERS::Order.Profit=0;

      MT4ORDERS::Order.Commission=0;
      MT4ORDERS::Order.Swap=0;

      return;
     }

   static void GetHistoryPositionData(const ulong Ticket)
     {
      MT4ORDERS::Order.Ticket=(int)::HistoryDealGetInteger(Ticket,DEAL_TICKET);
      MT4ORDERS::Order.Type=(int)::HistoryDealGetInteger(Ticket,DEAL_TYPE);

      if((MT4ORDERS::Order.Type>OP_SELL))
         MT4ORDERS::Order.Type+=(OP_BALANCE-OP_SELL-1);
      else
         MT4ORDERS::Order.Type=1-MT4ORDERS::Order.Type;

      MT4ORDERS::Order.Lots=::HistoryDealGetDouble(Ticket,DEAL_VOLUME);

      MT4ORDERS::Order.Symbol=::HistoryDealGetString(Ticket,DEAL_SYMBOL);
      MT4ORDERS::Order.Comment=::HistoryDealGetString(Ticket,DEAL_COMMENT);

      MT4ORDERS::Order.OpenPrice= ::HistoryDealGetDouble(Ticket,DEAL_PRICE);
      MT4ORDERS::Order.OpenTime =(datetime)::HistoryDealGetInteger(Ticket,DEAL_TIME);

      MT4ORDERS::Order.StopLoss=0;
      MT4ORDERS::Order.TakeProfit=0;

      MT4ORDERS::Order.ClosePrice= ::HistoryDealGetDouble(Ticket,DEAL_PRICE);
      MT4ORDERS::Order.CloseTime =(datetime)::HistoryDealGetInteger(Ticket,DEAL_TIME);;

      MT4ORDERS::Order.Expiration=0;

      MT4ORDERS::Order.MagicNumber=(int)::HistoryDealGetInteger(Ticket,DEAL_MAGIC);

      MT4ORDERS::Order.Profit=::HistoryDealGetDouble(Ticket,DEAL_PROFIT);

      MT4ORDERS::Order.Commission=::HistoryDealGetDouble(Ticket,DEAL_COMMISSION);
      MT4ORDERS::Order.Swap=::HistoryDealGetDouble(Ticket,DEAL_SWAP);

      const ulong OpenTicket=MT4ORDERS::GetPositionDealIn(::HistoryDealGetInteger(Ticket,DEAL_POSITION_ID));

      if(OpenTicket>0)
        {
         MT4ORDERS::Order.OpenPrice= ::HistoryDealGetDouble(OpenTicket,DEAL_PRICE);
         MT4ORDERS::Order.OpenTime =(datetime)::HistoryDealGetInteger(OpenTicket,DEAL_TIME);

         const double OpenLots=::HistoryDealGetDouble(OpenTicket,DEAL_VOLUME);

         if(OpenLots>0)
            MT4ORDERS::Order.Commission+=::HistoryDealGetDouble(OpenTicket,DEAL_COMMISSION)*MT4ORDERS::Order.Lots/OpenLots;

         if(MT4ORDERS::Order.MagicNumber== 0)
            MT4ORDERS::Order.MagicNumber =(int)::HistoryDealGetInteger(OpenTicket,DEAL_MAGIC);

         if(MT4ORDERS::Order.Comment== "")
            MT4ORDERS::Order.Comment = ::HistoryDealGetString(OpenTicket,DEAL_COMMENT);
        }

      return;
     }

   static bool Waiting(const bool FlagInit=false)
     {
      static ulong StartTime=0;

      if(FlagInit)
         StartTime=::GetMicrosecondCount();

      const bool Res=(::GetMicrosecondCount()-StartTime<MT4ORDERS::OrderSend_MaxPause);

      if(Res)
         ::Sleep(0);

      return(Res);
     }

   static bool EqualPrices(const double Price1,const double Price2,const int digits)
     {
      return(::NormalizeDouble(Price1 - Price2, digits) == 0);
     }

#define WHILE(A) while (!(Res = (A)) && MT4ORDERS::Waiting())

   static bool OrderSend(const MqlTradeRequest &Request,MqlTradeResult &Result)
     {
      bool Res=::OrderSend(Request,Result);

      if(Res && !MT4ORDERS::IsTester && (Result.retcode<TRADE_RETCODE_ERROR) && (MT4ORDERS::OrderSend_MaxPause>0))
        {
         Res=(Result.retcode==TRADE_RETCODE_DONE);
         MT4ORDERS::Waiting(true);

         if(Request.action==TRADE_ACTION_DEAL)
           {
            WHILE(::HistoryOrderSelect(Result.order))
            ;

            Res=Res && (((ENUM_ORDER_STATE)::HistoryOrderGetInteger(Result.order,ORDER_STATE)==ORDER_STATE_FILLED) || 
                        ((ENUM_ORDER_STATE)::HistoryOrderGetInteger(Result.order,ORDER_STATE)==ORDER_STATE_PARTIAL));

            if(Res)
               WHILE(::HistoryDealSelect(Result.deal))
               ;
           }
         else if(Request.action==TRADE_ACTION_PENDING)
           {
            if(Res)
               WHILE(::OrderSelect(Result.order))
               ;
            else
              {
               WHILE(::HistoryOrderSelect(Result.order))
               ;

               Res=false;
              }
           }
         else if(Request.action==TRADE_ACTION_SLTP)
           {
            if(Res)
              {
               bool EqualSL = false;
               bool EqualTP = false;

               const int digits=(int)::SymbolInfoInteger(Request.symbol,SYMBOL_DIGITS);

               if((Request.position==0) ? ::PositionSelect(Request.symbol) : ::PositionSelectByTicket(Request.position))
                 {
                  EqualSL = MT4ORDERS::EqualPrices(::PositionGetDouble(POSITION_SL), Request.sl, digits);
                  EqualTP = MT4ORDERS::EqualPrices(::PositionGetDouble(POSITION_TP), Request.tp, digits);
                 }

               WHILE((EqualSL && EqualTP))
               if((Request.position==0) ? ::PositionSelect(Request.symbol) : ::PositionSelectByTicket(Request.position))
                 {
                  EqualSL = MT4ORDERS::EqualPrices(::PositionGetDouble(POSITION_SL), Request.sl, digits);
                  EqualTP = MT4ORDERS::EqualPrices(::PositionGetDouble(POSITION_TP), Request.tp, digits);
                 }
              }
           }
         else if(Request.action==TRADE_ACTION_MODIFY)
           {
            if(Res)
              {
               bool EqualSL = false;
               bool EqualTP = false;

               const int digits=(int)::SymbolInfoInteger(Request.symbol,SYMBOL_DIGITS);

               if(::OrderSelect(Result.order))
                 {
                  EqualSL = MT4ORDERS::EqualPrices(::OrderGetDouble(ORDER_SL), Request.sl, digits);
                  EqualTP = MT4ORDERS::EqualPrices(::OrderGetDouble(ORDER_TP), Request.tp, digits);
                 }

               WHILE((EqualSL && EqualTP))
               if(::OrderSelect(Result.order))
                 {
                  EqualSL = MT4ORDERS::EqualPrices(::OrderGetDouble(ORDER_SL), Request.sl, digits);
                  EqualTP = MT4ORDERS::EqualPrices(::OrderGetDouble(ORDER_TP), Request.tp, digits);
                 }
              }
           }
         else if(Request.action==TRADE_ACTION_REMOVE)
         if(Res)
         WHILE(::HistoryOrderSelect(Result.order))
            ;
        }

      return(Res);
     }

#undef WHILE

   static bool NewOrderSend(const MqlTradeRequest &Request)
     {
      MqlTradeResult Result;

      return(MT4ORDERS::OrderSend(Request, Result) ? Result.retcode < TRADE_RETCODE_ERROR : false);
     }

   static bool ModifyPosition(const int Ticket,MqlTradeRequest &Request)
     {
      const bool Res=::PositionSelectByTicket(Ticket);

      if(Res)
        {
         Request.action=TRADE_ACTION_SLTP;

         Request.position=Ticket;
         Request.symbol=::PositionGetString(POSITION_SYMBOL);
        }

      return(Res);
     }

   static ENUM_ORDER_TYPE_FILLING GetFilling(const string Symb,const uint Type=ORDER_FILLING_FOK)
     {
      const ENUM_SYMBOL_TRADE_EXECUTION ExeMode=(ENUM_SYMBOL_TRADE_EXECUTION)::SymbolInfoInteger(Symb,SYMBOL_TRADE_EXEMODE);
      const int FillingMode=(int)::SymbolInfoInteger(Symb,SYMBOL_FILLING_MODE);

      return((FillingMode == 0 || (Type >= ORDER_FILLING_RETURN) || ((FillingMode & (Type + 1)) != Type + 1)) ?
             (((ExeMode==SYMBOL_TRADE_EXECUTION_EXCHANGE) || (ExeMode==SYMBOL_TRADE_EXECUTION_INSTANT)) ?
             ORDER_FILLING_RETURN :((FillingMode==SYMBOL_FILLING_IOC) ? ORDER_FILLING_IOC : ORDER_FILLING_FOK)) :
             (ENUM_ORDER_TYPE_FILLING)Type);
     }

   static bool ModifyOrder(const int Ticket,const double Price,const datetime Expiration,MqlTradeRequest &Request)
     {
      const bool Res=::OrderSelect(Ticket);

      if(Res)
        {
         Request.action= TRADE_ACTION_MODIFY;
         Request.order = Ticket;

         Request.price=Price;

         Request.symbol=::OrderGetString(ORDER_SYMBOL);

         Request.type_filling=MT4ORDERS::GetFilling(Request.symbol);

         if(Expiration>0)
           {
            Request.type_time=ORDER_TIME_SPECIFIED;
            Request.expiration=Expiration;
           }
        }

      return(Res);
     }

   static bool SelectByPosHistory(const int Index)
     {
      const int Ticket=(int)MT4ORDERS::History[Index];
      const bool Res=(Ticket>0) ? ::HistoryDealSelect(Ticket) :((Ticket<0) ? ::HistoryOrderSelect(-Ticket) : false);

      if(Res)
        {
         if(Ticket>0)
            MT4ORDERS::GetHistoryPositionData(Ticket);
         else
            MT4ORDERS::GetHistoryOrderData(-Ticket);
        }

      return(Res);
     }

   // position has higher priority
   static bool SelectByPos(const int Index)
     {
      const int Total = ::PositionsTotal();
      const bool Flag = (Index < Total);

      const bool Res=(Flag) ? ::PositionSelectByTicket(::PositionGetTicket(Index)) : ::OrderSelect(::OrderGetTicket(Index-Total));

      if(Res)
        {
         if(Flag)
            MT4ORDERS::GetPositionData();
         else
            MT4ORDERS::GetOrderData();
        }

      return(Res);
     }

   static bool SelectByHistoryTicket(const int Ticket)
     {
      bool Res=::HistoryDealSelect(Ticket) ? MT4HISTORY::IsMT4Deal(Ticket) : false;

      if(Res)
         MT4ORDERS::GetHistoryPositionData(Ticket);
      else
        {
         Res=::HistoryOrderSelect(Ticket) ? MT4HISTORY::IsMT4Order(Ticket) : false;

         if(Res)
            MT4ORDERS::GetHistoryOrderData(Ticket);
        }

      return(Res);
     }

   static bool SelectByExistingTicket(const int Ticket)
     {
      bool Res=true;

      if(::PositionSelectByTicket(Ticket))
         MT4ORDERS::GetPositionData();
      else if(::OrderSelect(Ticket))
         MT4ORDERS::GetOrderData();
      else
         Res=false;

      return(Res);
     }

   // One Ticket priority:
   // MODE_TRADES:  exist position > exist order > deal > canceled order
   // MODE_HISTORY: deal > canceled order > exist position > exist order
   static bool SelectByTicket(const int Ticket,const int Pool=MODE_TRADES)
     {
      return((Pool == MODE_TRADES) ?
             (MT4ORDERS::SelectByExistingTicket(Ticket) ? true : MT4ORDERS::SelectByHistoryTicket(Ticket)) :
             (MT4ORDERS::SelectByHistoryTicket(Ticket) ? true : MT4ORDERS::SelectByExistingTicket(Ticket)));
     }

public:
   static uint       OrderSend_MaxPause;

   static bool MT4OrderSelect(const int Index,const int Select,const int Pool=MODE_TRADES)
     {
      return((Select == SELECT_BY_POS) ?
             ((Pool==MODE_TRADES) ? MT4ORDERS::SelectByPos(Index) : MT4ORDERS::SelectByPosHistory(Index)) :
             MT4ORDERS::SelectByTicket(Index,Pool));
     }

   // MT5 OrderSelect
   static bool MT4OrderSelect(const ulong Ticket)
     {
      return(::OrderSelect(Ticket));
     }

   static int MT4OrdersTotal(void)
     {
      return(::OrdersTotal() + ::PositionsTotal());
     }

   // MT5 OrdersTotal
   static int MT4OrdersTotal(const bool MT5)
     {
      return(::OrdersTotal());
     }

   static int MT4OrdersHistoryTotal(void)
     {
      return(MT4ORDERS::History.GetAmount());
     }

   static int MT4OrderSend(const string Symb,const int Type,const double dVolume,const double Price,const int SlipPage,const double SL,const double TP,
                           const string comment=NULL,const int magic=0,const datetime dExpiration=0,color arrow_color=clrNONE)

     {
      MqlTradeRequest Request={};

      Request.action=(((Type == OP_BUY)||(Type == OP_SELL)) ? TRADE_ACTION_DEAL : TRADE_ACTION_PENDING);
      Request.magic = magic;

      Request.symbol = ((Symb == NULL) ? ::Symbol() : Symb);
      Request.volume = dVolume;
      Request.price=Price;

      Request.tp = TP;
      Request.sl = SL;
      Request.deviation=SlipPage;
      Request.type=(ENUM_ORDER_TYPE)Type;

      Request.type_filling=MT4ORDERS::GetFilling(Request.symbol,(uint)Request.deviation);

      if(dExpiration>0)
        {
         Request.type_time=ORDER_TIME_SPECIFIED;
         Request.expiration=dExpiration;
        }

      Request.comment=comment;

      MqlTradeResult Result;

      return(MT4ORDERS::OrderSend(Request, Result) ?
             ((Request.action==TRADE_ACTION_DEAL) ?(::HistoryDealSelect(Result.deal) ?(int)::HistoryDealGetInteger(Result.deal,DEAL_POSITION_ID) : -1) :(int)Result.order) : -1);
     }

   static bool MT4OrderModify(const int Ticket,const double Price,const double SL,const double TP,const datetime Expiration,const color Arrow_Color=clrNONE)
     {
      MqlTradeRequest Request={};

      // considered case if order and position has the same ticket
      bool Res=((Ticket!=MT4ORDERS::Order.Ticket) || (MT4ORDERS::Order.Ticket<=OP_SELL)) ?
               (MT4ORDERS::ModifyPosition(Ticket, Request) ? true : MT4ORDERS::ModifyOrder(Ticket, Price, Expiration, Request)) :
               (MT4ORDERS::ModifyOrder(Ticket, Price, Expiration, Request) ? true : MT4ORDERS::ModifyPosition(Ticket, Request));

      if(Res)
        {
         Request.tp = TP;
         Request.sl = SL;

         Res=MT4ORDERS::NewOrderSend(Request);
        }

      return(Res);
     }

   static bool MT4OrderClose(const int Ticket,const double dLots,const double Price,const int SlipPage,const color Arrow_Color=clrNONE)
     {
      bool Res=::PositionSelectByTicket(Ticket);

      if(Res)
        {
         MqlTradeRequest Request={};

         Request.action=TRADE_ACTION_DEAL;
         Request.position=Ticket;

         Request.symbol=::PositionGetString(POSITION_SYMBOL);

         Request.volume= dLots;
         Request.price = Price;

         Request.deviation=SlipPage;

         Request.type=(ENUM_ORDER_TYPE)(1-::PositionGetInteger(POSITION_TYPE));

         Request.type_filling=MT4ORDERS::GetFilling(Request.symbol,(uint)Request.deviation);

         Res=MT4ORDERS::NewOrderSend(Request);
        }

      return(Res);
     }

   static bool MT4OrderCloseBy(const int Ticket,const int Opposite,const color Arrow_color)
     {
      bool Res=::PositionSelectByTicket(Ticket);

      if(Res)
        {
         string symbol=::PositionGetString(POSITION_SYMBOL);
         ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)::PositionGetInteger(POSITION_TYPE);

         if(!PositionSelectByTicket(Opposite))
            return(false);

         string symbol_by=::PositionGetString(POSITION_SYMBOL);
         ENUM_POSITION_TYPE type_by=(ENUM_POSITION_TYPE)::PositionGetInteger(POSITION_TYPE);

         if(type==type_by)
            return(false);
         if(symbol!=symbol_by)
            return(false);

         MqlTradeRequest Request={};

         Request.action      = TRADE_ACTION_CLOSE_BY;
         Request.position    = Ticket;
         Request.position_by = Opposite;

         Res=MT4ORDERS::NewOrderSend(Request);
        }
      return (Res);
     }

   static bool MT4OrderDelete(const int Ticket,const color Arrow_Color=clrNONE)
     {
      bool Res=::OrderSelect(Ticket);

      if(Res)
        {
         MqlTradeRequest Request={};

         Request.action= TRADE_ACTION_REMOVE;
         Request.order = Ticket;

         Res=MT4ORDERS::NewOrderSend(Request);
        }

      return(Res);
     }

#define MT4_ORDERFUNCTION(NAME,T)  \
  static T MT4Order##NAME(void) \
  {                                \
    return(MT4ORDERS::Order.NAME); \
     }

   MT4_ORDERFUNCTION(Ticket,int)
   MT4_ORDERFUNCTION(Type,int)
   MT4_ORDERFUNCTION(Lots,double)
   MT4_ORDERFUNCTION(OpenPrice,double)
   MT4_ORDERFUNCTION(OpenTime,datetime)
   MT4_ORDERFUNCTION(StopLoss,double)
   MT4_ORDERFUNCTION(TakeProfit,double)
   MT4_ORDERFUNCTION(ClosePrice,double)
   MT4_ORDERFUNCTION(CloseTime,datetime)
   MT4_ORDERFUNCTION(Expiration,datetime)
   MT4_ORDERFUNCTION(MagicNumber,int)
   MT4_ORDERFUNCTION(Profit,double)
   MT4_ORDERFUNCTION(Commission,double)
   MT4_ORDERFUNCTION(Swap,double)
   MT4_ORDERFUNCTION(Symbol,string)
   MT4_ORDERFUNCTION(Comment,string)

#undef MT4_ORDERFUNCTION

   static void MT4OrderPrint(void)
     {
      Print(MT4ORDERS::Order.ToString());

      return;
     }
  };

static MT4_ORDER MT4ORDERS::Order={0};

static MT4HISTORY MT4ORDERS::History;

static const bool MT4ORDERS::IsTester=(::MQLInfoInteger(MQL_TESTER) || ::MQLInfoInteger(MQL_OPTIMIZATION) || 
                                       ::MQLInfoInteger(MQL_VISUAL_MODE) || ::MQLInfoInteger(MQL_FRAME_MODE));

static uint MT4ORDERS::OrderSend_MaxPause=1000000; // maximum time synchronization in seconds.
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderClose(const int Ticket,const double dLots,const double Price,const int SlipPage,const color Arrow_Color=clrNONE)
  {
   return(MT4ORDERS::MT4OrderClose(Ticket, dLots, Price, SlipPage, Arrow_Color));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderModify(const int Ticket,const double Price,const double SL,const double TP,const datetime Expiration,const color Arrow_Color=clrNONE)
  {
   return(MT4ORDERS::MT4OrderModify(Ticket, Price, SL, TP, Expiration, Arrow_Color));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderDelete(const int Ticket,const color Arrow_Color=clrNONE)
  {
   return(MT4ORDERS::MT4OrderDelete(Ticket, Arrow_Color));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderCloseBy(const int Ticket,const int Opposite,const color Arrow_color)
  {
   return (MT4ORDERS::MT4OrderCloseBy(Ticket, Opposite, Arrow_color));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderPrint(void)
  {
   MT4ORDERS::MT4OrderPrint();

   return;
  }

#define MT4_ORDERGLOBALFUNCTION(NAME,T)  \
  T Order##NAME(void) \
  {                                      \
    return(MT4ORDERS::MT4Order##NAME()); \
  }

MT4_ORDERGLOBALFUNCTION(sHistoryTotal,int)
MT4_ORDERGLOBALFUNCTION(Ticket,int)
MT4_ORDERGLOBALFUNCTION(Type,int)
MT4_ORDERGLOBALFUNCTION(Lots,double)
MT4_ORDERGLOBALFUNCTION(OpenPrice,double)
MT4_ORDERGLOBALFUNCTION(OpenTime,datetime)
MT4_ORDERGLOBALFUNCTION(StopLoss,double)
MT4_ORDERGLOBALFUNCTION(TakeProfit,double)
MT4_ORDERGLOBALFUNCTION(ClosePrice,double)
MT4_ORDERGLOBALFUNCTION(CloseTime,datetime)
MT4_ORDERGLOBALFUNCTION(Expiration,datetime)
MT4_ORDERGLOBALFUNCTION(MagicNumber,int)
MT4_ORDERGLOBALFUNCTION(Profit,double)
MT4_ORDERGLOBALFUNCTION(Commission,double)
MT4_ORDERGLOBALFUNCTION(Swap,double)
MT4_ORDERGLOBALFUNCTION(Symbol,string)
MT4_ORDERGLOBALFUNCTION(Comment,string)

#undef MT4_ORDERGLOBALFUNCTION

// reload mt4 functions
#define OrdersTotal MT4ORDERS::MT4OrdersTotal
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderSelect(const int Index,const int Select,const int Pool=MODE_TRADES)
  {
   return(MT4ORDERS::MT4OrderSelect(Index, Select, Pool));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderSend(const string Symb,const int Type,const double dVolume,const double Price,const int SlipPage,const double SL,const double TP,
              const string comment=NULL,const int magic=0,const datetime dExpiration=0,color arrow_color=clrNONE)
  {
   return(MT4ORDERS::MT4OrderSend(Symb, Type, dVolume, Price, SlipPage, SL, TP, comment, magic, dExpiration, arrow_color));
  }

#endif // __MT4ORDERS__
#endif // __MQL5__
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long AccountLeverage()
  {
   return AccountInfoInteger(ACCOUNT_LEVERAGE);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int FileOpenHistory(string filename,
                    int mode,
                    int delimiter=';') 
  {
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsDemo()
  {
   if(AccountInfoInteger(ACCOUNT_TRADE_MODE)==ACCOUNT_TRADE_MODE_DEMO)
      return(true);
   else
      return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsConnected() 
  {
   return (bool) TerminalInfoInteger(TERMINAL_CONNECTED);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string StringTrimRight4( string str)
{
   string var = str;
   StringTrimRight(var);
   return(var);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string StringTrimLeft4( string str)
{
   string var = str;
   StringTrimLeft(var);
   return(var);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string StringConcatenate4(string str1, string str2="", string str3="", string str4="", string str5="", string str6="", string str7="", string str8="", string str9="", string str10="")
{
   // ALTERNATIVE TO THIS: Consider using StringFormat("str...", var1, ...). Under certain conditions, it might be easier to modify the original MT4 StringConcatenate to use StringFormat. 
   string var = "";
   StringConcatenate(var, str1, str2, str3, str4, str5, str6, str7, str8, str9, str10);
   return(var);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
// MT4 docs have "bool ArraySort(...)", but the tooltip says "int ArraySort(...)".  Which type is it? Bool or int?
#define MODE_ASCEND 1
#define MODE_DESCEND 2
bool ArraySort(int& array[], int count, int start=0, int direction=MODE_ASCEND)
{
   bool ret = false;
   if(count == WHOLE_ARRAY && start == 0)
   {
      ret = ArraySort(array);
      if(ret && direction==MODE_DESCEND) ArrayReverse(array);
   }
   else
   {
      Alert("ERROR. The MT4_MT5 bridge equivalent of ArraySort does not yet support non-zero: count=",count," and/or start=",start);
   }
   return(ret); 
}
//+------------------------------------------------------------------+
bool ArraySort(long& array[], int count, int start=0, int direction=MODE_ASCEND)
{
   bool ret = false;
   if(count == WHOLE_ARRAY && start == 0)
   {
      ret = ArraySort(array);
      if(direction==MODE_DESCEND) ArrayReverse(array);
   }
   else
   {
      Alert("ERROR. The MT4_MT5 bridge equivalent of ArraySort does not yet support non-zero: count=",count," and/or start=",start);
   }
   return(ret); 
}
//+------------------------------------------------------------------+
bool ArraySort(double& array[], int count, int start=0, int direction=MODE_ASCEND)
{
   bool ret = false;
   if(count == WHOLE_ARRAY && start == 0)
   {
      ret = ArraySort(array);
      if(direction==MODE_DESCEND) ArrayReverse(array);
   }
   else
   {
      Alert("ERROR. The MT4_MT5 bridge equivalent of ArraySort does not yet support non-zero: count=",count," and/or start=",start);
   }
   return(ret); 
}
//+------------------------------------------------------------------+
bool ArraySort(datetime& array[], int count, int start=0, int direction=MODE_ASCEND)
{
   bool ret = false;
   if(count == WHOLE_ARRAY && start == 0)
   {
      ret = ArraySort(array);
      if(direction==MODE_DESCEND) ArrayReverse(array);
   }
   else
   {
      Alert("ERROR. The MT4_MT5 bridge equivalent of ArraySort does not yet support non-zero: count=",count," and/or start=",start);
   }
   return(ret); 
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long StrToInteger( string str)
{
   return( StringToInteger(str) );
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//MT4-to-MT5: MANY EQUIVALENTS ARE LISTED HERE: https://www.mql5.com/en/articles/81
//#include <Trade\TerminalInfo.mqh>
bool IsDllsAllowed()
{
   // At least for a script, if DLL's are referenced, one cannot even *run* the script without turning on DLL's, so this check may no longer be necessary at all!
   // HOWEVER, how about Indicator code which does have calls to DLL's, but when 'false' specifically avoids those calls?? (The code works, but is limited without the DLLs). Possibly it won't be allowed to even run.  Need to test it.
   return( (bool) TerminalInfoInteger(TERMINAL_DLLS_ALLOWED)); 
   // NOT GOOD ENOUGH!  This is the Terminal DLL setting, and does not check the specific "DLL's Allowed" checkbox when adding the Script/Indy.
   // Therefore, with the global DLL's NOT enabled, one runs the script, and manually enables the DLL's to run, yet this check still returns "false", which is wrong.
   
   //return( IsDLLsAllowed()); // There is a Class and #include that talks about this in MQL5.  Note the "DLL" is capitalized, vs. the MT4 "Dll".
}

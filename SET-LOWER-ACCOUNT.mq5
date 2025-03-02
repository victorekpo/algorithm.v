//+------------------------------------------------------------------+
//|                                                       Vic & Nana |
//|                            Copyright 2024-2025, Vic & Nancy, LLC |
//|                                 http://www.github.com/victorekpo |
//+------------------------------------------------------------------+
#property copyright   "2024-2025, Vic & Nancy"
#property link        "http://www.github.com/victorekpo"
#property description "Set Account BOT"

#define SETACCOUNTBOT  20240605

//---  Declare Libraries
#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>
#include <mq4_mq5_bridge.mqh>

CPositionInfo  m_position;                   // trade position object
CTrade         m_trade;                      // trading object
CPositionInfo position;

double desiredAccount = 700;

double curBuys[500];
bool BUYSINPROFIT;
bool SELLSINPROFIT;

//---  Declare functions


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(1);
//---
   return (INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| OnTick function                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
 // setLowerAccount();
  }
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {

  } // End OnTimer

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void setLowerAccount()
  {
// USE UNIUSD
   double lotSize = 100000;
   if(AccountInfoDouble(ACCOUNT_EQUITY) < 500)
     {
      lotSize = 500;
     }

   if(AccountInfoDouble(ACCOUNT_EQUITY) < 600)
     {
      lotSize = 300;
     }


   string comment = "SET_LOWER_ORDER";
   int magic = 000;
// need to calculate buy and sell orders and their profit
   if(AccountInfoDouble(ACCOUNT_EQUITY) > desiredAccount)
     {
      // Alert("too much money.. lowering account");

      if(calculateBuyOrdersProfit() > 0)
        {
         BUYSINPROFIT = true;
         SELLSINPROFIT = false;
        }

      if(calculateBuyOrdersProfit() < 0)
        {
         BUYSINPROFIT = false;
         SELLSINPROFIT = true;
        }


      if(!BUYSINPROFIT && !(calculateBuyOrdersProfit() > 0))
         OrderSend(_Symbol,OP_BUY,lotSize,Ask,3,0,0,comment,magic,0,Blue);
      if(!SELLSINPROFIT && !(calculateBuyOrdersProfit() < 0))

         OrderSend(_Symbol,OP_SELL,lotSize,Ask,3,0,0,comment,magic,0,Blue);

      closeAllOrders();
     }

   closeOrders();


  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void closeOrders()
  {

   if(AccountInfoDouble(ACCOUNT_PROFIT) < -150)
     {
      // close all orders
      closeAllOrders();
     }

  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void closeAllOrders()
  {
   for(int i=PositionsTotal()-1; i>=0; i--) // returns the number of current positions
      if(m_position.SelectByIndex(i))     // selects the position by index for further access to its properties
         if(m_position.Symbol()==Symbol())
            m_trade.PositionClose(m_position.Ticket()); // close a position by the specified symbol
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double calculateBuyOrdersProfit()
  {
   int buys=0;
   double SYMBOL_BUY_Profit=0;
   for(int i=PositionsTotal()-1; i>=0; i--) // returns the number of current positions
      if(m_position.SelectByIndex(i))     // selects the position by index for further access to its properties
         if(m_position.Symbol()==Symbol() && m_position.PositionType() == POSITION_TYPE_BUY)
           {
            curBuys[i] = m_position.Profit();
            SYMBOL_BUY_Profit = SYMBOL_BUY_Profit + m_position.Profit();
            //   Alert("SYMBOL_BUY_Profit ",SYMBOL_BUY_Profit);
            // Alert("pos profit ",m_position.Profit(), " ", SYMBOL_BUY_Profit);
            buys++;
           }
   return SYMBOL_BUY_Profit;

  }
//+------------------------------------------------------------------+

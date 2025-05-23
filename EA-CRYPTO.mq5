//+------------------------------------------------------------------+
//|                          Vic & Nana Expert Advisor                |
//|            Copyright 2024-2025, Vic & Nancy, LLC                  |
//|                    http://www.github.com/victorekpo               |
//+------------------------------------------------------------------+
#property copyright   "2024-2025, Vic & Nancy"
#property link        "http://www.github.com/victorekpo"
#property description "Million Dollar BOT for BOOM Index"

//--- Import Libraries
#include <EA-COMMON.mq5>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
//  Alert("hello");
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForInitialBuy1()
  {
   if(isUptrendFromSlope()
      && (
         (isThisBarBULLISH() && isThisBarBULLISH(60) && isThisBarBULLISH(999))
         || (getMA(M1, _20) < getLowestPrice(1,1) && getMA(M1, _50) < getLowestPrice(1,1) && getMA(M5, _50) < getLowestPrice(5,1) && getMA(M15, _50) < getLowestPrice(15,1) && isThisBarBULLISH(999))
      )
      && (getMA(M1, _200) < getLowestPrice(1,1) || (isThisBarBULLISH(999) && isThisBarBULLISH(240) && isThisBarBULLISH(60)))
      && getRSI(M1) < 65
      && getRSI(M5) < 65
      && getRSI(M15) < 65
      && getRSI(M30) < 65
      && getRSI(H1) < 65
      && getRSI(H4) < 65
      && getRSI(D1) < 60
      && isCurrentUptrend()
      && (getRSI(H1) < 15 || isThisBarBULLISH(999))
     )
     {
      placeBuyOrder(orderLots, "TESTBUY", 111);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForInitialSell1()
  {
   if(isDowntrendFromSlope()
      && (
         (isThisBarBEARISH() && isThisBarBEARISH(60) && isThisBarBEARISH(999))
         || (getMA(M1, _20) > getHighestPrice(1,1) && getMA(M1, _50) > getHighestPrice(1,1) && getMA(M5, _50) > getHighestPrice(5,1) && getMA(M15, _50) > getHighestPrice(15,1) && isThisBarBEARISH(999))
      )
      && (getMA(M1, _200) > getHighestPrice(1,1) || (isThisBarBEARISH(999) && isThisBarBEARISH(240) && isThisBarBEARISH(60)))
      && getRSI(M1) > 35
      && getRSI(M5) > 35
      && getRSI(M15) > 35
      && getRSI(M30) > 35
      && getRSI(M30) > 35
      && getRSI(H1) > 35
      && getRSI(H4) > 35
      && getRSI(D1) > 40
      && isCurrentDowntrend()
      && (getRSI(H1) > 85 || isThisBarBEARISH(999))
     )
     {
      placeSellOrder(orderLots, "TESTSELL", 222);
     }
  }


//+------------------------------------------------------------------+
//| OnTick function                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {




// Setting up the current time
   TimeCurrent(clock);

// Check Levels First
   CheckLevels();

   checkPendingOrdersTrend();

// close orders in profit
   double leastMinProfit = 1;
   double aggregateProfit = 3;
   closeInProfit(false,calculateTakeProfit());
   closeAggregateInProfit(true,calculateTakeProfit() * aggregateProfit,leastMinProfit);

   if(!checkAccountEquity(300))
     {
      closeAggregateInProfit(true,1,leastMinProfit);
     }

   CheckForEarlyClose();

// check bar sizes as well
// Comment("howclose:  L1 ", howClosetoLow, " H1 ", howClosetoHigh, " = ", howClose, "**", " L5 ", howClosetoLow_5, " H5 ", howClosetoHigh_5, " = ", howClose_5, "**", " L15 ", howClosetoLow_15, " H15 ", howClosetoHigh_15, " = ", howClose_15, "**", " L30 ", howClosetoLow_30, " H30 ", howClosetoHigh_30,  " = ", howClose_30, "**"," L240 ", howClosetoLow_240, " H240 ", howClosetoHigh_240,  " = ", howClose_240, "**"," L999 ", howClosetoLow_999, " H999 ",howClosetoHigh_999,  " = ", howClose_999, "**");
//Comment("recentprofit ", calculateSymbolProfitRecent(), " shouldBEAR: ", shouldAllowFromBEAR, " shouldRSI: ", shouldAllowSellFromRSI, " shouldRSI_5: ", shouldAllowSellFromRSI5, " shouldRSI_15: ", shouldAllowSellFromRSI15, " shouldRSI_30: ", shouldAllowSellFromRSI30, " shouldRSI_60: ", shouldAllowSellFromRSI60, " shouldRSI_240: ", shouldAllowSellFromRSI240, " bar size 15 ", getBarSize(15), " bar size 30 ", getBarSize(30), " bar size 60 ", getBarSize(60), " bar size 4hr ", getBarSize(240), " bar size 999 ", getBarSize(999), " how_close_999_h_l ", howClosetoHigh_999, " / ", howClosetoLow_999, " how_close_240 ", howClosetoHigh_240, " / ", howClosetoLow_240, " how_close_60 ", howClosetoHigh_60, " / ", howClosetoLow_60, " how_close ", howClosetoHigh, " / ", howClosetoLow, " MAXOrders ", MAXOrders, " percClose 999 ",percClose_999, " percClose 240 ",percClose_240, " percClose 60 ",percClose_60, " percClose_30 ", percClose_30,  " percClose_15 ", percClose_15, " percClose_5 ", percClose_5, " percClose ", percClose, " isTrend? ", isBoomTrendingDown);
//  Comment(rsiVelocity, " ", priceVelocity);
   Comment("howClose, M1: ",howClose[M1],
           " M5: ",howClose[M5],
           " M15: ",howClose[M15],
           " M30: ",howClose[M30],
           " H1: ",howClose[H1],
           " H4: ",howClose[H4],
           " D: ",howClose[D1],
           " W: ",howClose[W1],
           " MN: ",howClose[MN1],
           " shouldRSI: ", shouldAllowSellFromRSI[M1],
           " shouldRSI5: ", shouldAllowSellFromRSI[M5],
//   " occurenceBUY: ", checkOccurenceBuy(),
//   " occurenceSELL: ", checkOccurenceSell(),
//   " diff ", checkOccurenceBuy() - checkOccurenceSell(),
           " occur ", priceOccurence,
//   " aggProfit ", calculateTakeProfit() * aggregateProfit,
           " leastProfit ", leastMinProfit,
           " highestProfit ", highestProfit
          );

// take orders
   if(checkAccountEquity(500))
     {
      doubleUpOrders(true);
     }

   CheckForInitialBuy1();
   CheckForInitialSell1();
   if(checkAccountEquity(equityThreshold * 3))
     {

      if(!isRangingSell() || !isRangingSell(M5))
        {
         CheckForOpenSellMAConditions();
         CheckForOpenSellRSIConditions();
         CheckForOpenSellMARSIConditions();
         CheckForOpenSellConditions();
         CheckForOpenSellDaily_Bear();
         CheckForOpenSellMA_Driven();
         CheckForOpenSellMA_Driven2();
         CheckForOpenSellRSI_Driven();
         CheckForOpenSellRSI_MA_Driven();
         CheckForOpenSellRSI_MA_Driven2();
         CheckForOpenSellRSIMAStoch();
         CheckForOpenSell_ExtremeRSI();
         CheckForOpenSell_ExtremeRSI2();
         CheckForOpenSell_ExtremeRSI3();
         CheckForOpenSell_ExtremeMA();
         CheckForOpenSell_ExtremeMA2();
         CheckForOpenSell_ExtremeMA3();
         CheckForOpenSell_ExtremeMA4();
         CheckForOpenSell_ExtremeMA5();
         CheckForOpenSell();
         CheckForOpenSell2();
         CheckForOpenSell3();
         CheckForOpenSell4();
         CheckForOpenSell5();
        }

      if(!isRangingBuy() || !isRangingBuy(M5))
        {
         CheckForOpenBuy();
         CheckForOpenBuy2();
         CheckForOpenBuy3();
         CheckForOpenBuy4();
         CheckForOpenBuy5();

         CheckForOpenBuyRSIMAStoch();
         CheckForOpenBuyMAConditions();
         CheckForOpenBuyRSIConditions();
         CheckForOpenBuyMARSIConditions();
         CheckForOpenBuyConditions();
         CheckForOpenBuyDaily_Bear();
         CheckForOpenBuyMA_Driven();
         CheckForOpenBuyMA_Driven2();
         CheckForOpenBuyRSI_Driven();
         CheckForOpenBuyRSI_MA_Driven();
         CheckForOpenBuyRSI_MA_Driven2();
         CheckForOpenBuy_ExtremeRSI();
         CheckForOpenBuy_ExtremeRSI2();
         CheckForOpenBuy_ExtremeRSI3();
         CheckForOpenBuy_ExtremeMA();
         CheckForOpenBuy_ExtremeMA2();
         CheckForOpenBuy_ExtremeMA3();
         CheckForOpenBuy_ExtremeMA4();
         CheckForOpenBuy_ExtremeMA5();
        }
     }

   if(checkAccountEquity(1000))
     {
      HandleReversals();
      HandleStopLoss();
     }

// Pending Orders

// BUY ORDERS
   if(
// Buy Conditions
      getRSI(D1) < 60
      && getRSI(H4) < 60
      && getRSI(H1) < 60
//   && getRSI(M30) < 50
//   && getRSI(M15) < 40
//   && getRSI(M5) < 40
//   && getRSI(M1) < 40
      && getMA(M1, _20) < getLowestPrice(1,1)
      && getMA(M1, _50) < getLowestPrice(1,1)
      && getMA(M1, _200) < getLowestPrice(1,1)
      && getMA(M5, _50) < getLowestPrice(5,1)
      && getMA(M5, _200) < getLowestPrice(5,1)
      && getMA(M15, _9) < getLowestPrice(15, 1)
// && (!(getRSI(M1) > 40 && getRSI(M5) > 50))
      && (getMA(M1, _200) < getLowestPrice(1,1) || getMA(M1, _500) < getLowestPrice(1,1) || getMA(M1, _50) < getMA(M1, _9))
      && criticalConditionsForBuyOrder()
      && (!isRangingBuy() || !isRangingBuy(M5))
   )
     {
      if(
         calculateOrders(POSITION_TYPE_BUY) == 0
         && calculatePendingOrders(ORDER_TYPE_BUY_LIMIT) == 0
         //   && clock.hour & 2 == 0
         && clock.min % 5 == 0
         && clock.sec == 30
      )
        {
         Alert("no orders, taking delayed buy limit order" + clock.hour + " " + clock.min + " " + clock.sec);
         placeBuyLimitOrder(calculateLots(), "BUYLIMIT",001,50);
        }

      if(
         calculateOrders(POSITION_TYPE_BUY) == 0
         && calculatePendingOrders(ORDER_TYPE_BUY_STOP) == 0
         //   && clock.hour & 3 == 0
         && clock.min % 5 == 0
         && clock.sec == 30
         && getMA(M15, _50) < getLowestPrice(15,1)
      )
        {
         Alert("no orders, taking delayed buy stop order" + clock.hour + " " + clock.min + " " + clock.sec);
         placeBuyStopOrder(calculateLots(), "BUYSTOP",002,50);
        }

     }


// SELL ORDERS
   if(
// Sell Conditions
      getRSI(D1) > 40
      && getRSI(H4) > 40
      && getRSI(H1) > 40
//    && getRSI(M30) > 50
//   && getRSI(M15) > 60
//   && getRSI(M5) > 60
      && getMA(M1, _20) > getHighestPrice(1,1)
      && getMA(M1, _50) > getHighestPrice(1,1)
      && getMA(M1, _200) > getHighestPrice(1,1)
      && getMA(M5, _50) > getHighestPrice(5,1)
      && getMA(M5, _200) > getHighestPrice(5,1)
      && getMA(M15, _9) > getHighestPrice(15, 1)
// && (!(getRSI(M1) < 60 && getRSI(M5) < 50))
      && (getMA(M1, _200) > getHighestPrice(1,1) || getMA(M1, _500) > getHighestPrice(1,1) || getMA(M1, _50) > getMA(M1, _9))
      && criticalConditionsForSellOrder()
      && (!isRangingSell() || !isRangingSell(M5))
   )
     {
      if(
         calculateOrders(POSITION_TYPE_SELL) == 0
         && calculatePendingOrders(ORDER_TYPE_SELL_LIMIT) == 0
         //   && clock.hour & 2 == 0
         && clock.min % 5 == 0
         && clock.sec == 0
      )
        {
         Alert("no orders, taking delayed sell limit order" + clock.hour + " " + clock.min + " " + clock.sec);
         placeSellLimitOrder(calculateLots(), "SELLLIMIT",003,50);
        }

      if(
         calculateOrders(POSITION_TYPE_SELL) == 0
         && calculatePendingOrders(ORDER_TYPE_SELL_STOP) == 0
         //   && clock.hour & 3 == 0
         && clock.min % 5 == 0
         && clock.sec == 30
         && getMA(M15, _50) > getHighestPrice(15,1)
      )
        {
         Alert("no orders, taking delayed sell stop order" + clock.hour + " " + clock.min + " " + clock.sec);
         placeSellStopOrder(calculateLots(), "SELLSTOP",004,50);
        }
     }

   if(isRangingBuy()
      && calculatePendingOrders(OP_SELLSTOP) == 0
      && (getMA(M1, _500) < getLowestPrice(1,1) || getMA(M1, _200) < getMA(M1, _20))
     )
     {
      if(getRSI(M1) < 55 || getRSI(M5) < 55)
        {
         placeBuyStopOrder(calculateLots(), "BUYRANGE",002,100);
        }

      if(getRSI(M1) > 70 || getRSI(M5) > 70)
        {
         placeSellStopOrder(calculateLots(), "SELLRANGE",004,100);
        }
     }

   if(isRangingSell()
      && calculatePendingOrders(OP_BUYSTOP) == 0
      && (getMA(M1, _500) > getHighestPrice(1,1) || getMA(M1, _200) > getMA(M1, _20))
     )
     {
      if(getRSI(M1) < 30 || getRSI(M5) < 30)
        {
         placeBuyStopOrder(calculateLots(), "BUYRANGE",002,100);
        }

      if(getRSI(M1) > 45 || getRSI(M5) > 45)
        {
         placeSellStopOrder(calculateLots(), "SELLRANGE",004,100);
        }
     }

//Alert("MA 1,9: ",getMA(M1,_9));
// Alert("RSI: ", getRSI(M1));
   if(clock.sec == 0 && clock.min == 0)
     {
      deleteAllPendingBuyLimit();
      deleteAllPendingBuyStop();
      deleteAllPendingSellLimit();
      deleteAllPendingSellStop();
     }

   if(clock.sec == 0 && clock.min == 0 && clock.hour % 2 == 0)
     {
      Alert("every two hours, resetting highestProfit to 0");
      highestProfit = 0;
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSellMAConditions()
  {
   if(
      baseConditionsForSellOrder()
      && MAConditionsForSellOrder()
      && shouldAllowSellFromRSI[M1]
      && getRSI(M1) > 60
      && (getRSI(M5) > 50 || getRSI(M1) > 60)
      && (getMA(M1, _9) < getMA(M1, _20) // market ranging
          || getMA(M1, _20) < getMA(M1, _50)
          || getMA(M1, _500) > getHighestPrice(1,1))
   )
     {
      placeSellOrder(orderLots, "SellMA", 100, 0, true);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSellRSIConditions()
  {
   if(
      baseConditionsForSellOrder()
      && RSIConditionsForSellOrder()
      && (getRSI(M5) > 50 || getRSI(M1) > 60)
      && getMA(M15, _20) > getHighestPrice(15,1)
      && isThisBarBEARISH(60)
   )
     {
      // Symbol Overrides
      if(_Symbol == "ETHUSD")
        {
         if(getMA(M1, _200) < getHighestPrice(1,1))
           {
            return;
           }
        }
      if(_Symbol == "XRPUSD")
        {
         if(
            getMA(M1, _9) > getMA(M1, _20) // market ranging
            || getMA(M1, _500) < getHighestPrice(1,1)
         )
           {
            return;
           }
        }

      if(_Symbol == "NEOUSD")
        {
         if(getMA(M1, _200) < getHighestPrice(1,1))
           {
            return;
           }
        }

      if(_Symbol == "MKRUSD")
        {
         if(
            getMA(M1, _50) < getHighestPrice(1,1)
            || getMA(M1, _200) < getHighestPrice(1,1)
         )
           {
            return;
           }
        }

      if(_Symbol == "TRXUSD")
        {
         if(
            getMA(M1, _50) < getHighestPrice(1,1)
            || getMA(M1, _200) < getHighestPrice(1,1)
         )
           {
            return;
           }
        }

      if(_Symbol == "OMGUSD")
        {
         if(
            getMA(M1, _50) < getHighestPrice(1,1)
            || getMA(M1, _200) < getHighestPrice(1,1)
         )
           {
            return;
           }
        }

      if(_Symbol == "SOLUSD")
        {
         if(
            getMA(M1, _50) < getHighestPrice(1,1)
            || getMA(M1, _200) < getHighestPrice(1,1)
         )
           {
            return;
           }
        }

      // Take Order
      placeSellStopOrder(orderLots, "SellRSI", 200, 100);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSellMARSIConditions()
  {
   if(
      baseConditionsForSellOrder()
      && MAConditionsForSellOrder()
      && RSIConditionsForSellOrder()
      && getRSI(M1) > 50
      && (getMA(M1, _9) < getMA(M1, _20) // market ranging
          || getMA(M1, _20) < getMA(M1, _50)
          || getMA(M1, _500) > getHighestPrice(1,1))
   )
     {
      placeSellStopOrder(orderLots, "SellMARSI", 300, 100);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSellConditions()
  {
   if(
      baseConditionsForSellOrder()
      && (isThisBarBEARISH(999) || isThisBarBEARISH(240))
      && MAConditionsForSellOrder()
      && RSIConditionsForSellOrder()
      && getRSI(M1) > 50
      && (getMA(M1, _9) < getMA(M1, _20) // market ranging
          || getMA(M1, _20) < getMA(M1, _50)
          || getMA(M1, _500) > getHighestPrice(1,1))
   )
     {
      placeSellStopOrder(orderLots, "Sell", MILLIONDOLLARBOT, 100);

     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSellDaily_Bear()
  {
   if(
      baseConditionsForSellOrder()
      && isThisBarBEARISH(240) && getBarSize(240) > 100
      && isThisBarBEARISH(999) && getBarSize(999) > 500
      && MAConditionsForSellOrder()
      && RSIConditionsForSellOrder()
      && getRSI(M1) > 50
   )
     {
      placeSellStopOrder(orderLots, "SellDB", MILLIONDOLLARBOT, 100);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSellMA_Driven()
  {
   if(
      (getMA(M1, _50) - currentPrice > 2 || getMA(M1, _200) > currentPrice || (isThisBarBEARISH(240) && isThisBarBEARISH(60) && isThisBarBEARISH(30) && isThisBarBEARISH(15) && getMA(M5, _20) > currentPrice && getMA(M1, _20) > currentPrice && getMA(M1, _9) > currentPrice))
      && isThisBarBEARISH(5)
      && isThisBarBEARISH(15)
      && getBarSize(15) > 3
      && getRSI(M1) > 50
      && getMA(M1, _200) > getHighestPrice(1,1) // cascade MAs
      && getMA(M1, _200) > getMA(M1, _50)
      && getMA(M1, _50) > getMA(M1, _20)
      && getMA(M1, _20) > getMA(M1, _9)
      && getMA(M1, _9) > getHighestPrice(1,1)
      && (shouldAllowFromBEAR || getMA(M1, _50) > currentPrice || getMA(M1, _200) > currentPrice || (isThisBarBEARISH(240) && isThisBarBEARISH(60) && isThisBarBEARISH(30) && isThisBarBEARISH(15) && getMA(M5, _20) > currentPrice && getMA(M1, _20) > currentPrice && getMA(M1, _9) > currentPrice))
      && howClose[M1] < 0.5
      && howClose[M5] < 2
   )
     {
      placeSellOrder(orderLots, "SellMD", MILLIONDOLLARBOT, 0, true);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSellMA_Driven2()
  {
   if(
      getMA(M1, _50) > currentPrice
      && (getMA(M1, _9) > getHighestPrice(1,1) || checkAccountEquity(equityThreshold))
      && getMA(M1, _200) > currentPrice
      && getMA(M5, _20) > currentPrice
      && getMA(M5, _9) > currentPrice
      && getMA(M5, _200) > currentPrice
      && getMA(M15, _50) > currentPrice
      && getMA(M15, _20) > currentPrice
      && getMA(M15, _50) > currentPrice
      && getMA(M15, _200) > currentPrice
      && getMA(M30, _9) > currentPrice
      && getMA(M30, _20) > currentPrice
      && getMA(M30, _50) > currentPrice
      && getMA(M1, _20) < getMA(M1, _50)
      && (getRSI(M1) > 50 || getRSI(M5) > 50)
      && howClose[M5] < 2
      && isThisBarBEARISH()
      && isThisBarBEARISH(5)
      && (getMA(M5, _200) > currentPrice || getMA(M15, _50) > getMA(M15, _20) || getMA(M1, _50) > getMA(M1, _20))
      && getMA(M1, _20) - getMA(M1, _9) > 1
      && getMA(M15, _20) - getMA(M15, _50) > 3
   )
     {
      placeSellOrder(orderLots, "SellMD2", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSellRSI_Driven()
  {
   if(
      baseConditionsForSellOrder()
      && isThisBarBEARISH()
      && getRSI(M1) > 50
      && (getRSI(M1) > 45 || checkAccountEquity(equityThreshold))
      && (getRSI(M1) > 55 || getMA(M1, _200) > getHighestPrice(1,1) || (getMA(M1, _50) > getMA(M1, _9) && getMA(M1, _50) > getMA(M1, _20)))
      && getRSI(M5) > 35
      && (getRSI(M5) > 45 || checkAccountEquity(equityThreshold))
      && getRSI(M15) > 35
      && (getRSI(M15) > 45 || checkAccountEquity(equityThreshold))
      && getRSI(M30) > 35
      && (getRSI(M30) > 45 || checkAccountEquity(equityThreshold))
      && getRSI(H1) > 35
      && (getRSI(H1) > 45 || checkAccountEquity(equityThreshold))
      && getRSI(H4) > 35
      && (isThisBarBEARISH(60) || isThisBarBEARISH(30))
      && (isThisBarBEARISH(999) || isThisBarBEARISH(30))
      && (isThisBarBEARISH(9997) || isThisBarBEARISH(30))
      && getMA(M1, _9) > getHighestPrice(1,1)
      && getMA(M1, _20) > getHighestPrice(1,1)
      && getMA(M1, _50) > getHighestPrice(1,1)
      && getMA(M1, _200) > getHighestPrice(1,1)
      && getMA(M5, _9) > getHighestPrice(5,1)
      && getMA(M5, _9) > getHighestPrice(5,1)
      && MAConditionsForSellOrder()
      && (getRSI(M5) > 50 || getRSI(M1) > 60)
   )
     {
      placeSellOrder(orderLots, "SellRD", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSellRSI_MA_Driven()
  {
   if(
      isThisBarBEARISH(5)
      && isThisBarBEARISH(15)
      && howClose[D1] < -7
      && (getRSI(M1) > 30 || getRSI(M15) > 60)
      && (getRSI(M1) > 33 || getRSI(M5) > 35)
      && (getRSI(M1) > 45 || checkAccountEquity(equityThreshold))
      && (getRSI(M5) > 45 || checkAccountEquity(equityThreshold))
      && (getRSI(M15) > 45 || checkAccountEquity(equityThreshold))
      && (isThisBarBEARISH(60) || isThisBarBEARISH(30))
      && (isThisBarBEARISH(999) || isThisBarBEARISH(60))
      && (isThisBarBEARISH(9997) || isThisBarBEARISH(30))
      && getMA(M5, _9) > getHighestPrice(5,1)
      && getMA(M5, _9) > getHighestPrice(5,1)
      && (getMA(M1, _9) > getHighestPrice(1,1) || checkAccountEquity(equityThreshold))
      && getMA(M1, _20) > getHighestPrice(1,1)
      && MAConditionsForSellOrder()
      && getRSI(M1) > 50
      && (getRSI(M5) > 50 || getRSI(M1) > 60)
   )
     {
      placeSellOrder(orderLots, "SellRMD", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSellRSI_MA_Driven2()
  {
   if(
      baseConditionsForSellOrder()
      && isThisBarBEARISH()
      && isThisBarBEARISH(15)
      && (getRSI(M1) > 30 || getRSI(M15) > 50)
      && (getRSI(M1) > 33 || getRSI(M5) > 35)
      && (getRSI(M1) > 45 || checkAccountEquity(equityThreshold))
      && getRSI(M5) > 35
      && (getRSI(M5) > 45 || checkAccountEquity(equityThreshold))
      && (getRSI(M15) > 40 || checkAccountEquity(equityThreshold))
      && (getRSI(M30) > 40 || checkAccountEquity(equityThreshold))
      && (getRSI(H1) > 40 || checkAccountEquity(equityThreshold))
      && getRSI(W1) > 40
      && (isThisBarBEARISH(60) || isThisBarBEARISH(30))
      && (isThisBarBEARISH(999) || isThisBarBEARISH(60))
      && (isThisBarBEARISH(9997) || isThisBarBEARISH(30))
      && (getMA(M5, _9) > getHighestPrice(5,1) || getMA(M5, _200) > getHighestPrice(5,1) || getMA(M15, _50) > getHighestPrice(15,1) || getMA(M1, _50) > getHighestPrice(1,1))
      && getMA(M1, _9) > getHighestPrice(1,1)
      && getMA(M5, _20) > getHighestPrice(5,1)
      && getMA(M15, _50) > getHighestPrice(15,1)
      && getMA(M15, _20) > getHighestPrice(15,1)
      && MAConditionsForSellOrder()
      && getRSI(M1) > 50
      && (getRSI(M5) > 50 || getRSI(M1) > 60)
      && getMA(M1, _50) > getHighestPrice(1,1)
   )
     {
      placeSellOrder(orderLots, "SellRMD2", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSellRSIMAStoch()
  {
   if(
      isThisBarBEARISH(5)
      && isThisBarBEARISH(60)
      && getBarSize(60) > 30
      && isThisBarBEARISH(240)
      && getBarSize(240) > 50
      && isThisBarBEARISH(999)
      && getBarSize(999) > 200
      && shouldAllowSellFromRSI[M1]
      && getMA(H4, _20) > getHighestPrice(240,1)
      && getMA(H4, _50) > getHighestPrice(240,1)
      && getMA(H1, _200) > getHighestPrice(60,1)
      && getMA(M30, _200) > getHighestPrice(30,1)
      && getMA(M15, _50) > getHighestPrice(15,1)
      && (getMA(M15, _20) > getHighestPrice(15,1) || getMA(M15, _9) > getHighestPrice(15,1))
      && (getMA(M1, _50) > getHighestPrice(1,1) || getMA(M1, _200) > getHighestPrice(1,1))
      && getStochasticMain(15) > 20
      && getStochasticMain(30) > 20
      && getRSI(M1) > 65
      && getRSI(M5) > 65
   )
     {
      placeSellOrder(orderLots, "SellRMS", MILLIONDOLLARBOT, 0, true);
     }
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy()
  {
   if(
      isThisBarBULLISH(240)
      && (howClose[H4] > 7 || isThisBarBULLISH(9997))
      && ((getRSI(M1) < 20 || getRSI(M5) < 30 || getRSI(M15) < 30 || getRSI(M30) < 30 || getRSI(H1) < 30 || getRSI(H4) < 30 || getRSI(W1) < 30)
          || (isThisBarBULLISH(15) && isThisBarBULLISH(30) && isThisBarBULLISH(60))
         )
      && (getRSI(M1) < 60 && getRSI(M5) < 60 && getRSI(M15) < 60 && getRSI(M30) < 60 && getRSI(H1) < 60 && getRSI(H4) < 60 && getRSI(W1) < 60)
      && getMA(M5, _9) < getLowestPrice(5, 1)
      && getMA(M5, _20) < getLowestPrice(5, 1)
      && (getMA(M5, _9) < getLowestPrice(5, 1) || getMA(M5, _200) < getLowestPrice(5, 1))
      && (getMA(M1, _9) < getLowestPrice(1, 1) && getMA(M1, _20) < getLowestPrice(1, 1))
      && (getMA(M1, _50) < getLowestPrice(1, 1) || getMA(M1, _200) < getLowestPrice(1, 1))
      && getRSI(M1) < 35
      && isThisBarBULLISH(60)
   )
     {
      placeBuyOrder(orderLots, "Buy1", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy2()
  {
   if(
      ((isThisBarBULLISH(240) && getBarSize(240) > 20) || (isThisBarBULLISH(9997) && getBarSize(9997) > 20))
      && (getRSI(M1) < 20 || getRSI(M5) < 20 || getRSI(M15) < 20 || getRSI(M30) < 20 || getRSI(H1) < 20 || getRSI(H4) < 20 || getRSI(W1) < 20)
      && (getMA(H1, _20) < getLowestPrice(60, 1) || checkAccountEquity(equityThreshold))
      && (getMA(H1, _50) < getLowestPrice(60, 1) || checkAccountEquity(equityThreshold))
      && (getMA(M5, _9) < getLowestPrice(5, 1) || getMA(M1, _50) < getLowestPrice(1, 1))
      && (getMA(M5, _20) < getLowestPrice(5, 1) || getMA(M1, _50) < getLowestPrice(1, 1))
      && getRSI(M1) < 45
      && isThisBarBULLISH(5)
      && isThisBarBULLISH(60)
   )
     {
      placeBuyOrder(orderLots, "Buy2", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy3()
  {
   if(
      ((isThisBarBULLISH(240) && getBarSize(240) > 20) || (isThisBarBULLISH(9997) && getBarSize(9997) > 20))
      && (getRSI(M1) < 5 || getRSI(M5) < 10 || getRSI(M15) < 10 || getRSI(M30) < 10 || getRSI(H1) < 10 || getRSI(H4) < 10 || getRSI(W1) < 10)
      && (getMA(M5, _9) < getLowestPrice(5, 1) || getMA(M1, _50) < getLowestPrice(1, 1))
      && (getMA(M5, _20) < getLowestPrice(5, 1) || getMA(M1, _50) < getLowestPrice(1, 1))
      && isThisBarBULLISH(60)
      && getMA(M5, _50) < getLowestPrice(5, 1)
      && getRSI(M1) < 43
      && getRSI(M5) < 50
   )
     {
      placeBuyOrder(orderLots, "Buy3", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy4()
  {
   if(
      ((isThisBarBULLISH(240) && getBarSize(240) > 20) || (isThisBarBULLISH(9997) && getBarSize(9997) > 20))
      && getMA(H4, _20) < getLowestPrice(240, 1)
      && getMA(M1, _50) < getLowestPrice(1, 1)
      && getRSI(M1) <= 30
      && (getRSI(M5) <= 40 || getRSI(M15) <= 40)
      && isThisBarBULLISH()
      && isThisBarBULLISH(5)
      && isThisBarBULLISH(60)
   )
     {
      placeBuyOrder(orderLots, "Buy4", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy5()
  {
   if(
      (getRSI(M1) < 20)
      && (getRSI(M5) < 30 || getRSI(M15) < 30)
      && (getMA(M1, _20) < getLowestPrice(1,1) || getMA(M5, _20) < getLowestPrice(5,1) || getMA(M15, _20) < getLowestPrice(15,1) || getMA(M30, _20) < getLowestPrice(30,1) || getMA(H1, _20) < getLowestPrice(60,1) || getMA(H4, _20) < getLowestPrice(240,1))
      && (getRSI(H1) < 30 || checkAccountEquity(equityThreshold))
      && getRSI(H1) < 35
      && (getRSI(MN1) < 50 || checkAccountEquity(equityThreshold))
      && (getMA(M1, _500) < getLowestPrice(1,1) || checkAccountEquity(equityThreshold))
      && getStochasticSignal(M5) < getStochasticMain(M5)
      && ((getMA(M1, _9) < getLowestPrice(1, 1) && getMA(M1, _20) < getLowestPrice(1, 1))
          || (isThisBarBULLISH(5) && isThisBarBULLISH(15) && isThisBarBULLISH(30) && isThisBarBULLISH(60) && checkAccountEquity(5000)))
   )
     {
      placeBuyOrder(orderLots, "Buy5", MILLIONDOLLARBOT, 0, true);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuyMAConditions()
  {
   if(
      baseConditionsForBuyOrder()
      && MAConditionsForBuyOrder()
      && shouldAllowBuyFromRSI[M1]
      && isThisBarBULLISH()
      && getRSI(M1) < 40
      && (getRSI(M5) < 50 || getRSI(M1) < 40)
      && (getMA(M1, _9) > getMA(M1, _20) // market ranging
          || getMA(M1, _20) > getMA(M1, _50)
          || getMA(M1, _500) < getLowestPrice(1,1))
   )
     {
      placeBuyOrder(orderLots, "BuyMA", 100, 0, true);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuyRSIConditions()
  {
   if(
      baseConditionsForBuyOrder()
      && RSIConditionsForBuyOrder()
      && isThisBarBULLISH()
      && (getRSI(M5) < 50 || getRSI(M1) < 40)
      && isThisBarBULLISH(60)
      && getMA(M15, _20) < getLowestPrice(15,1)
   )
     {
      // Symbol overrides
      if(_Symbol == "ETHUSD")
        {
         if(getMA(M1, _200) > getLowestPrice(1,1))
           {
            return;
           }
        }
      if(_Symbol == "XRPUSD")
        {
         if(
            getMA(M1, _9) < getMA(M1, _20) // market ranging
            || getMA(M1, _500) > getLowestPrice(1,1)
         )
           {
            return;
           }
        }

      if(_Symbol == "NEOUSD")
        {
         if(getMA(M1, _200) > getLowestPrice(1,1))
           {
            return;
           }
        }

      placeBuyStopOrder(orderLots, "BuyRSI", 200, 100);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuyMARSIConditions()
  {
   if(
      baseConditionsForBuyOrder()
      && MAConditionsForBuyOrder()
      && RSIConditionsForBuyOrder()
      && isThisBarBULLISH()
      && getRSI(M1) < 55
      && (getMA(M1, _9) > getMA(M1, _20) // market ranging
          || getMA(M1, _20) > getMA(M1, _50)
          || getMA(M1, _500) < getLowestPrice(1,1))
   )
     {
      placeBuyStopOrder(orderLots, "BuyMARSI", 300, 100);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuyConditions()
  {
   if(
      baseConditionsForBuyOrder()
      && isThisBarBULLISH()
      && (isThisBarBULLISH(999) || isThisBarBULLISH(240))
      && MAConditionsForBuyOrder()
      && RSIConditionsForBuyOrder()
      && getRSI(M1) < 55
      && (getMA(M1, _9) > getMA(M1, _20) // market ranging
          || getMA(M1, _20) > getMA(M1, _50)
          || getMA(M1, _500) < getLowestPrice(1,1))

   )
     {
      placeBuyStopOrder(orderLots, "Buy", MILLIONDOLLARBOT, 100);
     }
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuyDaily_Bear()
  {
   if(
      baseConditionsForBuyOrder()
      && isThisBarBULLISH()
      && isThisBarBULLISH(240) && getBarSize(240) > 100
      && isThisBarBULLISH(999) && getBarSize(999) > 500
      && MAConditionsForBuyOrder()
      && RSIConditionsForBuyOrder()
      && getRSI(M1) < 55
   )
     {
      placeBuyStopOrder(orderLots, "BuyDB", MILLIONDOLLARBOT, 100);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuyMA_Driven()
  {
   if(
      (currentPrice - getMA(M1, _50) > 2 || currentPrice > getMA(M1, _200) || (isThisBarBULLISH(240) && isThisBarBULLISH(60) && isThisBarBULLISH(30) && isThisBarBULLISH(15) && currentPrice > getMA(M5, _20) && currentPrice > getMA(M1, _20) && currentPrice > getMA(M1, _9)))
      && isThisBarBULLISH()
      && isThisBarBULLISH(5)
      && isThisBarBULLISH(15)
      && getBarSize(15) > 3
      && getRSI(M1) < 50
      && getMA(M1, _200) < getLowestPrice(1,1) // cascade MAs
      && getMA(M1, _200) < getMA(M1, _50)
      && getMA(M1, _50) < getMA(M1, _20)
      && getMA(M1, _20) < getMA(M1, _9)
      && getMA(M1, _9) < getLowestPrice(1,1)
      && (shouldAllowFromBULL || currentPrice < getMA(M1, _50) || currentPrice < getMA(M1, _200) || (isThisBarBULLISH(240) && isThisBarBULLISH(60) && isThisBarBULLISH(30) && isThisBarBULLISH(15) && currentPrice > getMA(M5, _20) && currentPrice > getMA(M1, _20) && currentPrice > getMA(M1, _9)))
      && howClose[M1] < 0.5
      && howClose[M5] < 2
   )
     {
      placeBuyOrder(orderLots, "BuyMD", MILLIONDOLLARBOT, 0, true);
     }
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuyMA_Driven2()
  {
   if(
      currentPrice > getMA(M1, _50)
      && (currentPrice < getMA(M1, _9) || checkAccountEquity(1000))
      && currentPrice > getMA(M1, _200)
      && currentPrice > getMA(M5, _20)
      && currentPrice > getMA(M5, _9)
      && currentPrice > getMA(M5, _200)
      && currentPrice > getMA(M15, _50)
      && currentPrice > getMA(M15, _20)
      && currentPrice > getMA(M15, _50)
      && currentPrice > getMA(M15, _200)
      && currentPrice > getMA(M30, _9)
      && currentPrice > getMA(M30, _20)
      && currentPrice > getMA(M30, _50)
      && getMA(M1, _20) > getMA(M1, _50)
      && (getRSI(M1) < 50 || getRSI(M5) < 50)
      && howClose[M5] < 2
      && isThisBarBULLISH()
      && isThisBarBULLISH(5)
      && (currentPrice > getMA(M5, _200) || getMA(M15, _50) < getMA(M15, _20) || getMA(M1, _50) < getMA(M1, _20))
      && getMA(M1, _20) - getMA(M1, _9) < -1
      && getMA(M15, _20) - getMA(M15, _50) < -3
   )
     {
      placeBuyOrder(orderLots, "BuyMD2", MILLIONDOLLARBOT, 0, true);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuyRSI_Driven()
  {
   if(
      baseConditionsForBuyOrder()
      && isThisBarBULLISH()
      && getRSI(M1) < 50
      && (getRSI(M1) < 55 || checkAccountEquity(equityThreshold))
      && (getRSI(M1) < 50 || getMA(M1, _200) < getLowestPrice(1,1) || (getMA(M1, _50) < getMA(M1, _9) && getMA(M1, _50) < getMA(M1, _20)))
      && getRSI(M5) < 65
      && (getRSI(M5) < 55 || checkAccountEquity(equityThreshold))
      && getRSI(M15) < 65
      && (getRSI(M15) < 55 || checkAccountEquity(equityThreshold))
      && getRSI(M30) < 65
      && (getRSI(M30) < 55 || checkAccountEquity(equityThreshold))
      && getRSI(H1) < 65
      && (getRSI(H1) < 55 || checkAccountEquity(equityThreshold))
      && getRSI(H4) < 65
      && (isThisBarBULLISH(60) || isThisBarBULLISH(30))
      && (isThisBarBULLISH(999) || isThisBarBULLISH(30))
      && (isThisBarBULLISH(9997) || isThisBarBULLISH(30))
      && getMA(M1, _9) < getLowestPrice(1,1)
      && getMA(M1, _20) < getLowestPrice(1,1)
      && getMA(M1, _50) < getLowestPrice(1,1)
      && getMA(M1, _200) < getLowestPrice(1,1)
      && getMA(M5, _9) < getLowestPrice(5,1)
      && getMA(M5, _9) < getLowestPrice(5,1)
      && MAConditionsForBuyOrder()
      && (getRSI(M5) < 50 || getRSI(M1) < 40)
   )
     {
      placeBuyOrder(orderLots, "BuyRD", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuyRSI_MA_Driven()
  {
   if(
      isThisBarBULLISH()
      && isThisBarBULLISH(5)
      && isThisBarBULLISH(15)
      && howClose[D1] > -7
      && (getRSI(M1) < 70 || getRSI(M15) < 40)
      && (getRSI(M1) < 67 || getRSI(M5) < 65)
      && (getRSI(M1) < 55 || checkAccountEquity(equityThreshold))
      && (getRSI(M5) < 55 || checkAccountEquity(equityThreshold))
      && (getRSI(M15) < 55 || checkAccountEquity(equityThreshold))
      && getRSI(W1) < 60
      && (isThisBarBULLISH(60) || isThisBarBULLISH(30))
      && (isThisBarBULLISH(999) || isThisBarBULLISH(60))
      && (isThisBarBULLISH(9997) || isThisBarBULLISH(30))
      && getMA(M5, _9) < getLowestPrice(5,1)
      && getMA(M5, _9) < getLowestPrice(5,1)
      && (getMA(M1, _9) < getLowestPrice(1,1) || checkAccountEquity(equityThreshold))
      && getMA(M1, _20) < getLowestPrice(1,1)
//&& (shouldAllowBuyFromRSI || getMA(M30, _20) < getLowestPrice(30,1))
//&& (shouldAllowBuyFromRSI5 || getMA(M30, _50) < getLowestPrice(30,1))
      && getRSI(W1) < 65
      && getRSI(MN1) < 65
      && (getRSI(W1) < 55 || checkAccountEquity(equityThreshold))
      && (getRSI(MN1) < 55 || checkAccountEquity(equityThreshold))
      && MAConditionsForBuyOrder()
      && getRSI(M1) < 50
      && (getRSI(M5) < 50 || getRSI(M1) < 40)
   )
     {
      placeBuyOrder(orderLots, "BuyRMD", MILLIONDOLLARBOT, 0, true);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuyRSI_MA_Driven2()
  {
   if(
      baseConditionsForBuyOrder()
      && isThisBarBULLISH()
      && isThisBarBULLISH(15)
      && (getRSI(M1) < 70 || getRSI(M15) < 50)
      && (getRSI(M1) < 67 || getRSI(M5) < 65)
      && (getRSI(M1) < 55 || checkAccountEquity(equityThreshold))
      && getRSI(M5) < 65
      && (getRSI(M5) < 55 || checkAccountEquity(equityThreshold))
      && (getRSI(M15) < 60 || checkAccountEquity(equityThreshold))
      && (getRSI(M30) < 60 || checkAccountEquity(equityThreshold))
      && (getRSI(H1) < 60 || checkAccountEquity(equityThreshold))
      && getRSI(W1) < 60
      && (isThisBarBULLISH(60) || isThisBarBULLISH(30))
      && (isThisBarBULLISH(999) || isThisBarBULLISH(60))
      && (isThisBarBULLISH(9997) || isThisBarBULLISH(30))
      && (getMA(M5, _9) < getLowestPrice(5,1) || getMA(M5, _200) < getLowestPrice(5,1) || getMA(M15, _50) < getLowestPrice(15,1) || getMA(M1, _50) < getLowestPrice(1,1))
      && getMA(M1, _9) < getLowestPrice(1,1)
      && getMA(M5, _20) < getLowestPrice(5,1)
      && getMA(M15, _50) < getLowestPrice(15,1)
      && getMA(M15, _20) < getLowestPrice(15,1)
      && getRSI(W1) < 65
      && getRSI(MN1) < 65
      && (getRSI(W1) < 55 || checkAccountEquity(equityThreshold))
      && (getRSI(MN1) < 55 || checkAccountEquity(equityThreshold))
      && MAConditionsForBuyOrder()
      && getRSI(M1) < 50
      && (getRSI(M5) < 50 || getRSI(M1) < 40)
      && getMA(M1, _50) > getLowestPrice(1,1)
   )
     {
      placeBuyOrder(orderLots, "BuyRMD2", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuyRSIMAStoch()
  {
   if(
      isThisBarBULLISH(5)
      && isThisBarBULLISH(60)
      && getBarSize(60) > 30
      && isThisBarBULLISH(240)
      && getBarSize(240) > 50
      && isThisBarBULLISH(999)
      && getBarSize(999) > 200
      && shouldAllowBuyFromRSI[M1]
      && getMA(H4, _20) < getLowestPrice(240,1)
      && getMA(H4, _50) < getLowestPrice(240,1)
      && getMA(H1, _200) < getLowestPrice(60,1)
      && getMA(M30, _200) < getLowestPrice(30,1)
      && getMA(M15, _50) < getLowestPrice(15,1)
      && (getMA(M15, _20) < getLowestPrice(15,1) || getMA(M15, _9) < getLowestPrice(15,1))
      && getStochasticMain(15) < 80
      && getStochasticMain(30) < 80
      && getRSI(M1) < 35
      && getRSI(M5) < 35
      && (getMA(M1, _50) < getLowestPrice(1,1) || getMA(M1, _200) < getLowestPrice(1,1))
   )
     {
      placeBuyOrder(orderLots, "BuyRMS", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSell()
  {
   if(
      isThisBarBEARISH(240)
      && (howClose[H4] < -7 || isThisBarBEARISH(9997))
      && ((getRSI(M1) > 80 || getRSI(M5) > 70 || getRSI(M15) > 70 || getRSI(M30) > 70 || getRSI(H1) > 70 || getRSI(H4) > 70 || getRSI(W1) > 70)
          || (isThisBarBEARISH(15) && isThisBarBEARISH(30) && isThisBarBEARISH(60))
         )
      && (getRSI(M1) > 40 && getRSI(M5) > 40 && getRSI(M15) > 40 && getRSI(M30) > 40 && getRSI(H1) > 40 && getRSI(H4) > 40 && getRSI(W1) > 40)
      && getMA(M5, _9) > getHighestPrice(5, 1)
      && getMA(M5, _20) > getHighestPrice(5, 1)
      && (getMA(M5, _9) > getHighestPrice(5, 1) || getMA(M5, _200) > getHighestPrice(5, 1))
      && (getMA(M1, _9) > getHighestPrice(1, 1) && getMA(M1, _20) > getHighestPrice(1, 1))
      && (getMA(M1, _50) > getHighestPrice(1, 1) || getMA(M1, _200) > getHighestPrice(1, 1))
      && getRSI(M1) > 65
      && isThisBarBEARISH(60)
   )
     {
      placeSellOrder(orderLots, "Sell1", MILLIONDOLLARBOT, 0, true);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSell2()
  {
   if(
      ((isThisBarBEARISH(240) && getBarSize(240) > 20) || (isThisBarBEARISH(9997) && getBarSize(9997) > 20))
      && (getRSI(M1) > 80 || getRSI(M5) > 80 || getRSI(M15) > 80 || getRSI(M30) > 80 || getRSI(H1) > 80 || getRSI(H4) > 80 || getRSI(W1) > 80)
      && (getMA(H1, _20) > getHighestPrice(60, 1) || checkAccountEquity(equityThreshold))
      && (getMA(H1, _50) > getHighestPrice(60, 1) || checkAccountEquity(equityThreshold))
      && (getMA(M5, _9) > getHighestPrice(5, 1) || getMA(M1, _50) > getHighestPrice(1, 1))
      && (getMA(M5, _20) > getHighestPrice(5, 1) || getMA(M1, _50) > getHighestPrice(1, 1))
      && getRSI(M1) > 55
      && isThisBarBEARISH(5)
      && isThisBarBEARISH(60)
   )
     {
      placeSellOrder(orderLots, "Sell2", MILLIONDOLLARBOT, 0, true);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSell3()
  {
   if(
      ((isThisBarBEARISH(240) && getBarSize(240) > 20) || (isThisBarBEARISH(9997) && getBarSize(9997) > 20))
      && (getRSI(M1) > 95 || getRSI(M5) > 90 || getRSI(M15) > 90 || getRSI(M30) > 90 || getRSI(H1) > 90 || getRSI(H4) > 90 || getRSI(W1) > 90)
      && (getMA(M5, _9) > getHighestPrice(5, 1) || getMA(M1, _50) > getHighestPrice(1, 1))
      && (getMA(M5, _20) > getHighestPrice(5, 1) || getMA(M1, _50) > getHighestPrice(1, 1))
      && getMA(M5, _50) > getHighestPrice(5, 1)
      && getRSI(M1) > 57
      && getRSI(M5) > 50
      && isThisBarBEARISH(60)
   )
     {
      placeSellOrder(orderLots, "Sell3", MILLIONDOLLARBOT, 0, true);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSell4()
  {
   if(
      ((isThisBarBEARISH(240) && getBarSize(240) > 20) || (isThisBarBEARISH(9997) && getBarSize(9997) > 20))
      && getMA(H4, _20) > getHighestPrice(240, 1)
      && getMA(M1, _50) > getHighestPrice(1, 1)
      && getRSI(M1) >= 70
      && (getRSI(M5) >= 60 || getRSI(M15) >= 60)
      && (getRSI(D1) > 50 || checkAccountEquity(equityThreshold))
      && isThisBarBEARISH(60)
      && isThisBarBEARISH()
      && isThisBarBEARISH(5)
   )
     {
      placeSellOrder(orderLots, "Sell4", MILLIONDOLLARBOT, 0, true);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSell5()
  {
   if(
      (getRSI(M1) > 80)
      && (getRSI(M5) > 70 || getRSI(M15) > 70)
      && (getMA(M1, _20) > getHighestPrice(1,1) || getMA(M5, _20) > getHighestPrice(5,1) || getMA(M15, _20) > getHighestPrice(15,1) || getMA(M30, _20) > getHighestPrice(30,1) || getMA(H1, _20) > getHighestPrice(60,1) || getMA(H4, _20) > getHighestPrice(240,1))
      && (getRSI(H1) > 70 || checkAccountEquity(equityThreshold))
      && getRSI(H1) > 65
      && (getMA(M1, _500) > getHighestPrice(1,1) || checkAccountEquity(equityThreshold))
      && getStochasticSignal(M5) > getStochasticMain(M5)
      && ((getMA(M1, _9) > getHighestPrice(1, 1) && getMA(M1, _20) > getHighestPrice(1, 1))
          || (isThisBarBEARISH(5) || isThisBarBEARISH(15) || isThisBarBEARISH(30) || isThisBarBEARISH(60) || checkAccountEquity(5000)))
   )
     {
      placeSellOrder(orderLots, "Sell5", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy_ExtremeRSI()
  {
   if(
      (shouldPrepareForSellReverse[M1] || shouldPrepareForSellReverse[M5])
      && getMA(M1, _9) < getLowestPrice(1, 1)
      && getMA(M1, _20) < getLowestPrice(1, 1)
      && getMA(M1, _50) < getLowestPrice(1, 1)
      && getMA(M1, _200) < getLowestPrice(1, 1)
      && getRSI(M5) < 45
      && getRSI(M15) < 45
      && getRSI(M30) < 45
   )
     {
      placeBuyOrder(orderLots, "BuyXR", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSell_ExtremeRSI()
  {
   if(
      (shouldPrepareForBuyReverse[M1] || shouldPrepareForBuyReverse[M5])
      && getMA(M1, _9) > getHighestPrice(1, 1)
      && getMA(M1, _20) > getHighestPrice(1, 1)
      && getMA(M1, _50) > getHighestPrice(1, 1)
      && getMA(M1, _200) > getHighestPrice(1, 1)
      && getRSI(M5) > 55
      && getRSI(M15) > 55
      && getRSI(M30) > 55
   )
     {
      placeSellOrder(orderLots, "SellXR", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy_ExtremeRSI2()
  {
   if(
      (shouldPrepareForSellReverse2[M1] || shouldPrepareForSellReverse2[M5])
      && getMA(M1, _9) < getLowestPrice(1, 1)
      && getMA(M1, _20) < getLowestPrice(1, 1)
      && getMA(M1, _50) < getLowestPrice(1, 1)
      && getMA(M1, _200) < getLowestPrice(1, 1)
      && getRSI(M5) < 45
      && getRSI(M15) < 45
      && getRSI(M30) < 45

   )
     {
      placeBuyOrder(orderLots, "BuyXR2", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSell_ExtremeRSI2()
  {
   if(
      (shouldPrepareForBuyReverse2[M1] || shouldPrepareForBuyReverse2[M5])
      && getMA(M1, _9) > getHighestPrice(1, 1)
      && getMA(M1, _20) > getHighestPrice(1, 1)
      && getMA(M1, _50) > getHighestPrice(1, 1)
      && getMA(M1, _200) > getHighestPrice(1, 1)
      && getRSI(M5) > 55
      && getRSI(M15) > 55
      && getRSI(M30) > 55

   )
     {
      placeSellOrder(orderLots, "SellXR2", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy_ExtremeRSI3()
  {
   if(
      (
         (getRSI(M1) < 25
          && getRSI(M5) <= 30)
         || getRSI(M1) < 3
         || getRSI(M15) <= 30
         || getRSI(M30) <= 30
         || getRSI(H1) <= 30
         || getRSI(H4) <= 30
      )
   )
     {
      shouldPrepareForSellReverse3[M1] = true;
     }

   if(
      shouldPrepareForSellReverse3[M1]
      && getMA(M1, _200) < getLowestPrice(1,1)
      && getMA(M1, _200) < getMA(M1, _50)
      && getMA(M1, _50) < getMA(M1, _20)
      && getMA(M1, _20) < getMA(M1, _9)
      && (getRSI(M1, _20) > getRSI(M1, _50) || (isThisBarBULLISH(30) && isThisBarBULLISH(60)))
      && getRSI(M5) < 50
      && getRSI(M1) < 55
      && isThisBarBULLISH()
      && isThisBarBULLISH(5)
      && isThisBarBULLISH(15)
      && isThisBarBULLISH(60)
   )
     {
      placeBuyOrder(orderLots, "BuyXR3", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSell_ExtremeRSI3()
  {
   if(
      (
         (getRSI(M1) > 75
          && getRSI(M5) >= 70)
         || getRSI(M1) > 97
         || getRSI(M15) >= 70
         || getRSI(M30) >= 70
         || getRSI(H1) >= 70
         || getRSI(H4) >= 70
      )
   )
     {
      shouldPrepareForBuyReverse3[M1] = true;
     }

   if(
      shouldPrepareForBuyReverse3[M1]
      && getMA(M1, _20) > getMA(M1, _9)
      && getMA(M1, _50) > getMA(M1, _20)
      && getMA(M1, _200) > getMA(M1, _50)
      && getMA(M1, _200) > getHighestPrice(1,1)
      && (getRSI(M1, _50) > getRSI(M1, _20) || (isThisBarBEARISH(30) && isThisBarBEARISH(60)))
      && getRSI(M5) > 55
      && getRSI(M1) > 50
      && isThisBarBEARISH()
      && isThisBarBEARISH(5)
      && isThisBarBEARISH(15)
      && isThisBarBEARISH(60)
   )
     {
      placeSellOrder(orderLots, "SellXR3", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy_ExtremeMA()
  {
   if(allMADown())
     {
      placeBuyOrder(orderLots, "BuyXM", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSell_ExtremeMA()
  {
   if(allMAUp())
     {
      placeSellOrder(orderLots, "SellXM", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy_ExtremeMA2()
  {
   if(
      getMA(M5, _9) > getHighestPrice(5,2)
      && getMA(M5, _20) > getHighestPrice(5,2)
      && getMA(M5, _50) > getHighestPrice(5,2)
      && getMA(M5, _9) > getMA(M5, _20)
      && getMA(M5, _9) > getMA(M5, _50)
      && getMA(M5, _20) > getMA(M5, _50)
      && getMA(M1, _200) < getLowestPrice(1,1)
      && getMA(M1, _200) < getMA(M1, _50)
      && getMA(M1, _50) < getMA(M1, _20)
      && getMA(M1, _20) < getMA(M1, _9)
   )
     {
      placeBuyOrder(orderLots, "BuyXM2", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSell_ExtremeMA2()
  {
   if(
      getMA(M5, _9) < getLowestPrice(5,2)
      && getMA(M5, _20) < getLowestPrice(5,2)
      && getMA(M5, _50) < getLowestPrice(5,2)
      && getMA(M5, _50) > getMA(M5, _20)
      && getMA(M5, _50) > getMA(M5, _9)
      && getMA(M5, _20) > getMA(M5, _9)
      && getMA(M1, _20) > getMA(M1, _9)
      && getMA(M1, _50) > getMA(M1, _20)
      && getMA(M1, _200) > getMA(M1, _50)
      && getMA(M1, _200) > getHighestPrice(1,1)
   )
     {
      placeSellOrder(orderLots, "SellXM2", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy_ExtremeMA3()
  {
   if(
      getMA(M15, _9) > getHighestPrice(15,2)
      && getMA(M15, _20) > getHighestPrice(15,2)
      && getMA(M15, _50) > getHighestPrice(15,2)
      && getMA(M15, _9) > getMA(M15, _20)
      && getMA(M15, _9) > getMA(M15, _50)
      && getMA(M15, _20) > getMA(M15, _50)
      && getMA(M1, _200) < getLowestPrice(1,1)
      && getMA(M1, _200) < getMA(M1, _50)
      && getMA(M1, _50) < getMA(M1, _20)
      && getMA(M1, _20) < getMA(M1, _9)
   )
     {
      placeBuyOrder(orderLots, "BuyXM3", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSell_ExtremeMA3()
  {
   if(
      getMA(M15, _9) < getLowestPrice(15,2)
      && getMA(M15, _20) < getLowestPrice(15,2)
      && getMA(M15, _50) < getLowestPrice(15,2)
      && getMA(M15, _50) > getMA(M15, _20)
      && getMA(M15, _50) > getMA(M15, _9)
      && getMA(M15, _20) > getMA(M15, _9)
      && getMA(M1, _20) > getMA(M1, _9)
      && getMA(M1, _50) > getMA(M1, _20)
      && getMA(M1, _200) > getMA(M1, _50)
      && getMA(M1, _200) > getHighestPrice(1,1)
   )
     {
      placeSellOrder(orderLots, "SellXM3", MILLIONDOLLARBOT, 0, true);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy_ExtremeMA4()
  {
   if(
      getMA(M30, _9) > getHighestPrice(30,2)
      && getMA(M30, _20) > getHighestPrice(30,2)
      && getMA(M30, _50) > getHighestPrice(30,2)
      && getMA(M30, _9) > getMA(M30, _20)
      && getMA(M30, _9) > getMA(M30, _50)
      && getMA(M30, _20) > getMA(M30, _50)
      && getMA(M1, _200) < getLowestPrice(1,1)
      && getMA(M1, _200) < getMA(M1, _50)
      && getMA(M1, _50) < getMA(M1, _20)
      && getMA(M1, _20) < getMA(M1, _9)
      && isThisBarBULLISH(240)
   )
     {
      placeBuyOrder(orderLots, "BuyXM4", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSell_ExtremeMA4()
  {
   if(
      getMA(M30, _9) < getLowestPrice(30,2)
      && getMA(M30, _20) < getLowestPrice(30,2)
      && getMA(M30, _50) < getLowestPrice(30,2)
      && getMA(M30, _50) > getMA(M30, _20)
      && getMA(M30, _50) > getMA(M30, _9)
      && getMA(M30, _20) > getMA(M30, _9)
      && getMA(M1, _20) > getMA(M1, _9)
      && getMA(M1, _50) > getMA(M1, _20)
      && getMA(M1, _200) > getMA(M1, _50)
      && getMA(M1, _200) > getHighestPrice(1,1)
      && isThisBarBEARISH(240)
   )
     {
      placeSellOrder(orderLots, "SellXM4", MILLIONDOLLARBOT, 0, true);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy_ExtremeMA5()
  {
   if(
      getMA(H1, _9) > getHighestPrice(60,2)
      && getMA(H1, _20) > getHighestPrice(60,2)
      && getMA(H1, _50) > getHighestPrice(60,2)
      && getMA(H1, _9) > getMA(H1, _20)
      && getMA(H1, _9) > getMA(H1, _50)
      && getMA(H1, _20) > getMA(H1, _50)
      && getMA(M1, _200) < getLowestPrice(1,1)
      && getMA(M1, _200) < getMA(M1, _50)
      && getMA(M1, _50) < getMA(M1, _20)
      && getMA(M1, _20) < getMA(M1, _9)
   )
     {
      placeBuyOrder(orderLots, "BuyXM5", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSell_ExtremeMA5()
  {
   if(
      getMA(H1, _9) < getLowestPrice(60,2)
      && getMA(H1, _20) < getLowestPrice(60,2)
      && getMA(H1, _50) < getLowestPrice(60,2)
      && getMA(H1, _50) > getMA(H1, _20)
      && getMA(H1, _50) > getMA(H1, _9)
      && getMA(H1, _20) > getMA(H1, _9)
      && getMA(M1, _20) > getMA(M1, _9)
      && getMA(M1, _50) > getMA(M1, _20)
      && getMA(M1, _200) > getMA(M1, _50)
      && getMA(M1, _200) > getHighestPrice(1,1)
   )
     {
      placeSellOrder(orderLots, "SellXM5", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+

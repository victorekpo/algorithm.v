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
//" M15: ",howClose[M15],
//" M30: ",howClose[M30],
//" H1: ",howClose[H1],
//" H4: ",howClose[H4],
//" D: ",howClose[D1],
//" W: ",howClose[W1],
//" MN: ",howClose[MN1],
           " shouldRSI: ", shouldAllowBuyFromRSI[M1],
           " shouldRSI5: ", shouldAllowBuyFromRSI[M5],
//  " occurenceBUY: ", checkOccurenceBuy(),
//  " occurenceSELL: ", checkOccurenceSell(),
//  " diff ", checkOccurenceBuy() - checkOccurenceSell(),
           " occur ", priceOccurence,
// " steps ", steps,
//   " aggProfit ", calculateTakeProfit() * aggregateProfit,
//" leastProfit ", leastMinProfit,
//" highestProfit ", highestProfit,
           " trendH ", trendData.consecutiveHighs,
           " trendLH ", trendData.lastHigh,
           " trendL  ", trendData.consecutiveLows,
           " trendLL ", trendData.lastLow,
           " trendS ", trendData.trendStrength,
           " isBear5 ", isThisBarBEARISH(5),
//" isBear15 ", isThisBarBEARISH(15),
           " isBear30 ", isThisBarBEARISH(30),
// " isBear60 ", isThisBarBEARISH(60),
           " isBear240 ", isThisBarBEARISH(240),
           " isBear999 ", isThisBarBEARISH(999),
           " isBull5 ", isThisBarBULLISH(5),
//" isBull15 ", isThisBarBULLISH(15),
           " isBull30 ", isThisBarBULLISH(30),
// " isBull60 ", isThisBarBULLISH(60),
           " isBull240 ", isThisBarBULLISH(240),
           " isBull999 ", isThisBarBULLISH(999)
          );

// take orders

   if(checkAccountEquity(500))
     {
      doubleUpOrders();
     }

   if(checkAccountEquity(5))
     {
      //   if(!isRangingSell() || true)
      //     {
      CheckForInitialSell1();
      CheckForInitialSell2();
      CheckForOpenMAConditions();
      CheckForOpenRSIConditions();
      CheckForOpenMARSIConditions();
      CheckForOpenSell();
      CheckForOpenSellDaily_Bear();
      CheckForOpenSellMA_Driven();
      CheckForOpenSellMA_Driven2();
      CheckForOpenSellRSI_Driven();
      CheckForOpenSellRSI_MA_Driven();
      CheckForOpenSellRSI_MA_Driven2();
      CheckForOpenRSIMAStoch();
      CheckForOpenSell_ExtremeRSI();
      CheckForOpenSell_ExtremeRSI2();
      CheckForOpenSell_ExtremeRSI3();
      CheckForOpenSell_ExtremeMA();
      CheckForOpenSell_ExtremeMA2();
      CheckForOpenSell_ExtremeMA3();
      CheckForOpenSell_ExtremeMA4();
      CheckForOpenSell_ExtremeMA5();
      //     }
     }

   if(checkAccountEquity(50))
     {
      //   if(!isRangingBuy() || true)
      //     {
      CheckForInitialBuy1();
      CheckForInitialBuy2();
      CheckForOpenBuy();
      CheckForOpenBuy2();
      CheckForOpenBuy3();
      CheckForOpenBuy4();
      CheckForOpenBuy5();
      CheckForOpenBuy_ExtremeRSI();
      CheckForOpenBuy_ExtremeRSI2();
      CheckForOpenBuy_ExtremeRSI3();
      CheckForOpenBuy_ExtremeMA();
      CheckForOpenBuy_ExtremeMA2();
      CheckForOpenBuy_ExtremeMA3();
      CheckForOpenBuy_ExtremeMA4();
      CheckForOpenBuy_ExtremeMA5();
      //    }
     }

   if(checkAccountEquity(1000))
     {
      HandleReversals();
      HandleStopLoss();
     }

//Alert("MA 1,9: ",getMA(M1,_9));
// Alert("RSI: ", getRSI(M1));
//if(clock.sec == 0 && clock.min == 0)
//  {
//   deleteAllPendingBuyLimit();
//   deleteAllPendingSellLimit();
//
   if(clock.sec == 0 && clock.min == 0 && clock.hour % 2 == 0)
     {
      Alert("every two hours, resetting highestProfit to 0");
      highestProfit = 0;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForInitialBuy1()
  {
   bool isBullish = !isThisBarBEARISH(999) && !isThisBarBEARISH(240) && !isThisBarBEARISH(60) && !isThisBarBEARISH(30);
   bool isBearish = !isThisBarBULLISH(999) && !isThisBarBULLISH(240) && !isThisBarBULLISH(60) && !isThisBarBULLISH(30);

   if(
      (isUptrendFromSlope() || (getRSI(M30) < 45 && getRSI(H1) < 45 && getRSI(M15) < 50))
//     && (isCurrentUptrend() || getMA(D1, _9) < getLowestPrice(999, 1))
      && !isThisBarBEARISH()
      && (!isThisBarBEARISH(5) || getRSI(D1) < 40)
      && (!isThisBarBEARISH(15) || getMA(D1, _9) < getLowestPrice(999, 1))
      && (!isThisBarBEARISH(30) || getMA(D1, _9) < getLowestPrice(999, 1))
      && (!isThisBarBEARISH(60) || getMA(D1, _9) < getLowestPrice(999, 1))
      && (getRSI(M1) < 58 || (isBullish && getRSI(D1) < 25))
      && (getRSI(M5) < 48 || (isBullish && getRSI(D1) < 25))
      && getRSI(M15) < 57
      && (getRSI(M15) < 45 || (isBullish && getRSI(D1) < 25))
      && (getMA(M5, _9) > getHighestPrice(5,2) || getMA(M5, _20) > getHighestPrice(5,1))
      && getRSI(M30) < 50
      && getRSI(H1) < 50
      && getRSI(H4) < 50
      && getRSI(D1) < 50
      && (getMA(M5, _50) < getLowestPrice(5,1) || getMA(M30, _20) < getLowestPrice(30,1) || getMA(D1, _50) < getLowestPrice(999,1))
      && (
         getMA(M1, _50) < getLowestPrice(1, 1)
         || getMA(M1, _200) < getLowestPrice(1, 1)
         || getMA(M5, _9) < getLowestPrice(5, 1)
         || getMA(M5, _20) < getLowestPrice(5, 1)
         || getMA(M5, _50) < getLowestPrice(5, 1)
         || getMA(M15, _9) < getLowestPrice(15, 1)
         || getMA(M15, _20) < getLowestPrice(15, 1)
      )
      && (getMA(M5, _9) < getLowestPrice(5,3) || getMA(M5, _20) < getLowestPrice(5,2) || getMA(M15, _50) < getLowestPrice(15,1) || getMA(D1, _50) < getLowestPrice(999,1))
      && (getMA(M5, _200) < getLowestPrice(5,1) || getMA(M15, _50) < getLowestPrice(15,1) || getMA(M30, _50) < getLowestPrice(30,1) || getMA(H1, _20) < getLowestPrice(60,1) || isThisBarBULLISH(999) || isThisBarBULLISH(9997))
   )
     {
      placeBuyOrder(orderLots, "TESTBUY1", 111);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForInitialSell1()
  {
   bool isBullish = !isThisBarBEARISH(999) && !isThisBarBEARISH(240) && !isThisBarBEARISH(60) && !isThisBarBEARISH(30);
   bool isBearish = !isThisBarBULLISH(999) && !isThisBarBULLISH(240) && !isThisBarBULLISH(60) && !isThisBarBULLISH(30);

   if(
      (isDowntrendFromSlope() || (getRSI(M30) > 55 && getRSI(H1) > 55 && getRSI(M15) > 50) || getRSI(W1) > 60)
//    && (isCurrentDowntrend() || getMA(D1, _9) > getHighestPrice(999, 1))
      && !isThisBarBULLISH()
      && (!isThisBarBULLISH(5) || getRSI(D1) > 60)
      && (!isThisBarBULLISH(15) || getMA(D1, _9) > getHighestPrice(999, 1))
      && (!isThisBarBULLISH(30) || getMA(D1, _9) > getHighestPrice(999, 1))
      && (!isThisBarBULLISH(60) || getMA(D1, _9) > getHighestPrice(999, 1))
      && (!isThisBarBULLISH(60) || getMA(M5, _20) > getHighestPrice(5,1) || isThisBarBEARISH(30))
      && (getRSI(M1) > 10 || getRSI(D1) > 65 || getRSI(W1) > 60)
      && (getRSI(M1) > 10 || (isBearish && getRSI(D1) > 55) || getRSI(W1) > 60)
      && (getRSI(M5) > 30 || (isBearish && getRSI(D1) > 55) || getRSI(W1) > 60)
      && getRSI(M15) > 30
      && (getRSI(M15) > 45 || (isBearish && getRSI(D1) > 55) || getRSI(W1) > 60)
      && getRSI(M30) > 30
      && getRSI(H1) > 35
      && getRSI(H4) > 35
      && getRSI(D1) > 35
      && (!isThisBarBULLISH(240) || getMA(M30, _9) > getHighestPrice(30,2) || getMA(M15, _20) > getHighestPrice(15,2) || getMA(M5, _50) > getHighestPrice(5,2) || getMA(M1, _200) > getHighestPrice(1,5) || (getRSI(D1) > 50 && getRSI(H4) > 50 && getRSI(H1) > 50 && getRSI(M30) > 45 && getRSI(M15) > 45 && getRSI(M5) > 40))
      && (getRSI(M1) > 30 || getMA(M1, _200) > getHighestPrice(1,1) || getMA(H1, _9) > getHighestPrice(60,1) || (getRSI(D1) > 50 && getRSI(H4) > 50 && getRSI(H1) > 50 && getRSI(M30) > 45 && getRSI(M15) > 45 && getRSI(M5) > 40))
      && (getMA(M5, _50) > getHighestPrice(5,1) || getMA(M30, _20) > getHighestPrice(30,1) || getMA(D1, _50) > getHighestPrice(999,1) || (getRSI(D1) > 50 && getRSI(H4) > 50 && getRSI(H1) > 50 && getRSI(M30) > 45 && getRSI(M15) > 45 && getRSI(M5) > 40))
      && (getMA(M5, _9) > getHighestPrice(5,3) || getMA(M5, _20) > getHighestPrice(5,2) || getMA(M15, _50) > getHighestPrice(15,1) || getMA(D1, _50) > getHighestPrice(999,1) || (getRSI(D1) > 50 && getRSI(H4) > 50 && getRSI(H1) > 50 && getRSI(M30) > 45 && getRSI(M15) > 45 && getRSI(M5) > 40))
      && (getMA(M5, _200) > getHighestPrice(5,1) || getMA(M15, _50) > getHighestPrice(15,1) || getMA(M30, _50) > getHighestPrice(30,1) || getMA(H1, _20) > getHighestPrice(60,1) || isThisBarBEARISH(999) || isThisBarBEARISH(9997) || (getRSI(D1) > 50 && getRSI(H4) > 50 && getRSI(H1) > 50 && getRSI(M30) > 45 && getRSI(M15) > 45 && getRSI(M5) > 40))
      && (!isThisBarBULLISH(999) || getMA(M5, _50) > getHighestPrice(5,1) || getMA(M15, _20) > getHighestPrice(15,1) || getMA(M30, _9) > getHighestPrice(30,1) || (getRSI(D1) > 50 && getRSI(H4) > 50 && getRSI(H1) > 50 && getRSI(M30) > 45 && getRSI(M15) > 45 && getRSI(M5) > 40))
      && (!isThisBarBULLISH(999) || getMA(M5, _20) > getHighestPrice(5,1) || getMA(M15, _9) > getHighestPrice(15,1) || !isThisBarBULLISH(30) || !isThisBarBULLISH(9997) || (getRSI(D1) > 50 && getRSI(H4) > 50 && getRSI(H1) > 50 && getRSI(M30) > 45 && getRSI(M15) > 45 && getRSI(M5) > 40))
      && (getMA(M1, _200) > getHighestPrice(1,1) || getMA(M5, _200) > getHighestPrice(5,1) || getMA(M15, _50) > getHighestPrice(15,1) || getMA(M30, _9) > getHighestPrice(30,1) || getMA(M15, _50) > getHighestPrice(15,1) || isThisBarBULLISH(999) || (getRSI(D1) > 50 && getRSI(H4) > 50 && getRSI(H1) > 50 && getRSI(M30) > 45 && getRSI(M15) > 45 && getRSI(M5) > 40)) 
// && !(getRSI(M1 < 20) && getRSI(M5) < 45)

      && (
         getMA(M1, _50) > getHighestPrice(1, 1)
         || getMA(M1, _200) > getHighestPrice(1, 1)
         || getMA(M5, _9) > getHighestPrice(5, 1)
         || getMA(M5, _20) > getHighestPrice(5, 1)
         || getMA(M5, _50) > getHighestPrice(5, 1)
         || getMA(M15, _9) > getHighestPrice(15, 1)
         || getMA(M15, _20) > getHighestPrice(15, 1)
      )
   )
     {
      // Reverse and take sell orders
      if(
         (getRSI(M1 < 20) && getRSI(M5) < 45)
         ||
         (
            (getMA(M1, _20) < getLowestPrice(1,1) || getMA(M1, _50) < getLowestPrice(1,1))
            && getMA(M30, _9) < getLowestPrice(30,1) && getMA(M30, _20) < getLowestPrice(30,1)
         )
         || (getRSI(M1) < 30 && getRSI(M5) < 40 && getRSI(M15) < 40 && getMA(M15, _200) < getLowestPrice(15,1))
         || (getRSI(W1) < 30 && getRSI(D1) < 45 && getRSI(M5) < 55 && getRSI(M1) < 40 && getMA(D1, _9) < getLowestPrice(999,1) && getMA(H4, _9) < getLowestPrice(240,1) && getMA(H4, _50) < getLowestPrice(240,1) && getMA(M15, _200) < getLowestPrice(15,1) && getMA(M5, _200) < getLowestPrice(5,1))
      )
        {
         if(isThisBarBULLISH(30) && isThisBarBULLISH(60) && isThisBarBULLISH(240))
           {
            placeBuyOrder(orderLots, "TESTBUY3", 111);
           }
         return;
        }

      placeSellOrder(orderLots, "TESTSELL1", 222);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForInitialBuy2()
  {
   bool isBullish = !isThisBarBEARISH(999) && !isThisBarBEARISH(240) && !isThisBarBEARISH(60) && !isThisBarBEARISH(30);
   bool isBearish = !isThisBarBULLISH(999) && !isThisBarBULLISH(240) && !isThisBarBULLISH(60) && !isThisBarBULLISH(30);

   if(
      isCurrentUptrend()
      && isThisBarBULLISH()
      && (isThisBarBULLISH(15) || getRSI(D1) < 30)
      && (isThisBarBULLISH(60) || getRSI(D1) < 30)
      && (isThisBarBULLISH(999) || getRSI(D1) < 30)
      && (getRSI(M1) < 78 || (isBullish && getRSI(D1) < 45))
      && (getRSI(M5) < 68 || (isBullish && getRSI(D1) < 45))
      && getRSI(M15) < 67
      && (getRSI(M15) < 65 || (isBullish && getRSI(D1) < 45))
      && getRSI(M30) < 65
      && getRSI(H1) < 65
      && getRSI(H4) < 65
      && getRSI(D1) < 60
      && (getMA(M5, _9) < getLowestPrice(5,3) || getMA(M5, _20) < getLowestPrice(5,2) || getMA(M15, _50) < getLowestPrice(15,1) || getMA(D1, _50) < getLowestPrice(999,1))
      && (getMA(M5, _200) < getLowestPrice(5,1) || getMA(M15, _50) < getLowestPrice(15,1) || getMA(M30, _50) < getLowestPrice(30,1) || getMA(H1, _20) < getLowestPrice(60,1) || isThisBarBULLISH(999) || isThisBarBULLISH(9997))
      && (
         getMA(M1, _50) < getLowestPrice(1, 1)
         || getMA(M1, _200) < getLowestPrice(1, 1)
         || getMA(M5, _9) < getLowestPrice(5, 1)
         || getMA(M5, _20) < getLowestPrice(5, 1)
         || getMA(M5, _50) < getLowestPrice(5, 1)
         || getMA(M15, _9) < getLowestPrice(15, 1)
         || getMA(M15, _20) < getLowestPrice(15, 1)
      )
   )
     {
      placeBuyOrder(orderLots, "TESTBUY2", 111);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForInitialSell2()
  {
   bool isBullish = !isThisBarBEARISH(999) && !isThisBarBEARISH(240) && !isThisBarBEARISH(60) && !isThisBarBEARISH(30);
   bool isBearish = !isThisBarBULLISH(999) && !isThisBarBULLISH(240) && !isThisBarBULLISH(60) && !isThisBarBULLISH(30);

   if(
      (isCurrentDowntrend() || (getRSI(M30) > 55 && getRSI(H1) > 55 && getRSI(M15) > 50) || getRSI(W1) > 60)
      && isThisBarBEARISH()
      && (isThisBarBEARISH(15) || getRSI(D1) > 70)
      && (isThisBarBEARISH(60) || getRSI(D1) > 70)
      && (isThisBarBEARISH(999) || getRSI(D1) > 70)
      && (isThisBarBEARISH(60) || isThisBarBEARISH(240) || isThisBarBEARISH(999) || getMA(M1, _9) > getHighestPrice(1,1) || getMA(M1, _20) > getHighestPrice(1,1) || getMA(M5, _9) > getHighestPrice(5,1) || getMA(M5, _20) > getHighestPrice(5,1))
      && (getRSI(M1) > 23 || (isBearish && getRSI(D1) > 55))
      && (getRSI(M5) > 33 || (isBearish && getRSI(D1) > 55))
      && getRSI(M15) > 34
      && (getRSI(M15) > 35 || (isBearish && getRSI(D1) > 55))
      && getRSI(M30) > 35
      && getRSI(H1) > 35
      && getRSI(H4) > 35
      && getRSI(D1) > 40
      && (getMA(M1, _50) > getMA(M1,_9) || getRSI(M1) > 45 || checkAccountEquity(20000))
      && (getMA(M15, _9) > getHighestPrice(15,1) || getMA(M15, _20) > getHighestPrice(15,1) || getMA(M15, _50) > getHighestPrice(15,1) || isThisBarBEARISH(240))
      && (getMA(M5, _9) > getHighestPrice(5,3) || getMA(M5, _20) > getHighestPrice(5,2) || getMA(M15, _50) > getHighestPrice(15,1) || getMA(D1, _50) > getHighestPrice(999,1))
      && (getMA(M5, _200) > getHighestPrice(5,1) || getMA(M15, _50) > getHighestPrice(15,1) || getMA(M30, _50) > getHighestPrice(30,1) || getMA(H1, _20) > getHighestPrice(60,1) || isThisBarBEARISH(999) || isThisBarBEARISH(9997))
      && (
         getMA(M1, _50) > getHighestPrice(1, 1)
         || getMA(M1, _200) > getHighestPrice(1, 1)
         || getMA(M5, _9) > getHighestPrice(5, 1)
         || getMA(M5, _20) > getHighestPrice(5, 1)
         || getMA(M5, _50) > getHighestPrice(5, 1)
         || getMA(M15, _9) > getHighestPrice(15, 1)
         || getMA(M15, _20) > getHighestPrice(15, 1)
      )
   )
     {
      // Reverse and take buy orders
      if(
         getMA(M1, _500) < getLowestPrice(1,1)
         && getMA(M1, _200) < getHighestPrice(1,1)
         && getMA(M5, _200) < getLowestPrice(5,1)
         && getMA(M15, _50) < getLowestPrice(15,1)
         && getMA(M15, _200) < getLowestPrice(15,1)
         && getMA(M30, _20) < getLowestPrice(30,1)
         && getMA(M30, _50) < getLowestPrice(30,1)
         && getMA(M30, _200) < getLowestPrice(30,1)
         && getMA(H1, _20) < getLowestPrice(60,1)
         && getMA(H1, _50) < getLowestPrice(60,1)
         && getMA(H1, _200) < getLowestPrice(60,1)
         && getMA(H4, _9) < getLowestPrice(240,1)
         && getMA(H4, _20) < getLowestPrice(240,1)
         && getMA(H4, _50) < getLowestPrice(240,1)
         && getMA(H4, _200) < getLowestPrice(240,1)
         && getMA(D1, _9) < getLowestPrice(999,1)
         && getMA(D1, _20) < getLowestPrice(999,1)
         && getRSI(M1) < 70
         && getRSI(M5) < 40
         && getRSI(M15) < 55
         && getRSI(M30) < 61
         && isThisBarBULLISH(240,1)
         && isThisBarBULLISH(999,1)
         && isThisBarBULLISH(9997)
      )
        {
         placeBuyOrder(orderLots, "TESTBUY3b", 111);
         return;
        }


      if(
         (getRSI(M1 < 20) && getRSI(M5) < 45)
         ||
         (
            (getMA(M1, _20) < getLowestPrice(1,1) || getMA(M1, _50) < getLowestPrice(1,1))
            && getMA(M30, _9) < getLowestPrice(30,1) && getMA(M30, _20) < getLowestPrice(30,1)
         )
         || (getRSI(M1) < 30 && getRSI(M5) < 40 && getRSI(M15) < 40 && getMA(M15, _200) < getLowestPrice(15,1))
      )
        {
         if(isThisBarBULLISH(30) && isThisBarBULLISH(60) && isThisBarBULLISH(240))
           {
            placeBuyOrder(orderLots, "TESTBUY4", 111);
           }
         return;
        }

      placeSellOrder(orderLots, "TESTSELL2", 222);
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenMAConditions()
  {
   if(
      baseConditionsForSellOrder()
      && MAConditionsForSellOrder()
      && shouldAllowSellFromRSI[M1]
      && (getRSI(M1) > 45 || getRSI(D1) > 60)
      && getMA(M5, _20) > getHighestPrice(5, 1)
      && getMA(M1, _9) > getHighestPrice(1,1)
      && getMA(M1, _20) > getMA(M1, _9) // cascade MAs
      && getMA(M1, _50) > getMA(M1, _20)
      && getMA(M1, _200) > getMA(M1, _50)
      && getMA(M1, _200) > getHighestPrice(1,1)
      && (getMA(D1, _20) > getHighestPrice(9991, 1) || checkAccountEquity(10000))
      && (getMA(H4, _200) > getHighestPrice(240, 1) || checkAccountEquity(10000))
      && (getMA(H1, _500) > getHighestPrice(60, 1) || checkAccountEquity(10000))
   )
     {
      placeSellOrder(orderLots, "SellMA", 100);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenRSIConditions()
  {
   if(
      baseConditionsForSellOrder()
      && RSIConditionsForSellOrder()
      && !(getMA(M1, _20) < getHighestPrice(1, 1))
      && !(getMA(M1, _50) < getHighestPrice(1, 1))
      && !(getMA(M1, _200) < getLowestPrice(1, 1))
      && !(getMA(M30, _50) < getLowestPrice(30, 1))
      && isThisBarBEARISH()
      && ((isThisBarBEARISH(5) && isThisBarBEARISH(15))
          || getMA(M30, _50) > getHighestPrice(30, 1))
   )
     {
      placeSellOrder(orderLots, "SellRSI", 200);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenMARSIConditions()
  {
   if(
      baseConditionsForSellOrder()
      && MAConditionsForSellOrder()
      && RSIConditionsForSellOrder()
      && getMA(M1, _50) > getHighestPrice(1,1)
      && (getRSI(M1) > 55 || getMA(M1, _500) > getHighestPrice(1,1) || getMA(M5, _200) > getHighestPrice(5,1) || getMA(M15, _50) > getHighestPrice(15,1) || getRSI(D1) > 60)
   )
     {
      placeSellOrder(orderLots, "SellMARSI", 300);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSell()
  {
   if(
      baseConditionsForSellOrder()
      && (isThisBarBEARISH(999) || isThisBarBEARISH(240))
      && MAConditionsForSellOrder()
      && RSIConditionsForSellOrder()
      && (getRSI(M1) > 55 || getMA(M1, _500) > getHighestPrice(1,1) || getMA(M5, _200) > getHighestPrice(5,1) || getMA(M15, _50) > getHighestPrice(15,1) || getRSI(D1) > 60)
   )
     {
      placeSellOrder(orderLots, "Sell", MILLIONDOLLARBOT);

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
      && (getRSI(M1) > 55 || getMA(M1, _500) > getHighestPrice(1,1) || getMA(M5, _200) > getHighestPrice(5,1) || getMA(M15, _50) > getHighestPrice(15,1) || getRSI(D1) > 60)
   )
     {
      placeSellOrder(orderLots, "SellDB", MILLIONDOLLARBOT);
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
      && (isThisBarBEARISH(240) || getMA(H4, _20) > getHighestPrice(240, 1) || getMA(M30, _200) > getHighestPrice(30, 1) || getMA(M5, _50) > getMA(M5, _20))
      && getBarSize(15) > 3
      && (getRSI(M1) > 50 || getRSI(D1) > 60)
      && (getRSI(M5) > 50 || getRSI(D1) > 60)
      && (getRSI(M15) > 50 || getRSI(D1) > 60)
      && (getRSI(M30) > 50 || getRSI(D1) > 60)
      && (getRSI(H1) > 50 || getRSI(D1) > 60)
      && (getRSI(H4) > 50 || getRSI(D1) > 60)
      && (getRSI(D1) > 50 || getRSI(D1) > 60)
      && (getMA(M30, _20) > getHighestPrice(30,1) || isThisBarBEARISH(240))
      && getMA(M1, _9) > getHighestPrice(1,1)
      && getMA(M1, _20) > getMA(M1, _9)
      && getMA(M1, _50) > getMA(M1, _20)
      && getMA(M1, _50) - getMA(M1, _20) > 2
      && getMA(M1, _200) > getMA(M1, _50)
      && getMA(M1, _200) > getHighestPrice(1,1)
      && (getRSI(M1) > 70
          || (
             (getRSI(M5) > 45 || getRSI(M15) > 45)
             && getMA(M1, _9) > getHighestPrice(1,1) && getMA(M1, _20) > getHighestPrice(1,1)
          ))
      && (shouldAllowFromBEAR || getMA(M1, _50) > currentPrice || getMA(M1, _200) > currentPrice || (isThisBarBEARISH(240) && isThisBarBEARISH(60) && isThisBarBEARISH(30) && isThisBarBEARISH(15) && getMA(M5, _20) > currentPrice && getMA(M1, _20) > currentPrice && getMA(M1, _9) > currentPrice))
      && howClose[M1] < 0.5
      && howClose[M5] < 2
   )
     {
      placeSellOrder(orderLots, "SellMD", MILLIONDOLLARBOT);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSellMA_Driven2()
  {
   if(
      getMA(M1, _50) > currentPrice
// && (getMA(M1, _9) > getHighestPrice(1,1) || checkAccountEquity(1000))
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
      && (getRSI(M1) > 50 || getRSI(M5) > 50 || getRSI(D1) > 60)
      && howClose[M5] < 2
      && isThisBarBEARISH()
      && isThisBarBEARISH(5)
      && (getMA(M5, _200) > currentPrice || getMA(M15, _50) > getMA(M15, _20) || getMA(M1, _50) > getMA(M1, _20))
      && getMA(M1, _20) - getMA(M1, _9) > 1
      && getMA(M15, _20) - getMA(M15, _50) > 3
      && (getRSI(M1) > 50 || getRSI(D1) > 60)
      && (getRSI(M5) > 50 || getRSI(D1) > 60)
      && (getRSI(M15) > 50 || getRSI(D1) > 60)
      && (getRSI(M30) > 50 || getRSI(D1) > 60)
      && (getRSI(H1) > 50 || getRSI(D1) > 60)
      && (getRSI(H4) > 50 || getRSI(D1) > 60)
      && (getRSI(D1) > 50 || getRSI(D1) > 60)
   )
     {
      placeSellOrder(orderLots, "SellMD2", MILLIONDOLLARBOT);
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
      && (getRSI(M1) > 50 || getRSI(D1) > 60)
      && (getRSI(M1) > 45 || checkAccountEquity(equityThreshold) || getRSI(D1) > 60)
      && (getRSI(M5) > 35 || getRSI(D1) > 60)
      && (getRSI(M5) > 45 || checkAccountEquity(equityThreshold) || getRSI(D1) > 60)
      && (getRSI(M15) > 35 || getRSI(D1) > 60)
      && (getRSI(M15) > 45 || checkAccountEquity(equityThreshold) || getRSI(D1) > 60)
      && (getRSI(M30) > 35 || getRSI(D1) > 60)
      && (getRSI(M30) > 45 || checkAccountEquity(equityThreshold) || getRSI(D1) > 60)
      && (getRSI(H1) > 35 || getRSI(D1) > 60)
      && (getRSI(H1) > 45 || checkAccountEquity(equityThreshold) || getRSI(D1) > 60)
      && (getRSI(H4) > 35 || getRSI(D1) > 60)
      && (isThisBarBEARISH(60) || isThisBarBEARISH(30))
      && (isThisBarBEARISH(D1) || isThisBarBEARISH(30))
      && (isThisBarBEARISH(9997) || isThisBarBEARISH(30))
      && getMA(M5, _9) > getHighestPrice(5,1)
      && getMA(M5, _9) > getHighestPrice(5,1)
      && getMA(M1, _20) - getMA(M1, _9) > 2
      && getMA(M1, _50) - getMA(M1, _9) > 2
      && getMA(M1, _50) - getMA(M1, _20) > 2
      && MAConditionsForSellOrder()
      && shouldAllowSellFromRSI[M1]
   )
     {
      placeSellOrder(orderLots, "SellRD", MILLIONDOLLARBOT);
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
      && (getRSI(M1) > 30 || getRSI(M15) > 60 || getRSI(D1) > 60)
      && (getRSI(M1) > 33 || getRSI(M5) > 35 || getRSI(D1) > 60)
      && (getRSI(M1) > 45 || checkAccountEquity(equityThreshold) || getRSI(D1) > 60)
      && (getRSI(M5) > 45 || checkAccountEquity(equityThreshold) || getRSI(D1) > 60)
      && (getRSI(M15) > 45 || checkAccountEquity(equityThreshold) || getRSI(D1) > 60)
      && (getRSI(M5) > 40 || getMA(M15, _50) > getHighestPrice(15,1))
      && (isThisBarBEARISH(60) || isThisBarBEARISH(30))
      && (isThisBarBEARISH(D1) || isThisBarBEARISH(60))
      && (isThisBarBEARISH(9997) || isThisBarBEARISH(30))
      && getMA(M5, _9) > getHighestPrice(5,1)
      && getMA(M5, _9) > getHighestPrice(5,1)
// && (getMA(M1, _9) > getHighestPrice(1,1) || checkAccountEquity(1000))
      && getMA(M1, _20) > getHighestPrice(1,1)
      && getMA(M1, _20) - getMA(M1, _9) > 2
      && getMA(M1, _50) - getMA(M1, _9) > 2
      && getMA(M1, _50) - getMA(M1, _20) > 2
      && MAConditionsForSellOrder()
      && (getRSI(M1) > 65 || getRSI(D1) > 65)
      && (getRSI(M1) > 35 || getRSI(M15) > 55)
      && (getRSI(M5) > 35 || getRSI(M15) > 55)
      && (getRSI(M15) > 35 || getRSI(D1) > 80)
   )
     {
      placeSellOrder(orderLots, "SellRMD", MILLIONDOLLARBOT);
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
      && (getRSI(M1) > 40 || getRSI(M5) > 45 || getRSI(M15) > 50 || getRSI(D1) > 60)
      && (getRSI(M1) > 55 || (getMA(M1, _50) > getMA(M1, _9) && getMA(M1, _50) > getMA(M1, _20)) || getRSI(D1) > 60)
      && (getRSI(M5) > 45 || getRSI(D1) > 60)
      && (getRSI(M5) > 55 || checkAccountEquity(equityThreshold) || getRSI(D1) > 60)
      && (getRSI(M15) > 50 || checkAccountEquity(equityThreshold) || getRSI(D1) > 60)
      && (getRSI(M30) > 50 || checkAccountEquity(equityThreshold) || getRSI(D1) > 60)
      && (getRSI(H1) > 50 || checkAccountEquity(equityThreshold) || getRSI(D1) > 60)
      && (getRSI(W1) > 40 || getRSI(D1) > 60)
      && (isThisBarBEARISH(60) || isThisBarBEARISH(30))
      && (isThisBarBEARISH(D1) || isThisBarBEARISH(60))
      && (isThisBarBEARISH(9997) || isThisBarBEARISH(30))
      && (getRSI(M1) > 50 || getRSI(D1) > 60)
      && getMA(M1, _9) > getHighestPrice(1,1)
      && getMA(M1, _20) > getHighestPrice(1,1)
      && getMA(M1, _50) > getHighestPrice(1,1)
      && getMA(M1, _200) > getHighestPrice(1,1)
      && getMA(M5, _200) > getHighestPrice(1,1)
      && getMA(M15, _50) > getHighestPrice(1,1)
      && getMA(M1, _9) > getHighestPrice(1,1)
      && getMA(M1, _20) > getHighestPrice(1,1)
      && getMA(M1, _50) > getHighestPrice(1,1)
      && (isDowntrendFromSlope() || isCurrentDowntrend())
      && (getRSI(M1) > 65 || getRSI(D1) > 65)
      && (getRSI(M1) > 35 || getRSI(M15) > 55)
      && (getRSI(M5) > 35 || getRSI(M15) > 55)
      && (getRSI(M15) > 35 || getRSI(D1) > 80)
   )
     {
      placeSellOrder(orderLots, "SellRMD2", MILLIONDOLLARBOT);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenRSIMAStoch()
  {
   if(
      isThisBarBEARISH()
      && isThisBarBEARISH(5)
      && isThisBarBEARISH(15)
      && getBarSize(15) > 10
      && isThisBarBEARISH(30)
      && getBarSize(30) > 10
      && isThisBarBEARISH(60)
      && getBarSize(60) > 20
      && isThisBarBEARISH(240)
      && getBarSize(240) > 30
      && isThisBarBEARISH(999)
      && getBarSize(999) > 40
      && shouldAllowSellFromRSI[M1]
      && getMA(H4, _20) > getHighestPrice(240,1)
      && getMA(H4, _50) > getHighestPrice(240,1)
      && getMA(H1, _200) > getHighestPrice(60,1)
      && getMA(M30, _200) > getHighestPrice(30,1)
      && getMA(M15, _50) > getHighestPrice(15,1)
      && (getMA(M15, _20) > getHighestPrice(15,1) || getMA(M15, _9) > getHighestPrice(15,1))
      && getMA(M1, _9) > getHighestPrice(1,1)
      && getMA(M1, _20) > getHighestPrice(1,1)
      && getMA(M1, _50) > getHighestPrice(1,1)
      && getMA(M1, _200) > getHighestPrice(1,1)
      && getMA(M1, _50) > getMA(M1, _20)
      && getMA(M1, _50) > getMA(M1, _9)
      && getStochasticMain(15) > 20
      && getStochasticMain(30) > 20
      && ((getRSI(M1) > 55 && getRSI(M5) > 55) || getRSI(D1) > 60)
      && ((getRSI(M15) > 55 && getRSI(M30) > 55) || getRSI(D1) > 60)
      && ((getRSI(H1) > 50 && getRSI(H4) > 50) || getRSI(D1) > 60)
      && ((getRSI(D1) > 50 && getRSI(W1) > 50) || getRSI(D1) > 60)
   )
     {
      placeSellOrder(orderLots, "SellRMS", MILLIONDOLLARBOT);
     }
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy()
  {
   if(
      isThisBarBULLISH(240)
      && isThisBarBULLISH(60)
      && isThisBarBULLISH(30)
      && (howClose[H4] > 7 || isThisBarBULLISH(9997))
      && ((getRSI(M1) < 20 || getRSI(M5) < 30 || getRSI(M15) < 30 || getRSI(M30) < 30 || getRSI(H1) < 30 || getRSI(H4) < 30 || getRSI(W1) < 30)
          || (isThisBarBULLISH(15) && isThisBarBULLISH(30) && isThisBarBULLISH(60) && getRSI(M1) < 35)
         )
      && ((getRSI(M1) < 60 && getRSI(M5) < 60 && getRSI(M15) < 60 && getRSI(M30) < 60 && getRSI(H1) < 60 && getRSI(H4) < 60 && getRSI(W1) < 60) || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
      && getMA(M30, _9) < getLowestPrice(30, 1)
      && getMA(M30, _20) < getLowestPrice(30, 1)
      && getMA(M30, _200) < getLowestPrice(30, 1)
      && (getMA(M15, _200) < getLowestPrice(15, 1) || getMA(M15, _50) < getLowestPrice(15, 1))
      && (getMA(M15, _50) < getLowestPrice(15, 1) || getMA(M15, _200) < getLowestPrice(15, 1))
      && ((getMA(M15, _9) < getLowestPrice(15, 1) && getMA(M15, _20) < getLowestPrice(15, 1))
          || (isThisBarBULLISH(5) && isThisBarBULLISH(15) && isThisBarBULLISH(30) && isThisBarBULLISH(60) && checkAccountEquity(5000)))
      && (getRSI(M1) < 30 || steps > 30 || getRSI(D1) < 40)
      && (getRSI(M5) < 40 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
   )
     {
      placeBuyOrder(orderLots, "Buy", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy2()
  {
   if(
      ((isThisBarBULLISH(240) && getBarSize(240) > 20) || (isThisBarBULLISH(9997) && getBarSize(9997) > 20))
      && (getRSI(M1) < 20 || getRSI(M5) < 20 || getRSI(M15) < 20 || getRSI(M30) < 20 || getRSI(H1) < 20 || getRSI(H4) < 20 || getRSI(W1) < 20 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
      && (getMA(H1, _20) < getLowestPrice(60, 1) || checkAccountEquity(equityThreshold))
      && (getMA(H1, _50) < getLowestPrice(60, 1) || checkAccountEquity(equityThreshold))
      && (getMA(M5, _9) < getLowestPrice(5, 1) || getMA(M1, _50) < getLowestPrice(1, 1))
      && (getMA(M5, _20) < getLowestPrice(5, 1) || getMA(M1, _50) < getLowestPrice(1, 1))
      && (getRSI(M1) < 50 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
      && (getRSI(M5) < 50 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
      && (getRSI(M15) < 60 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
      && (getMA(M1, _200) < getLowestPrice(1,1) && getMA(M1, _500) < getLowestPrice(1,1))
      && getMA(M1, _20) < getLowestPrice(1,1)
      && getMA(M1, _9) < getLowestPrice(1,1)

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
      && isThisBarBULLISH(30)
      && isThisBarBULLISH(240)
      && isThisBarBULLISH(999)
      && (getRSI(M1) < 5 || getRSI(M5) < 10 || getRSI(M15) < 10 || getRSI(M30) < 10 || getRSI(H1) < 10 || getRSI(H4) < 10 || getRSI(W1) < 10 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
      && (getMA(M5, _9) < getLowestPrice(5, 1) || getMA(M1, _50) < getLowestPrice(1, 1))
      && (getMA(M5, _20) < getLowestPrice(5, 1) || getMA(M1, _50) < getLowestPrice(1, 1))
      && getRSI(H1) < 35
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
      && getMA(H4, _20) > getHighestPrice(240, 1)
      && getRSI(D1) < 47
      && isThisBarBULLISH(30)
      && (isThisBarBULLISH(999) || isThisBarBULLISH(60))
      && (isThisBarBULLISH(999) || getMA(M5, _50) < getLowestPrice(5,1))
      && (getRSI(M1) <= 30 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
      && (getRSI(M5) <= 40 || getRSI(M15) <= 40 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
      && (getMA(M5, _50) < getLowestPrice(5,1) || isThisBarBULLISH(9997))
      && (getMA(M1, _50) < getLowestPrice(1, 1) || getMA(M1, _200) < getLowestPrice(1, 1))
      && (getMA(M1, _20) < getLowestPrice(1, 1) || getMA(M1, _200) < getLowestPrice(1, 1))
      && ((getMA(M1, _9) < getLowestPrice(1, 1) && getMA(M1, _20) < getLowestPrice(1, 1))
          || (isThisBarBULLISH(5) || isThisBarBULLISH(15) || isThisBarBULLISH(30) || isThisBarBULLISH(60) || checkAccountEquity(20000)))

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
      (getRSI(M1) < 30 || steps > 30 || getRSI(D1) < 40)
      && (getRSI(M5) < 32 || getRSI(M15) < 32 || getRSI(D1) < 40)
      && getRSI(M5) < 55
      && (getMA(M1, _20) < getLowestPrice(1,1) || getMA(M5, _20) < getLowestPrice(5,1) || getMA(M15, _20) < getLowestPrice(15,1) || getMA(M30, _20) < getLowestPrice(30,1) || getMA(H1, _20) < getLowestPrice(60,1) || getMA(H4, _20) < getLowestPrice(240,1))
      && (getRSI(H1) < 50 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
      && (getRSI(H1) < 45 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
      && (getRSI(MN1) < 60 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
      && getMA(M1, _200) < getLowestPrice(1,2)
      && getMA(M1, _500) < getLowestPrice(1,2)
      && getMA(M5, _9) < getLowestPrice(5,1)
      && getMA(M5, _20) < getLowestPrice(5,1)
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
void CheckForOpenSell_ExtremeRSI()
  {
   if(
      (shouldPrepareForBuyReverse[M1] || shouldPrepareForBuyReverse[M5] || shouldPrepareForBuyReverse[M15])
      && getMA(M1, _9) > getHighestPrice(1, 1)
      && getMA(M1, _20) > getHighestPrice(1, 1)
      && getMA(M1, _50) > getHighestPrice(1, 1)
      && (getMA(M1, _200) > getHighestPrice(1,1) || checkAccountEquity(10000))
      && (getMA(M1, _200) > getMA(M1, _50) || checkAccountEquity(10000))
      && getMA(M1, _50) > getMA(M1, _20)
      && getMA(M5, _20) > getHighestPrice(5, 1)
      && (getRSI(M5) > 45 || getRSI(D1) > 60)
      && (getMA(M30, _20) > getHighestPrice(30,1) || getMA(D1, _50) > getHighestPrice(999,1))
// readd  && (getRSI(M1) > 40 || getRSI(M5) > 65)
//   && getRSI(M15) > 45
//   && getRSI(M30) > 45
   )
     {
      if(_Symbol == "Boom 1000 Index" || _Symbol == "Boom 900 Index")
        {
         if(
            getMA(M1, _50) < getHighestPrice(1, 1)
            || getMA(M5, _9) < getHighestPrice(5,1)
            || getMA(M5, _20) < getHighestPrice(5,1)
            || getMA(M5, _50) < getHighestPrice(5,1)
         )
           {
            // return;
            // ShowAlertWithDelay("low zone");
           }
        }
      placeSellOrder(orderLots, "SellXR", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy_ExtremeRSI()
  {
   if(
      (shouldPrepareForSellReverse[M1] || shouldPrepareForSellReverse[M5] || shouldPrepareForSellReverse[M15])
      &&
      (
         (
            getMA(M1, _9) < getLowestPrice(1, 3)
            && getMA(M1, _20) < getLowestPrice(1, 3)
            && getMA(M1, _50) < getLowestPrice(1, 3)
            && getMA(M1, _200) < getLowestPrice(1, 3)
            && (getRSI(M5) < 45 || isThisBarBULLISH(999))
            && (getRSI(M15) < 50 || isThisBarBULLISH(999))
            && (getRSI(M30) < 50 || isThisBarBULLISH(999))
         )
      )
      && (!(getRSI(D1) > 65 && getRSI(H4) > 65))
      && (!(getRSI(W1) > 65 && getRSI(D1) > 65))
      && (getMA(M5, _50) < getLowestPrice(5,1) || isThisBarBULLISH(9997))
      && (isThisBarBULLISH(240) || isThisBarBULLISH(999))
      && (getMA(M5, _200) < getLowestPrice(5,1) || isThisBarBULLISH(9997))
   )
     {
      if(_Symbol == "Boom 1000 Index" || _Symbol == "Boom 900 Index")
        {
         if(
            getMA(M1, _50) > getLowestPrice(1,1)
            || getMA(M5, _9) > getLowestPrice(5,1)
            || getMA(M5, _20) > getLowestPrice(5,1)
            || getMA(M5, _50) > getLowestPrice(5,1)
         )
           {
            //  return;
            //   ShowAlertWithDelay("low zone");
           }
        }
      placeBuyOrder(orderLots, "BuyXR", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSell_ExtremeRSI2()
  {
   if(
      (shouldPrepareForBuyReverse2[M1] || shouldPrepareForBuyReverse2[M5])
      && getMA(M1, _200) > getHighestPrice(1, 1)
      && getMA(M1, _200) > getMA(M1, _50)
      && getMA(M1, _50) > getMA(M1, _20)
      && getMA(M1, _20) > getMA(M1, _9)
      && getMA(M1, _9) > getHighestPrice(1, 1)
   )
     {
      placeSellOrder(orderLots, "SellXR2", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy_ExtremeRSI2()
  {
   if(
      (shouldPrepareForSellReverse2[M1] || shouldPrepareForSellReverse2[M5] || shouldPrepareForSellReverse2[M15])
      && (getMA(M1, _20) < getLowestPrice(1,1) || getRSI(M5) < 5)
      && (getMA(M1, _50) < getLowestPrice(1,1) || getRSI(M5) < 5)
      && (getMA(M1, _200) < getLowestPrice(1,1) || getRSI(M5) < 5)
      && (getMA(M5, _50) < getLowestPrice(5, 1) || getRSI(M5) < 5)
   )
     {
      placeBuyOrder(orderLots, "BuyXR2", MILLIONDOLLARBOT, 0, true);
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
      if(_Symbol == "Boom 1000 Index" || _Symbol == "Boom 900 Index")
        {
         if(
            (getRSI(M5) < 68 && getRSI(M15) < 70)
            || (getMA(M1, _9) < getHighestPrice(1,1) && getMA(M1, _20) < getHighestPrice(1,1))
            || getMA(M1, _50) < getHighestPrice(1,1)
         )
           {
            //   return;
            // ShowAlertWithDelay("low zone");
           }
        }
      shouldPrepareForBuyReverse3[M1] = true;
     }

   if(
      shouldPrepareForBuyReverse3[M1]
      && getMA(M1, _9) > getHighestPrice(1,3)
      && (getMA(M1, _50) > getHighestPrice(1,1) || getMA(M1, _200) > getHighestPrice(1,1) || getRSI(M1) > 75)
      && (getMA(M1, _20) > getHighestPrice(1,1) || getRSI(M5) > 75)
      && (getRSI(M1) > 55 || getMA(M5, _20) > getHighestPrice(5,1) || getMA(M30, _20) > getHighestPrice(30,1) || getMA(H1, _20) > getHighestPrice(60,1) || getRSI(D1) > 60)
      && isThisBarBEARISH()
      && isThisBarBEARISH(5)
      && isThisBarBEARISH(15)
      && isThisBarBEARISH(30)
      && getMA(M15, _200) > getHighestPrice(15,1)
      && getRSI(M15) > 40
      && getRSI(M30) > 40
      && (!(getRSI(M1) < 55 && getMA(M1, _500) < getLowestPrice(1, 1)))
   )
     {
      placeSellOrder(orderLots, "SellXR3", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy_ExtremeRSI3()
  {
// boom!
   if(
      (
         (getRSI(M1) < 25
          && getRSI(M5) <= 30)
         || getRSI(M1) < 3
         || getRSI(M15) <= 30
         || getRSI(M30) <= 30
         || getRSI(H1) <= 30
         || getRSI(H4) <= 30
         || getRSI(D1) < 40
      )
      && (steps > 20 || getRSI(M1 <= 2))
   )
     {
      if(_Symbol == "Boom 1000 Index" || _Symbol == "Boom 900 Index")
        {
         if(getRSI(M1) > 20 && getRSI(M5) > 30 && getRSI(M15) > 30)
           {
            // ShowAlertWithDelay("low zone");
            //return;
           }
        }
      shouldPrepareForSellReverse3[M1] = true;
     }

   if(
      shouldPrepareForSellReverse3[M1]
      && getMA(M1, _9) < getLowestPrice(1,1)
      && getMA(M1, _20) < getLowestPrice(1,1)
      && getMA(M1, _50) < getLowestPrice(1,1)
      && getMA(M1, _200) < getLowestPrice(1,1)
      && getMA(M1, _500) < getLowestPrice(1,1)
      && getMA(M5, _50) < getLowestPrice(1,1)
//&& (getRSI(M1) < 40 || getRSI(D1) < 40)
      && getRSI(M5) < 50
      && (getRSI(M15) < 50 || getRSI(D1) < 40)
      && (getRSI(M1) < 40
          || (
             (getRSI(M5) < 55 || getRSI(M15) < 55)
             && getMA(M1, _9) < getLowestPrice(1,1) && getMA(M1, _20) < getLowestPrice(1,1)
          ))
// readd  && (getRSI(M1) < 65 || getRSI(M5) < 40)
   )
     {
      placeBuyOrder(orderLots, "BuyXR3", MILLIONDOLLARBOT, 0, true);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy_ExtremeMA()
  {
   if(
      allMADown()
      && (getRSI(M1) < 60 || getRSI(D1) < 40)
      && (getRSI(M5) < 60 || getRSI(D1) < 40)
      && (getRSI(M15) < 60 || getRSI(D1) < 40)
   )
     {
      placeBuyOrder(orderLots, "BuyXM", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSell_ExtremeMA()
  {
   if(
      allMAUp()
      && (getRSI(M1) > 40 || getRSI(D1) > 60)
      && (getRSI(M5) > 40 || getRSI(D1) > 60)
      && (getRSI(M15) > 40 || getRSI(D1) > 60)
   )
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
      getMA(M5, _9) < getLowestPrice(5,2)
      && getMA(M5, _20) < getLowestPrice(5,2)
      && getMA(M5, _50) < getLowestPrice(5,2)
      && getMA(M5, _50) > getMA(M5, _20)
      && getMA(M5, _50) > getMA(M5, _9)
      && getMA(M5, _20) > getMA(M5, _9)
      && (getRSI(M1) < 60 || getRSI(D1) < 40)
      && (getRSI(M5) < 60 || getRSI(D1) < 40)
      && (getRSI(M15) < 60 || getRSI(D1) < 40)
      && (shouldPrepareForSellReverse[M1] || shouldPrepareForSellReverse[M5] || shouldPrepareForSellReverse[M15])
      && (getMA(M1, _200) < getLowestPrice(1,1) || checkAccountEquity(10000))
   )
     {
      placeBuyOrder(orderLots, "BuyXM2", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |f
//+------------------------------------------------------------------+
void CheckForOpenSell_ExtremeMA2()
  {
   if(
      getMA(M5, _9) > getHighestPrice(5,2)
      && getMA(M5, _20) > getHighestPrice(5,2)
      && getMA(M5, _50) > getHighestPrice(5,2)
      && getMA(M5, _200) > getHighestPrice(5,2)
      && getMA(M5, _9) > getMA(M5, _20)
      && getMA(M5, _9) > getMA(M5, _50)
      && getMA(M5, _20) > getMA(M5, _50)
      && (getMA(M1, _200) > getHighestPrice(1,1) || checkAccountEquity(10000))
      && (getRSI(M1) > 40 || getRSI(D1) > 60)
      && (getRSI(M5) > 40 || getRSI(D1) > 60)
      && (getRSI(M15) > 40 || getRSI(D1) > 60)
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
      getMA(M15, _9) < getLowestPrice(15,2)
      && getMA(M15, _20) < getLowestPrice(15,2)
      && getMA(M15, _50) < getLowestPrice(15,2)
      && getMA(M15, _50) > getMA(M15, _20)
      && getMA(M15, _50) > getMA(M15, _9)
      && getMA(M15, _20) > getMA(M15, _9)
      && getMA(H1, _50) < getLowestPrice(60,2)
      && (getRSI(M1) < 60 || getRSI(D1) < 40)
      && (getRSI(M5) < 60 || getRSI(D1) < 40)
      && (getRSI(M15) < 60 || getRSI(D1) < 40)
      && (shouldPrepareForSellReverse[M1] || shouldPrepareForSellReverse[M5] || shouldPrepareForSellReverse[M15])
      && (isThisBarBULLISH(60) || isThisBarBULLISH(30))
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
      getMA(M15, _9) > getHighestPrice(15,2)
      && getMA(M15, _20) > getHighestPrice(15,2)
      && getMA(M15, _50) > getHighestPrice(15,2)
      && getMA(M15, _9) > getMA(M15, _20)
      && getMA(M15, _9) > getMA(M15, _50)
      && getMA(M15, _20) > getMA(M15, _50)
      && getMA(H1, _50) > getHighestPrice(60,2)
      && isThisBarBEARISH()
      && isThisBarBEARISH(5)
      && isThisBarBEARISH(15)
      && isThisBarBEARISH(30)
      && isThisBarBEARISH(60)
      && (getRSI(M1) > 40 || getRSI(D1) > 60)
      && (getRSI(M5) > 40 || getRSI(D1) > 60)
      && (getRSI(M15) > 40 || getRSI(D1) > 60)
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
      getMA(M30, _9) < getLowestPrice(30,2)
      && getMA(M30, _20) < getLowestPrice(30,2)
      && getMA(M30, _50) < getLowestPrice(30,2)
      && getMA(M30, _50) > getMA(M30, _20)
      && getMA(M30, _50) > getMA(M30, _9)
      && getMA(M30, _20) > getMA(M30, _9)
      && (getRSI(M1) < 60 || getRSI(D1) < 40)
      && (getRSI(M5) < 60 || getRSI(D1) < 40)
      && (getRSI(M15) < 60 || getRSI(D1) < 40)
      && (shouldPrepareForSellReverse[M1] || shouldPrepareForSellReverse[M5] || shouldPrepareForSellReverse[M15])
      && (isThisBarBULLISH(60) || isThisBarBULLISH(30))
      && (getMA(D1, _9) < getLowestPrice(999,1) || getMA(H1, _200) < getLowestPrice(60, 1) || checkAccountEquity(30000))
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
      getMA(M30, _9) > getHighestPrice(30,2)
      && getMA(M30, _20) > getHighestPrice(30,2)
      && getMA(M30, _50) > getHighestPrice(30,2)
      && getMA(M30, _9) > getMA(M30, _20)
      && getMA(M30, _9) > getMA(M30, _50)
      && getMA(M30, _20) > getMA(M30, _50)
      && (getRSI(M1) > 40 || getRSI(D1) > 60)
      && (getRSI(M5) > 40 || getRSI(D1) > 60)
      && (getRSI(M15) > 40 || getRSI(D1) > 60)
      && (getMA(D1, _9) > getHighestPrice(999,1) || getMA(H1, _200) > getHighestPrice(60, 1) || checkAccountEquity(30000))
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
      getMA(H1, _9) < getLowestPrice(60,2)
      && getMA(H1, _20) < getLowestPrice(60,2)
      && getMA(H1, _50) < getLowestPrice(60,2)
      && getMA(H1, _50) > getMA(H1, _20)
      && getMA(H1, _50) > getMA(H1, _9)
      && getMA(H1, _20) > getMA(H1, _9)
      && (getRSI(M1) < 60 || getRSI(D1) < 40)
      && (getRSI(M5) < 60 || getRSI(D1) < 40)
      && (getRSI(M15) < 60 || getRSI(D1) < 40)
      && (shouldPrepareForSellReverse[M1] || shouldPrepareForSellReverse[M5] || shouldPrepareForSellReverse[M15])
      && (isThisBarBULLISH(60) || isThisBarBULLISH(30))
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
      getMA(H1, _9) > getHighestPrice(60,2)
      && getMA(H1, _20) > getHighestPrice(60,2)
      && getMA(H1, _50) > getHighestPrice(60,2)
      && getMA(H1, _9) > getMA(H1, _20)
      && getMA(H1, _9) > getMA(H1, _50)
      && getMA(H1, _20) > getMA(H1, _50)
      && (getMA(M1, _9) > getHighestPrice(1,1) || getMA(M1, _20) > getHighestPrice(1,1))
      && (getMA(M1, _200) > getHighestPrice(1,1) || getRSI(M1) > 80 || getRSI(M5) > 70)
      && (getRSI(M1) > 40 || getRSI(D1) > 60)
      && (getRSI(M5) > 40 || getRSI(D1) > 60)
      && (getRSI(M15) > 40|| getRSI(D1) > 60)
      && (getRSI(D1) > 35 || getRSI(M1) > 60)
      && (getRSI(M1) > 40 || getRSI(M5) > 40 || getRSI(M15) > 55)
   )
     {
      placeSellOrder(orderLots, "SellXM5", MILLIONDOLLARBOT, 0, true);
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

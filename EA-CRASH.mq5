//+------------------------------------------------------------------+
//|                          Vic & Nana Expert Advisor                |
//|            Copyright 2024-2025, Vic & Nancy, LLC                  |
//|                    http://www.github.com/victorekpo               |
//+------------------------------------------------------------------+
#property copyright   "2024-2025, Vic & Nancy"
#property link        "http://www.github.com/victorekpo"
#property description "Million Dollar BOT for CRASH Index"

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
//Comment("recentprofit ", calculateSymbolProfitRecent(), " shouldBEAR: ", shouldAllowFromBEAR, " shouldRSI: ", shouldAllowBuyFromRSI, " shouldRSI_5: ", shouldAllowBuyFromRSI5, " shouldRSI_15: ", shouldAllowBuyFromRSI15, " shouldRSI_30: ", shouldAllowBuyFromRSI30, " shouldRSI_60: ", shouldAllowBuyFromRSI60, " shouldRSI_240: ", shouldAllowBuyFromRSI240, " bar size 15 ", getBarSize(15), " bar size 30 ", getBarSize(30), " bar size 60 ", getBarSize(60), " bar size 4hr ", getBarSize(240), " bar size 999 ", getBarSize(999), " how_close_999_h_l ", howClosetoHigh_999, " / ", howClosetoLow_999, " how_close_240 ", howClosetoHigh_240, " / ", howClosetoLow_240, " how_close_60 ", howClosetoHigh_60, " / ", howClosetoLow_60, " how_close ", howClosetoHigh, " / ", howClosetoLow, " MAXOrders ", MAXOrders, " percClose 999 ",percClose_999, " percClose 240 ",percClose_240, " percClose 60 ",percClose_60, " percClose_30 ", percClose_30,  " percClose_15 ", percClose_15, " percClose_5 ", percClose_5, " percClose ", percClose, " isTrend? ", isBoomTrendingDown);
//  Comment(rsiVelocity, " ", priceVelocity);
   Comment("howClose, M1: ",howClose[M1],
           " M5: ",howClose[M5],
//       " M15: ",howClose[M15],
//       " M30: ",howClose[M30],
//       " H1: ",howClose[H1],
//       " H4: ",howClose[H4],
//       " D: ",howClose[D1],
//       " W: ",howClose[W1],
//       " MN: ",howClose[MN1],
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

   if(checkAccountEquity(50))
     {
      doubleUpOrders();
     }

// take orders
   if(checkAccountEquity(5))
     {

      //  if(!isRangingBuy() || true)
      //    {
      CheckForInitialBuy1();
      CheckForInitialBuy2();
      CheckForOpenMAConditions();
      CheckForOpenRSIConditions();
      CheckForOpenMARSIConditions();
      CheckForOpenBuy();
      CheckForOpenBuyDaily_Bear();
      CheckForOpenBuyMA_Driven();
      CheckForOpenBuyMA_Driven2();
      CheckForOpenBuyRSI_Driven();
      CheckForOpenBuyRSI_MA_Driven();
      CheckForOpenBuyRSI_MA_Driven2();
      CheckForOpenRSIMAStoch();
      CheckForOpenBuy_ExtremeRSI();
      CheckForOpenBuy_ExtremeRSI2();
      CheckForOpenBuy_ExtremeRSI3();
      CheckForOpenBuy_ExtremeMA();
      CheckForOpenBuy_ExtremeMA2();
      CheckForOpenBuy_ExtremeMA3();
      CheckForOpenBuy_ExtremeMA4();
      CheckForOpenBuy_ExtremeMA5();
      //   }
     }

   if(checkAccountEquity(50))
     {
      // if(!isRangingSell() || true)
      //   {
      CheckForInitialSell1();
      CheckForInitialSell2();
      CheckForOpenSell();
      CheckForOpenSell2();
      CheckForOpenSell3();
      CheckForOpenSell4();
      CheckForOpenSell5();
      CheckForOpenSell_ExtremeRSI();
      CheckForOpenSell_ExtremeRSI2();
      CheckForOpenSell_ExtremeRSI3();
      CheckForOpenSell_ExtremeMA();
      CheckForOpenSell_ExtremeMA2();
      CheckForOpenSell_ExtremeMA3();
      CheckForOpenSell_ExtremeMA4();
      CheckForOpenSell_ExtremeMA5();
      //    }
     }

//Alert("MA 1,9: ",getMA(M1,_9));
// Alert("RSI: ", getRSI(M1));
   if(checkAccountEquity(1000))
     {
      HandleReversals();
      HandleStopLoss();
     }

//if(clock.sec == 0 && clock.min == 0)
//  {
//   deleteAllPendingBuyLimit();
//   deleteAllPendingSellLimit();
//  }
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
      (isUptrendFromSlope() || (getRSI(M30) < 45 && getRSI(H1) < 45 && getRSI(M15) < 50) || getRSI(W1) < 40)
//     && (isCurrentUptrend() || getMA(D1, _9) < getLowestPrice(999, 1))
      && !isThisBarBEARISH()
      && (!isThisBarBEARISH(5) || getRSI(D1) < 40)
      && (!isThisBarBEARISH(15) || getMA(D1, _9) < getLowestPrice(999, 1))
      && (!isThisBarBEARISH(30) || getMA(D1, _9) < getLowestPrice(999, 1))
      && (!isThisBarBEARISH(60) || getMA(D1, _9) < getLowestPrice(999, 1))
      && (!isThisBarBEARISH(60) || getMA(M5, _20) < getLowestPrice(5,1) || isThisBarBULLISH(30))
      && (getRSI(M1) < 90 || getRSI(D1) < 35 || getRSI(W1) < 40)
      && (getRSI(M1) < 90 || (isBullish && getRSI(D1) < 45) || getRSI(W1) < 40)
      && (getRSI(M5) < 70 || (isBullish && getRSI(D1) < 45) || getRSI(W1) < 40)
      && getRSI(M15) < 70
      && (getRSI(M15) < 55 || (isBullish && getRSI(D1) < 45) || getRSI(W1) < 40)
      && getRSI(M30) < 70
      && getRSI(H1) < 65
      && getRSI(H4) < 65
      && getRSI(D1) < 65
      && (!isThisBarBEARISH(240) || getMA(M30, _9) < getHighestPrice(30,2) || getMA(M15, _20) < getHighestPrice(15,2) || getMA(M5, _50) < getHighestPrice(5,2) || getMA(M1, _200) < getHighestPrice(1,5) || (getRSI(D1) < 50 && getRSI(H4) < 50 && getRSI(H1) < 50 && getRSI(M30) < 55 && getRSI(M15) < 55 && getRSI(M5) < 60))
      && (getRSI(M1) < 70 || getMA(M1, _200) < getLowestPrice(1,1) || getMA(H1, _9) < getLowestPrice(60,1) || (getRSI(D1) < 50 && getRSI(H4) < 50 && getRSI(H1) < 50 && getRSI(M30) < 55 && getRSI(M15) < 55 && getRSI(M5) < 60))
      && (getMA(M5, _50) < getLowestPrice(5,1) || getMA(M30, _20) < getLowestPrice(30,1) || getMA(D1, _50) < getLowestPrice(999,1) || (getRSI(D1) < 50 && getRSI(H4) < 50 && getRSI(H1) < 50 && getRSI(M30) < 55 && getRSI(M15) < 55 && getRSI(M5) < 60))
      && (!isThisBarBEARISH(999) || getMA(M5, _50) < getLowestPrice(5,1) || getMA(M15, _20) < getLowestPrice(15,1) || getMA(M30, _9) < getLowestPrice(30,1) || (getRSI(D1) < 50 && getRSI(H4) < 50 && getRSI(H1) < 50 && getRSI(M30) < 55 && getRSI(M15) < 55 && getRSI(M5) < 60))
      && (!isThisBarBEARISH(999) || getMA(M5, _20) < getLowestPrice(5,1) || getMA(M15, _9) < getLowestPrice(15,1) || !isThisBarBEARISH(30) || !isThisBarBEARISH(9997) || (getRSI(D1) < 50 && getRSI(H4) < 50 && getRSI(H1) < 50 && getRSI(M30) < 55 && getRSI(M15) < 55 && getRSI(M5) < 60))
      && (getMA(M5, _9) < getLowestPrice(5,3) || getMA(M5, _20) < getLowestPrice(5,2) || getMA(M15, _50) < getLowestPrice(15,1) || getMA(D1, _50) < getLowestPrice(999,1) || (getRSI(D1) < 50 && getRSI(H4) < 50 && getRSI(H1) < 50 && getRSI(M30) < 55 && getRSI(M15) < 55 && getRSI(M5) < 60))
      && (getMA(M5, _200) < getLowestPrice(5,1) || getMA(M15, _50) < getLowestPrice(15,1) || getMA(M30, _50) < getLowestPrice(30,1) || getMA(H1, _20) < getLowestPrice(60,1) || isThisBarBULLISH(999) || isThisBarBULLISH(9997) || (getRSI(D1) < 50 && getRSI(H4) < 50 && getRSI(H1) < 50 && getRSI(M30) < 55 && getRSI(M15) < 55 && getRSI(M5) < 60))
// && !(getRSI(M1 > 80) && getRSI(M5) > 55)
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
      // Reverse and take sell orders
      if(
         getMA(M1, _500) > getHighestPrice(1,1)
         && getMA(M1, _200) > getLowestPrice(1,1)
         && getMA(M5, _200) > getHighestPrice(5,1)
         && getMA(M15, _50) > getHighestPrice(15,1)
         && getMA(M15, _200) > getHighestPrice(15,1)
         && getMA(M30, _20) > getHighestPrice(30,1)
         && getMA(M30, _50) > getHighestPrice(30,1)
         && getMA(M30, _200) > getHighestPrice(30,1)
         && getMA(H1, _20) > getHighestPrice(60,1)
         && getMA(H1, _50) > getHighestPrice(60,1)
         && getMA(H1, _200) > getHighestPrice(60,1)
         && getMA(H4, _9) > getHighestPrice(240,1)
         && getMA(H4, _20) > getHighestPrice(240,1)
         && getMA(H4, _50) > getHighestPrice(240,1)
         && getMA(H4, _200) > getHighestPrice(240,1)
         && getMA(D1, _9) > getHighestPrice(999,1)
         && getMA(D1, _20) > getHighestPrice(999,1)
         && getRSI(M1) > 30
         && getRSI(M5) > 50
         && getRSI(M15) > 45
         && getRSI(M30) > 39
         && isThisBarBEARISH(240,1)
         && isThisBarBEARISH(999,1)
         && isThisBarBEARISH(9997)
      )
        {
         placeSellOrder(orderLots, "TESTSELL3b", 111);
         return;
        }



      if(
         (getRSI(M1 > 80) && getRSI(M5) > 55)
         ||
         (
            (getMA(M1, _20) > getHighestPrice(1,1) && getMA(M1, _50) > getHighestPrice(1,1))
            && getMA(M30, _9) > getHighestPrice(30,1) && getMA(M30, _20) > getHighestPrice(30,1)
         )
         || (getRSI(M1) > 70 && getRSI(M5) > 60 && getRSI(M15) > 60 && getMA(M15, _200) > getHighestPrice(15,1))
         || (getRSI(W1) > 70 && getRSI(D1) > 55 && getRSI(M5) > 45 && getRSI(M1) > 60 && getMA(D1, _9) > getHighestPrice(999,1) && getMA(H4, _9) > getHighestPrice(240,1) && getMA(H4, _50) > getHighestPrice(240,1) && getMA(M15, _200) > getHighestPrice(15,1) && getMA(M5, _200) > getHighestPrice(5,1))
      )
        {
         if(isThisBarBEARISH(30) && isThisBarBEARISH(60) && isThisBarBEARISH(240))
           {
            if(getMA(M1, _50) > getHighestPrice(1,1) && getMA(M5, _50) > getHighestPrice(5,1))
              {
               placeSellOrder(orderLots, "TESTSELL3", 111);
              }
           }

         return;
        }

      placeBuyOrder(orderLots, "TESTBUY1", 111);
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
      (isCurrentUptrend() || (getRSI(M30) < 45 && getRSI(H1) < 45 && getRSI(M15) < 50) || getRSI(W1) < 40)
      && isThisBarBULLISH()
      && (isThisBarBULLISH(15) || getMA(M5, _9) < getLowestPrice(5,1))
      && (isThisBarBULLISH(15) || getRSI(D1) < 30)
      && (isThisBarBULLISH(30) || getMA(M15, _9) < getLowestPrice(5,1))
      && (isThisBarBULLISH(60) || getRSI(D1) < 30)
      && (isThisBarBULLISH(999) || getRSI(D1) < 30)
      && (isThisBarBULLISH(60) || isThisBarBULLISH(240) || isThisBarBULLISH(999) || getMA(M1, _9) < getLowestPrice(1,1) || getMA(M1, _20) < getLowestPrice(1,1) || getMA(M5, _9) < getLowestPrice(5,1) || getMA(M5, _20) < getLowestPrice(5,1))
      && (getRSI(M1) < 78 || (isBullish && getRSI(D1) < 45))
      && (getRSI(M5) < 68 || (isBullish && getRSI(D1) < 45))
      && getRSI(M15) < 67
      && (getRSI(M15) < 65 || (isBullish && getRSI(D1) < 45))
      && getRSI(M30) < 65
      && getRSI(H1) < 65
      && getRSI(H4) < 65
      && getRSI(D1) < 60
      && (getMA(M1, _50) < getMA(M1,_9) || getRSI(M1) < 55 || checkAccountEquity(20000))
      && (getMA(M15, _9) < getLowestPrice(15,1) || getMA(M15, _20) < getLowestPrice(15,1) || getMA(M15, _50) < getLowestPrice(15,1) || isThisBarBULLISH(240))
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
      // Reverse and take sell orders
      if(
         (getRSI(M1 > 80) && getRSI(M5) > 55)
         ||
         (
            (getMA(M1, _20) > getHighestPrice(1,1) && getMA(M1, _50) > getHighestPrice(1,1))
            && getMA(M30, _9) > getHighestPrice(30,1) && getMA(M30, _20) > getHighestPrice(30,1)
         )
         || (getRSI(M1) > 70 && getRSI(M5) > 60 && getRSI(M15) > 60 && getMA(M15, _200) > getHighestPrice(15,1))
      )
        {
         if(isThisBarBEARISH(30) && isThisBarBEARISH(60) && isThisBarBEARISH(240))
           {
            if(getMA(M1, _50) < getHighestPrice(1,1) && getMA(M5, _50) < getHighestPrice(5,1))
              {
               placeSellOrder(orderLots, "TESTSELL4", 111);
              }
           }

         return;
        }

      placeBuyOrder(orderLots, "TESTBUY2", 111);
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
      (isDowntrendFromSlope()  || (getRSI(M30) > 55 && getRSI(H1) > 55 && getRSI(M15) > 50))
//    && (isCurrentDowntrend() || getMA(D1, _9) > getHighestPrice(999, 1))
      && !isThisBarBULLISH()
      && (!isThisBarBULLISH(5) || getRSI(D1) > 60)
      && (!isThisBarBULLISH(15) || getMA(D1, _9) > getHighestPrice(999, 1))
      && (!isThisBarBULLISH(30) || getMA(D1, _9) > getHighestPrice(999, 1))
      && (!isThisBarBULLISH(60) || getMA(D1, _9) > getHighestPrice(999, 1))
      && (getRSI(M1) > 43 || (isBearish && getRSI(D1) > 75))
      && (getRSI(M5) > 53 || (isBearish && getRSI(D1) > 75))
      && getRSI(M15) > 44
      && (getRSI(M15) > 50 || (isBearish && getRSI(D1) > 75))
      && getRSI(M30) > 50
      && getRSI(H1) > 50
      && getRSI(H4) > 50
      && getRSI(D1) > 50
      && (getMA(M5, _9) > getHighestPrice(5,2) || getMA(M5, _20) > getHighestPrice(5,1))
      && (getMA(M5, _50) > getHighestPrice(5,1) || getMA(M30, _20) > getHighestPrice(30,1) || getMA(D1, _50) > getHighestPrice(999,1))
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
      placeSellOrder(orderLots, "TESTSELL1", 222);
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
      isCurrentDowntrend()
      && isThisBarBEARISH()
      && (isThisBarBEARISH(15) || getRSI(D1) > 70)
      && (isThisBarBEARISH(60) || getRSI(D1) > 70)
      && (isThisBarBEARISH(999) || getRSI(D1) > 70)
      && (getRSI(M1) > 23 || (isBearish && getRSI(D1) > 55))
      && (getRSI(M5) > 33 || (isBearish && getRSI(D1) > 55))
      && getRSI(M15) > 34
      && (getRSI(M15) > 35 || (isBearish && getRSI(D1) > 55))
      && getRSI(M30) > 35
      && getRSI(H1) > 35
      && getRSI(H4) > 35
      && getRSI(D1) > 40
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
      placeSellOrder(orderLots, "TESTSELL2", 222);
     }

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenMAConditions()
  {
   if(
      baseConditionsForBuyOrder()
      && MAConditionsForBuyOrder()
      && shouldAllowBuyFromRSI[M1]
      && isThisBarBULLISH()
      && (getRSI(M1) < 55 || getRSI(D1) < 40)
      && (getMA(D1, _20) < getLowestPrice(9991, 1) || checkAccountEquity(10000))
      && (getMA(H4, _200) < getLowestPrice(240, 1) || checkAccountEquity(10000))
      && (getMA(H1, _500) < getLowestPrice(60, 1) || checkAccountEquity(10000))
      && getMA(M5, _20) < getLowestPrice(5, 1)
      && getMA(M1, _200) < getLowestPrice(1,1) // cascade MAs
      && getMA(M1, _200) < getMA(M1, _50)
      && getMA(M1, _50) < getMA(M1, _20)
      && getMA(M1, _20) < getMA(M1, _9)
      && getMA(M1, _9) < getLowestPrice(1,1)
   )
     {
      placeBuyOrder(orderLots, "BuyMA", 100);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenRSIConditions()
  {
   if(
      baseConditionsForBuyOrder()
      && RSIConditionsForBuyOrder()
      && !(getMA(M1, _20) > getLowestPrice(1, 1))
      && !(getMA(M1, _50) > getLowestPrice(1, 1))
      && !(getMA(M1, _200) > getHighestPrice(1, 1))
      && !(getMA(M30, _50) > getHighestPrice(1, 1))
      && isThisBarBULLISH()
      && ((isThisBarBULLISH(5) && isThisBarBULLISH(15))
          || getMA(M30, _50) < getLowestPrice(30, 1))
   )
     {
      placeBuyOrder(orderLots, "BuyRSI", 200);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenMARSIConditions()
  {
   if(
      baseConditionsForBuyOrder()
      && MAConditionsForBuyOrder()
      && RSIConditionsForBuyOrder()
      && isThisBarBULLISH()
      && getMA(M1, _50) < getLowestPrice(1,1)
      && (getRSI(M1) < 45 || getMA(M1, _500) < getLowestPrice(1,1) || getMA(M5, _200) < getLowestPrice(5,1) || getMA(M15, _50) < getLowestPrice(15,1) || getRSI(D1) < 40)
   )
     {
      placeBuyOrder(orderLots, "BuyMARSI", 300);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy()
  {
   if(
      baseConditionsForBuyOrder()
      && isThisBarBULLISH()
      && (isThisBarBULLISH(999) || isThisBarBULLISH(240))
      && MAConditionsForBuyOrder()
      && RSIConditionsForBuyOrder()
      && (getRSI(M1) < 45 || getMA(M1, _500) < getLowestPrice(1,1) || getMA(M5, _200) < getLowestPrice(5,1) || getMA(M15, _50) < getLowestPrice(15,1) || getRSI(D1) < 40)
   )
     {
      placeBuyOrder(orderLots, "Buy", MILLIONDOLLARBOT);
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
      && (getRSI(M1) < 45 || getMA(M1, _500) < getLowestPrice(1,1) || getMA(M5, _200) < getLowestPrice(5,1) || getMA(M15, _50) < getLowestPrice(15,1) || getRSI(D1) < 40)
   )
     {
      placeBuyOrder(orderLots, "BuyDB", MILLIONDOLLARBOT);
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
      && (isThisBarBULLISH(240) || getMA(H4, _20) < getLowestPrice(240, 1) || getMA(M30, _200) < getLowestPrice(30, 1) || getMA(M5, _50) < getMA(M5, _20))
      && getBarSize(15) > 3
      && (getRSI(M1) < 50 || getRSI(D1) < 40)
      && (getRSI(M5) < 50 || getRSI(D1) < 40)
      && (getRSI(M15) < 50 || getRSI(D1) < 40)
      && (getRSI(M30) < 50 || getRSI(D1) < 40)
      && (getRSI(H1) < 55 || getRSI(D1) < 40)
      && (getRSI(H4) < 55 || getRSI(D1) < 40)
      && (getRSI(D1) < 55 || getRSI(D1) < 40)
      && (getMA(M30, _20) < getLowestPrice(30,1) || isThisBarBULLISH(240))
      && getMA(M1, _200) < getLowestPrice(1,1)
      && getMA(M1, _50) < getLowestPrice(1,1)
      && getMA(M1, _200) < getMA(M1, _50)
      && getMA(M1, _50) < getMA(M1, _20)
      && getMA(M1, _20) - getMA(M1, _50) > 2
      && getMA(M1, _20) < getMA(M1, _9)
      && getMA(M1, _9) < getLowestPrice(1,1)
      && (getRSI(M1) < 30
          || (
             (getRSI(M5) < 55 || getRSI(M15) < 55)
             && getMA(M1, _9) < getLowestPrice(1,1) && getMA(M1, _20) < getLowestPrice(1,1)
          ))
      && (shouldAllowFromBULL || currentPrice < getMA(M1, _50) || currentPrice < getMA(M1, _200) || (isThisBarBULLISH(240) && isThisBarBULLISH(60) && isThisBarBULLISH(30) && isThisBarBULLISH(15) && currentPrice > getMA(M5, _20) && currentPrice > getMA(M1, _20) && currentPrice > getMA(M1, _9)))
      && howClose[M1] < 0.5
      && howClose[M5] < 2
   )
     {
      placeBuyOrder(orderLots, "BuyMD", MILLIONDOLLARBOT);
     }
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuyMA_Driven2()
  {
   if(
      currentPrice > getMA(M1, _50)
// && (currentPrice > getMA(M1, _9) || checkAccountEquity(1000))
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
      && steps < 350
      && howClose[M5] < 2
      && isThisBarBULLISH()
      && isThisBarBULLISH(5)
      && (currentPrice > getMA(M5, _200) || getMA(M15, _50) < getMA(M15, _20) || getMA(M1, _50) < getMA(M1, _20))
      && getMA(M1, _20) - getMA(M1, _9) < -1
      && getMA(M15, _20) - getMA(M15, _50) < -3
      && (getRSI(M1) < 50 || getRSI(D1) < 40)
      && (getRSI(M5) < 50 || getRSI(D1) < 40)
      && (getRSI(M15) < 50 || getRSI(D1) < 40)
      && (getRSI(M30) < 50 || getRSI(D1) < 40)
      && (getRSI(H1) < 55 || getRSI(D1) < 40)
      && (getRSI(H4) < 55 || getRSI(D1) < 40)
      && (getRSI(D1) < 55 || getRSI(D1) < 40)
   )
     {
      placeBuyOrder(orderLots, "BuyMD2", MILLIONDOLLARBOT);
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
      && (getRSI(M1) < 50 || getRSI(D1) < 40)
      && (getRSI(M1) < 55 || checkAccountEquity(equityThreshold) || getRSI(D1) < 40)
      && (getRSI(M5) < 65 || getRSI(D1) < 40)
      && (getRSI(M5) < 55 || checkAccountEquity(equityThreshold) || getRSI(D1) < 40)
      && (getRSI(M15) < 65 || getRSI(D1) < 40)
      && (getRSI(M15) < 55 || checkAccountEquity(equityThreshold) || getRSI(D1) < 40)
      && (getRSI(M30) < 65 || getRSI(D1) < 40)
      && (getRSI(M30) < 55 || checkAccountEquity(equityThreshold) || getRSI(D1) < 40)
      && (getRSI(H1) < 65 || getRSI(D1) < 40)
      && (getRSI(H1) < 55 || checkAccountEquity(equityThreshold) || getRSI(D1) < 40)
      && (getRSI(H4) < 65 || getRSI(D1) < 40)
      && (isThisBarBULLISH(60) || isThisBarBULLISH(30))
      && (isThisBarBULLISH(999) || isThisBarBULLISH(30))
      && (isThisBarBULLISH(9997) || isThisBarBULLISH(30))
      && getMA(M5, _9) < getLowestPrice(5,1)
      && getMA(M5, _9) < getLowestPrice(5,1)
      && getMA(M1, _9) - getMA(M1, _20) > 2
      && getMA(M1, _9) - getMA(M1, _50) > 2
      && getMA(M1, _20) - getMA(M1, _50) > 2
      && MAConditionsForBuyOrder()
      && shouldAllowBuyFromRSI[M1]
   )
     {
      placeBuyOrder(orderLots, "BuyRD", MILLIONDOLLARBOT);
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
      && (getRSI(M1) < 70 || getRSI(M15) < 40 || getRSI(D1) < 40)
      && (getRSI(M1) < 67 || getRSI(M5) < 65 || getRSI(D1) < 40)
      && (getRSI(M1) < 55 || checkAccountEquity(equityThreshold) || getRSI(D1) < 40)
      && (getRSI(M5) < 55 || checkAccountEquity(equityThreshold) || getRSI(D1) < 40)
      && (getRSI(M15) < 55 || checkAccountEquity(equityThreshold) || getRSI(D1) < 40)
      && (getRSI(W1) < 60 || getRSI(D1) < 40)
      && (getRSI(M5) < 60 || getMA(M15, _50) < getLowestPrice(15,1))
      && (isThisBarBULLISH(60) || isThisBarBULLISH(30))
      && (isThisBarBULLISH(999) || isThisBarBULLISH(60))
      && (isThisBarBULLISH(9997) || isThisBarBULLISH(30))
      && getMA(M5, _9) < getLowestPrice(5,1)
      && getMA(M5, _9) < getLowestPrice(5,1)
//   && (getMA(M1, _9) < getLowestPrice(1,1) || checkAccountEquity(1000))
      && getMA(M1, _20) < getLowestPrice(1,1)
//&& (shouldAllowBuyFromRSI || getMA(M30, _20) < getLowestPrice(30,1))
//&& (shouldAllowBuyFromRSI5 || getMA(M30, _50) < getLowestPrice(30,1))
      && MAConditionsForBuyOrder()
      && (getRSI(M1) < 35 || getRSI(D1) < 40)
      && (getRSI(M1) < 35 || getRSI(D1) < 35)
      && (getRSI(M1) < 65 || getRSI(M15) < 55)
      && (getRSI(M5) < 65 || getRSI(M15) < 55)
      && (getRSI(M15) < 65 || getRSI(D1) < 20)
   )
     {
      placeBuyOrder(orderLots, "BuyRMD", MILLIONDOLLARBOT);
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
      && (getRSI(M1) < 60 || getRSI(M5) < 55 || getRSI(M15) < 50 || getRSI(D1) < 40)
      && (getRSI(M1) < 50 || (getMA(M1, _50) < getMA(M1, _9) && getMA(M1, _50) < getMA(M1, _20)) || getRSI(D1) < 40)
      && (getRSI(M5) < 55 || getRSI(D1) < 40)
      && (getRSI(M5) < 55 || checkAccountEquity(equityThreshold) || getRSI(D1) < 40)
      && (getRSI(M15) < 50 || checkAccountEquity(equityThreshold) || getRSI(D1) < 40)
      && (getRSI(M30) < 50 || checkAccountEquity(equityThreshold) || getRSI(D1) < 40)
      && (getRSI(H1) < 50 || checkAccountEquity(equityThreshold) || getRSI(D1) < 40)
      && (getRSI(W1) < 60 || getRSI(D1) < 40)
      && (isThisBarBULLISH(60) || isThisBarBULLISH(30))
      && (isThisBarBULLISH(999) || isThisBarBULLISH(60))
      && (isThisBarBULLISH(9997) || isThisBarBULLISH(30))
      && (getRSI(M1) < 50 || getRSI(D1) < 40)
      && getMA(M1, _9) < getLowestPrice(1,1)
      && getMA(M1, _20) < getLowestPrice(1,1)
      && getMA(M1, _50) < getLowestPrice(1,1)
      && getMA(M1, _200) < getLowestPrice(1,1)
      && getMA(M5, _200) < getLowestPrice(1,1)
      && getMA(M15, _50) < getLowestPrice(1,1)
      && getMA(M1, _9) < getLowestPrice(1,1)
      && getMA(M1, _20) < getLowestPrice(1,1)
      && getMA(M1, _50) < getLowestPrice(1,1)
      && (getRSI(M1) < 65 || getRSI(M5) < 40)
      && (isUptrendFromSlope() || isCurrentUptrend())
      && (getRSI(M1) < 35 || getRSI(D1) < 35)
      && (getRSI(M1) < 65 || getRSI(M15) < 55)
      && (getRSI(M5) < 65 || getRSI(M15) < 55)
      && (getRSI(M15) < 65 || getRSI(D1) < 20)
   )
     {
      placeBuyOrder(orderLots, "BuyRMD2", MILLIONDOLLARBOT);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenRSIMAStoch()
  {
   if(
      isThisBarBULLISH()
      && isThisBarBULLISH(5)
      && isThisBarBULLISH(15)
      && getBarSize(15) > 10
      && isThisBarBULLISH(30)
      && getBarSize(30) > 10
      && isThisBarBULLISH(60)
      && getBarSize(60) > 20
      && isThisBarBULLISH(240)
      && getBarSize(240) > 30
      && isThisBarBULLISH(999)
      && getBarSize(999) > 40
      && shouldAllowBuyFromRSI[M1]
      && getMA(H4, _20) < getLowestPrice(240,1)
      && getMA(H4, _50) < getLowestPrice(240,1)
      && getMA(H1, _200) < getLowestPrice(60,1)
      && getMA(M30, _200) < getLowestPrice(30,1)
      && getMA(M15, _50) < getLowestPrice(15,1)
      && (getMA(M15, _20) < getLowestPrice(15,1) || getMA(M15, _9) < getLowestPrice(15,1))
      && getMA(M1, _9) < getLowestPrice(1,1)
      && getMA(M1, _20) < getLowestPrice(1,1)
      && getMA(M1, _50) < getLowestPrice(1,1)
      && getMA(M1, _200) < getLowestPrice(1,1)
      && getMA(M1, _50) < getMA(M1, _20)
      && getMA(M1, _50) < getMA(M1, _9)
      && getStochasticMain(15) < 80
      && getStochasticMain(30) < 80
      && ((getRSI(M1) < 50 && getRSI(M5) < 50) || getRSI(D1) < 40)
      && ((getRSI(M15) < 50 && getRSI(M30) < 50) || getRSI(D1) < 40)
      && ((getRSI(H1) < 55 && getRSI(H4) < 55) || getRSI(D1) < 40)
      && ((getRSI(D1) < 60 && getRSI(W1) < 60) || getRSI(D1) < 40)
   )
     {
      placeBuyOrder(orderLots, "BuyRMS", MILLIONDOLLARBOT);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSell()
  {
   if(
      isThisBarBEARISH(240)
      && isThisBarBEARISH(60)
      && isThisBarBEARISH(30)
      && (howClose[H4] < -7 || isThisBarBEARISH(9997))
      && ((getRSI(M1) > 80 || getRSI(M5) > 70 || getRSI(M15) > 70 || getRSI(M30) > 70 || getRSI(H1) > 70 || getRSI(H4) > 70 || getRSI(W1) > 70 || getRSI(D1) > 60)
          || (isThisBarBEARISH(15) && isThisBarBEARISH(30) && isThisBarBEARISH(60) && getRSI(M1) > 65)
         )
      && ((getRSI(M1) > 40 && getRSI(M5) > 40 && getRSI(M15) > 40 && getRSI(M30) > 40 && getRSI(H1) > 40 && getRSI(H4) > 40 && getRSI(W1) > 40) || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
      && getMA(M30, _9) > getHighestPrice(30, 1)
      && getMA(M30, _20) > getHighestPrice(30, 1)
      && getMA(M30, _200) > getHighestPrice(30, 1)
      && (getMA(M15, _200) > getHighestPrice(15, 1) || getMA(M15, _50) > getHighestPrice(15, 1))
      && (getMA(M15, _50) > getHighestPrice(15, 1) || getMA(M15, _200) > getHighestPrice(15, 1))
      && ((getMA(M15, _9) > getHighestPrice(1, 1) && getMA(M15, _20) > getHighestPrice(15, 1))
          || (isThisBarBEARISH(5) && isThisBarBEARISH(15) && isThisBarBEARISH(30) && isThisBarBEARISH(60) && checkAccountEquity(5000)))
      && (getRSI(M1) > 70 || steps > 30 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
      && (getRSI(M5) > 60 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
   )
     {
      placeSellOrder(orderLots, "Sell", MILLIONDOLLARBOT, 0, true);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSell2()
  {
   if(
      ((isThisBarBEARISH(240) && getBarSize(240) > 20) || (isThisBarBEARISH(9997) && getBarSize(9997) > 20))
      && (getRSI(M1) > 80 || getRSI(M5) > 80 || getRSI(M15) > 80 || getRSI(M30) > 80 || getRSI(H1) > 80 || getRSI(H4) > 80 || getRSI(W1) > 80 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
      && (getMA(H1, _20) > getHighestPrice(60, 1) || checkAccountEquity(equityThreshold))
      && (getMA(H1, _50) > getHighestPrice(60, 1) || checkAccountEquity(equityThreshold))
      && (getMA(M5, _9) > getHighestPrice(5, 1) || getMA(M1, _50) > getHighestPrice(1, 1))
      && (getMA(M5, _20) > getHighestPrice(5, 1) || getMA(M1, _50) > getHighestPrice(1, 1))
      && (getRSI(M1) > 55 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
      && (getRSI(M5) > 40 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
      && (getRSI(M15) > 40 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
      && (getMA(M1, _200) > getHighestPrice(1,1) && getMA(M1, _500) > getHighestPrice(1,1))
      && getMA(M1, _20) > getHighestPrice(1,1)
      && getMA(M1, _9) > getHighestPrice(1,1)
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
      && isThisBarBEARISH(30)
      && isThisBarBEARISH(240)
      && isThisBarBEARISH(999)
      && (getRSI(M1) > 95 || getRSI(M5) > 90 || getRSI(M15) > 90 || getRSI(M30) > 90 || getRSI(H1) > 90 || getRSI(H4) > 90 || getRSI(W1) > 90 || getRSI(D1) > 60 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
      && (getMA(M5, _9) > getHighestPrice(5, 1) || getMA(M1, _50) > getHighestPrice(1, 1))
      && (getMA(M5, _20) > getHighestPrice(5, 1) || getMA(M1, _50) > getHighestPrice(1, 1))
      && getRSI(H1) > 65
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
      && getMA(H4, _20) < getLowestPrice(240, 1)
      && getRSI(D1) > 55
      && isThisBarBEARISH(30)
      && (isThisBarBEARISH(999) || isThisBarBEARISH(60))
      && (isThisBarBEARISH(999) || getMA(M5, _50) > getHighestPrice(5,1))
      && (getRSI(M1) >= 70 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
      && (getRSI(M5) >= 60 || getRSI(M15) >= 60 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
      && (getRSI(D1) > 50 || checkAccountEquity(1000) || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
      && (getMA(M5, _50) > getHighestPrice(5,1) || isThisBarBEARISH(9997))
      && (getMA(M1, _50) > getHighestPrice(1, 1) || getMA(M1, _200) > getHighestPrice(1, 1))
      && (getMA(M1, _20) > getHighestPrice(1, 1) || getMA(M1, _200) > getHighestPrice(1, 1))
      && ((getMA(M1, _9) > getHighestPrice(1, 1) && getMA(M1, _20) > getHighestPrice(1, 1))
          || (isThisBarBEARISH(5) || isThisBarBEARISH(15) || isThisBarBEARISH(30) || isThisBarBEARISH(60) || checkAccountEquity(5000)))
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
      (getRSI(M1) > 70 || steps > 30 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
      && (getRSI(M5) > 68 || getRSI(M15) > 68 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
      && getRSI(M5) > 45
      && (getMA(M1, _20) > getHighestPrice(1,1) || getMA(M5, _20) > getHighestPrice(5,1) || getMA(M15, _20) > getHighestPrice(15,1) || getMA(M30, _20) > getHighestPrice(30,1) || getMA(H1, _20) > getHighestPrice(60,1) || getMA(H4, _20) > getHighestPrice(240,1))
      && (getRSI(H1) > 50 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
      && (getRSI(H1) > 55 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
      && getMA(M1, _200) > getHighestPrice(1,2)
      && getMA(M1, _500) > getHighestPrice(1,2)
      && getMA(M5, _9) > getHighestPrice(5,1)
      && getMA(M5, _20) > getHighestPrice(5,1)
      && getStochasticSignal(M5) > getStochasticMain(M5)
      && ((getMA(M1, _9) > getHighestPrice(1, 1) && getMA(M1, _20) > getHighestPrice(1, 1))
          || (isThisBarBEARISH(5) || isThisBarBEARISH(15) || isThisBarBEARISH(30) || isThisBarBEARISH(60) || checkAccountEquity(5000)))
   )
     {
      placeSellOrder(orderLots, "Sell5", MILLIONDOLLARBOT,0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy_ExtremeRSI()
  {
   if(
      (shouldPrepareForSellReverse[M1] || shouldPrepareForSellReverse[M5] || shouldPrepareForSellReverse[M15])
      && getMA(M1, _9) < getLowestPrice(1, 1)
      && getMA(M1, _20) < getLowestPrice(1, 1)
      && getMA(M1, _50) < getLowestPrice(1, 1)
      && (getMA(M1, _200) < getLowestPrice(1,1) || checkAccountEquity(10000))
      && (getMA(M1, _200) < getMA(M1, _50) || checkAccountEquity(10000))
      && getMA(M1, _50) < getMA(M1, _20)
      && getMA(M5, _20) < getLowestPrice(5, 1)
      && (getRSI(M5) < 45 || getRSI(D1) < 40)
      && (getMA(M30, _20) < getLowestPrice(30,1) || getMA(D1, _50) < getLowestPrice(999,1))
      && (isThisBarBULLISH() && isThisBarBULLISH(5) && isThisBarBULLISH(15))
// readd && (getRSI(M1) < 60 || getRSI(M5) < 35)
//   && getRSI(M15) < 45
//   && getRSI(M30) < 45
   )
     {
      if(_Symbol == "Crash 1000 Index" || _Symbol == "Crash 900 Index")
        {
         if(
            getMA(M1, _50) > getLowestPrice(1,1)
            || getMA(M5, _9) > getLowestPrice(5,1)
            || getMA(M5, _20) > getLowestPrice(5,1)
            || getMA(M5, _50) > getLowestPrice(5,1)
         )
           {
            //  return;
            // ShowAlertWithDelay("high zone");
           }
        }
      placeBuyOrder(orderLots, "BuyXR", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenSell_ExtremeRSI()
  {
   if(
      (shouldPrepareForBuyReverse[M1] || shouldPrepareForBuyReverse[M5] || shouldPrepareForBuyReverse[M15])
      &&
      (
         (
            getMA(M1, _9) > getHighestPrice(1, 3)
            && getMA(M1, _20) > getHighestPrice(1, 3)
            && getMA(M1, _50) > getHighestPrice(1, 3)
            && getMA(M1, _200) > getHighestPrice(1, 3)
            && (getRSI(M5) > 65 || isThisBarBEARISH(999) || getRSI(D1) > 60)
            && (getRSI(M15) > 60 || isThisBarBEARISH(999) || getRSI(D1) > 60)
            && (getRSI(M30) > 60 || isThisBarBEARISH(999) || getRSI(D1) > 60)
         )

      )
      && (!(getRSI(D1) < 35 && getRSI(H4) < 35))
      && (!(getRSI(W1) < 35 && getRSI(D1) < 35))
      && (getMA(M5, _50) > getHighestPrice(5,1) || isThisBarBEARISH(9997))
      && (isThisBarBEARISH(240) || isThisBarBEARISH(999))
      && (getMA(M5, _200) > getHighestPrice(5,1) || isThisBarBEARISH(9997))
   )
     {
      if(_Symbol == "Crash 1000 Index" || _Symbol == "Crash 900 Index")
        {
         if(
            getMA(M1, _50) < getHighestPrice(1, 1)
            || getMA(M5, _9) < getHighestPrice(5,1)
            || getMA(M5, _20) < getHighestPrice(5,1)
            || getMA(M5, _50) < getHighestPrice(5,1)
         )
           {
            //  return;
            //  ShowAlertWithDelay("high zone");
           }
        }
      placeSellOrder(orderLots, "SellXR", MILLIONDOLLARBOT, 0, true);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpenBuy_ExtremeRSI2()
  {
   if(
      (shouldPrepareForSellReverse2[M1] || shouldPrepareForSellReverse2[M5] || shouldPrepareForSellReverse2[M15])
      && getMA(M1, _200) < getLowestPrice(1, 1)
      && getMA(M1, _200) < getMA(M1, _50)
      && getMA(M1, _50) < getMA(M1, _20)
      && getMA(M1, _20) < getMA(M1, _9)
      && getMA(M1, _9) < getLowestPrice(1, 1)
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
      (shouldPrepareForBuyReverse2[M1] || shouldPrepareForBuyReverse2[M5] || shouldPrepareForBuyReverse2[M15])
      && (getMA(M1, _20) > getHighestPrice(1,1) || getRSI(M5) > 95)
      && (getMA(M1, _50) > getHighestPrice(1,1) || getRSI(M5) > 95)
      && (getMA(M1, _200) > getHighestPrice(1,1) || getRSI(M5) > 95)
      && (getMA(M5, _50) > getHighestPrice(5,1) || getRSI(M5) > 95)
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
         || getRSI(D1) < 40
      )
   )
     {
      if(_Symbol == "Crash 1000 Index" || _Symbol == "Crash 900 Index")
        {
         if(
            (getRSI(M5) > 32 && getRSI(M15) > 30)
            || (getMA(M1, _9) > getLowestPrice(1,1) && getMA(M1, _20) > getLowestPrice(1,1))
            || getMA(M1, _50) > getLowestPrice(1,1)
         )
           {
            // ShowAlertWithDelay("high zone");
            // return;
           }
        }
      shouldPrepareForSellReverse3[M1] = true;
     }

   if(
      shouldPrepareForSellReverse3[M1]
      && getMA(M1, _9) < getLowestPrice(1,3)
      && (getMA(M1, _50) < getLowestPrice(1,1) || getMA(M1, _200) < getLowestPrice(1,1) || getRSI(M1) < 25)
      && (getMA(M1, _20) < getLowestPrice(1,1) || getRSI(M5) < 25)
      && (getRSI(M1) < 45 || getMA(M5, _20) < getLowestPrice(5,1) || getMA(M30, _20) < getLowestPrice(30,1) || getMA(H1, _20) < getLowestPrice(60,1))
      && isThisBarBULLISH()
      && isThisBarBULLISH(5)
      && isThisBarBULLISH(15)
      && isThisBarBULLISH(30)
      && isThisBarBULLISH(60)
      && getMA(M15, _200) < getLowestPrice(15,1)
      && getRSI(M15) < 60
      && getRSI(M30) < 60
      && (!(getRSI(M1) > 45 && getMA(M1, _500) > getHighestPrice(1, 1)))
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
// crash!
   if(
      (
         (getRSI(M1) > 75
          && getRSI(M5) >= 70)
         || getRSI(M1) > 97
         || getRSI(M15) >= 70
         || getRSI(M30) >= 70
         || getRSI(H1) >= 70
         || getRSI(H4) >= 70
         || getRSI(D1) > 60
      )
      && (steps > 20 || getRSI(M1) >= 98)
   )
     {
      if(_Symbol == "Crash 1000 Index" || _Symbol == "Crash 900 Index")
        {
         if(getRSI(M1) < 80 && getRSI(M5) < 70 && getRSI(M15) < 70)
           {
            //ShowAlertWithDelay("high zone");
            //   return;
           }
        }
      shouldPrepareForBuyReverse3[M1] = true;
     }

   if(
      shouldPrepareForBuyReverse3[M1]
      && getMA(M1, _9) > getHighestPrice(1,1)
      && getMA(M1, _20) > getHighestPrice(1,1)
      && getMA(M1, _50) > getHighestPrice(1,1)
      && getMA(M1, _200) > getHighestPrice(1,1)
      && getMA(M1, _500) > getHighestPrice(1,1)
      && getMA(M5, _50) > getHighestPrice(1,1)
//&& (getRSI(M1) > 60 || getRSI(D1) > 60)
      && getRSI(M5) > 55
      && (getRSI(M15) > 55 || getRSI(D1) > 60)
      && (getRSI(M1) > 60
          || (
             (getRSI(M5) > 45 || getRSI(M15) > 45)
             && getMA(M1, _9) > getHighestPrice(1,1) && getMA(M1, _20) > getHighestPrice(1,1)
          ))
//readd && (getRSI(M1) > 35 || getRSI(M5) > 60)
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
void CheckForOpenSell_ExtremeMA2()
  {
   if(
      getMA(M5, _9) > getHighestPrice(5,2)
      && getMA(M5, _20) > getHighestPrice(5,2)
      && getMA(M5, _50) > getHighestPrice(5,2)
      && getMA(M5, _9) > getMA(M5, _20)
      && getMA(M5, _9) > getMA(M5, _50)
      && getMA(M5, _20) > getMA(M5, _50)
      && (shouldPrepareForBuyReverse[M1] || shouldPrepareForBuyReverse[M5] || shouldPrepareForBuyReverse[M15])
      && (getRSI(M1) > 40 || getRSI(D1) > 60)
      && (getRSI(M5) > 40 || getRSI(D1) > 60)
      && (getRSI(M15) > 40 || getRSI(D1) > 60)
      && (getMA(M1, _200) > getHighestPrice(1,1) || checkAccountEquity(10000))
   )
     {
      placeSellOrder(orderLots, "SellXM2", MILLIONDOLLARBOT, 0, true);
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
      && getMA(M5, _200) < getLowestPrice(5,2)
      && getMA(M5, _50) > getMA(M5, _20)
      && getMA(M5, _50) > getMA(M5, _9)
      && getMA(M5, _20) > getMA(M5, _9)
      && (getRSI(M1) < 60 || getRSI(D1) < 40)
      && (getRSI(M5) < 60 || getRSI(D1) < 40)
      && (getRSI(M15) < 60 || getRSI(D1) < 40)
      && (getMA(M1, _200) < getLowestPrice(1,1) || checkAccountEquity(10000))
   )
     {
      placeBuyOrder(orderLots, "BuyXM2", MILLIONDOLLARBOT, 0, true);
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
      && (getRSI(M1) > 40 || getRSI(D1) > 60)
      && (getRSI(M5) > 40 || getRSI(D1) > 60)
      && (getRSI(M15) > 40 || getRSI(D1) > 60)
      && (shouldPrepareForBuyReverse[M1] || shouldPrepareForBuyReverse[M5] || shouldPrepareForBuyReverse[M15])
      && (isThisBarBEARISH(60) || isThisBarBEARISH(30))
   )
     {
      placeSellOrder(orderLots, "SellXM3", MILLIONDOLLARBOT, 0, true);
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
      && isThisBarBULLISH()
      && isThisBarBULLISH(5)
      && isThisBarBULLISH(15)
      && isThisBarBULLISH(30)
      && isThisBarBULLISH(60)
      && (getRSI(M1) < 60 || getRSI(D1) < 40)
      && (getRSI(M5) < 60 || getRSI(D1) < 40)
      && (getRSI(M15) < 60 || getRSI(D1) < 40)
   )
     {
      placeBuyOrder(orderLots, "BuyXM3", MILLIONDOLLARBOT, 0, true);
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
      && (shouldPrepareForBuyReverse[M1] || shouldPrepareForBuyReverse[M5] || shouldPrepareForBuyReverse[M15])
      && (isThisBarBEARISH(60) || isThisBarBEARISH(30))
      && (getMA(D1, _9) > getHighestPrice(999,1) || getMA(H1, _200) > getHighestPrice(60, 1) || checkAccountEquity(30000))
   )
     {
      placeSellOrder(orderLots, "SellXM4", MILLIONDOLLARBOT, 0, true);
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
      && getMA(M15, _200) < getLowestPrice(15,2)
      && (getRSI(M1) < 60 || getRSI(D1) < 40)
      && (getRSI(M5) < 60 || getRSI(D1) < 40)
      && (getRSI(M15) < 60 || getRSI(D1) < 40)
      && (getMA(D1, _9) < getLowestPrice(999,1) || getMA(H1, _200) < getLowestPrice(60, 1) || checkAccountEquity(30000))
   )
     {
      placeBuyOrder(orderLots, "BuyXM4", MILLIONDOLLARBOT, 0, true);
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
      && (getRSI(M1) > 40 || getRSI(D1) > 60)
      && (getRSI(M5) > 40 || getRSI(D1) > 60)
      && (getRSI(M15) > 40 || getRSI(D1) > 60)
      && (shouldPrepareForBuyReverse[M1] || shouldPrepareForBuyReverse[M5] || shouldPrepareForBuyReverse[M15])
      && (isThisBarBEARISH(60) || isThisBarBEARISH(30))
   )
     {
      placeSellOrder(orderLots, "SellXM5", MILLIONDOLLARBOT, 0, true);
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
      && (getMA(M1, _9) < getLowestPrice(1,1) || getMA(M1, _20) < getLowestPrice(1,1))
      && (getMA(M1, _200) < getLowestPrice(1,1) || getRSI(M1) < 20 || getRSI(M5) < 30)
      && (getRSI(M1) < 60 || getRSI(D1) < 40)
      && (getRSI(M5) < 60 || getRSI(D1) < 40)
      && (getRSI(M15) < 60 || getRSI(D1) < 40)
      && (getRSI(D1) < 65 || getRSI(M1) < 40)
      && (getRSI(M1) < 60 || getRSI(M5) < 60 || getRSI(M15) < 45)
   )
     {
      placeBuyOrder(orderLots, "BuyXM5", MILLIONDOLLARBOT, 0, true);
     }
  }
//+------------------------------------------------------------------+

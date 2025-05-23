//+------------------------------------------------------------------+
//|                          Vic & Nana Expert Advisor                |
//|            Copyright 2024-2025, Vic & Nancy, LLC                  |
//|                    http://www.github.com/victorekpo               |
//+------------------------------------------------------------------+
#property copyright   "2024-2025, Vic & Nancy"
#property link        "http://www.github.com/victorekpo"
#property description "Million Dollar BOT for Step Index"

//--- Import Libraries
#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>
#include <mq4_mq5_bridge.mqh>
#include <Generic\HashMap.mqh>

// HashMap to store lowest profit by ticket
CPositionInfo m_position;  // Trade position object
CTrade m_trade;            // Trading object
CPositionInfo position;


//--- Constants
#define MILLIONDOLLARBOT 20250101

int equityThreshold = 150;

// Structs
struct HistoryEntry
  {
   double            value;   // Price or RSI value
   long              timestamp; // Store datetime as long
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class LowestProfit
  {
private:
   long              ticket;
   double            value;

public:
   // Constructor
                     LowestProfit(long t, double v)
     {
      ticket = t;
      value = v;
     }

   // Getters
   long              GetTicket() { return ticket; }
   double            GetValue() { return value; }

   // Update the lowest profit value if needed
   void              UpdateValue(double newValue)
     {
      if(newValue < value)
        {
         value = newValue;
        }
     }
  };

CHashMap<long, LowestProfit*> lowestProfits;  // HashMap storing pointers to LowestProfit objects


//--- Declare Inputs
input int maxBuyOrders = 10;
input int maxSellOrders = 10;
input int maxSteps = 100;
input int maxOrdersTotal = 30;
input int maxReverseBuyOrders = 10;
input int maxReverseSellOrders = 10;
int maxConcurrentOrdersEarlyClose = 5;
input double maxLotSize = 1000;
input bool enableHighLotSize = false;
input bool forceBuyOrders = false;
input bool forceSellOrders = false;
input int forceGap = 7;

int numBuyOrders;
int numSellOrders;

// TrailingStop default stop loss points
double stopLossPoints = 4;

double orderLots;
double maxOrders;
// Define lot size thresholds
double lotThresholds[][2] =
  {
     {250, 0.1},   // Equity >= 300 -> 0.1 lot
     {500, 0.2},   // Equity >= 500 -> 0.2 lot
     {1000, 0.5},  // Equity >= 1000 -> 0.5 lot
     {2000, 0.8},  // Equity >= 2000 -> 0.8 lot
     {3000, 1.0},  // Equity >= 3000 -> 1.0 lot
     {50000, 5.0}  // Equity >= 50000 -> 5.0 lot
  };

// Define max orders thresholds
double orderThresholds[][2] =
  {
     {250, 1},    // Equity >= 300 -> 1 order
     {500, 2},    // Equity >= 500 -> 2 orders
     {1000, 3},   // Equity >= 1000 -> 3 orders
     {2000, 4},   // Equity >= 2000 -> 4 orders
     {5000, 5}    // Equity >= 5000 -> 5 orders
  };

// Define take profit thresholds
double takeProfitThresholds[][2] =
  {
     {250, 0.35},    // Equity >= 300 -> $0.3 profit
     {500, 0.5},    // Equity >= 500 -> $0.5 profit
     {1000, 1},   // Equity >= 1000 -> $1 profit
     {2000, 2},   // Equity >= 2000 -> $2 profit
     {5000, 5}    // Equity >= 5000 -> $5 profit
  };

//--- Enums for Timeframes
enum TimeFrame {M1, M5, M15, M30, H1, H4, D1, W1, MN1};
int timeframes[] = {1, 5, 15, 30, 60, 240, 999, 9997, 99930};
int min1min5Times[] = {1,5};

enum MAPeriods {_9, _20, _50, _200, _500};

//--- MA and RSI Handles (organized into arrays for easier handling)
int MAHandles[9][5];    // MAHandles[TimeFrame][Periods: 9, 20, 50, 200, 500]
int RSIHandles[9];      // RSIHandles[TimeFrame]

//--- Bears and Bulls Power Handles
int BearsPowerHandles[3]; // BearsPowerHandles[M1, M5, M15]
int BullsPowerHandles[3]; // BullsPowerHandles[M1, M5, M15]

//--- Operational Variables
MqlDateTime clock;
string marketType[11];
HistoryEntry priceHistory[501];
HistoryEntry rsi1History[501];
HistoryEntry rsi5History[501];
double stochastic1History[11];
double stochastic5History[11];

double curBuys[500];
double curSells[500];
double lowestProf[500];
double highestProf[500];
double orderTime[500];
double lowClose[9][5];  // [Timeframe][Period: 10, 30, 90, 200, 500]
double highClose[9][5]; // [Timeframe][Period: 10, 30, 90, 200, 500]
double howClose[9]; // [Timeframe][Period: 10, 30, 90, 200, 500]
enum proximityPeriods { P_10, P_30, P_90, P_200, P_500 };

double rsiVelocity,priceVelocity;

double currentPrice;
double highestProfit = 0;
double lowestProfit = -9999;
double takeProfit = 3;
double highestrsi;
double lowestrsi;
double highestprice;
double lowestprice;
double priceOccurence;

bool shouldReverseBuy = false;
bool shouldReverseSell = false;
bool isMarketRanging = false;
bool isMarketTrending = false;
bool isMarketTrendingUp = false;
bool isMarketTrendingDown = false;

double lastPriceBuyOrder, lastPriceSellOrder;
double lastPriceBuyStopOrder, lastPriceSellStopOrder;
double lastPriceBuyLimitOrder, lastPriceSellLimitOrder;

bool shouldAllowBuyFromRSI[6] = {true, true, true, true, true, true};
bool shouldAllowSellFromRSI[6] = {true, true, true, true, true, true};
bool shouldPrepareForBuyReverse[6] = {false, false, false, false, false, false};
bool shouldPrepareForSellReverse[6] = {false, false, false, false, false, false};
bool shouldPrepareForBuyReverse2[6] = {false, false, false, false, false, false};
bool shouldPrepareForSellReverse2[6] = {false, false, false, false, false, false};
bool shouldPrepareForBuyReverse3[6] = {false, false, false, false, false, false};
bool shouldPrepareForSellReverse3[6] = {false, false, false, false, false, false};
bool shouldAllowFromBEAR = true;
bool shouldAllowFromBULL = true;
bool rsiBelowThreshold[8] = {false};
bool rsiAboveThreshold[8] = {false};

int steps;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   InitializeAlert(ALERT_10, 10);
   InitializeAlert(ALERT_20, 20);
   InitializeAlert(ALERT_25, 25);
   InitializeAlert(ALERT_30, 30);
   InitializeAlert(ALERT_40, 40);
   InitializeAlert(ALERT_50, 50);
   InitializeAlert(ALERT_60, 60);
   InitializeAlert(ALERT_70, 60);
   InitializeAlert(ALERT_80, 60);
   InitializeAlert(ALERT_90, 60);
   InitializeAlert(ALERT_100, 60);
   InitializeAlert(ALERT_600, 600);

// Initialize all arrays with INVALID_HANDLE
   ArrayInitialize(RSIHandles, INVALID_HANDLE);
   ArrayInitialize(BearsPowerHandles, INVALID_HANDLE);
   ArrayInitialize(BullsPowerHandles, INVALID_HANDLE);

   for(int i = 0; i < 9; i++)
     {
      for(int j = 0; j < 5; j++)
        {
         MAHandles[i][j] = INVALID_HANDLE;
        }
     }

// Populate MA Handles (ascending order: 9, 20, 50, 200, 500)
// M1 Timeframe
   MAHandles[M1][_9]   = iMA(NULL, PERIOD_M1, 9, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[M1][_20]  = iMA(NULL, PERIOD_M1, 20, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[M1][_50]  = iMA(NULL, PERIOD_M1, 50, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[M1][_200] = iMA(NULL, PERIOD_M1, 200, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[M1][_500] = iMA(NULL, PERIOD_M1, 500, 0, MODE_SMA, PRICE_CLOSE);

// M5 Timeframe
   MAHandles[M5][_9]   = iMA(NULL, PERIOD_M5, 9, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[M5][_20]  = iMA(NULL, PERIOD_M5, 20, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[M5][_50]  = iMA(NULL, PERIOD_M5, 50, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[M5][_200] = iMA(NULL, PERIOD_M5, 200, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[M5][_500] = iMA(NULL, PERIOD_M5, 500, 0, MODE_SMA, PRICE_CLOSE);

// M15 Timeframe
   MAHandles[M15][_9]   = iMA(NULL, PERIOD_M15, 9, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[M15][_20]  = iMA(NULL, PERIOD_M15, 20, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[M15][_50]  = iMA(NULL, PERIOD_M15, 50, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[M15][_200] = iMA(NULL, PERIOD_M15, 200, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[M15][_500] = iMA(NULL, PERIOD_M15, 500, 0, MODE_SMA, PRICE_CLOSE);

// M30 Timeframe
   MAHandles[M30][_9]   = iMA(NULL, PERIOD_M30, 9, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[M30][_20]  = iMA(NULL, PERIOD_M30, 20, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[M30][_50]  = iMA(NULL, PERIOD_M30, 50, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[M30][_200] = iMA(NULL, PERIOD_M30, 200, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[M30][_500] = iMA(NULL, PERIOD_M30, 500, 0, MODE_SMA, PRICE_CLOSE);

// H1 Timeframe
   MAHandles[H1][_9]   = iMA(NULL, PERIOD_H1, 9, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[H1][_20]  = iMA(NULL, PERIOD_H1, 20, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[H1][_50]  = iMA(NULL, PERIOD_H1, 50, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[H1][_200] = iMA(NULL, PERIOD_H1, 200, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[H1][_500] = iMA(NULL, PERIOD_H1, 500, 0, MODE_SMA, PRICE_CLOSE);

// H4 Timeframe
   MAHandles[H4][_9]   = iMA(NULL, PERIOD_H4, 9, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[H4][_20]  = iMA(NULL, PERIOD_H4, 20, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[H4][_50]  = iMA(NULL, PERIOD_H4, 50, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[H4][_200] = iMA(NULL, PERIOD_H4, 200, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[H4][_500] = iMA(NULL, PERIOD_H4, 500, 0, MODE_SMA, PRICE_CLOSE);

// D1 Timeframe
   MAHandles[D1][_9]   = iMA(NULL, PERIOD_D1, 9, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[D1][_20]  = iMA(NULL, PERIOD_D1, 20, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[D1][_50]  = iMA(NULL, PERIOD_D1, 50, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[D1][_200] = iMA(NULL, PERIOD_D1, 200, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[D1][_500] = iMA(NULL, PERIOD_D1, 500, 0, MODE_SMA, PRICE_CLOSE);

// W1 Timeframe
   MAHandles[W1][_9]   = iMA(NULL, PERIOD_W1, 9, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[W1][_20]  = iMA(NULL, PERIOD_W1, 20, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[W1][_50]  = iMA(NULL, PERIOD_W1, 50, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[W1][_200] = iMA(NULL, PERIOD_W1, 200, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[W1][_500] = iMA(NULL, PERIOD_W1, 500, 0, MODE_SMA, PRICE_CLOSE);

// MN1 Timeframe
   MAHandles[MN1][_9]   = iMA(NULL, PERIOD_MN1, 9, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[MN1][_20]  = iMA(NULL, PERIOD_MN1, 20, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[MN1][_50]  = iMA(NULL, PERIOD_MN1, 50, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[MN1][_200] = iMA(NULL, PERIOD_MN1, 200, 0, MODE_SMA, PRICE_CLOSE);
   MAHandles[MN1][_500] = iMA(NULL, PERIOD_MN1, 500, 0, MODE_SMA, PRICE_CLOSE);

// Populate RSI Handles
   RSIHandles[M1]  = iRSI(NULL, PERIOD_M1, 14, PRICE_CLOSE);
   RSIHandles[M5]  = iRSI(NULL, PERIOD_M5, 14, PRICE_CLOSE);
   RSIHandles[M15] = iRSI(NULL, PERIOD_M15, 14, PRICE_CLOSE);
   RSIHandles[M30] = iRSI(NULL, PERIOD_M30, 14, PRICE_CLOSE);
   RSIHandles[H1]  = iRSI(NULL, PERIOD_H1, 14, PRICE_CLOSE);
   RSIHandles[H4]  = iRSI(NULL, PERIOD_H4, 14, PRICE_CLOSE);
   RSIHandles[D1]  = iRSI(NULL, PERIOD_D1, 14, PRICE_CLOSE);
   RSIHandles[W1]  = iRSI(NULL, PERIOD_W1, 14, PRICE_CLOSE);
   RSIHandles[MN1] = iRSI(NULL, PERIOD_MN1, 14, PRICE_CLOSE);

   if(!ValidateHandles())
     {
      Print("Error creating indicators");
      return (INIT_FAILED);
     }

   EventSetTimer(1);  // Set event timer
   return (INIT_SUCCEEDED);
  }

// Validation Function
// Validation Function
bool ValidateHandles()
  {
// Validate MA Handles
   for(int i = 0; i < 9; i++)
     {
      for(int j = 0; j < 5; j++)
        {
         if(MAHandles[i][j] == INVALID_HANDLE)
           {
            PrintFormat("MA handle failed for TimeFrame %d, Period %d", i, j);
            return false;
           }
        }
     }

// Validate RSI Handles
   for(int i = 0; i < 9; i++)
     {
      if(RSIHandles[i] == INVALID_HANDLE)
        {
         PrintFormat("RSI handle failed for TimeFrame %d", i);
         return false;
        }
     }

// Validate Bears Power Handles, check this later
//   for(int i = 0; i < 9; i++)
//     {
//      if(BearsPowerHandles[i] == INVALID_HANDLE)
//        {
//         PrintFormat("BearsPower handle failed for TimeFrame %d", i);
//         return false;
//        }
//     }
//
//// Validate Bulls Power Handles
//   for(int i = 0; i < 9; i++)
//     {
//      if(BullsPowerHandles[i] == INVALID_HANDLE)
//        {
//         PrintFormat("BullsPower handle failed for TimeFrame %d", i);
//         return false;
//        }
//     }

   return true;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

// Order Functions

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckLevels()
  {
// Update price and RSI history
   calcPriceHistory();
   calcRSI1History();
// calcRSI5History();
   orderLots = calculateLots();
   maxOrders = calculateMaxOrders();

   numBuyOrders = calculateOrders(POSITION_TYPE_BUY);
   numSellOrders = calculateOrders(POSITION_TYPE_SELL);

   currentPrice = iClose(Symbol(), PERIOD_M1, 0);
   priceOccurence = percdiff_signed(checkOccurenceBuy(), checkOccurenceSell());
   rsiVelocity = NormalizeDouble(calcCurrentVelocity(rsi1History, 500),4);
   priceVelocity = NormalizeDouble(calcCurrentVelocity(priceHistory, 500),4);
   bool isBoom = startsWith(_Symbol, "Boom");
   steps = getStepsLastBar(PERIOD_M1,0,isBoom ? true : false);
// Update highest/lowest RSI and price velocity
   highestrsi = MathMax(highestrsi, rsiVelocity);
   lowestrsi = MathMin(lowestrsi, rsiVelocity);
   highestprice = MathMax(highestprice, priceVelocity);
   lowestprice = MathMin(lowestprice, priceVelocity);

   UpdateTrendData();

// Calculate proximity values for each timeframe and period
   for(int i = 0; i < ArraySize(timeframes); i++)
     {
      lowClose[i][P_10] = NormalizeDouble(percdiff(currentPrice, getLowestPrice(timeframes[i], 10)),2);
      lowClose[i][P_30] = NormalizeDouble(percdiff(currentPrice, getLowestPrice(timeframes[i], 30)),2);
      lowClose[i][P_90] = NormalizeDouble(percdiff(currentPrice, getLowestPrice(timeframes[i], 90)),2);
      lowClose[i][P_200] = NormalizeDouble(percdiff(currentPrice, getLowestPrice(timeframes[i], 200)),2);
      lowClose[i][P_500] = NormalizeDouble(percdiff(currentPrice, getLowestPrice(timeframes[i], 500)),2);

      highClose[i][P_10] = NormalizeDouble(percdiff(getHighestPrice(timeframes[i], 10), currentPrice),2);
      highClose[i][P_30] = NormalizeDouble(percdiff(getHighestPrice(timeframes[i], 30), currentPrice),2);
      highClose[i][P_90] = NormalizeDouble(percdiff(getHighestPrice(timeframes[i], 90), currentPrice),2);
      highClose[i][P_200] = NormalizeDouble(percdiff(getHighestPrice(timeframes[i], 200), currentPrice),2);
      highClose[i][P_500] = NormalizeDouble(percdiff(getHighestPrice(timeframes[i], 500), currentPrice),2);
      //Alert(i, " ", timeframes[i]);
     }

   for(int i = 0; i < ArraySize(timeframes); i++)
     {
      howClose[i] = NormalizeDouble(highClose[i][P_200] - lowClose[i][P_200], 2) * 10;
     }

// Market trending detection using price and RSI
   isMarketRanging =
      (MathAbs(rsiVelocity) < 3) ||
      ((isThisBarBULLISH(5) && isThisBarBEARISH(5, 1)) ||
       (isThisBarBEARISH(5) && isThisBarBULLISH(5, 1)));

   isMarketTrendingUp = !isMarketRanging && rsiVelocity > 3;
   isMarketTrendingDown = !isMarketRanging && rsiVelocity < -3;

// Toggle - and - Trigger Algorithms
// RSI checks using predefined thresholds
   double rsiValues[6] = {getRSI(M1), getRSI(M5), getRSI(M15), getRSI(M30), getRSI(H1), getRSI(H4)};
   int rsiSellThresholds[6] = {30, 33, 33, 35, 35, 35};
   int rsiBuyThresholds[6] = {70, 67, 67, 65, 65, 65};
   int rsiSellReverseThresholds[6] = {25, 33, 33, 35, 35, 35};
   int rsiSell1000ReverseThresholds[6] = {25, 33,  33, 35, 35, 35};
   int rsiBuyReverseThresholds[6] = {70, 65, 65, 65, 65, 65};
   int rsiBuy1000ReverseThresholds[6] = {75, 67, 67, 65, 65, 65};
   int rsiSellReverseThresholds2[6] = {8, 20, 25, 25, 25, 25};
   int rsiSell1000ReverseThresholds2[6] = {3, 15,  20, 20, 20, 20};
   int rsiBuyReverseThresholds2[6] = {95, 85, 80, 80, 80, 80};
   int rsiBuy1000ReverseThresholds2[6] = {98, 88, 83, 83, 83, 83};

   for(int i = 0; i < ArraySize(rsiValues); i++)
     {
      // Should Allows
      if(rsiValues[i] <= rsiSellThresholds[i])
        {
         shouldAllowSellFromRSI[i] = false;
        }

      if(rsiValues[i] >= rsiBuyThresholds[i])
        {
         shouldAllowBuyFromRSI[i] = false;
        }


      if(rsiValues[i] >= 70)
        {
         shouldAllowSellFromRSI[i] = true;
        }

      if(rsiValues[i] <= 30)
        {
         shouldAllowBuyFromRSI[i] = true;
        }

      // Should Reverse
      // resets
      if(rsiValues[i] >= 50 || getMA(M1, _20) > getHighestPrice(1,1) || getMA(M1, _50) > getHighestPrice(1,1))
        {
         shouldPrepareForSellReverse[i] = false;
         shouldPrepareForSellReverse2[i] = false;
         shouldPrepareForSellReverse3[i] = false;
        }

      if(rsiValues[i] <= 50 || getMA(M1, _20) < getLowestPrice(1,1) || getMA(M1, _50) < getLowestPrice(1,1))
        {
         shouldPrepareForBuyReverse[i] = false;
         shouldPrepareForBuyReverse2[i] = false;
         shouldPrepareForBuyReverse3[i] = false;
        }

      if(rsiValues[i] <= rsiSellReverseThresholds[i] && _Symbol != "Boom 1000 Index")
        {
         shouldPrepareForSellReverse[i] = true;
         // Alert("should reverse sell threshold reached!", rsiValues[i], " ", rsiSellReverseThresholds[i]);
        }
      if(rsiValues[i] <= rsiSell1000ReverseThresholds[i] && _Symbol == "Boom 1000 Index")
        {
         shouldPrepareForSellReverse[i] = true;
         // Alert("should reverse sell 1000 threshold reached!", rsiValues[i], " ", rsiSell1000ReverseThresholds[i]);
        }

      if(rsiValues[i] >= rsiBuyReverseThresholds[i] && _Symbol != "Crash 1000 Index")
        {
         shouldPrepareForBuyReverse[i] = true;
         // Alert("should reverse buy threshold reached! ", rsiValues[i], " ", rsiBuyReverseThresholds[i]);
        }
      if(rsiValues[i] >= rsiBuy1000ReverseThresholds[i] && _Symbol == "Crash 1000 Index")
        {
         shouldPrepareForBuyReverse[i] = true;
         // Alert("should reverse buy 1000 threshold reached!", rsiValues[i], " ", rsiBuy1000ReverseThresholds[i]);
        }

      // 2
      if(rsiValues[i] <= rsiSellReverseThresholds2[i] && _Symbol != "Boom 1000 Index")
        {
         shouldPrepareForSellReverse2[i] = true;
         // Alert("should reverse sell threshold reached!", rsiValues[i], " ", rsiSellReverseThresholds[i]);
        }
      if(rsiValues[i] <= rsiSell1000ReverseThresholds2[i] && _Symbol == "Boom 1000 Index")
        {
         shouldPrepareForSellReverse2[i] = true;
         // Alert("should reverse sell 1000 threshold reached!", rsiValues[i], " ", rsiSell1000ReverseThresholds[i]);
        }

      if(rsiValues[i] >= rsiBuyReverseThresholds2[i] && _Symbol != "Crash 1000 Index")
        {
         shouldPrepareForBuyReverse2[i] = true;
         // Alert("should reverse buy threshold reached! ", rsiValues[i], " ", rsiBuyReverseThresholds[i]);
        }
      if(rsiValues[i] >= rsiBuy1000ReverseThresholds2[i] && _Symbol == "Crash 1000 Index")
        {
         shouldPrepareForBuyReverse2[i] = true;
         // Alert("should reverse buy 1000 threshold reached!", rsiValues[i], " ", rsiBuy1000ReverseThresholds[i]);
        }
     }

// Print debugging information
//PrintFormat(
//   "RSI Velocity: %.2f, Price Velocity: %.2f, Trending Up: %d, Trending Down: %d",
//   rsiVelocity, priceVelocity, isMarketTrendingUp, isMarketTrendingDown
//);

   if(!checkAccountEquity(500))
     {
      maxConcurrentOrdersEarlyClose = 2;
     }

   if(!checkAccountEquity(300))
     {
      maxConcurrentOrdersEarlyClose = 1;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int placeBuyOrder(double lotSize, string comment, int magic, int gapAmt = 1, bool checkVeryCritical = false, bool reverseOrder = false, bool doubleUp = false)
  {
   int orderPlaced = -1;
   double price = Ask;

   if(
      (checkAccountHealth(POSITION_TYPE_BUY) || reverseOrder || doubleUp)
// && isThrottledPrice(price, lastPriceBuyOrder, gapAmt, comment)
   )
     {
      if((criticalConditionsForBuyOrder() || checkVeryCritical || reverseOrder || veryCriticalConditionsForBuyOrder()) && (veryCriticalConditionsForBuyOrder() || reverseOrder) && !doubleUp)
        {
         // Check risky order
         if(priceOccurence < -75 && !reverseOrder)
           {
            ShowAlertWithDelay("risky buy order!!!" + priceOccurence + " " + checkOccurenceBuy());
            if(
               checkOccurenceBuy() < 5000
               && getRSI(M1) > 35
               && getRSI(M5) > 38
               && getRSI(M15) > 38
               && getRSI(M30) > 38
               && (
                  getMA(M1, _500) > getLowestPrice(1, 1)
                  || getMA(M5, _500) > getLowestPrice(5, 1)
                  || getMA(M15, _500) > getLowestPrice(15, 1)
                  || getMA(H4, _9) > getLowestPrice(240, 1)
                  || getRSI(M1) > 55
               )
            )
              {
               //   Alert("Avoiding risky buy order due to conditions " + _Symbol);
               //  return -1;
              }
           }

         Alert("Placing BUY order");
         orderPlaced = OrderSend(_Symbol, OP_BUY, lotSize, Ask, 3, 0, 0, "algorithm.V_" + comment, magic, 0, Blue);

         lastPriceBuyOrder = price;
         highestProfit = 0;
         trendData.trendStrength = 0;

         // Resets
         double rsiValues[6] = {getRSI(M1), getRSI(M5), getRSI(M15), getRSI(M30), getRSI(H1), getRSI(H4)};
         for(int i = 0; i < ArraySize(rsiValues); i++)
           {
            shouldPrepareForSellReverse[i] = false;
            shouldPrepareForSellReverse2[i] = false;
            shouldPrepareForSellReverse3[i] = false;
            shouldPrepareForBuyReverse[i] = false;
            shouldPrepareForBuyReverse2[i] = false;
            shouldPrepareForBuyReverse3[i] = false;
           }

        }

      if(doubleUp)
        {
         Alert("Placing BUY DOUBLE order");
         orderPlaced = OrderSend(_Symbol, OP_BUY, lotSize, Ask, 3, 0, 0, "algorithm.V_" + comment, magic, 0, Blue);

         lastPriceBuyOrder = price;
         highestProfit = 0;
         trendData.trendStrength = 0;

         // Resets
         double rsiValues[6] = {getRSI(M1), getRSI(M5), getRSI(M15), getRSI(M30), getRSI(H1), getRSI(H4)};
         for(int i = 0; i < ArraySize(rsiValues); i++)
           {
            shouldPrepareForSellReverse[i] = false;
            shouldPrepareForSellReverse2[i] = false;
            shouldPrepareForSellReverse3[i] = false;
            shouldPrepareForBuyReverse[i] = false;
            shouldPrepareForBuyReverse2[i] = false;
            shouldPrepareForBuyReverse3[i] = false;
           }
        }
     }

   return orderPlaced;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int placeBuyStopOrder(double lotSize, string comment, int magic, int gapAmt = 1, bool reverseOrder=false)
  {
   int orderPlaced = -1;
   double gap = (9 * Point);
   double price = Ask + gap;

   if(
      (checkAccountHealth(POSITION_TYPE_BUY) || reverseOrder)
      && calculatePendingOrders(OP_BUYSTOP, comment) < 3
      && isThrottledPrice(price, lastPriceBuyStopOrder, gapAmt, comment)
   )
     {
      if(criticalConditionsForBuyOrder() || reverseOrder)
        {
         orderPlaced = OrderSend(_Symbol, OP_BUYSTOP, lotSize, price, 3, 0, 0, "algorithm.V_STOP_" + comment, magic, 0, Blue);

         if(orderPlaced < 0)
           {
            price = Ask + (gap * 2);
            orderPlaced = OrderSend(_Symbol, OP_BUYSTOP, lotSize, price, 3, 0, 0, "algorithm.V_STOP_" + comment, magic, 0, Blue);
            if(orderPlaced < 0)
              {
               price = Ask + (gap * 4);
               orderPlaced = OrderSend(_Symbol, OP_BUYSTOP, lotSize, price, 3, 0, 0, "algorithm.V_STOP_" + comment, magic, 0, Blue);

               if(orderPlaced < 0)
                 {
                  price = Ask + (gap * 10);
                  orderPlaced = OrderSend(_Symbol, OP_BUYSTOP, lotSize, price, 3, 0, 0, "algorithm.V_STOP_" + comment, magic, 0, Blue);

                  if(orderPlaced < 0)
                    {
                     price = Ask + (gap * 20);
                     orderPlaced = OrderSend(_Symbol, OP_BUYSTOP, lotSize, price, 3, 0, 0, "algorithm.V_STOP_" + comment, magic, 0, Blue);

                     if(orderPlaced < 0)
                       {
                        price = Ask + (gap * 40);
                        orderPlaced = OrderSend(_Symbol, OP_BUYSTOP, lotSize, price, 3, 0, 0, "algorithm.V_STOP_" + comment, magic, 0, Blue);

                        if(orderPlaced < 0)
                          {
                           price = Ask + (gap * 100);
                           orderPlaced = OrderSend(_Symbol, OP_BUYSTOP, lotSize, price, 3, 0, 0, "algorithm.V_STOP_" + comment, magic, 0, Blue);
                          }
                       }
                    }
                 }
              }
           }
         lastPriceBuyStopOrder = price;
        }
     }
   return orderPlaced;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int placeBuyLimitOrder(double lotSize, string comment, int magic, int gapAmt = 1, double orderPrice = 0)
  {
   int orderPlaced = -1;
   double price = (orderPrice != 0) ? orderPrice : (Bid - (50 * Point));

   if(
      checkAccountHealth(POSITION_TYPE_BUY)
      && calculatePendingOrders(OP_BUYLIMIT, comment) < 3
      && isThrottledPrice(price, lastPriceBuyLimitOrder, gapAmt + 10, comment)
   )
     {
      if(criticalConditionsForBuyOrder() || true)
        {
         orderPlaced = OrderSend(_Symbol, OP_BUYLIMIT, lotSize, price, 3, 0, 0, "algorithm.V_LIMIT_" + comment, magic, 0, Blue);
         lastPriceBuyLimitOrder = price;
        }
     }
   return orderPlaced;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int placeSellOrder(double lotSize, string comment, int magic, int gapAmt = 1, bool checkVeryCritical = false, bool reverseOrder = false, bool doubleUp = false)
  {
   int orderPlaced = -1;
   double price = Bid;

   if(
      (checkAccountHealth(POSITION_TYPE_SELL) || reverseOrder || doubleUp)
//   && isThrottledPrice(price, lastPriceSellOrder, gapAmt, comment)
   )
     {
      if((criticalConditionsForSellOrder() || checkVeryCritical || reverseOrder || veryCriticalConditionsForSellOrder()) && (veryCriticalConditionsForSellOrder() || reverseOrder) && !doubleUp)
        {
         // Check risky order
         if(priceOccurence > 75 && !reverseOrder)
           {
            ShowAlertWithDelay("risky sell order!!! " + priceOccurence + " " + checkOccurenceBuy());
            if(
               checkOccurenceSell() < 5000
               && getRSI(M1) < 65
               && getRSI(M5) < 62
               && getRSI(M15) < 62
               && getRSI(M30) < 62
               && (
                  getMA(M1, _500) < getHighestPrice(1, 1)
                  || getMA(M5, _500) < getHighestPrice(5, 1)
                  || getMA(M15, _500) < getHighestPrice(15, 1)
                  || getMA(H4, _9) < getHighestPrice(240, 1)
                  || getRSI(M1) < 45
               )
            )
              {
               //   Alert("Avoiding risky sell order due to conditions " + _Symbol);
               //   return -1;
              }
           }

         Alert("Placing SELL order");
         orderPlaced = OrderSend(_Symbol, OP_SELL, lotSize, Bid, 3, 0, 0, "algorithm.V_" + comment, magic, 0, Red);

         lastPriceSellOrder = price;
         highestProfit = 0;
         trendData.trendStrength = 0;

         // Resets
         double rsiValues[6] = {getRSI(M1), getRSI(M5), getRSI(M15), getRSI(M30), getRSI(H1), getRSI(H4)};
         for(int i = 0; i < ArraySize(rsiValues); i++)
           {
            shouldPrepareForSellReverse[i] = false;
            shouldPrepareForSellReverse2[i] = false;
            shouldPrepareForSellReverse3[i] = false;
            shouldPrepareForBuyReverse[i] = false;
            shouldPrepareForBuyReverse2[i] = false;
            shouldPrepareForBuyReverse3[i] = false;
           }
        }

      if(doubleUp)
        {
         Alert("Placing SELL DOUBLE order");
         orderPlaced = OrderSend(_Symbol, OP_SELL, lotSize, Bid, 3, 0, 0, "algorithm.V_" + comment, magic, 0, Red);

         lastPriceSellOrder = price;
         highestProfit = 0;
         trendData.trendStrength = 0;

         // Resets
         double rsiValues[6] = {getRSI(M1), getRSI(M5), getRSI(M15), getRSI(M30), getRSI(H1), getRSI(H4)};
         for(int i = 0; i < ArraySize(rsiValues); i++)
           {
            shouldPrepareForSellReverse[i] = false;
            shouldPrepareForSellReverse2[i] = false;
            shouldPrepareForSellReverse3[i] = false;
            shouldPrepareForBuyReverse[i] = false;
            shouldPrepareForBuyReverse2[i] = false;
            shouldPrepareForBuyReverse3[i] = false;
           }
        }
     }

   return orderPlaced;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int placeSellStopOrder(double lotSize, string comment, int magic, int gapAmt = 1, bool reverseOrder=false)
  {
   int orderPlaced = -1;
   double gap = (9 * Point);
   double price = Bid - gap;
// Alert("Bid: ", Bid, " gap ", 2000*Point);

   if(
      (checkAccountHealth(POSITION_TYPE_SELL) || reverseOrder)
      && calculatePendingOrders(OP_SELLSTOP, comment) < 3
      && isThrottledPrice(price, lastPriceSellStopOrder, gapAmt, comment)
   )
     {
      if(criticalConditionsForSellOrder() || reverseOrder)
        {
         orderPlaced = OrderSend(_Symbol, OP_SELLSTOP, lotSize, price, 3, 0, 0, "algorithm.V_STOP_" + comment, magic, 0, Red);

         if(orderPlaced < 0)
           {
            price = Bid - (gap * 2);
            orderPlaced = OrderSend(_Symbol, OP_SELLSTOP, lotSize, price, 3, 0, 0, "algorithm.V_STOP_" + comment, magic, 0, Red);

            if(orderPlaced < 0)
              {
               price = Bid - (gap * 4);
               orderPlaced = OrderSend(_Symbol, OP_SELLSTOP, lotSize, price, 3, 0, 0, "algorithm.V_STOP_" + comment, magic, 0, Red);

               if(orderPlaced < 0)
                 {
                  price = Bid - (gap * 10);
                  orderPlaced = OrderSend(_Symbol, OP_SELLSTOP, lotSize, price, 3, 0, 0, "algorithm.V_STOP_" + comment, magic, 0, Red);

                  if(orderPlaced < 0)
                    {
                     price = Bid - (gap * 20);
                     orderPlaced = OrderSend(_Symbol, OP_SELLSTOP, lotSize, price, 3, 0, 0, "algorithm.V_STOP_" + comment, magic, 0, Red);

                     if(orderPlaced < 0)
                       {
                        price = Bid - (gap * 40);
                        orderPlaced = OrderSend(_Symbol, OP_SELLSTOP, lotSize, price, 3, 0, 0, "algorithm.V_STOP_" + comment, magic, 0, Red);

                        if(orderPlaced < 0)
                          {
                           price = Bid - (gap * 100);
                           orderPlaced = OrderSend(_Symbol, OP_SELLSTOP, lotSize, price, 3, 0, 0, "algorithm.V_STOP_" + comment, magic, 0, Red);
                          }
                       }
                    }
                 }
              }
           }
         lastPriceSellStopOrder = price;
        }
     }
   return orderPlaced;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int placeSellLimitOrder(double lotSize, string comment, int magic, int gapAmt = 1, double orderPrice = 0)
  {
   int orderPlaced = -1;
   double price = (orderPrice != 0) ? orderPrice : (Ask + (50 * Point));

   if(
      checkAccountHealth(POSITION_TYPE_SELL)
      && calculatePendingOrders(OP_SELLLIMIT, comment) < 3
      && isThrottledPrice(price, lastPriceSellLimitOrder, gapAmt + 10, comment)
   )
     {
      if(criticalConditionsForSellOrder() || true)
        {
         orderPlaced = OrderSend(_Symbol, OP_SELLLIMIT, lotSize, price, 3, 0, 0, "algorithm.V_LIMIT_" + comment, magic, 0, Red);
         lastPriceSellLimitOrder = price;
        }
     }
   return orderPlaced;
  }


// Utility Functions

//+------------------------------------------------------------------+
//| Function to set time frame based on input integer               |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES setTimeFrame(int time)
  {
   switch(time)
     {
      case 1:
         return PERIOD_M1;
      case 5:
         return PERIOD_M5;
      case 15:
         return PERIOD_M15;
      case 30:
         return PERIOD_M30;
      case 60:
         return PERIOD_H1;
      case 240:
         return PERIOD_H4;
      case 999:
         return PERIOD_D1;
      case 9997:
         return PERIOD_W1;
      case 99930:
         return PERIOD_MN1;
      default:
         // Return a default value if no match is found
         // You can choose PERIOD_CURRENT or another valid ENUM_TIMEFRAMES value
         return PERIOD_CURRENT;
     }
  }


// delayed alerts

// Define an enum for alert types
enum AlertType
  {
   ALERT_10,
   ALERT_20,
   ALERT_25,
   ALERT_30,
   ALERT_40,
   ALERT_50,
   ALERT_60,
   ALERT_70,
   ALERT_80,
   ALERT_90,
   ALERT_100,
   ALERT_600,
   ALERT_COUNT // Size of the array
  };

// Define a struct to store alert information
struct AlertInfo
  {
   datetime          lastAlertTime; // Last time the alert was shown
   int               delaySeconds;       // Interval for the alert
  };

// Create an array to hold multiple alerts
AlertInfo alerts[ALERT_COUNT]; // Array sized based on enum

// Function to initialize an alert with a specific delay
void InitializeAlert(AlertType alertType, int delaySeconds)
  {
// Ensure the alertType is within bounds
   if(alertType < ALERT_COUNT)
     {
      alerts[alertType].lastAlertTime = 0; // Initialize to 0
      alerts[alertType].delaySeconds = delaySeconds; // Set delay
     }
  }

// Function to show an alert with a specific alias and message
void ShowAlertWithDelay(string message, AlertType alertType=ALERT_60)
  {
// Ensure the alertType is within bounds
   if(alertType < ALERT_COUNT)
     {
      // Get the current local time
      datetime time = TimeCurrent();

      // Check if the delay time has passed
      if(time - alerts[alertType].lastAlertTime >= alerts[alertType].delaySeconds)
        {
         Alert(message);  // Show the alert
         alerts[alertType].lastAlertTime = time;  // Update the last alert time
        }
     }
  }

//Define Functions

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getPrice(int time, int shift)
  {
   ENUM_TIMEFRAMES timeframe = setTimeFrame(time);
   return iClose(Symbol(), timeframe, shift);
  }


//Function to calculate Percentage Difference Between Two Numbers
//+------------------------------------------------------------------+
//| Calculate the absolute percentage difference between two values |
//+------------------------------------------------------------------+
double percdiff(double val1, double val2)
  {
// Handle cases where val2 is zero to avoid division by zero
   if(val2 == 0)
     {
      // Return a very large number or handle the zero division case as needed
      return val1 == 0 ? 0 : 10000; // Example: 10000% difference if val2 is zero
     }

// Calculate absolute percentage difference
   double percentageDiff = ((val1 - val2) / val2) * 100;
   return MathAbs(percentageDiff); // Return the absolute value
  }


//+------------------------------------------------------------------+
//| Calculate the signed percentage difference between two values    |
//+------------------------------------------------------------------+
double percdiff_signed(double val1, double val2)
  {
// Handle cases where val2 is zero to avoid division by zero
   if(val2 == 0)
     {
      // Return a very large number or handle the zero division case as needed
      return val1 == 0 ? 0 : 10000; // Example: 10000% difference if val2 is zero
     }

// Calculate signed percentage difference
   return ((val1 - val2) / val2) * 100;
  }

//+------------------------------------------------------------------+
//| Calculate the standard deviation for an array of values         |
//+------------------------------------------------------------------+
double stddev(double &values[], int size)
  {
// Calculate the mean of the values
   double mean = 0;
   for(int i = 0; i < size; i++)
     {
      mean += values[i];
     }
   mean /= size;

// Calculate the variance
   double variance = 0;
   for(int j = 0; j < size; j++)
     {
      variance += MathPow(values[j] - mean, 2);
     }
   variance /= size;

// Return the standard deviation (square root of variance)
   return MathSqrt(variance);
  }


//Function to get Random Number Within a Range
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int RandNum(int maxAttempts = 100)
  {
   for(int i = 0; i < maxAttempts; i++) // Bounded loop
     {
      int randomNum = MathRand();
      if(randomNum >= 0 && randomNum <= 1)
        {
         return randomNum; // Return a valid random number
        }
     }
   return -1; // Return -1 if no valid number is found within maxAttempts
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getBarSize(int time=1, int period=0)
  {
   double openPrice = iOpen(Symbol(), setTimeFrame(time), period);
   double closePrice = iClose(Symbol(), setTimeFrame(time), period);

// Calculate absolute bar size
   double sizeOfBar = MathAbs(openPrice - closePrice);

// Normalize by dividing by the average price
   double avgPrice = (openPrice + closePrice) / 2.0;

// Return bar size as a percentage of the average price
   if(sizeOfBar == 0 || avgPrice == 0)
      return 0;

   return (sizeOfBar / avgPrice) * 1000 * 100;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getBarSizeThreshold(int time)
  {
   switch(time)
     {
      case 1:
         return 0.05;  // 0.05% for M1
      case 5:
         return 0.12;  // 0.08% for M5
      case 15:
         return 0.25;  // 0.12% for M15
      case 30:
         return 0.50;  // 0.15% for M30
      case 60:
         return 1;   // 0.2% for H1
      case 240:
         return 2;   // 0.3% for H4
      case 999:
         return 5;   // 0.4% for custom
      case 9997:
         return 10;   // 0.5% for custom
      default:
         return 0.1;   // Default to 0.1% if an unknown timeframe is used
     }
  }


//+------------------------------------------------------------------+
//| Check if the current bar is BULLISH                              |
//+------------------------------------------------------------------+
//bool isThisBarBULLISH(int time = 1, int period = 0)
//  {
//   return (iClose(Symbol(),setTimeFrame(time),period) > iOpen(Symbol(),setTimeFrame(time),period));
//  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//bool isThisBarBULLISH(int time = 1, int period = 0)
//  {
//   static double lastHigh = 0;
//
//   double openPrice  = iOpen(Symbol(), setTimeFrame(time), period);
//   double closePrice = iClose(Symbol(), setTimeFrame(time), period);
//   double highPrice  = iHigh(Symbol(), setTimeFrame(time), period);
//   double lowPrice   = iLow(Symbol(), setTimeFrame(time), period);
//
//   double barSize = highPrice - lowPrice;
//   double bodySize = MathAbs(closePrice - openPrice);
//
//// Condition 1: Standard bullish check
//   bool isBullish = (closePrice > openPrice);
//
//// Condition 2: Bar is actively strengthening (high is increasing)
//   bool isStrengthening = (highPrice > lastHigh);  // ✅ FIXED
//
//// Condition 3: Body is at least half the bar's size (not a weak bullish move)
//   bool isStrongBullish = (bodySize >= (barSize / 2.0));
//
//// Update stored high for real-time tracking
//   lastHigh = highPrice;
//
//   return isBullish && ((isStrengthening && isStrongBullish) || getRSI(D1) < 40 || getRSI(H1) < 35 || getRSI(M30) < 35);
//  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isThisBarBULLISH(int time = 1, int period = 0)
  {
   static double lastHigh = 0;

   double openPrice  = iOpen(Symbol(), setTimeFrame(time), period);
   double closePrice = iClose(Symbol(), setTimeFrame(time), period);
   double highPrice  = iHigh(Symbol(), setTimeFrame(time), period);
   double lowPrice   = iLow(Symbol(), setTimeFrame(time), period);

   double bodySize = getBarSize(time, period);

// Define minimum body size threshold for longer timeframes
   double sizeThreshold = getBarSizeThreshold(time); // Get threshold dynamically

// Condition 1: Standard bullish check
   bool isBullish = (closePrice > openPrice);

// Condition 2: Bar is actively strengthening (high is increasing)
   bool isStrengthening = (highPrice >= lastHigh);

// Condition 3: Body is at least half the total range (not a weak bullish move)
   bool isStrongBullish = (bodySize >= ((highPrice - lowPrice) / 2.0));

// Condition 4: Ensure body size is meaningful for longer timeframes
   bool meetsSizeThreshold = (time <= 5 || bodySize >= sizeThreshold);


   bool isFinalBullish = isBullish && meetsSizeThreshold && ((isStrengthening && isStrongBullish) || getRSI(D1) < 40 || getRSI(H1) < 35 || getRSI(M30) < 35);

// Update stored high for real-time tracking
   lastHigh = highPrice;

   return isFinalBullish;
  }



//+------------------------------------------------------------------+
//| Check if the current bar is BEARISH                              |
//+------------------------------------------------------------------+
//bool isThisBarBEARISH(int time = 1, int period=0)
//  {
//   return (iClose(Symbol(),setTimeFrame(time),period) < iOpen(Symbol(),setTimeFrame(time),period));
//  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//bool isThisBarBEARISH(int time = 1, int period = 0)
//  {
//   static double lastLow = 0;
//
//   double openPrice  = iOpen(Symbol(), setTimeFrame(time), period);
//   double closePrice = iClose(Symbol(), setTimeFrame(time), period);
//   double highPrice  = iHigh(Symbol(), setTimeFrame(time), period);
//   double lowPrice   = iLow(Symbol(), setTimeFrame(time), period);
//
//   double barSize = highPrice - lowPrice;
//   double bodySize = MathAbs(closePrice - openPrice);
//
//// Condition 1: Standard bearish check
//   bool isBearish = (closePrice < openPrice);
//
//// Condition 2: Bar is actively strengthening (low is decreasing)
//   bool isStrengthening = (lowPrice < lastLow);  // ✅ FIXED
//
//// Condition 3: Body is at least half the bar's size (not a weak bearish move)
//   bool isStrongBearish = (bodySize >= (barSize / 2.0));
//
//// Update stored low for real-time tracking
//   lastLow = lowPrice;
//
//   return isBearish && ((isStrengthening && isStrongBearish) || getRSI(D1) > 60 || getRSI(H1) > 65 || getRSI(M30) > 65);
//  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isThisBarBEARISH(int time = 1, int period = 0)
  {
   static double lastLow = 0;

   double openPrice  = iOpen(Symbol(), setTimeFrame(time), period);
   double closePrice = iClose(Symbol(), setTimeFrame(time), period);
   double highPrice  = iHigh(Symbol(), setTimeFrame(time), period);
   double lowPrice   = iLow(Symbol(), setTimeFrame(time), period);

   double barSize = highPrice - lowPrice;
   double bodySize = getBarSize(time, period);

// Define minimum bar size threshold for longer timeframes
   double sizeThreshold = getBarSizeThreshold(time); // Get threshold dynamically

// Condition 1: Standard bearish check
   bool isBearish = (closePrice < openPrice);

// Condition 2: Bar is actively strengthening (low is decreasing)
   bool isStrengthening = (lowPrice <= lastLow);

// Condition 3: Body is at least half the bar's size (not a weak bearish move)
   bool isStrongBearish = (bodySize >= (barSize / 2.0));

// Condition 4: Ensure bar size is meaningful for longer timeframes
   bool meetsSizeThreshold = (time <= 5 || bodySize >= sizeThreshold);



   bool isFinalBearish = isBearish && meetsSizeThreshold && ((isStrengthening && isStrongBearish) || getRSI(D1) > 60 || getRSI(H1) > 65 || getRSI(M30) > 65);

// Update stored low for real-time tracking
   lastLow = lowPrice;

   return isFinalBearish;
  }




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int getStepsLastBar(int time, int period = 0, bool bull = true, int max = 3000)
  {
   for(int count = 0; count <= max; count++, period++)
     {
      bool bar = bull ? isThisBarBULLISH(time, period) : isThisBarBEARISH(time, period);
      if(bar && getBarSize(time, period) > 0)
        {
         return count;
        }
     }
   return -1; // Return -1 to indicate no matching bar was found within the maximum steps
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getHighestPrice(int time=1, int period=0)
  {
   return iHigh(NULL,setTimeFrame(time),iHighest(NULL, setTimeFrame(time), MODE_HIGH, period, 0));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getLowestPrice(int time=1, int period=0)
  {
   return iLow(NULL,setTimeFrame(time),iLowest(NULL, setTimeFrame(time), MODE_LOW, period, 0));
  }

//+------------------------------------------------------------------+
//| Check if the current price is relatively high or low            |
//+------------------------------------------------------------------+
bool isPriceRelative(double cprice, double historicalPrice, double thresholdPercent, bool checkHigh)
  {
   double percentDiff = percdiff(cprice, historicalPrice);
   if(checkHigh)
     {
      return percentDiff < thresholdPercent;
     }
   else
     {
      return percentDiff > thresholdPercent;
     }
  }

//+------------------------------------------------------------------+
//| Check if the price is trending up or down                       |
//+------------------------------------------------------------------+
bool isPriceTrending(int timeFrame, int &periods[], bool trendUp)
  {
   double cprice = iClose(Symbol(), setTimeFrame(timeFrame), 0);
   for(int i = 0; i < ArraySize(periods); i++)
     {
      double periodPrice = iClose(Symbol(), setTimeFrame(timeFrame), periods[i]);
      if((trendUp && cprice <= periodPrice) || (!trendUp && cprice >= periodPrice))
        {
         return false;
        }
     }
   return true;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double calculateVelocity(double val1, double val2, datetime timeOfVal2)
  {
   if(val1 == 0 || val2 == 0 || timeOfVal2 == 0)
      return 0;

   double avgPrice = (val1 + val2) / 2.0;
   if(avgPrice == 0)
      return 0;

   double valueDiff = NormalizeDouble((val1 - val2) / avgPrice, 4) * 100;
   datetime timeDiff = MathMax(1, TimeCurrent() - timeOfVal2);  // Avoid division by zero

   return NormalizeDouble((valueDiff / timeDiff) * 100, 4);
  }


//+------------------------------------------------------------------+
//| Retrieve the indicator value from the handle                     |
//+------------------------------------------------------------------+
double getIndicatorValue(int handle, const int index = 0)
  {
   double value[1];  // Buffer to store the result
   ResetLastError();  // Reset the error code before calling CopyBuffer

   if(CopyBuffer(handle, 0, index, 1, value) < 0)
     {
      PrintFormat("Failed to copy data from the indicator, error code %d", GetLastError());
      return 0;  // Return 0 if the data copy failed
     }

   return value[0];  // Return the first value from the buffer
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getBullsPower(int timeframe, const int index = 0)
  {
   int handle = BullsPowerHandles[timeframe - 1];  // Adjust index for 1-based input
   if(handle == INVALID_HANDLE)
     {
      PrintFormat("Invalid Bulls Power handle for timeframe %d", timeframe);
      return 0;
     }
   return getIndicatorValue(handle, index);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getBearsPower(int timeframe, const int index = 0)
  {
   int handle = BearsPowerHandles[timeframe - 1];  // Adjust index for 1-based input
   if(handle == INVALID_HANDLE)
     {
      PrintFormat("Invalid Bears Power handle for timeframe %d", timeframe);
      return 0;
     }
   return getIndicatorValue(handle, index);
  }

//+------------------------------------------------------------------+
//| Retrieve Stochastic value (Main or Signal)                       |
//+------------------------------------------------------------------+
double getStochasticValue(int timeframe, int line, const int time = 0)
  {
   double buffer[];  // Dynamically allocated array
   ArraySetAsSeries(buffer, true);  // Set as series

   int handle = iStochastic(_Symbol, setTimeFrame(timeframe), 5, 3, 3, MODE_SMA, STO_LOWHIGH);
   if(handle == INVALID_HANDLE)
     {
      PrintFormat("Failed to initialize Stochastic handle for timeframe %d", timeframe);
      return 0;
     }

   ResetLastError();  // Reset error code

// Resize the array to hold 1 value
   ArrayResize(buffer, 1);

   if(CopyBuffer(handle, line, time, 1, buffer) < 0)
     {
      PrintFormat("Failed to copy Stochastic data, error code: %d", GetLastError());
      return 0;
     }

   return NormalizeDouble(buffer[0], 1);  // Normalize to 1 decimal place
  }

// Wrapper for Stochastic Main (K)
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getStochasticMain(int timeframe, const int time = 0)
  {
   return getStochasticValue(timeframe, 0, time);  // Line 0 for Main (K)
  }

// Wrapper for Stochastic Signal (D)
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getStochasticSignal(int timeframe, const int time = 0)
  {
   return MathMax(0, getStochasticValue(timeframe, 1, time));  // Ensure non-negative
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getRSI(int timeframe, const int index = 0)
  {
   int handle = RSIHandles[timeframe];
   if(handle == INVALID_HANDLE)
     {
      PrintFormat("Invalid RSI handle for timeframe %d", timeframe);
      return 0;
     }
//Alert(timeframes[timeframe], " ", getIndicatorValue(handle, index));
   return getIndicatorValue(handle, index);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getMA(int timeframe, int periodIndex, const int index = 0)
  {
   int handle = MAHandles[timeframe][periodIndex];
   if(handle == INVALID_HANDLE)
     {
      PrintFormat("Invalid MA handle for timeframe %d, period index %d", timeframe, periodIndex);
      return 0;
     }
   return getIndicatorValue(handle, index);
  }


//+------------------------------------------------------------------+
//| Check if the MA is above the highest price                       |
//+------------------------------------------------------------------+
bool isMAAbove(int timeframe, int periodIndex, int periods = 1)
  {
   return getMA(timeframe, periodIndex) > getHighestPrice(timeframe, periods);
  }

//+------------------------------------------------------------------+
//| Check if the MA is below the lowest price                        |
//+------------------------------------------------------------------+
bool isMABelow(int timeframe, int periodIndex, int periods = 1)
  {
   return getMA(timeframe, periodIndex) < getLowestPrice(timeframe, periods);
  }


//+------------------------------------------------------------------+
//| Check if all relevant MAs are trending up                        |
//+------------------------------------------------------------------+
bool allMAUp()
  {
   return checkMATrend(true, min1min5Times);  // true indicates checking for "up" trend
  }

//+------------------------------------------------------------------+
//| Check if all relevant MAs are trending down                      |
//+------------------------------------------------------------------+
bool allMADown()
  {
   return checkMATrend(false, min1min5Times);  // false indicates checking for "down" trend
  }

//+------------------------------------------------------------------+
//| Helper function to check if all relevant MAs are in the same trend |
//+------------------------------------------------------------------+
bool checkMATrend(bool isUp, int &times[])
  {
   int periods[] = {_9, _20, _50, _200};  // MA periods to check

// Loop through each timeframe and corresponding MA periods
   for(int i = 0; i < ArraySize(timeframes); i++)
     {
      double highestPrice = getHighestPrice(timeframes[i]);  // Get highest price
      double lowestPrice = getLowestPrice(timeframes[i]);  // Get lowest price

      for(int j = 0; j < ArraySize(periods); j++)
        {
         double maValue = getMA(i, periods[j]);

         // Check trend: either all MAs are above the high (up) or below the low (down)
         if(isUp && maValue <= highestPrice)
            return false;
         if(!isUp && maValue >= lowestPrice)
            return false;
        }
     }
   return true;  // All MAs are in the desired trend
  }

//+------------------------------------------------------------------+
//| Shift history data for 2D HistoryEntry arrays                    |
//+------------------------------------------------------------------+
void shiftHistory(HistoryEntry &history[], int length)
  {
   for(int p = length - 1; p > 0; p--)
     {
      history[p] = history[p - 1];
     }
  }


//+------------------------------------------------------------------+
//| Calculate and store history data                                 |
//+------------------------------------------------------------------+
void calcHistory(HistoryEntry &history[], int length, int timeframe, bool isRSI = false)
  {
   shiftHistory(history, length);  // Shift history data

// Store either RSI value or the current price
   history[0].value = isRSI ? getRSI(timeframe) : currentPrice;

// Store the timestamp as a long
   history[0].timestamp = TimeCurrent();
  }

//+------------------------------------------------------------------+
//| Check if history is trending up or down                          |
//+------------------------------------------------------------------+
bool isHistoryTrending(bool isUp, HistoryEntry &history[], int length)
  {
   int count = 0;

   for(int j = 0; j < length - 1; j++)
     {
      // Ensure both current and next entries have non-zero values
      if(history[j].value != 0 && history[j + 1].value != 0)
        {
         // Check if the trend is consistent with the expected direction
         if((isUp && history[j].value > history[j + 1].value)
            || (!isUp && history[j].value < history[j + 1].value))
           {
            count++;
           }
        }
     }
// Return true if all comparisons matched the trend direction
   return count == length - 1;
  }



// Calculate price history
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void calcPriceHistory()
  {
   calcHistory(priceHistory, 500, 0, false);  // Not using timeframe for price
  }

// Calculate RSI(1) history
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void calcRSI1History()
  {
   calcHistory(rsi1History, 500, M1, true);  // M1 timeframe for RSI(1)
  }

// Calculate RSI(5) history
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void calcRSI5History()
  {
   calcHistory(rsi5History, 10, M5, true);  // M5 timeframe for RSI(5)
  }


// Check if price history is trending up
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool priceHistoryGoingUp(int length)
  {
   return isHistoryTrending(true, priceHistory, length);
  }

// Check if price history is trending down
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool priceHistoryGoingDown(int length)
  {
   return isHistoryTrending(false, priceHistory, length);
  }

//+------------------------------------------------------------------+
//| Retrieve a specific entry from the history array                 |
//+------------------------------------------------------------------+
HistoryEntry getHistoryEntry(HistoryEntry &history[], int index)
  {
   if(index < 0 || index >= ArraySize(history))
     {
      PrintFormat("Index %d out of bounds for history array", index);

      // Create and return a default HistoryEntry object
      HistoryEntry defaultEntry;
      defaultEntry.value = 0;
      defaultEntry.timestamp = 0;
      return defaultEntry;
     }
   return history[index];  // Return the requested HistoryEntry object
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double calcCurrentVelocity(HistoryEntry &arr[], int length)
  {
   double velocity = 0.0;
   int dataPoints = 0;

   for(int p=1; p<length; p++)
     {
      // Check if the data points are valid
      if(arr[p].value != 0 && arr[p-1].value != 0)
        {
         // Calculate price change over time between consecutive ticks
         double priceChange = arr[p-1].value - arr[p].value;
         long timeChange = arr[p-1].timestamp - arr[p].timestamp;

         // Prevent division by zero in case timeChange is zero
         if(timeChange > 0)
           {
            velocity += priceChange / timeChange; // accumulate velocity
            dataPoints++;
           }
        }
     }
// Return the average velocity if valid data points exist
   if(dataPoints > 0)
      return (velocity / dataPoints) *10;
   return 0.0; // return 0 if no valid data points found
  }


//+------------------------------------------------------------------+
//| Calculate the slope of the trendline using linear regression    |
//+------------------------------------------------------------------+
double calculateSlope(double &prices[], int size)
  {
   double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
   for(int i = 0; i < size; i++)
     {
      double x = i;
      double y = prices[i];
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
     }

   double N = size;
   return (N * sumXY - sumX * sumY) / (N * sumX2 - sumX * sumX);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getSlope()
  {
   double prices[30];  // Array to hold 10 periods of closing prices
   int size = 30;

// Fill the prices array with the last 10 closing prices from the M1 chart
   for(int i = 0; i < size; i++)
     {
      prices[i] = iClose(_Symbol, PERIOD_M5, i);
     }

// Calculate the average price over the 10 periods for normalization
   double avgPrice = 0;
   for(int j = 0; j < size; j++)
     {
      avgPrice += prices[j];
     }
   avgPrice /= size;  // Calculate the average price

// Call the calculateSlope function to get the slope of the prices
   double slope = calculateSlope(prices, size);

// Normalize the slope by dividing by the average price and converting to a percentage
   double normalizedSlope = NormalizeDouble((slope / avgPrice) * 10000, 2);

// Print the normalized slope value
// Alert("Normalized Slope: ", normalizedSlope, "%");

   return normalizedSlope;
  }


//+------------------------------------------------------------------+
//| Check Sell Occurrence                                             |
//+------------------------------------------------------------------+
int checkOccurenceSell(int time = 1, int periods = 43200) // month
  {
   int calc = 0;

   for(int count = 0; count < periods; count++)
     {
      double priceCheckUp = iHigh(_Symbol, setTimeFrame(time), count); // High price of each bar

      // Count when currentPrice is greater than the previous highs
      if(currentPrice > priceCheckUp)
        {
         calc++;
        }
     }

   return(calc);
  }


//+------------------------------------------------------------------+
//| Check Buy Occurrence                                              |
//+------------------------------------------------------------------+
int checkOccurenceBuy(int time = 1, int periods = 43200) // month
  {
   int calc = 0;

   for(int count = 0; count < periods; count++)
     {
      double priceCheckDown = iLow(_Symbol, setTimeFrame(time), count); // Low price of each bar

      // Count when currentPrice is less than the previous lows
      if(currentPrice < priceCheckDown)
        {
         calc++;
        }
     }

   return(calc);
  }


//+------------------------------------------------------------------+
//| Calculate number of positions based on type and comment          |
//+------------------------------------------------------------------+
int calculateOrders(ENUM_POSITION_TYPE type = POSITION_TYPE_BUY, string comment = "")
  {
   int orderCount = 0;

   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(m_position.SelectByIndex(i)
         && m_position.Symbol() == Symbol()
         && m_position.PositionType() == type
         && (comment == "" || m_position.Comment() == comment)
        )
        {
         orderCount++;
        }
     }
   return orderCount;
// int sellHODLOrders = calculateOrders(POSITION_TYPE_SELL, "algorithm.V_SELLHODL");
// int buyOrders = calculateOrders(POSITION_TYPE_BUY, "algorithm.V_BUYHODL");
  }


//+------------------------------------------------------------------+
//| Calculate profit of positions based on type and comment          |
//+------------------------------------------------------------------+
double calculateOrdersProfit(ENUM_POSITION_TYPE type = POSITION_TYPE_BUY, string comment = "")
  {
   double totalProfit = 0.0;

   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(m_position.SelectByIndex(i)
         && m_position.Symbol() == Symbol()
         && m_position.PositionType() == type
         && (comment == "" || m_position.Comment() == comment)
        )
        {
         totalProfit += m_position.Profit();
        }
     }
   return totalProfit;
// double buyProfit = calculateOrdersProfit(POSITION_TYPE_BUY);
  }


//+------------------------------------------------------------------+
//| Calculate pending orders based on type and comment               |
//+------------------------------------------------------------------+
int calculatePendingOrders(ENUM_ORDER_TYPE type = -1, string comment = "")
  {
   int pendingCount = 0;

   for(int i = 0; i < OrdersTotal(); i++)
     {
      int orderType = OrderType();
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)
         && OrderSymbol() == Symbol()
         //  && (type == -1 || OrderGetInteger(ORDER_TYPE) == type) // Check type or accept all
         && (comment == "" || StringFind(OrderGetString(ORDER_COMMENT), comment) >= 0)) // Check comment substring
        {
         if(orderType > 1 && orderType == type) // Ensure it's a pending order
           {
            //   Alert("pending type ", type, " order type ", OrderGetInteger(ORDER_TYPE));
            pendingCount++;
           }
        }
     }
   return pendingCount;

// Example usage:
// int buyLimitOrders = calculatePendingOrders(OP_BUYLIMIT);
// int allOrdersWithComment = calculatePendingOrders(-1, "algorithm.V_BUY");
  }


//+------------------------------------------------------------------+
//| Calculate Orders based on Timeframe, Position Type, Age, and Comment |
//+------------------------------------------------------------------+
int calculateOrdersByTime(
   int timeframeInSeconds,
   ENUM_POSITION_TYPE posType,
   bool isNew = true,
   string comment = ""
)
  {
   int ordersCount = 0;
   datetime currentTime = TimeCurrent();

   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(m_position.SelectByIndex(i) && m_position.Symbol() == _Symbol)
        {
         datetime posTime = m_position.Time();
         datetime thresholdTime = posTime + timeframeInSeconds;
         bool commentMatch = comment == "" || m_position.Comment() == comment;

         if(
            ((isNew && thresholdTime > currentTime) || (!isNew && thresholdTime < currentTime))
            && m_position.PositionType() == posType
            && commentMatch
         )
           {
            ordersCount++;
           }
        }
     }
   return ordersCount;

// Example usage:
// int newBuyOrders = calculateOrdersByTime(300, POSITION_TYPE_BUY, true, "myComment");
// int newSellOrders = calculateOrdersByTime(600, POSITION_TYPE_SELL, true);
// int oldBuyOrders = calculateOrdersByTime(300, POSITION_TYPE_BUY, false);
// int oldSellOrders = calculateOrdersByTime(600, POSITION_TYPE_SELL, false, "specificComment");
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double calculateOrdersProfitByTime(
   int timeframeInSeconds,
   ENUM_POSITION_TYPE posType,
   bool isNew = true,
   string comment = "",
   bool all = false,
   bool profitOnly = false
)
  {
   double totalProfit = 0.0;
   datetime currentTime = TimeCurrent();

   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(m_position.SelectByIndex(i) && (m_position.Symbol() == _Symbol || all))
        {
         datetime posTime = m_position.Time();
         datetime thresholdTime = posTime + timeframeInSeconds;
         bool commentMatch = comment == "" || m_position.Comment() == comment;

         if(
            ((isNew && thresholdTime > currentTime) || (!isNew && thresholdTime < currentTime))
            && m_position.PositionType() == posType
            && commentMatch
         )
           {
            if(
               (profitOnly && m_position.Profit() > 0)
               || !profitOnly
            )
              {
               totalProfit += m_position.Profit();
              }
           }
        }
     }
   return totalProfit;

// Example usage:
// double newBuyProfit = calculateOrdersProfitByTime(300, POSITION_TYPE_BUY, true, "myComment");
// double oldSellProfit = calculateOrdersProfitByTime(600, POSITION_TYPE_SELL, false, "specificComment");
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isBoomCrash()
  {
   return startsWith(_Symbol, "Boom") || startsWith(_Symbol, "Crash");
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isInTrend(bool isBuy)
  {
   if(
      (isBuy &&
       (
          (getRSI(M1) < 60 || getRSI(D1) < 40 || getRSI(H1) < 40 || getRSI(M30) < 40)
          && (getRSI(M5) < 60 || getRSI(D1) < 40 || getRSI(H1) < 40 || getRSI(M30) < 40)
          && (getRSI(M15) < 60 || getRSI(D1) < 40 || getRSI(H1) < 40 || getRSI(M30) < 40)
          && isThisBarBULLISH()
          && (isThisBarBULLISH(1,1) || isThisBarBULLISH(5,1) || getMA(M1, _50) < getLowestPrice(1,1))
          && (isThisBarBULLISH(5) || getMA(M1, _50) < getLowestPrice(1,1))
          && getMA(M1, _9) < getLowestPrice(1,1)
          && getMA(M1, _20) < getLowestPrice(1,1)
          && (getMA(M1, _200) < getLowestPrice(1,1) || getMA(M1, _50) < getLowestPrice(1,1))
//  && getMA(M15, _9) < getLowestPrice(15,1)
//  && getMA(M15, _50) < getLowestPrice(15,1)
//  && getMA(H1, _9) < getLowestPrice(60,1)
//           && ((isThisBarBULLISH(60) && getBarSize(60) > 40) || !isBoomCrash())
//          && (isThisBarBULLISH(240) || isThisBarBULLISH(999) || !isBoomCrash())
//          && (currentPrice > getMA(M1, _9) || !isBoomCrash())
       )
      )
      || (!isBuy &&
          (
             (getRSI(M1) > 40 || getRSI(D1) > 60 || getRSI(H1) > 60 || getRSI(M30) > 60)
             && (getRSI(M5) > 40 || getRSI(D1) > 60 || getRSI(H1) > 60 || getRSI(M30) > 60)
             && (getRSI(M15) > 40 || getRSI(D1) > 60 || getRSI(H1) > 60 || getRSI(M30) > 60)
             && isThisBarBEARISH()
             && (isThisBarBEARISH(1,1) || isThisBarBEARISH(5,1) || getMA(M1, _50) > getHighestPrice(1,1))
             && (isThisBarBEARISH(5) || getMA(M1, _50) > getHighestPrice(1,1))
             && getMA(M1, _9) > getHighestPrice(1,1)
             && getMA(M1, _20) > getHighestPrice(1,1)
             && (getMA(M1, _200) > getHighestPrice(1,1) || getMA(M1, _50) > getHighestPrice(1,1))
//  && getMA(M15, _9) > getHighestPrice(15,1)
//  && getMA(M15, _50) > getHighestPrice(15,1)
//  && getMA(H1, _9) > getHighestPrice(60,1)
//            && ((isThisBarBEARISH(60) && getBarSize(60) > 40) || !isBoomCrash())
//             && (isThisBarBEARISH(240) || isThisBarBEARISH(999) || !isBoomCrash())
//            && (currentPrice < getMA(M1, _9) || !isBoomCrash())
          )
         )
   )
     {
      ShowAlertWithDelay("Is in trend", ALERT_60);
      return true;
     }


   return false;
  }


//+------------------------------------------------------------------+
//| Close positions in profit                                        |
//+------------------------------------------------------------------+
void closeInProfit(
   bool allSymbols = false,
   double minProfit = 2,
   string comment = ""
)
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(m_position.SelectByIndex(i))
        {
         bool symbolMatch = allSymbols || m_position.Symbol() == _Symbol;
         bool commentMatch = comment == "" || m_position.Comment() == comment;

         if(
            symbolMatch
            && commentMatch
            && m_position.Profit() > minProfit
         )
           {
            bool isBuy = m_position.PositionType() == POSITION_TYPE_BUY;

            if(isInTrend(isBuy) && m_position.Profit() < 20 && ((numBuyOrders + numSellOrders < 10) || m_position.Profit() < 5))
              {
               // Alert("Order still in trend, continuing: Ticket=", m_position.Ticket());
               continue; // Skip closing this position
              }

            Alert("Closing in profit ", m_position.Profit());
            m_trade.PositionClose(m_position.Ticket());
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Close aggregate positions if profit threshold is met             |
//+------------------------------------------------------------------+
void closeAggregateInProfit(
   bool allSymbols = false,
   double minProfit = 2,
   double leastMinProfit = 1,
   int timeframeInSeconds = 86400, // Default to the last 24 hours
   bool isNew = true,
   string comment = ""
)
  {
// Calculate aggregate profit across both buy and sell positions within the last 24 hours
   double aggregateProfit = calculateOrdersProfitByTime(timeframeInSeconds, POSITION_TYPE_BUY, isNew, comment, true, true) +
                            calculateOrdersProfitByTime(timeframeInSeconds, POSITION_TYPE_SELL, isNew, comment, true, true);

   if(aggregateProfit >= minProfit)
     {
      for(int i = PositionsTotal() - 1; i >= 0; i--)
        {
         if(m_position.SelectByIndex(i))
           {
            bool symbolMatch = allSymbols || m_position.Symbol() == _Symbol;
            bool commentMatch = comment == "" || m_position.Comment() == comment;


            // Loop through time intervals and update the leastMinProfit
            // Define the adjustment intervals and divisors
            int adjustmentIntervals[] = {150, 300, 600, 1200, 2400, 4800, 9600};
            int divisors[] = {2, 4, 8, 16, 32, 64, 128};

            // Initialize leastProfit from leastMinProfit
            double leastProfit = leastMinProfit;

            // Calculate time difference once
            double timeDifference = TimeCurrent() - m_position.Time();

            // Loop through intervals and adjust leastProfit
            for(int i = 0; i < ArraySize(adjustmentIntervals); i++)
              {
               if(timeDifference > adjustmentIntervals[i])
                 {
                  string alertMessage = StringFormat("least profit getting adjusted / %d", divisors[i]);
                  //  ShowAlertWithDelay(alertMessage + " " + leastProfit, ALERT_20);
                  leastProfit = MathMax(leastProfit / divisors[i], 0.02);
                 }
              }
            // End Loop


            if(
               symbolMatch
               && commentMatch
               && m_position.Profit() >= leastProfit
            )
              {
               if(m_position.Profit() > 20)
                 {
                  bool isBuy = m_position.PositionType() == POSITION_TYPE_BUY;

                  if(
                     m_position.Profit() < 20
                     && isInTrend(isBuy)
                     && ((timeDifference < 900
                          && steps < 50)
                         || m_position.Profit()  < 5)
                  )
                    {
                     // Alert("Order still in trend, continuing: Ticket=", m_position.Ticket());
                     continue; // Skip closing this position

                    }
                  if(m_position.Symbol() == _Symbol)
                    {
                     Alert("Closing aggregate in profit ", m_position.Profit());
                    }
                  m_trade.PositionClose(m_position.Ticket());
                 }
              }
           }
        }
     }
  }


//+------------------------------------------------------------------+
//| Calculate profit or loss for positions                           |
//+------------------------------------------------------------------+
double calculateProfitLoss(
   bool isProfit,
   bool allSymbols = false,
   string comment = ""
)
  {
   double result = 0;

   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(m_position.SelectByIndex(i))
        {
         bool symbolMatch = allSymbols || m_position.Symbol() == _Symbol;
         bool commentMatch = comment == "" || m_position.Comment() == comment;
         bool profitCheck = isProfit ? m_position.Profit() > 0 : m_position.Profit() < 0;

         if(
            symbolMatch
            && commentMatch
            && profitCheck
         )
           {
            result += m_position.Profit();
           }
        }
     }
   return result;
  }

//+------------------------------------------------------------------+
//| Calculate the maximum loss                                       |
//+------------------------------------------------------------------+
double calculateMaxLoss(
   bool allSymbols = false,
   string comment = ""
)
  {
   double maxLoss = 0;

   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(m_position.SelectByIndex(i))
        {
         bool symbolMatch = allSymbols || m_position.Symbol() == _Symbol;
         bool commentMatch = comment == "" || m_position.Comment() == comment;

         if(
            symbolMatch
            && commentMatch
            && m_position.Profit() < maxLoss
         )
           {
            maxLoss = m_position.Profit();
           }
        }
     }
   return maxLoss;
  }

//+------------------------------------------------------------------+
//| Calculate the lowest buy price                                   |
//+------------------------------------------------------------------+
double calculateBuyLowestPrice(
   bool allSymbols = false,
   string comment = ""
)
  {
   double lowestPrice = DBL_MAX;

   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(m_position.SelectByIndex(i))
        {
         bool symbolMatch = allSymbols || m_position.Symbol() == _Symbol;
         bool commentMatch = comment == "" || m_position.Comment() == comment;

         if(
            symbolMatch
            && commentMatch
            && m_position.PositionType() == POSITION_TYPE_BUY
            && m_position.PriceOpen() < lowestPrice
         )
           {
            lowestPrice = m_position.PriceOpen();
           }
        }
     }
   return lowestPrice;
  }

//+------------------------------------------------------------------+
//| Calculate the highest sell price                                 |
//+------------------------------------------------------------------+
double calculateSellHighestPrice(
   bool allSymbols = false,
   string comment = ""
)
  {
   double highestPrice = DBL_MIN;

   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(m_position.SelectByIndex(i))
        {
         bool symbolMatch = allSymbols || m_position.Symbol() == _Symbol;
         bool commentMatch = comment == "" || m_position.Comment() == comment;

         if(
            symbolMatch
            && commentMatch
            && m_position.PositionType() == POSITION_TYPE_SELL
            && m_position.PriceOpen() > highestPrice
         )
           {
            highestPrice = m_position.PriceOpen();
           }
        }
     }
   return highestPrice;
  }

//+------------------------------------------------------------------+
//| Calculate recent profit based on a time window                   |
//+------------------------------------------------------------------+
double calculateRecentProfit(
   datetime timeWindow,
   bool allSymbols = false,
   string comment = ""
)
  {
   double profit = 0;
   datetime mostRecent = TimeCurrent() - timeWindow;

   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(m_position.SelectByIndex(i))
        {
         bool symbolMatch = allSymbols || m_position.Symbol() == _Symbol;
         bool commentMatch = comment == "" || m_position.Comment() == comment;

         if(
            symbolMatch
            && commentMatch
            && m_position.Time() > mostRecent
         )
           {
            profit += m_position.Profit();
           }
        }
     }
   return profit;
  }

//+------------------------------------------------------------------+
//| Helper: Get Value Based on Equity Thresholds                     |
//+------------------------------------------------------------------+
double getEquityBasedValue(double &thresholds[][2], double equity, int size)
  {
   double lastMatchedValue = thresholds[0][1];  // Default to the lowest value

   for(int i = 0; i < size; i++)     // Loop from smallest to largest
     {
      //Alert("thresholds ", i);
      if(equity >= thresholds[i][0])
        {
         lastMatchedValue = thresholds[i][1];  // Update last matched value
        }
      else
        {
         break;  // Stop as soon as equity is less than a threshold
        }
     }
   return lastMatchedValue;
  }


// Calculate lot size based on equity
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double calculateLots()
  {
   double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   int rowSize = 6;
   double lots = getEquityBasedValue(lotThresholds, equity, rowSize);

// Boom 600 starts at 0.2 volume
   if(_Symbol == "Boom 600 Index")
     {
      lots = MathMax(lots, 0.2);
     }

// Boom 900 starts at 0.2 volume
   if(_Symbol == "Boom 900 Index")
     {
      lots = MathMax(lots, 0.2);
     }

// Boom 1000 starts at 0.2 volume
   if(_Symbol == "Boom 1000 Index")
     {
      if(checkAccountEquity(500))
        {
         lots = MathMax(lots*2, 0.2);
        }
      else
        {
         lots = MathMax(lots, 0.2);
        }
     }

// Crash 600 starts at 0.2 volume
   if(_Symbol == "Crash 600 Index")
     {
      lots = MathMax(lots, 0.2);
     }

// Crash 900 starts at 0.2 volume
   if(_Symbol == "Crash 900 Index")
     {
      lots = MathMax(lots, 0.2);
     }

// Crash 1000 starts at 0.2 volume
   if(_Symbol == "Crash 1000 Index")
     {
      if(checkAccountEquity(500))
        {
         lots = MathMax(lots * 2, 0.2);
        }
      else
        {
         lots = MathMax(lots, 0.2);
        }
     }

// Boom 500 starts at 0.2 volume
   if(_Symbol == "Boom 500 Index")
     {
      lots = MathMax(lots, 0.2);
     }

// Crash 500 starts at 0.2 volume
   if(_Symbol == "Crash 500 Index")
     {
      lots = MathMax(lots, 0.2);
     }

// Boom 300 starts at 1 volume
   if(_Symbol == "Boom 300 Index")
     {
      lots = MathMax(lots, 1);
     }

// Crash 300 starts at 0.5 volume
   if(_Symbol == "Crash 300 Index")
     {
      lots = MathMax(lots, 0.5);
     }

   if(_Symbol == "XLMUSD")
     {
      lots = lots * 10000;
     }

   if(_Symbol == "DOGUSD")
     {
      lots = MathMax(lots * 15000, 1500);
     }

   if(_Symbol == "XRPUSD")
     {
      lots = MathMax(lots * 1000, 500);
     }

   if(_Symbol == "UNIUSD")
     {
      lots = MathMax(lots * 10, 1);
     }

   if(_Symbol == "XTZUSD")
     {
      lots = MathMax(lots * 100, 10);
     }

   if(_Symbol == "SOLUSD")
     {
      lots = MathMax(lots * 5, 0.5);
     }

   if(_Symbol == "LNKUSD")
     {
      lots = MathMax(lots * 20, 1);
     }

   if(_Symbol == "DOTUSD")
     {
      lots = MathMax(lots * 100, 10);
     }

   if(_Symbol == "FILUSD")
     {
      lots = MathMax(lots * 50, 1);
     }

   if(_Symbol == "ADAUSD")
     {
      lots = MathMax(lots * 1000, 100);
     }

   if(_Symbol == "BCHUSD")
     {
      lots = MathMax(lots * 10, 1);
     }

   if(_Symbol == "ALGUSD")
     {
      lots = MathMax(lots * 5000, 500);
     }

   if(_Symbol == "NEOUSD")
     {
      lots = MathMin(MathMax(lots * 5000, 500),2000);
     }

   if(_Symbol == "OMGUSD")
     {
      lots = MathMax(lots * 5000, 500);
     }

   if(_Symbol == "IOTUSD")
     {
      lots = MathMax(lots * 5000, 500);
     }

   if(_Symbol == "BATUSD")
     {
      lots = MathMax(lots * 5000, 500);
     }

   if(_Symbol == "TRXUSD")
     {
      lots = MathMax(lots * 5000, 2000);
     }

   if(_Symbol == "XMRUSD")
     {
      lots = MathMax(lots * 10, 0.1);
     }

   if(_Symbol == "XCUUSD")
     {
      lots = MathMax(lots * 0.01, 0.01);
     }

   if(_Symbol == "XALUSD")
     {
      lots = MathMax(lots * 0.01, 0.01);
     }

   if(_Symbol == "DSHUSD")
     {
      lots = MathMax(lots * 5, 0.5);
     }

   if(_Symbol == "LTCUSD")
     {
      lots = MathMax(lots * 5, 0.5);
     }

   return lots;
  }

// Calculate max orders based on equity
int calculateMaxOrders()
  {
   double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   int rowSize = 5;
   return (int)getEquityBasedValue(orderThresholds, equity, rowSize);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double calculateTakeProfit()
  {
   double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   int rowSize = 5;
   double profit = getEquityBasedValue(takeProfitThresholds, equity, rowSize);

// Double take profit for Crash 300, moves quickly
   if(_Symbol == "Crash 300 Index")
     {
      profit = getEquityBasedValue(takeProfitThresholds, equity, rowSize) * 3;
     }
   return profit;
  }



//+------------------------------------------------------------------+
//| Generic Function to Delete Pending Orders                        |
//+------------------------------------------------------------------+
void deletePendingOrders(int orderType = -1, string commentFilter = "")
  {
   int ordTotal = OrdersTotal();
   for(int i = ordTotal - 1; i >= 0; i--)
     {
      ulong ticket = OrderGetTicket(i);
      if(OrderSelect(ticket) && OrderGetString(ORDER_SYMBOL) == Symbol())
        {
         bool typeMatch = (orderType == -1 || OrderGetInteger(ORDER_TYPE) == orderType);
         bool commentMatch = (commentFilter == "" || OrderComment() == commentFilter);

         if(typeMatch && commentMatch)
           {
            m_trade.OrderDelete(ticket);
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Delete Orders by Type                                            |
//+------------------------------------------------------------------+
void deleteAllPendingBuyLimit()
  {
   deletePendingOrders(OP_BUYLIMIT);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void deleteAllPendingBuyStop()
  {
   deletePendingOrders(OP_BUYSTOP);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void deleteAllPendingSellLimit()
  {
   deletePendingOrders(OP_SELLLIMIT);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void deleteAllPendingSellStop()
  {
   deletePendingOrders(OP_SELLSTOP);
  }

//+------------------------------------------------------------------+
//| Delete Scalp Orders                                              |
//+------------------------------------------------------------------+
void deletePendingScalp()
  {
   deletePendingOrders(-1, "algorithm.V_BUYSTOP");
   deletePendingOrders(-1, "algorithm.V_SELLSTOP");
  }

//+------------------------------------------------------------------+
//| Delete HODL Orders                                               |
//+------------------------------------------------------------------+
void deletePendingHODL()
  {
   deletePendingOrders(-1, "algorithm.V_BUYONE");
   deletePendingOrders(-1, "algorithm.V_BUYTWO");
  }

//+------------------------------------------------------------------+
//| Get and Print Comments for All Positions                         |
//+------------------------------------------------------------------+
void getComment()
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(m_position.SelectByIndex(i) && m_position.Symbol() == Symbol())
        {
         Alert(m_position.Comment());
        }
     }
  }

//+------------------------------------------------------------------+
//| Optimized Trailing Stop                                           |
//+------------------------------------------------------------------+
void TrailingStop()
  {
   double startProfitMultiplier = 9;  // Profit multiplier for triggering trailing stop
   double minProfitThreshold = 20;    // Profit threshold to reduce stop-loss points

   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(m_position.SelectByIndex(i) && m_position.Symbol() == Symbol())
        {
         if(m_position.Comment() != "algorithm.V_BUYHODL" &&
            m_position.Comment() != "algorithm.V_SELLHODL")
           {

            ENUM_POSITION_TYPE type = m_position.PositionType();
            double currentSL = m_position.StopLoss();
            double price = m_position.PriceCurrent();
            double currentProfit = m_position.Profit();
            double startTrailingProfit = startProfitMultiplier * m_position.Volume();
            double newStopLoss = (type == POSITION_TYPE_BUY)
                                 ? price - stopLossPoints * Point
                                 : price + stopLossPoints * Point;

            if(currentProfit >= minProfitThreshold)
              {
               stopLossPoints = 2;
              }

            ShowAlertWithDelay("Trailing stop activated, doublecheck " + currentSL + " " + currentProfit + " " + startTrailingProfit + " " + newStopLoss + " " + minProfitThreshold, ALERT_600);
            if(currentProfit >= startTrailingProfit &&
               ((type == POSITION_TYPE_BUY && (newStopLoss > currentSL || currentSL == 0.0)) ||
                (type == POSITION_TYPE_SELL && (newStopLoss < currentSL || currentSL == 0.0))))
              {
               m_trade.PositionModify(m_position.Ticket(), NormalizeDouble(newStopLoss, Digits), 0);
               Alert((type == POSITION_TYPE_BUY) ? "Trailing Stop: Buy" : "Trailing Stop: Sell");
              }
           }
        }
     }
  }


//+------------------------------------------------------------------+
//| Optimized Double-Up Orders                                       |
//+------------------------------------------------------------------+
void doubleUpOrders(bool isCrypto=false)
  {
   int TIME_THRESHOLD = 3600;
   int numSellOrders = calculateOrders(POSITION_TYPE_SELL);
   int numBuyOrders = calculateOrders(POSITION_TYPE_BUY);
   int newSellOrders = calculateOrdersByTime(TIME_THRESHOLD, POSITION_TYPE_SELL, true);
   int newBuyOrders = calculateOrdersByTime(TIME_THRESHOLD, POSITION_TYPE_BUY, true);
   double totalProfitBuy = calculateOrdersProfitByTime(TIME_THRESHOLD, POSITION_TYPE_BUY, true, "", false, true);
   double totalProfitSell = calculateOrdersProfitByTime(TIME_THRESHOLD, POSITION_TYPE_SELL, true, "", false, true);

   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(
         m_position.SelectByIndex(i)
         && m_position.Symbol() == _Symbol
         && m_position.Profit() > 0
      )
        {
         ENUM_POSITION_TYPE posType = m_position.PositionType();
         bool isBuy = posType == POSITION_TYPE_BUY;
         bool isSell = posType == POSITION_TYPE_SELL;
         bool isBoom = strIncludes(_Symbol, "Boom");
         bool isCrash = strIncludes(_Symbol, "Crash");
         bool isBoomCrash = isBoom || isCrash;
         double lots = calculateLots();

         // Adjusted to use new indicator functions
         bool readyToDoubleUpSell =
            isSell
            && isThisBarBEARISH()
            //  && (getStochasticValue(PERIOD_M1, 0) > 40 || getStochasticValue(PERIOD_M5, 0) > 30 || getRSI(M5) > 35)
            && (getRSI(M1) > 20 || isThisBarBEARISH(240) || getRSI(M5) > 60)
            && (getRSI(M1) > 30 || getRSI(M15) > 60 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
            && (getRSI(M1) > 30 || getRSI(M15) > 60 || !isCrypto || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
            && (getRSI(M5) > 30 || getRSI(M15) > 60 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
            && (getRSI(M5) > 30 || !isCrypto || getRSI(M15) > 60 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
            && (getRSI(M15) > 30 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
            && (getRSI(M15) > 30 || !isCrypto || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
            && (getRSI(M30) > 30 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
            && (getRSI(M30) > 30 || !isCrypto || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
            && (getRSI(H1) > 40 || getRSI(M5) > 60)
            && !(isCrash && getMA(M1, _200) > getHighestPrice(1,1))
            && (isBoomCrash || getMA(M5, _200) > getHighestPrice(5,1))
            && (isBoomCrash || getMA(M15, _200) > getHighestPrice(15,1))
            //    && getRSI(H4) > 35
            //    && getRSI(D1) > 35

            && getMA(M1, _9) > getHighestPrice(1,1)
            && getMA(M1, _20) > getMA(M1, _9)
            && (getMA(M1, _50) > getMA(M1, _20) || getMA(M1, _200) > getMA(M1, _20))
            && (getMA(M1, _50) > getHighestPrice(1,1) || getMA(M1, _200) > getHighestPrice(1,1))

            //&& getMA(M5, _9) > getHighestPrice(5,1)
            //&& getMA(M5, _20) > getMA(M5, _9)
            //&& (getMA(M5, _50) > getMA(M5, _20) || getMA(M5, _200) > getMA(M5, _20))
            //&& (getMA(M5, _50) > getHighestPrice(5,1) || getMA(M5, _200) > getHighestPrice(5,1))

            // && (getMA(M15, _50) > getHighestPrice(15,1) || getMA(M15, _200) > getHighestPrice(15,1) || (getRSI(M1) > 55 && getRSI(M5) > 50))
            && (getMA(M30, _200) > getHighestPrice(30,1) || isThisBarBEARISH(9997) || getStochasticMain(M5) > 10 || checkAccountEquity(20000))
            && m_position.Profit() > 0
            //  && (shouldAllowSellFromRSI[M1] || checkAccountEquity(10000))
            //    && getRSI(W1) > 35
            // && getHowCloseToLow(PERIOD_M1) > 20;
            ;


         bool readyToDoubleUpBuy =
            isBuy
            && isThisBarBULLISH()
            // && (getStochasticValue(PERIOD_M1, 0) < 70 || getStochasticValue(PERIOD_M5, 0) < 80 || getRSI(M5) < 65)
            && (getRSI(M1) < 80 || isThisBarBULLISH(240) || getRSI(M5) < 40)
            && (getRSI(M1) < 70 || getRSI(M15) < 40 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
            && (getRSI(M1) < 70 || getRSI(M15) < 40 || !isCrypto || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
            && (getRSI(M5) < 70 || getRSI(M15) < 40 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
            && (getRSI(M5) < 70 || !isCrypto || getRSI(M15) < 40 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
            && (getRSI(M15) < 70 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
            && (getRSI(M15) < 70 || !isCrypto || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
            && (getRSI(M30) < 70 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
            && (getRSI(M30) < 70 || !isCrypto || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
            && (getRSI(H1) < 60 || getRSI(M5) < 40)
            && !(isBoom && getMA(M1, _200) < getLowestPrice(1,1))
            && (isBoomCrash || getMA(M5, _200) < getLowestPrice(5,1))
            && (isBoomCrash || getMA(M15, _200) < getLowestPrice(15,1))

            //    && getRSI(H4) < 65
            //    && getRSI(D1) < 65

            && (getMA(M1, _50) < getLowestPrice(1,1) || getMA(M1, _200) < getLowestPrice(1,1))
            && (getMA(M1, _50) < getMA(M1, _20) || getMA(M1, _200) < getMA(M1, _20))
            && getMA(M1, _20) < getMA(M1, _9)
            && getMA(M1, _9) < getLowestPrice(1,1)


            //&& (getMA(M5, _50) < getLowestPrice(5,1) || getMA(M5, _200) < getLowestPrice(5,1))
            //&& (getMA(M5, _50) < getMA(M5, _20) || getMA(M5, _200) < getMA(M5, _20))
            //&& getMA(M5, _20) < getMA(M5, _9)
            //&& getMA(M5, _9) < getLowestPrice(5,1)

            // && ((getMA(M15, _50) < getLowestPrice(15,1) || getMA(M15, _200) < getLowestPrice(15,1) || (getRSI(M1) < 50 && getRSI(M5) < 55)))
            // && (shouldAllowBuyFromRSI[M1] || checkAccountEquity(10000))
            && (getMA(M30, _200) < getLowestPrice(30,1) || isThisBarBULLISH(9997) || getStochasticMain(M5) < 90 || checkAccountEquity(20000))
            && m_position.Profit() > 0
            //   && getRSI(W1) < 65
            // && getHowCloseToHigh(PERIOD_M1) > 20;
            ;

         if(
            totalProfitSell > (highestProfit + 0.5)
            || m_position.Profit() >= (highestProfit + 0.5)
         )
           {
            if(
               isSell
               && newSellOrders < (MathMax(AccountInfoDouble(ACCOUNT_EQUITY) / 500, 2))
               && numSellOrders < (MathMax(AccountInfoDouble(ACCOUNT_EQUITY) / 500, 3))
               && readyToDoubleUpSell
            )
              {
               highestProfit += 0.1;
               Alert("Doubling up Sell order, Step 2 " + highestProfit + " " + m_position.Symbol() + " totalProfitSell " + totalProfitSell);
               if(isCrypto && (totalProfitSell < (highestProfit + 1) || totalProfitSell < 1))
                 {
                  Alert("profit not enough to double up sell");
                  return;
                 }
               placeSellOrder(lots, "SELLDBL2", 999, 0, false, false, true);
              }
           }

         if(
            totalProfitBuy > (highestProfit + 0.5)
            || m_position.Profit() >= (highestProfit + 0.5)
         )
           {
            if(
               isBuy
               && newBuyOrders < (MathMax(AccountInfoDouble(ACCOUNT_EQUITY) / 500, 2))
               && numBuyOrders < (MathMax(AccountInfoDouble(ACCOUNT_EQUITY) / 500, 3))
               && readyToDoubleUpBuy
            )
              {
               highestProfit += 0.1;
               Alert("Doubling up Buy order, Step 2 " + highestProfit + " " + m_position.Symbol() + " totalProfitBuy " + totalProfitBuy);
               if(isCrypto && (totalProfitBuy < (highestProfit + 1) || totalProfitBuy < 1))
                 {
                  Alert("profit not enough to double up buy");
                  return;
                 }
               placeBuyOrder(lots, "BUYDBL2", 999, 0, false, false, true);
              }
           }


         if(
            totalProfitSell > (highestProfit + 1)
            || m_position.Profit() >= (highestProfit + 1)
         )
           {
            if(
               isSell
               && newSellOrders < (MathMax(AccountInfoDouble(ACCOUNT_EQUITY) / 500, 2))
               && numSellOrders < (MathMax(AccountInfoDouble(ACCOUNT_EQUITY) / 500, 3))
               && readyToDoubleUpSell
               && getMA(M1, _200) > getMA(M1, _50)
               && getMA(M1, _200) > getHighestPrice(1,1)
               && getMA(M5, _200) > getHighestPrice(5,1)
               && (getRSI(M1) > 45 || getMA(M5, _200) > getMA(M5, _50))
            )
              {
               highestProfit += 1;
               Alert("Doubling up Sell order, Step 3 " + highestProfit + " " + m_position.Symbol() + " totalProfitBuy " + totalProfitBuy);
               if(isCrypto && (totalProfitSell < (highestProfit + 1) || totalProfitSell < 1))
                 {
                  Alert("profit not enough to double up sell");
                  return;
                 }
               placeSellOrder(lots, "SELLDBL3", 999, 0, false, false, true);
              }
           }


         if(
            totalProfitBuy > (highestProfit + 1)
            || m_position.Profit() >= (highestProfit + 1)
         )
           {
            if(
               isBuy
               && newBuyOrders < (MathMax(AccountInfoDouble(ACCOUNT_EQUITY) / 500, 2))
               && numBuyOrders < (MathMax(AccountInfoDouble(ACCOUNT_EQUITY) / 500, 3))
               && readyToDoubleUpBuy
               && getMA(M5, _200) < getLowestPrice(5,1)
               && getMA(M1, _200) < getLowestPrice(1,1) // cascade MAs
               && getMA(M1, _200) < getMA(M1, _50)
               && (getRSI(M1) < 55 || getMA(M5, _200) < getMA(M5, _50))

            )
              {
               highestProfit += 1;
               Alert("Doubling up Buy order, Step 3 " + highestProfit + " " + m_position.Symbol() + " totalProfitSell " + totalProfitSell);
               if(isCrypto && (totalProfitBuy < (highestProfit + 1) || totalProfitBuy < 1))
                 {
                  Alert("profit not enough to double up buy");
                  return;
                 }
               placeBuyOrder(lots, "BUYDBL3", 999, 0, false, false, true);
              }
           }
        }
     }
  }


//+------------------------------------------------------------------+
//| Check if the price is throttled based on the gap and comment      |
//+------------------------------------------------------------------+
bool isThrottledPrice(
   double price,
   double lastOrderPrice,
   int gapAmt = 1,
   string comment = "",
   ENUM_ORDER_TYPE type = -1  // Optional type filtering
)
  {
   double gap = gapAmt * Point;

   bool isLastPriceZero = lastOrderPrice == 0;
   bool isCurrentPriceHigherThanLast = price > (lastOrderPrice + gap);
   bool isCurrentPriceLowerThanLast = price < (lastOrderPrice - gap);

// Log the gap details for debugging (optional)
   if(lastOrderPrice != 0)
     {
      // Alert("Last Order Price: ", lastOrderPrice, " Current Price: ", price);
      // Alert("Gap: ", gap, " Price Range: [", lastOrderPrice - gap, ", ", lastOrderPrice + gap, "]");
     }

// Check if there are fewer pending orders than the allowed max
   int maxByComment = 1;
   bool isPendingBelowMax = calculatePendingOrders(type, comment) < maxByComment;

   return (isLastPriceZero || isCurrentPriceHigherThanLast || isCurrentPriceLowerThanLast)
          && isPendingBelowMax;
  }

//+------------------------------------------------------------------+
//| Check and Delete Pending Orders Based on Trend Changes            |
//+------------------------------------------------------------------+
void checkPendingOrdersTrend()
  {
   int totalOrders = OrdersTotal();
   if(totalOrders == 0)
      return;

   for(int i = totalOrders - 1; i >= 0; i--)
     {
      ulong ticket = OrderGetTicket(i);
      if(!OrderSelect(ticket) || OrderGetString(ORDER_SYMBOL) != Symbol())
         continue;

      ENUM_ORDER_TYPE orderType = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);

      // Skip non-pending orders
      if(orderType != OP_BUYLIMIT && orderType != OP_SELLLIMIT &&
         orderType != OP_BUYSTOP && orderType != OP_SELLSTOP)
         continue;

      double orderPrice = OrderGetDouble(ORDER_PRICE_OPEN);
      double priceDiff = MathAbs(currentPrice - orderPrice);
      double priceDiffThreshold = 1.2;

      // If the price is close to the pending order price, evaluate market conditions
      if(priceDiff < priceDiffThreshold && shouldCancelPendingOrder(orderType, orderPrice))
        {
         m_trade.OrderDelete(ticket);
         Alert("Deleted pending ", EnumToString(orderType), " order at ", orderPrice);
        }
     }
  }

//+------------------------------------------------------------------+
//| Helper: Determine if Pending Order Should Be Cancelled            |
//+------------------------------------------------------------------+
bool shouldCancelPendingOrder(ENUM_ORDER_TYPE orderType, double orderPrice)
  {
// Evaluate whether the trend has reversed or conditions have changed
   bool bearishTrend = isBearishTrend();
   bool bullishTrend = isBullishTrend();

   bool isBuyOrder = (orderType == OP_BUYLIMIT || orderType == OP_BUYSTOP);
   bool isSellOrder = (orderType == OP_SELLLIMIT || orderType == OP_SELLSTOP);

// Cancel buy orders if market is bearish, or conditions are unfavorable
   if(isBuyOrder && (bearishTrend || priceVelocity < -5 || rsiVelocity < -15))
      return true;

// Cancel sell orders if market is bullish, or conditions are unfavorable
   if(isSellOrder && (bullishTrend || priceVelocity > 5 || rsiVelocity > 15))
      return true;

// Additional checks for overbought/oversold RSI and proximity to key levels
   if(isBuyOrder && (getStochasticMain(60) >= 65)) // || howClosetoHigh_999 < 40))
      return true;

   if(isSellOrder && (getStochasticMain(60) <= 35)) // || howClosetoLow_999 < 40))
      return true;

// Cancel buy orders if MA is above or RSI is greater than threshold
   if(isBuyOrder && (getMA(M1, _9) < getLowestPrice(1,1) || getRSI(M1) > 70))
      return true;

// Cancel sell orders if MA is below or RSI is lower than threshold
   if(isSellOrder && (getMA(M1, _9) > getHighestPrice(1,1) || getRSI(M1) < 30))
      return true;


// Cancel buy orders if MA is above or RSI is greater than threshold
   if(isBuyOrder && (getMA(M5, _9) < getLowestPrice(5,1) || getRSI(M5) > 70))
      return true;

// Cancel sell orders if MA is below or RSI is lower than threshold
   if(isSellOrder && (getMA(M5, _9) > getHighestPrice(5,1) || getRSI(M5) < 30))
      return true;

// Cancel buy orders if MA is above or RSI is greater than threshold
   if(isBuyOrder && (getMA(M15, _9) < getLowestPrice(15,1) || getRSI(M15) > 70))
      return true;

// Cancel sell orders if MA is below or RSI is lower than threshold
   if(isSellOrder && (getMA(M15, _9) > getHighestPrice(15,1) || getRSI(M15) < 30))
      return true;

   return false;  // Keep the order if none of the cancellation conditions are met
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isBearishTrend()
  {
   return isThisBarBEARISH(60) && isThisBarBEARISH(30) &&
          isThisBarBEARISH(240) && isThisBarBEARISH(15);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isBullishTrend()
  {
   return isThisBarBULLISH(60) && isThisBarBULLISH(30) &&
          isThisBarBULLISH(240) && isThisBarBULLISH(15);
  }


//+------------------------------------------------------------------+
//| Check if the trend has changed based on position type            |
//+------------------------------------------------------------------+
bool HasTrendChanged(ENUM_POSITION_TYPE type)
  {
   if(type == POSITION_TYPE_SELL)
     {
      return isBullishTrend();
     }

   if(type == POSITION_TYPE_BUY)
     {
      return isBearishTrend();
     }

   return false;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TrackLowestProfit(long ticket, double currentProfit)
  {
   LowestProfit *entry = NULL;

// Try to get the existing entry from the HashMap
   if(lowestProfits.TryGetValue(ticket, entry))
     {
      entry.UpdateValue(currentProfit);  // Update if new profit is lower
     }
   else
     {
      // Create a new entry and add it to the HashMap
      entry = new LowestProfit(ticket, currentProfit);
      if(!lowestProfits.TrySetValue(ticket, entry))
        {
         delete entry;  // Clean up if insertion fails
        }
     }
  }

//bool IsCloseToCriticalLevel() {
//   return (
//      howClosetoLow_999 < 10
//      || howClosetoHigh_999 < 10
//      || howClosetoLow_240 < 5
//      || howClosetoHigh_240 < 5
//      || howClosetoLow_60 < 5
//      || howClosetoHigh_60 < 5
//      || howClosetoLow_30 < 5
//      || howClosetoHigh_30 < 5
//      || howClosetoLow_15 < 5
//      || howClosetoHigh_15 < 5
//      || howClosetoLow_5 < 5
//      || howClosetoHigh_5 < 5
//      || howClosetoLow < 2
//      || howClosetoHigh < 2
//   );
//}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isHODLOrder(string comment)
  {
   return (
             comment == "algorithm.V_BUYHODL"
             || comment == "algorithm.V_SELLHODL"
          );
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ShouldCloseOrderEarly(long ticket)
  {
   const double PROFIT_THRESHOLD = 0.5;  // Profit threshold for early close
   LowestProfit *entry = NULL;

   if(!lowestProfits.TryGetValue(ticket, entry))
      return false;

   double profitThreshold = m_position.Volume() * -10;
   datetime posTime = m_position.Time();
   datetime timeAlarm = posTime + 7200; // 2 hours later
   datetime currentTime = TimeCurrent();

   double rsiM1AtTime = getRSIAtTime(_Symbol, PERIOD_M1, RSIHandles[M1], posTime);
   double rsiM5AtTime = getRSIAtTime(_Symbol, PERIOD_M5, RSIHandles[M5], posTime);
   double rsiM15AtTime = getRSIAtTime(_Symbol, PERIOD_M15, RSIHandles[M15], posTime);
   double rsiM30AtTime = getRSIAtTime(_Symbol, PERIOD_M30, RSIHandles[M30], posTime);
   double rsiH1AtTime = getRSIAtTime(_Symbol, PERIOD_H1, RSIHandles[H1], posTime);
   double rsiH4AtTime = getRSIAtTime(_Symbol, PERIOD_H4, RSIHandles[H4], posTime);

   bool closeByProfit = entry.GetValue() < profitThreshold && m_position.Profit() >= PROFIT_THRESHOLD;
   bool closeByTime = currentTime > timeAlarm && m_position.Profit() >= PROFIT_THRESHOLD;

   string cause = "";
   bool any = false;

   if(closeByProfit)
     {
      cause += "closeByprofit";
      any = true;
     }

   if(closeByTime)
     {
      cause += "closeByTime";
      any = true;
     }

   bool rsiTooHighForBuy =
      (
         (getRSI(M1) > 60 || getRSI(M5) > 60 || getRSI(M15) > 60 || getRSI(M30) > 60 || getRSI(H1) > 60 || getRSI(H4) > 60 || getRSI(D1) > 60 || getRSI(W1) > 60 || getRSI(MN1) > 60)
         && m_position.PositionType() == 0
         && m_position.Profit() >= PROFIT_THRESHOLD
      );
   if(rsiTooHighForBuy)
     {
      cause += "rsiTooHighForBuy ";
      any = true;
     }

   bool rsiTooLowForSell =
      (
         (getRSI(M1) < 40 || getRSI(M5) < 40 || getRSI(M15) < 40 || getRSI(M30) < 40 || getRSI(H1) < 40 || getRSI(H4) < 40 || getRSI(D1) < 40 || getRSI(W1) < 40 || getRSI(MN1) < 40)
         && m_position.PositionType() == 1
         && m_position.Profit() >= PROFIT_THRESHOLD
      );
   if(rsiTooLowForSell)
     {
      cause += "rsiTooLowForSell ";
      any = true;
     }

   bool rsiTooHighForBuyOrderTime =
      (
         (rsiM1AtTime > 70 || rsiM5AtTime > 70 || rsiM15AtTime > 70 || rsiM30AtTime > 70 || rsiH1AtTime > 70 || rsiH4AtTime > 70)
         && m_position.PositionType() == 0
         && m_position.Profit() >= PROFIT_THRESHOLD
      );
   if(rsiTooHighForBuyOrderTime)
     {
      cause += "rsiTooHighForBuyOrderTime ";
      any = true;
     }

   bool rsiTooLowForSellOrderTime =
      (
         (rsiM1AtTime < 30 || rsiM5AtTime < 30 || rsiM15AtTime < 30 || rsiM30AtTime < 30 || rsiH1AtTime < 30 || rsiH4AtTime < 30)
         && m_position.PositionType() == 1
         && m_position.Profit() >= PROFIT_THRESHOLD
      );
   if(rsiTooLowForSellOrderTime)
     {
      cause += "rsiTooLowForSellOrderTime ";
      any = true;
     }

   if(any)
     {
      //
      // Alert("cause: " + cause);
     }


   return (
             closeByProfit
             || closeByTime
//   || IsCloseToCriticalLevel()
//        || HasTrendChanged(m_position.PositionType())
             || rsiTooLowForSell
             || rsiTooHighForBuy
             || rsiTooHighForBuyOrderTime
             || rsiTooLowForSellOrderTime
          );
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForEarlyClose()
  {
   double LEAST_PROFIT_THRESHOLD = 0.75;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(!m_position.SelectByIndex(i) || m_position.Symbol() != _Symbol || isHODLOrder(m_position.Comment()))
         continue;

      ulong ticket = m_position.Ticket();
      double currentProfit = m_position.Profit();

      // Track the lowest profit for the current ticket
      TrackLowestProfit(ticket, currentProfit);

      // Close the order if the conditions are met
      if(ShouldCloseOrderEarly(ticket) && currentProfit > LEAST_PROFIT_THRESHOLD)
        {
         bool isBuy = m_position.PositionType() == POSITION_TYPE_BUY;

         if(isInTrend(isBuy) && m_position.Profit() < 20 && ((numBuyOrders + numSellOrders < maxConcurrentOrdersEarlyClose) || m_position.Profit() < maxConcurrentOrdersEarlyClose))
           {
            // Alert("Order still in trend, continuing: Ticket=", m_position.Ticket());
            continue; // Skip closing this position
           }

         Alert("Closing position ", ticket, " at profit: ", currentProfit, " for symbol ", _Symbol);
         m_trade.PositionClose(ticket);

         // Clean up the entry from the HashMap
         LowestProfit *entry = NULL;
         if(lowestProfits.TryGetValue(ticket, entry))
           {
            delete entry;  // Free memory
            lowestProfits.Remove(ticket);  // Remove from HashMap
           }
        }
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void HandleReversals()
  {
   bool isBoomCrash = startsWith(_Symbol, "Boom") || startsWith(_Symbol, "Crash");
// Calculate the number of active and pending buy/sell orders
   int numberOfBuyOrders = calculateOrders(POSITION_TYPE_BUY)
                           + calculatePendingOrders(OP_BUYSTOP)
                           + calculatePendingOrders(OP_BUYLIMIT);

   int numberOfSellOrders = calculateOrders(POSITION_TYPE_SELL)
                            + calculatePendingOrders(OP_SELLSTOP)
                            + calculatePendingOrders(OP_SELLLIMIT);

   int maxReverseBuyAtATime = 1; //checkAccountEquity(500) ? numberOfSellOrders : 1;
   int maxReverseSellAtATime = 1; // checkAccountEquity(500) ? numberOfBuyOrders : 1;

//if(_Symbol == "Boom 600 Index")
//  {
//   Alert("maxReverseBuy ", maxReverseBuyAtATime, " numberSell ", numberOfSellOrders, " maxReverseSell ", maxReverseSellAtATime, " numberBuy ", numberOfBuyOrders);
//  }


// Encapsulate logic for reversal buy orders
   bool shouldTakeMoreReversalBuy =
      (
         (
            getRSI(H4) < 60
            || getRSI(H1) < 60
            || getRSI(M30) < 50
            || getRSI(M15) < 50
            || getRSI(M5) < 45
            || getRSI(M5) < 35
            || numberOfBuyOrders == 0
         )
         && (numberOfBuyOrders < maxReverseBuyAtATime)
         &&
         (
            (
               getRSI(M30) < 60
               && getRSI(M15) < 60
            )
            || (
               priceHistoryGoingUp(4)
               && getRSI(M5) < 25
               && getRSI(M15) < 30
               && getRSI(M30) < 40
               && getRSI(H1) < 40
               && (
                  checkAccountMargin(10000)
                  || numberOfBuyOrders < 1
               )
            )
         )
//   || true
         &&
         (
            (
               getMA(M1, _50) < getLowestPrice(1,1)
               && getMA(M1, _200) < getLowestPrice(1,1)
               && getRSI(M5) < 65
               && getRSI(M15) < 65
               && getRSI(M30) < 65
            )
            || (isThisBarBULLISH() && isThisBarBULLISH(5) && isThisBarBULLISH(15) && isThisBarBULLISH(30) && isThisBarBULLISH(60))
         )

         && getRSI(H1) < 65
         && getRSI(H4) < 65
         && getRSI(D1) < 65
         && (getMA(M1, _50) < getLowestPrice(1,1) || getMA(M1, _200) < getLowestPrice(1,1))
         && (getMA(M1, _50) < getMA(M1, _20) || getMA(M1, _200) < getMA(M1, _20))
         && getMA(M1, _20) < getMA(M1, _9)
         && (!(getMA(M1, _20) > getMA(M1, _9) || getMA(M1, _20) > getLowestPrice(1,1)))
// && getMA(M1, _500) < getLowestPrice(1,1)
      );

   bool shouldTakeMoreReversalBoomCrashBuy =
      (
         isBoomCrash
         && (steps < 30 || getRSI(M1) < 20)
         && (!(getRSI(M15) > 65 && getRSI(M30) > 65 && getRSI(H1) > 65 && getRSI(H4) > 65 && getRSI(D1) > 65))
         && (!(getRSI(M1) > 65 && getRSI(M5) > 65 && getRSI(H4) > 65 && getRSI(D1) > 65))
         && (!(getRSI(H4) > 65 && getRSI(D1) > 65))
         && (!(getRSI(H1) > 65 && getRSI(D1) > 65))
         && (!(getRSI(M1) > 70 && getRSI(M5) > 70 && getRSI(M15) > 70))
         && numberOfBuyOrders < maxReverseBuyAtATime
         && (!(getRSI(M1) > 35 && getRSI(M5) > 45 && getRSI(M15) > 45))
         && isThisBarBULLISH()
         && isThisBarBULLISH(5)
         && isThisBarBULLISH(15)
         && (getMA(M1, _9) < getLowestPrice(1,1) || getMA(M1, _20) < getLowestPrice(1,1) || getMA(M1, _50) < getLowestPrice(1,1))
         && (!(startsWith(_Symbol, "Boom") && getRSI(M1) > 30))
         && (!(startsWith(_Symbol, "Crash") && (isThisBarBEARISH(M15) || isThisBarBEARISH(M30))))
         && (!(startsWith(_Symbol, "Crash") && (getMA(M1, _500) > getMA(M1, _50) || getMA(M1, _200) > getMA(M1, _20))))
         && (!(startsWith(_Symbol, "Crash") && getRSI(M1) > 60 && getRSI(M5) > 50))
         && (!(startsWith(_Symbol, "Crash") && getMA(M1, _20) > getHighestPrice(1,1) && getRSI(H4) > 55))
         && (!(startsWith(_Symbol, "Crash") && getMA(M1, _50) > getHighestPrice(1,1) && getRSI(H4) > 55))
      );

// Encapsulate logic for reversal sell orders
   bool shouldTakeMoreReversalSell =
      (
         (
            getRSI(H4) > 40
            || getRSI(H1) > 40
            || getRSI(M30) > 50
            || getRSI(M15) > 50
            || getRSI(M5) > 55
            || getRSI(M1) > 65
            || numberOfSellOrders == 0
         )
         && (numberOfSellOrders < maxReverseSellAtATime)
         &&
         (
            (
               getRSI(M30) > 40
               && getRSI(M15) > 40
            )
            || (
               priceHistoryGoingDown(4)
               && getRSI(M5) > 75
               && getRSI(M15) > 70
               && getRSI(M30) > 60
               && getRSI(H1) > 60
               && (
                  checkAccountMargin(10000)
                  || numberOfSellOrders < 1
               )
            )
         )
//   || true
         &&
         (
            (
               getMA(M1, _50) > getHighestPrice(1,1)
               && getMA(M1, _200) > getHighestPrice(1,1)
               && getRSI(M5) > 35
               && getRSI(M15) > 35
               && getRSI(M30) > 35
            )
            || (isThisBarBEARISH() && isThisBarBEARISH(5) && isThisBarBEARISH(15) && isThisBarBEARISH(30) && isThisBarBEARISH(60))
         )


         && getRSI(H1) > 35
         && getRSI(H4) > 35
         && getRSI(D1) > 35
         && getMA(M1, _20) > getMA(M1, _9)
         && (getMA(M1, _50) > getMA(M1, _20) || getMA(M1, _200) > getMA(M1, _20))
         && (getMA(M1, _50) > getHighestPrice(1,1) || getMA(M1, _200) > getHighestPrice(1,1))
         && (!(getMA(M1, _20) < getMA(M1, _9) || getMA(M1, _20) < getHighestPrice(1,1)))
      );

   bool shouldTakeMoreReversalBoomCrashSell =
      (
         isBoomCrash
         && (steps < 30 || getRSI(M1) > 80)
         && (!(getRSI(M15) < 35 && getRSI(M30) < 35 && getRSI(H1) < 35 && getRSI(H4) < 35 && getRSI(D1) < 35))
         && (!(getRSI(M1) < 35 && getRSI(M5) < 35 && getRSI(H4) < 35 && getRSI(D1) < 35))
         && (!(getRSI(H4) < 35 && getRSI(D1) < 35))
         && (!(getRSI(H1) < 35 && getRSI(D1) < 35))
         && (!(getRSI(M1) < 30 && getRSI(M5) < 35 && getRSI(M15) < 35))
         && numberOfSellOrders < maxReverseSellAtATime
         && (!(getRSI(M1) < 65 && getRSI(M5) < 55 && getRSI(M15) < 55))
         && isThisBarBEARISH()
         && isThisBarBEARISH(5)
         && isThisBarBEARISH(15)
         && (getMA(M1, _9) > getHighestPrice(1,1) || getMA(M1, _20) > getHighestPrice(1,1) || getMA(M1, _50) > getHighestPrice(1,1))
         && (!(startsWith(_Symbol, "Crash") && getRSI(M1) < 70))
         && (!(startsWith(_Symbol, "Boom") && (isThisBarBULLISH(M15) || isThisBarBULLISH(M30))))
         && (!(startsWith(_Symbol, "Boom") && (getMA(M1, _500) < getMA(M1, _50) || getMA(M1, _200) < getMA(M1, _20))))
         && (!(startsWith(_Symbol, "Boom") && getRSI(M1) < 40 && getRSI(M5) < 40))
         && (!(startsWith(_Symbol, "Boom") && getMA(M1, _20) < getLowestPrice(1,1) && getRSI(H4) < 45))
         && (!(startsWith(_Symbol, "Boom") && getMA(M1, _50) < getLowestPrice(1,1) && getRSI(H4) < 45))
      );

// Iterate through all positions to handle reversals
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(m_position.SelectByIndex(i) && m_position.Symbol() == _Symbol)
        {
         double currentProfit = m_position.Profit();
         ENUM_POSITION_TYPE posType = m_position.PositionType();
         // Handle reversal logic only if the position is in loss
         if(m_position.Profit() < -20)//(10 * m_position.Volume()))
           {
            if(
               posType == POSITION_TYPE_SELL
               //  && isBullishTrend()
            )
              {
               // Alert("SHOULD REVERSE BUY");
               if(isBoomCrash && shouldTakeMoreReversalBoomCrashBuy)
                 {
                  placeBuyOrder(calculateLots(), "REVERSALBUY", 334, 0, false, true);
                 }

               if(!isBoomCrash && shouldTakeMoreReversalBuy && !isRangingBuy() && !isRangingBuy(M5) && !isRangingBuy(M15))
                 {
                  placeBuyStopOrder(calculateLots(), "REVERSALBUY", 333, 3, true);
                  //  placeBuyLimitOrder(calculateLots(),"REVERSALBUY",335,3);
                 }
              }

            if(
               posType == POSITION_TYPE_BUY
               //    && isBearishTrend()
            )
              {
               //   Alert("SHOULD REVERSE SELL");
               if(isBoomCrash && shouldTakeMoreReversalBoomCrashSell)
                 {
                  placeSellOrder(calculateLots(), "REVERSALSELL", 445, 0, false, true);
                 }

               if(!isBoomCrash && shouldTakeMoreReversalSell && !isRangingSell() && !isRangingSell(M5) && !isRangingSell(M15))
                 {
                  placeSellStopOrder(calculateLots(), "REVERSALSELL", 444, 3, true);
                  // placeSellLimitOrder(calculateLots(), "REVERSALSELLL",446,3);
                 }
              }
           }
        }
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void HandleStopLoss()
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(m_position.SelectByIndex(i) && m_position.Symbol() == _Symbol)
        {
         datetime currentTime = TimeCurrent();
         datetime posTime = m_position.Time();
         int timeDifference = (int)(currentTime - posTime);
         int day = 86400;
         int threeDays = day * 3;
         double currentProfit = m_position.Profit();
         double volumeMultiplier = m_position.Volume() * -9;
         ENUM_POSITION_TYPE posType = m_position.PositionType();

         double closeThreshold = -10;
         bool closeCondition = currentProfit < closeThreshold;

         // Get RSI at the time the position was taken
         double rsiAtOpenM1 = getRSIAtTime(_Symbol, PERIOD_M1, RSIHandles[M1], posTime);
         double rsiAtOpenM5 = getRSIAtTime(_Symbol, PERIOD_M5, RSIHandles[M1], posTime);
         double rsiAtOpenM15 = getRSIAtTime(_Symbol, PERIOD_M15, RSIHandles[M1], posTime);
         double rsiAtOpenM30 = getRSIAtTime(_Symbol, PERIOD_M30, RSIHandles[M1], posTime);
         double rsiAtOpenH1 = getRSIAtTime(_Symbol, PERIOD_H1, RSIHandles[H1], posTime);
         double rsiAtOpenH4 = getRSIAtTime(_Symbol, PERIOD_H4, RSIHandles[H1], posTime);

         //Alert("rsiM1 ", rsiAtOpenM1, " t ", m_position.Ticket());
         //Alert("rsiH1 ", rsiAtOpenH1, " t ", m_position.Ticket());

         // Stop loss condition check
         // CLOSE SELL
         bool isBullish = isBullishTrend();
         bool shouldCloseSell =
            (
               (getRSI(M1) < 1
                && getRSI(M5) < 10
                && getRSI(M15) < 25
                && getRSI(M30) < 30
                && getRSI(H1) < 35
                && getRSI(H4) < 35)
            );
         bool sellRSIChanged =
            (
               (rsiAtOpenM1 < 30 && getRSI(M1) > 99)
               || (rsiAtOpenM5 < 30 && getRSI(M5) > 90)
               || (rsiAtOpenM15 < 30 && getRSI(M15) > 80)
               || (rsiAtOpenM30 < 30 && getRSI(M30) > 70)
               || (rsiAtOpenH1 < 30 && getRSI(H1) > 70)
               || (rsiAtOpenH4 < 30 && getRSI(H4) > 60)
            );


         // CLOSE BUY
         bool isBearish = isBearishTrend();
         bool shouldCloseBuy =
            (
               (getRSI(M1) > 99
                && getRSI(M5) > 90
                && getRSI(M15) > 75
                && getRSI(M30) > 70
                && getRSI(H1) > 65
                && getRSI(H4) > 65)
            );
         bool buyRSIChanged =
            (
               (rsiAtOpenM1 > 70 && getRSI(M1) < 1)
               || (rsiAtOpenM5 > 70 && getRSI(M5) < 10)
               || (rsiAtOpenM15 > 70 && getRSI(M15) < 20)
               || (rsiAtOpenM30 > 70 && getRSI(M30) < 30)
               || (rsiAtOpenH1 > 70 && getRSI(H1) < 30)
               || (rsiAtOpenH4 > 70 && getRSI(H4) < 40)
            );

         // Trigger alerts and close positions if conditions are met
         if(closeCondition && timeDifference > threeDays)
           {
            if(posType == POSITION_TYPE_SELL)
              {
               if(
                  (isBullish && shouldCloseSell)
                  || (isThisBarBULLISH() && isThisBarBULLISH(5) && isThisBarBULLISH(15) && isThisBarBULLISH(30) && isThisBarBULLISH(60) && getBarSize(60) > 20 && sellRSIChanged)
                  || (getMA(M1, _9) < getLowestPrice(M1) && getMA(M1, _20) < getLowestPrice(M1) && getMA(M1, _50) < getLowestPrice(M1) && getMA(M1, _200) < getLowestPrice(M1) && getMA(M1, _500) < getLowestPrice(M1))
                  || (getMA(M5, _9) < getLowestPrice(M5) && getMA(M5, _20) < getLowestPrice(M5) && getMA(M5, _50) < getLowestPrice(M5) && getMA(M5, _200)< getLowestPrice(M5) && getMA(M5, _500) < getLowestPrice(M5))
                  || (isThisBarBULLISH() && getMA(M1, _9) < getLowestPrice(M1) && getMA(M1, _20) < getLowestPrice(M1) && getMA(M1, _50) < getLowestPrice(M1) && timeDifference > 720000)
                  // || (isThisBarBULLISH() && rsiVelocity > 15 && priceVelocity > 3)
               )
                 {
                  Alert("STOP LOSS!! #SELL ", currentProfit);
                  m_trade.PositionClose(m_position.Ticket());
                 }
              }

            if(posType == POSITION_TYPE_BUY)
              {
               if(
                  (isBearish && shouldCloseBuy)
                  || (isThisBarBEARISH() && isThisBarBEARISH(5) && isThisBarBEARISH(15) && isThisBarBEARISH(30) && isThisBarBEARISH(60) && getBarSize(60) > 20 && buyRSIChanged)
                  || (getMA(M1, _9) > getHighestPrice(M1) && getMA(M1, _20) > getHighestPrice(M1) && getMA(M1, _50) > getHighestPrice(M1) && getMA(M1, _200) > getHighestPrice(M1) && getMA(M1, _500) > getHighestPrice(M1))
                  || (getMA(M5, _9) > getHighestPrice(M5) && getMA(M5, _20) > getHighestPrice(M5) && getMA(M5, _50) > getHighestPrice(M5) && getMA(M5, _200) > getHighestPrice(M5) && getMA(M5, _500) > getHighestPrice(M5))
                  || (isThisBarBULLISH() && getMA(M1, _9) > getHighestPrice(M1) && getMA(M1, _20) > getHighestPrice(M1) && getMA(M1, _50) > getHighestPrice(M1) && timeDifference > 720000)
                  //  || (isThisBarBEARISH() && rsiVelocity < -15 && priceVelocity < -3)
               )
                 {
                  Alert("STOP LOSS!! #BUY ", currentProfit);
                  m_trade.PositionClose(m_position.Ticket());
                 }
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getRSIAtTime(string symbol, ENUM_TIMEFRAMES timeframe, int handle, datetime time)
  {
   int shift = iBarShift(symbol, timeframe, time, false); // Find the bar index for the given time
   if(shift < 0)
      return -1; // Invalid shift, meaning the time isn't found

   double rsiBuffer[]; // Buffer to hold RSI values
   if(CopyBuffer(handle, 0, shift, 1, rsiBuffer) <= 0)  // Copy RSI value for the specific bar
     {
      Print("Failed to retrieve RSI value at time: ", time);
      return -1;
     }

   return rsiBuffer[0]; // Return the RSI value
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsBearishMultiple(const int &periods[])
  {
   for(int i = 0; i < ArraySize(periods); i++)
     {
      if(!isThisBarBEARISH(periods[i]))
         return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsBullishMultiple(const int &periods[])
  {
   for(int i = 0; i < ArraySize(periods); i++)
     {
      if(!isThisBarBULLISH(periods[i]))
         return false;
     }
   return true;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool checkAccountEquity(double threshold)
  {
   return AccountInfoDouble(ACCOUNT_EQUITY) > threshold;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool checkAccountMargin(double threshold)
  {
   return AccountInfoDouble(ACCOUNT_MARGIN) > threshold;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool checkAccountProfit(double threshold)
  {
   return AccountInfoDouble(ACCOUNT_PROFIT) > threshold;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool checkAccountHealth(ENUM_POSITION_TYPE type)
  {
   int equityThresholdHealth = 500;
   int marginThresholdHealth = 5000;
   double profitThreshold = 0.1;
   int timeThreshold = 3600;

   return (((calculateOrdersByTime(timeThreshold, type, true) < (type == POSITION_TYPE_BUY ? maxBuyOrders : maxSellOrders)
             || calculateOrdersProfitByTime(timeThreshold, type) > profitThreshold)
            && (checkAccountEquity(equityThresholdHealth) || checkAccountMargin(marginThresholdHealth))
            && calculateOrders(type) < maxOrders
           )
           || calculateOrders(type) == 0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool criticalConditionsForSellOrder()
  {
   return getRSI(MN1) > 35
          && (getRSI(MN1) > 40 || checkAccountEquity(equityThreshold) || getRSI(H4) > 60 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && (getRSI(W1) > 35 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && (getRSI(W1) > 40 || checkAccountEquity(equityThreshold) || getRSI(H4) > 60 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && (getRSI(D1) > 35 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && (getRSI(H4) > 40 || getRSI(M5) > 60 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && (getRSI(H4) > 45 || checkAccountEquity(equityThreshold) || getRSI(W1) > 60 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && (getRSI(H1) > 40 || getRSI(M5) > 60 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && (getRSI(H1) > 45 || checkAccountEquity(equityThreshold) || getRSI(H4) > 55 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && (getRSI(M30) > 40 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && (getRSI(M30) > 45 || checkAccountEquity(equityThreshold) || getRSI(H1) > 55 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && (getRSI(M5) > 35 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && (getRSI(M1) > 25 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && (getRSI(M1) > 40
              || getRSI(M5) > 50
              || priceVelocity < -3
              || getMA(M1, _200) - currentPrice > 2
              || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && isThisBarBEARISH(15);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool criticalConditionsForBuyOrder()
  {
   return getRSI(MN1) < 65
          && (getRSI(MN1) < 60 || checkAccountEquity(equityThreshold) || getRSI(H4) < 40 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && (getRSI(W1) < 65 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && (getRSI(W1) < 60 || checkAccountEquity(equityThreshold) || getRSI(H4) < 40 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && (getRSI(D1) < 65 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && (getRSI(H4) < 60 || getRSI(M5) < 40 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && (getRSI(H4) < 55 || checkAccountEquity(equityThreshold) || getRSI(W1) < 40 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && (getRSI(H1) < 60 || getRSI(M5) < 40 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && (getRSI(H1) < 55 || checkAccountEquity(equityThreshold) || getRSI(H4) < 45 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && (getRSI(M30) < 60 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && (getRSI(M30) < 55 || checkAccountEquity(equityThreshold) || getRSI(H1) < 45 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && (getRSI(M5) < 65 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && (getRSI(M1) < 75 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && (getRSI(M1) < 60
              || getRSI(M5) < 50
              || priceVelocity > 3
              || currentPrice - getMA(M1, _200) > 2
              || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && isThisBarBULLISH(15);;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool veryCriticalConditionsForSellOrder()
  {
   return (getRSI(H1) > 40
           && getRSI(M30) > 40
           && getRSI(M15) > 40)
          || getRSI(M1) > 50
          || getRSI(M5) > 50
          || getRSI(M15) > 50
          || getRSI(M30) > 50
          || getRSI(H1) > 50
          || getRSI(H4) > 50
          || getRSI(D1) > 50
          || getRSI(W1) > 50
          || getRSI(MN1) > 50;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool veryCriticalConditionsForBuyOrder()
  {
   return (getRSI(H1) < 60
           && getRSI(M30) < 60
           && getRSI(M15) < 60)
          || getRSI(M1) < 50
          || getRSI(M5) < 50
          || getRSI(M15) < 50
          || getRSI(M30) < 50
          || getRSI(H1) < 50
          || getRSI(H4) < 50
          || getRSI(D1) < 50
          || getRSI(W1) < 50
          || getRSI(MN1) < 50;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool baseConditionsForBuyOrder()
  {
// Define arrays for multiple period checks
   int bullishPeriods[] = {240, 60, 30, 15};
   bool isBullishAll = IsBullishMultiple(bullishPeriods);

   return isThisBarBULLISH()
//&& ((isThisBarBULLISH(60) && getBarSize(60) > 5) || isThisBarBULLISH(15) || getRSI(H1) < 35 || getRSI(H4) < 35)
          && (getMA(M1, _20) < getLowestPrice(1, 1) || getRSI(M1) < 35  || getRSI(M5) < 35 || getRSI(M15) < 35 || getRSI(M30) < 35 || getRSI(H1) < 35 || getMA(M1,_200) < getLowestPrice(1, 1))
          && (getMA(M1,_50) < getLowestPrice(1, 1) || getRSI(M1) < 35  || getRSI(M5) < 35 || getRSI(M15) < 35 || getRSI(M30) < 35 || getRSI(H1) < 35 || getMA(M1,_200) < getLowestPrice(1, 1))
          && !allMAUp()
          && (
             shouldAllowFromBULL
             || (isBullishAll && getBarSize(240) > 10 && getBarSize(60) > 5 && getBarSize(30) > 5 && getBarSize(15) > 5)
             || getMA(M1, _50) < getLowestPrice(1,1)
             || getMA(M1, _200) < getLowestPrice(1,1)
             || getMA(M5, _50) < getLowestPrice(1,1)
             || getMA(M5, _200) < getLowestPrice(1,1)
             || (getRSI(H1) < 35 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
             || (getRSI(H4) < 35 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          );
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool baseConditionsForSellOrder()
  {
// Define arrays for multiple period checks
   int bearishPeriods[] = {240, 60, 30, 15};
   bool isBearishAll = IsBearishMultiple(bearishPeriods);

   return isThisBarBEARISH()
//&& ((isThisBarBEARISH(60) && getBarSize(60) > 5) || isThisBarBEARISH(15) || getRSI(H1) > 65 || getRSI(H4) > 65)
          && (getMA(M1, _20) > getHighestPrice(1, 1) || getRSI(M1) > 65 || getRSI(M5) > 65 || getRSI(M15) > 65 || getRSI(M30) > 65 || getRSI(H1) > 65 || getMA(M1,_200) > getHighestPrice(1, 1))
          && (getMA(M1,_50) > getHighestPrice(1, 1) || getRSI(M1) > 65 || getRSI(M5) > 65 || getRSI(M15) > 65 || getRSI(M30) > 65 || getRSI(H1) > 65 || getMA(M1,_200) > getHighestPrice(1, 1))
          && !allMADown()
          && (
             shouldAllowFromBEAR
             || (isBearishAll && getBarSize(240) > 10 && getBarSize(60) > 5 && getBarSize(30) > 5 && getBarSize(15) > 5)
             || getMA(M1, _50) > getHighestPrice(1,1)
             || getMA(M1, _200) > getHighestPrice(1,1)
             || getMA(M5, _50) > getHighestPrice(1,1)
             || getMA(M5, _200) > getHighestPrice(1,1)
             || (getRSI(H1) > 65 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
             || (getRSI(H4) > 65 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          );
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool RSIConditionsForSellOrder()
  {
   return (shouldAllowSellFromRSI[M1] || getRSI(H1) > 70 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && (shouldAllowSellFromRSI[M5] || getRSI(H1) > 65 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && (shouldAllowSellFromRSI[M15] || getRSI(H4) > 60 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && (shouldAllowSellFromRSI[M30] || getRSI(H4) > 60 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && (getRSI(M5) > 45 || getRSI(H1) > 60 || getRSI(H4) > 60 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && (getRSI(M1) > 55 || getRSI(H1) > 60 || getRSI(H4) > 60 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && (getRSI(M1) > 50 || steps < 5 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && (getRSI(M1) > 40 || (getRSI(D1) > 60 && getRSI(M30) > 50 && getRSI(M15) > 50 && getRSI(M5) > 50))
          && isThisBarBEARISH(5)
          && (
             (isThisBarBEARISH(15) && getBarSize(15) > 7)
             || (isThisBarBEARISH(30) && getBarSize(30) > 7)
             || (isThisBarBEARISH(60) && getBarSize(60) > 7)
          )
          && (checkAccountEquity(equityThreshold) || isThisBarBEARISH(240) || isThisBarBEARISH(60));
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool RSIConditionsForBuyOrder()
  {
   return (shouldAllowBuyFromRSI[M1] || getRSI(H1) < 30 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && (shouldAllowBuyFromRSI[M5] || getRSI(H1) < 35 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && (shouldAllowBuyFromRSI[M15] || getRSI(H4) < 40 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && (shouldAllowBuyFromRSI[M30] || getRSI(H4) < 40 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && (getRSI(M5) < 55 || getRSI(H1) < 40 || getRSI(H4) < 40 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && (getRSI(M1) < 45 || getRSI(H1) < 40 || getRSI(H4) < 40 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && (getRSI(M1) < 50 || steps < 5 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && (getRSI(M1) < 60 || (getRSI(D1) < 40 && getRSI(M30) < 50 && getRSI(M15) < 50 && getRSI(M5) < 50))
          && isThisBarBULLISH(5)
          && (
             (isThisBarBULLISH(15) && getBarSize(15) > 7)
             || (isThisBarBULLISH(30) && getBarSize(30) > 7)
             || (isThisBarBULLISH(60) && getBarSize(60) > 7)
          )
          && (checkAccountEquity(equityThreshold) || isThisBarBULLISH(240) || isThisBarBULLISH(60));
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MAConditionsForSellOrder()
  {
// Define arrays for multiple period checks
   int bearishPeriods[] = {240, 60, 30, 15};
   bool isBearishAll = IsBearishMultiple(bearishPeriods);

   return getMA(M1, _20) > getHighestPrice(1, 1)
// && getMA(M1, _20) - getMA(M1, _9) > 1
// && getMA(M1, _20) < getMA(M1, _50)
          && (
             getMA(M1, _50) - currentPrice > 2
             || getMA(M1, _200) > getHighestPrice(1,1)
             || (
                isBearishAll
                && getMA(M5, _20) > getHighestPrice(5,1)
                && getMA(M1, _20) > getHighestPrice(1,1)
                && getMA(M1, _9) > getHighestPrice(1,1)
             )
          )
          && getMA(M1, _50) > getHighestPrice(1, 1)
          && (
             getMA(M1, _500) > getHighestPrice(1, 1)
             || getMA(M1, _200) > getHighestPrice(1, 1)
             || checkAccountEquity(500)
          )
          && (
             getMA(M30, _50) > getHighestPrice(30, 1)
             || isThisBarBEARISH(240)
          )
          && (
             getMA(M30, _9) > getHighestPrice(30, 1)
             || getMA(M30, _20) > getHighestPrice(30, 1)
          )
          && (
             getMA(M5, _200) > currentPrice
             || getMA(M15, _50) > getMA(M15, _20)
             || getMA(M1, _50) > getMA(M1, _20)
          );
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MAConditionsForBuyOrder()
  {
// Define arrays for multiple period checks
   int bullishPeriods[] = {240, 60, 30, 15};
   bool isBullishAll = IsBullishMultiple(bullishPeriods);

   return getMA(M1, _20) < getLowestPrice(1, 1)
// && getMA(M1, _20) - getMA(M1, _9) < -1
// && getMA(M1, _20) > getMA(M1, _50)
          && (
             currentPrice - getMA(M1, _50) > 2
             || getMA(M1, _200) < getLowestPrice(1,1)
             || (
                isBullishAll
                && getMA(M5, _20) < getLowestPrice(5,1)
                && getMA(M1, _20) < getLowestPrice(1,1)
                && getMA(M1, _9) < getLowestPrice(1,1)
             )
          )
          && (
             getMA(M1, _500) < getLowestPrice(1, 1)
             || getMA(M1, _200) < getLowestPrice(1, 1)
             || checkAccountEquity(500)
          )
          && (
             getMA(M30, _50) < getLowestPrice(30, 1)
             || isThisBarBULLISH(240)
          )
          && (
             getMA(M30, _9) < getLowestPrice(30, 1)
             || getMA(M30, _20) < getLowestPrice(30, 1)
          )
          && (
             getMA(M5, _200) < currentPrice
             || getMA(M15, _50) < getMA(M15, _20)
             || getMA(M1, _50) < getMA(M1, _20)
          );
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool startsWith(const string symbol, const string prefix)
  {
// Compare the prefix with the start of the symbol
   return StringSubstr(symbol, 0, StringLen(prefix)) == prefix;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool strIncludes(const string symbol, const string substring)
  {
// Find the substring in the symbol
   return StringFind(symbol, substring) != -1;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isRangingSell(TimeFrame time=M1)
  {
   if(
      (
         (
            getMA(time, _50) < currentPrice
            && (
               getMA(time, _50) > getMA(time, _9)
               || getMA(time, _50) > getMA(time, _20)
            )
         )
         || (
            getMA(time, _200) < currentPrice
            && (
               getMA(time, _200) > getMA(time, _9)
               || getMA(time, _200) > getMA(time, _20)
               || getMA(time, _200) > getMA(time, _50)
            )
         )
         || (
            getMA(time, _500) < currentPrice
            && (
               getMA(time, _500) > getMA(time, _9)
               || getMA(time, _500) > getMA(time, _20)
               || getMA(time, _500) > getMA(time, _50)
            )
         )
      )
      && (
         isThisBarBULLISH(999)
         && isThisBarBULLISH(240)
         && isThisBarBULLISH(60)
         && isThisBarBULLISH(30)
         && isThisBarBULLISH(15)
         && isThisBarBULLISH(5)
         && (isThisBarBULLISH() || isThisBarBULLISH(1,1))
      )
   )
     {
      //  ShowAlertWithDelay("Ranging.. skipping sell order processing", ALERT_50);
      return true;
     }
   return false;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isRangingBuy(TimeFrame time=M1)
  {
   if(
      (
         (
            getMA(time, _50) > currentPrice
            && (
               getMA(time, _50) < getMA(time, _9)
               || getMA(time, _50) < getMA(time, _20)
            )
         )
         || (
            getMA(time, _200) > currentPrice
            && (
               getMA(time, _200) < getMA(time, _9)
               || getMA(time, _200) < getMA(time, _20)
               || getMA(time, _200) < getMA(time, _50)
            )
         )
         || (
            getMA(time, _500) > currentPrice
            && (
               getMA(time, _500) < getMA(time, _9)
               || getMA(time, _500) < getMA(time, _20)
               || getMA(time, _500) < getMA(time, _50)
            )
         )
      )
      && (
         isThisBarBEARISH(999)
         && isThisBarBEARISH(240)
         && isThisBarBEARISH(60)
         && isThisBarBEARISH(30)
         && isThisBarBEARISH(15)
         && isThisBarBEARISH(5)
         && (isThisBarBEARISH() || isThisBarBEARISH(1,1))
      )
   )
     {
      // ShowAlertWithDelay("Ranging.. skipping buy order processing", ALERdT_50);
      return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CalculateHigherHighsDeviation(int period, ENUM_TIMEFRAMES timeframe)
  {
// Function to calculate if the highs are getting higher over a period
   long rates_total;
   if(!SeriesInfoInteger(_Symbol, timeframe, SERIES_BARS_COUNT, rates_total) || rates_total < period)
      return 0;

   double sumX = 0, sumY = 0, sumXY = 0, sumXX = 0;
   int limit = rates_total - period;

// Loop over the period to calculate the slope for higher highs
   for(int i = 0; i < period; i++)
     {
      double y = getHighestPrice(timeframe, i + limit);  // Get high price using refactored function
      double x = i;                                      // Time step (0, 1, 2, ...)

      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumXX += x * x;
     }

// Calculate the slope of the highs
   double slope = (period * sumXY - sumX * sumY) / (period * sumXX - sumX * sumX);
   return slope * 1000;  // Return scaled slope
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CalculateLowerLowsDeviation(int period, ENUM_TIMEFRAMES timeframe)
  {
// Function to calculate if the lows are getting lower over a period
   long rates_total;
   if(!SeriesInfoInteger(_Symbol, timeframe, SERIES_BARS_COUNT, rates_total) || rates_total < period)
      return 0;

   double sumX = 0, sumY = 0, sumXY = 0, sumXX = 0;
   int limit = rates_total - period;

// Loop over the period to calculate the slope for lower lows
   for(int i = 0; i < period; i++)
     {
      double y = getLowestPrice(timeframe, i + limit);  // Get low price using refactored function
      double x = i;                                     // Time step (0, 1, 2, ...)

      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumXX += x * x;
     }

// Calculate the slope of the lows
   double slope = (period * sumXY - sumX * sumY) / (period * sumXX - sumX * sumX);
   return slope * 1000;  // Return scaled slope
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isUptrendFromSlope(int period=300, ENUM_TIMEFRAMES timeframe=PERIOD_M1)
  {
   double higherHighsSlope = CalculateHigherHighsDeviation(period, timeframe);
   double lowerLowsSlope = CalculateLowerLowsDeviation(period, timeframe);

//  Alert("Higher Highs Slope: ", higherHighsSlope);
//  Alert("Lower Lows Slope: ", lowerLowsSlope);

   if(higherHighsSlope > 0 && lowerLowsSlope > 0)
     {
      //  Alert("Uptrend detected");
      return true;
     }

   return false;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isDowntrendFromSlope(int period=300, ENUM_TIMEFRAMES timeframe=PERIOD_M1)
  {
   double higherHighsSlope = CalculateHigherHighsDeviation(period, timeframe);
   double lowerLowsSlope = CalculateLowerLowsDeviation(period, timeframe);

// Alert("Higher Highs Slope: ", higherHighsSlope);
// Alert("Lower Lows Slope: ", lowerLowsSlope);

   if(higherHighsSlope < 0 && lowerLowsSlope < 0)
     {
      // Alert("Downtrend detected");
      return true;
     }

   return false;
  }

// Function to detect real-time higher highs
double CalculateCurrentHigherHighsDeviation(ENUM_TIMEFRAMES timeframe = PERIOD_M1)
  {
   static double lastHigh = 0;
   double currentHigh = iHigh(_Symbol, timeframe, 0);  // Get current bar high

   if(lastHigh == 0)
     {
      lastHigh = currentHigh;  // Initialize on first tick
      return 0;
     }

   if(currentHigh > lastHigh)
     {
      lastHigh = currentHigh;
      return 1;  // Higher high detected
     }

   return 0;  // No new high detected
  }

// Function to detect real-time lower lows

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CalculateCurrentLowerLowsDeviation(ENUM_TIMEFRAMES timeframe = PERIOD_M1)
  {
   static double lastLow = 0;
   double currentLow = iLow(_Symbol, timeframe, 0);  // Get current bar low

   if(lastLow == 0)
     {
      lastLow = currentLow;  // Initialize on first tick
      return 0;
     }

   if(currentLow < lastLow)
     {
      lastLow = currentLow;
      return -1;  // Lower low detected
     }

   return 0;  // No new low detected
  }

// Function to check if there's a real-time uptrend from current price action


// Define the buffer size for our moving average calculation
#define VELOCITY_BUFFER_SIZE 20

//+------------------------------------------------------------------+
//| Function: CalculatePriceVelocitySMA                              |
//| Purpose: Tracks tick-to-tick price velocity and computes the SMA   |
//|          over the most recent VELOCITY_BUFFER_SIZE ticks           |
//+------------------------------------------------------------------+
double CalculatePriceVelocitySMA()
  {
// Static variables to store previous price and the ring buffer data
   static double lastPrice = 0;
   static double velocityBuffer[VELOCITY_BUFFER_SIZE];
   static int bufferCount = 0; // Number of values currently stored (max VELOCITY_BUFFER_SIZE)
   static int index = 0;       // Current index in the ring buffer

// Get the current bid price
   double currentPrice = SymbolInfoDouble(Symbol(), SYMBOL_BID);

// If this is the first tick, initialize and return 0 velocity
   if(lastPrice == 0)
     {
      lastPrice = currentPrice;
      return 0;
     }

// Compute the instantaneous velocity as the difference between current and previous price
   double instantaneousVelocity = currentPrice - lastPrice;
   lastPrice = currentPrice;

// Store the instantaneous velocity in our ring buffer
   velocityBuffer[index] = instantaneousVelocity;
   index = (index + 1) % VELOCITY_BUFFER_SIZE; // Wrap index around when reaching the buffer size

   if(bufferCount < VELOCITY_BUFFER_SIZE)
      bufferCount++;

// Compute the average velocity from the stored values
   double sum = 0;
   for(int i = 0; i < bufferCount; i++)
      sum += velocityBuffer[i];

   double avgVelocity = sum / bufferCount;
   return avgVelocity;
  }

//+------------------------------------------------------------------+
//| Function: CalculateRSIVelocitySMA                                |
//| Purpose: Tracks the tick-to-tick change in RSI and computes the SMA  |
//|          over the most recent VELOCITY_BUFFER_SIZE ticks           |
//+------------------------------------------------------------------+
double CalculateRSIVelocitySMA(int rsiPeriod = 14, ENUM_TIMEFRAMES timeframe = 0)
  {
// Static variables to store the previous RSI and the ring buffer data
   static double lastRSI = 0;
   static double velocityBuffer[VELOCITY_BUFFER_SIZE];
   static int bufferCount = 0;
   static int index = 0;

// Calculate the current RSI using the built-in iRSI function
   double currentRSI = getRSI(timeframe);

// If this is the first call, initialize lastRSI and return 0 velocity
   if(lastRSI == 0)
     {
      lastRSI = currentRSI;
      return 0;
     }

// Compute the instantaneous RSI velocity as the difference between current and previous RSI
   double instantaneousRSIVelocity = currentRSI - lastRSI;
   lastRSI = currentRSI;

// Store the instantaneous RSI velocity in our ring buffer
   velocityBuffer[index] = instantaneousRSIVelocity;
   index = (index + 1) % VELOCITY_BUFFER_SIZE;

   if(bufferCount < VELOCITY_BUFFER_SIZE)
      bufferCount++;

// Compute the average RSI velocity from the stored values
   double sum = 0;
   for(int i = 0; i < bufferCount; i++)
      sum += velocityBuffer[i];

   double avgRSIVelocity = sum / bufferCount;
   return avgRSIVelocity;
  }

// Structure to store trend data and trend strength
struct TrendData
  {
   double            lastHigh;
   double            lastLow;
   double            highDeviation;
   double            lowDeviation;
   int               consecutiveHighs;
   int               consecutiveLows;
   double            trendStrength; // Trend strength score based on deviations
  };

// Declare static trend data for real-time tracking
static TrendData trendData = {0, 0, 0, 0, 0, 0, 0};

// Function to calculate and update trend information
void UpdateTrendData(ENUM_TIMEFRAMES timeframe=PERIOD_M5)
  {
   static datetime lastProcessedTime = 0;  // Track the last processed period
   datetime currentTime = iTime(Symbol(), timeframe, 0);  // Get the current period start time

// ShowAlertWithDelay(currentTime + " " + lastProcessedTime, ALERT_10);
   if(currentTime == lastProcessedTime)
      return;  // Skip if still in the same period

   lastProcessedTime = currentTime;  // Update the last processed time


// Calculate current deviations
   double highDeviation = CalculateCurrentHigherHighsDeviation(timeframe);
   double lowDeviation = CalculateCurrentLowerLowsDeviation(timeframe);

// Update trend strength based on the deviations
   trendData.trendStrength += highDeviation;  // Add positive deviation (higher highs)
   trendData.trendStrength += lowDeviation;   // Add negative deviation (lower lows)

// Track consecutive highs and lows
   if(highDeviation == 1)
      trendData.consecutiveHighs++;
   else
      if(highDeviation == -1)
         trendData.consecutiveHighs = 0;  // Reset if trend reverses

   if(lowDeviation == -1)
      trendData.consecutiveLows++;
   else
      if(lowDeviation == 1)
         trendData.consecutiveLows = 0;  // Reset if trend reverses

// Update high and low deviation values
   trendData.highDeviation = highDeviation;
   trendData.lowDeviation = lowDeviation;

// Cap trend strength to avoid excessive values
   if(MathAbs(trendData.trendStrength) > 100)
      trendData.trendStrength = 100 * (trendData.trendStrength > 0 ? 1 : -1);  // Cap to max positive/negative value

// Example: Print trend data for debugging
//  Print("Trend Strength: ", trendData.trendStrength);
//  Print("Consecutive Higher Highs: ", trendData.consecutiveHighs);
//  Print("Consecutive Lower Lows: ", trendData.consecutiveLows);
  }


// Function to reset trend data after a specific period or condition (optional)
void ResetTrendData()
  {
   trendData.trendStrength = 0;
   trendData.consecutiveHighs = 0;
   trendData.consecutiveLows = 0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isCurrentUptrend()
  {
   return trendData.trendStrength >= 10;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isCurrentDowntrend()
  {
   return trendData.trendStrength <= -10;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isCurrentUptrendOnce()
  {
   double highDeviation = CalculateCurrentHigherHighsDeviation();
   double lowDeviation = CalculateCurrentLowerLowsDeviation();

   return (highDeviation == 1 && lowDeviation == 1);
  }

// Function to check if there's a real-time downtrend from current price action

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isCurrentDowntrendOnce()
  {
   double highDeviation = CalculateCurrentHigherHighsDeviation();
   double lowDeviation = CalculateCurrentLowerLowsDeviation();

   return (highDeviation == -1 && lowDeviation == -1);
  }


//+------------------------------------------------------------------+

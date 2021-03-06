//+------------------------------------------------------------------+
//|                        Crypto_Trading_Automation_Victor_Ekpo.mq4 |
//|                       Copyright © 2021, Teknix International LLC |
//|                                        https://www.teknixco.net/ |
//+------------------------------------------------------------------+

#property copyright "Victor Ekpo"
#property link      "https://teknixco.net"
#property version   "3.0"
#property description "Crypto Trading Automation Bot"
//#property strict //Strict compiling

//Define External Inputs
extern string mymsg = "Welcome to the million dollar life. Thank you God.";
enum messages
  {
   MSG_1_PICK = 0,
   MSG_2_OR_THIS_ONE,
   MSG_3_OR_EVEN,
  };
extern messages mycustommsg = 0;
extern double BTCUSD_TrailingStop = 1000000;
extern double ETHUSD_TrailingStop = 1000; //trailing stop loss set after threshold is reached, differs for different pairs
extern double BreathingRoom = 1;

//Define Variables
string mode, rangeMode;
string lastmode[15];
//Messages
string praisemsgs[] = {"Thank you God.","Thank you Lord."};
string msg = praisemsgs[mycustommsg];
string buy_msgs[] = {" is going up! #BUYSIGNAL"," Get ready to buy! #BUYSIGNAL"};
string majorbuy_msgs[] = {" is going up ALOTT! #MAJORBUY #BUYSIGNAL"," BUY RIGHT NOW! #MAJORBUY #BUYSIGNAL"};
string sell_msgs[] = {" is going down.. Maybe time to sell #SELLSIGNAL"," Get ready to sell! #SELLSIGNAL"};
string majorsell_msgs[] = {" is majorly down. SELL NOW!!! #MAJORSELLSIGNAL"," SELL IT RIGHT NOW! #MAJORSELLSIGNAL"};
string thinking1_msgs[] = {" -price is varying.. still thinking.."," -Hmm..."};
string thinking2_msgs[] = {" +price is varying.. still thinking.."," +Hmm..."};
string goingup_msg =  " is going up";
string goingdown_msg =  " is going down";

int ticket,RandomNumber,i,j,x;
int arrindex = 0;
int c = 1;
int leastProfit = 1;
int VIC[50]; //Take Profit Target, increases dynamically
int countprofit[50];
int countreverse[50];
double prevprofit[50];
double curprofit[50];
double OrderTP[50];
double OrderTime[50];
double OrderTimeDiff[50];
double ProfitTime[50];
double ProfitTimeDiff[50];
double HighestProfit[50];
double NegativeTime[50];
double NegativeTimeDiff[50];
double LowestProfit[50];
double pdiffs[2];
double price1_current,price1_last,pdlast,pdnow,pdrate,currentTime,trendTime,trendDiff,BotTimeDiff;
double BotStartTime = TimeCurrent();

//Symbols



//Define Functions
//Function to calculate Percentage Difference Between Two Numbers
double percdiff(double val1, double val2)
  {
   double result;
   if(val1 == 0) {val1 =1;}
   if(val2 == 0) {val2 =1;}
   result = MathAbs((MathAbs(val1)/MathAbs(val2)-1)*100)*100;
   return(result);
  };
double percdiff_signed(double val1, double val2)
  {
   double result;
   if(val1 == 0) {val1 =1;}
   if(val2 == 0) {val2 =1;}   
   result = ((MathAbs(val1)/MathAbs(val2)-1)*100)*100;
   return(result);
  };
//Function to get Random Number Within a Range
int RandNum()
  {
//loop keeps running until it finds a random number less than bounds
   for(int n = 0; n < 1; n++)
     {
      RandomNumber = MathRand();
      if(RandomNumber > 1 || RandomNumber < 0)
        {
         n--;
        }
     };
   return RandomNumber;
  };



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---,
//--- create timer
   EventSetTimer(5);
//---
   return(INIT_SUCCEEDED);

  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
//--- destroy timer
   EventKillTimer();

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  
//+------------------------------------------------------------------+

// Define OnTick Variables

//Time
   string TimeStamp = Symbol()+" "+Month()+"."+Day()+"."+Year()+" "
     +TimeHour(TimeLocal())+":"+TimeMinute(TimeLocal())+"("+TimeHour(TimeCurrent())+":"+TimeMinute(TimeCurrent());   
   currentTime = TimeCurrent();
   BotTimeDiff = currentTime - BotStartTime;
   trendDiff = currentTime - trendTime;
   if(trendTime == 0) {trendDiff=0;}

//Delimiter
   string begin_msg = "******************BEGIN "+Symbol()+"********************";
   string end_msg = "******************END "+TimeStamp+")********************";
   Print(end_msg); // delimiter begin

//Account Information
   int total=OrdersTotal();
   double marginLevel=AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
   double freeMargin=AccountFreeMargin();
//BTCUSD
   int BTCUSD_buytotal,BTCUSD_selltotal,BTCUSD_buycount,BTCUSD_sellcount;
//ETHUSD
   int ETHUSD_buytotal,ETHUSD_selltotal,ETHUSD_buycount,ETHUSD_sellcount;
//Mode Messages
   string o_mode="";
   string o_mode_test="";
   string test_account="";
   string mode_buy_msg = buy_msgs[RandNum()];
   string mode_majorbuy_msg = majorbuy_msgs[RandNum()];
   string mode_sell_msg = sell_msgs[RandNum()];
   string mode_majorsell_msg = majorsell_msgs[RandNum()];
   string mode_thinking1_msg = thinking1_msgs[RandNum()];
   string mode_thinking2_msg = thinking2_msgs[RandNum()];

//Time-Series Array of Values to Compare Pricing
   MqlRates rates[];
   ArraySetAsSeries(rates,true);
   int copied=CopyRates(Symbol(),0,0,3,rates);
   int TAKEPROFIT[50];
   double price1=rates[0].close;
   double price2=rates[1].close;
   double price3=rates[2].close;
   price1_current=price1;
   pdnow=percdiff(price1,price2);
   pdlast=pdnow;
   pdrate=(percdiff(pdnow,pdiffs[1]))/1000;
   if(price1_last==0){pdrate=0;}
   //Alert(Symbol()," ",price1_current," ",price1_last);

//Highs and Lows
   double highestPrice = High[iHighest(Symbol(), 0, MODE_HIGH, 40, 1)]; // set the highest price, 10 periods from the 4 hour chart, or 40 periods from the 1 hr chart.
   double highestDiff = percdiff(highestPrice,price1);
   double lowestPrice = Low[iLowest(Symbol(), 0, MODE_LOW, 40, 1)]; // set the lowest price, 10 periods from the 4 hour chart, or 40 periods from the 1 hr chart.
   double lowestDiff = percdiff(lowestPrice,price1);
   double priceRange = highestDiff - lowestDiff;
   if(priceRange < 300 || priceRange > -300) {rangeMode="MEDIAN";}
   if(priceRange >= 300) {Print("CLOSER TO LOW");rangeMode="LOW";}
   if(priceRange <= -300) {Print("CLOSER TO HIGH");rangeMode="HIGH";}
   if(priceRange > 600) {rangeMode="VERY_LOW";Print("VERY CLOSE TO LOW!");x++;if(x==1){SendNotification(Symbol()+" is very close to its relative LOW");}}
   if(priceRange < -600) {rangeMode="VERY_HIGH";Print("VERY CLOSETO HIGH!");x++;if(x==1){SendNotification(Symbol()+" is very close to its relative HIGH");}}

//+------------------------------------------------------------------+

// BEGIN ORDERS CHECK BEFORE OTHER LOGIC AND CREATE REPORT
int handle=FileOpen("OrdersReport.csv",FILE_WRITE|FILE_CSV,"\t"); //BEGIN FILE HANDLING
FileWrite(handle,"#","open price","open time","symbol","lots"); // write header
if(OrdersTotal() > 0) // Run check if there is at least one order placed.
 {
 for(int orderindex=0; orderindex<OrdersTotal(); orderindex++) //count current orders to get symbol total
  {
   //DEFINE VARIABLES FOR ORDERS
   OrderTimeDiff[orderindex] = currentTime - OrderTime[orderindex];
   if(OrderTime[orderindex] == 0) {OrderTimeDiff[orderindex]=0;}
   int checksymbolTotal = OrderSelect(orderindex, SELECT_BY_POS, MODE_TRADES);
   FileWrite(handle,OrderTicket(),OrderOpenPrice(),OrderOpenTime(),OrderSymbol(),OrderLots()); // write open orders
   if(OrderSymbol()==Symbol() && OrderType()<=OP_SELL)
     { //begin individual order logic
      if(OrderType()==OP_BUY)
        {
         if(Symbol()=="BTCUSD"){BTCUSD_buycount++;} // check for total by symbol, increment by 1
         if(Symbol()=="ETHUSD"){ETHUSD_buycount++;}
        }
      if(OrderType()==OP_SELL)
        {
         if(Symbol()=="BTCUSD"){BTCUSD_sellcount++;} // check for total by symbol, increment by 1
         if(Symbol()=="ETHUSD"){ETHUSD_sellcount++;}
        }
      //BEGIN PROFIT LOGIC
      TAKEPROFIT[orderindex]=0; 
      OrderTP[orderindex] = OrderProfit() + OrderSwap() + OrderCommission();
      if(OrderTP[orderindex] < 0) {ProfitTime[orderindex] = 0; 
        if(NegativeTime[orderindex] == 0) { NegativeTime[orderindex]=TimeCurrent();} }
      if(OrderTP[orderindex] > 0) {NegativeTime[orderindex] = 0;
        if(ProfitTime[orderindex] == 0) { ProfitTime[orderindex]=TimeCurrent();} }
      ProfitTimeDiff[orderindex] = currentTime - ProfitTime[orderindex];
      NegativeTimeDiff[orderindex] = currentTime - NegativeTime[orderindex];
      if(ProfitTime[orderindex] == 0) { ProfitTimeDiff[orderindex] = 0; }
      if(NegativeTime[orderindex] == 0) { NegativeTimeDiff[orderindex] = 0; }
      if(OrderTP[orderindex] < LowestProfit[orderindex]) { LowestProfit[orderindex] = OrderTP[orderindex]; }
      if(OrderTP[orderindex] > HighestProfit[orderindex]) { HighestProfit[orderindex] = OrderTP[orderindex]; }
      if(OrderTP[orderindex] > 2) {SendNotification("Order#: "+orderindex+" Order Time: "+OrderTimeDiff[orderindex]+" Profit Time: "+ProfitTimeDiff[orderindex]);}
      Print("Order#: ",orderindex," Order Time: ",OrderTimeDiff[orderindex]," Profit Time: ",ProfitTimeDiff[orderindex],
        " Negative Time: ",NegativeTimeDiff[orderindex]," Lowest Profit: $",LowestProfit[orderindex]," Highest Profit: $",HighestProfit[orderindex]," Profit: $",OrderTP[orderindex]);
      curprofit[orderindex]=OrderTP[orderindex];
      // count profit decrease
      if(curprofit[orderindex]<prevprofit[orderindex])
        {
         countreverse[orderindex]++;
        }
      // ********** PROFIT ********
      // increase profit algorithm
      if(OrderTP[orderindex]<=(leastProfit))
        {
         VIC[orderindex]=leastProfit;
        }
      if(OrderTP[orderindex]>=(VIC[orderindex]*1)+0.50)
        {
         VIC[orderindex]++;
         countprofit[orderindex]=0;
         Alert("Increasing take profit $",VIC[orderindex]);
        }
      if(OrderTP[orderindex]>=VIC[orderindex] && curprofit[orderindex]>prevprofit[orderindex])
        {
         countprofit[orderindex]++;
         SendNotification("#"+orderindex+" $"+VIC[orderindex]+" I hold you down, I hold you down girl, like the #V is supposed to.. #NuhLetGo "
           +Symbol()+"  Profit: "+OrderTP[orderindex]+" count: "+countprofit[orderindex]);
         Alert("#",orderindex," $"+VIC[orderindex]+" I hold you down, I hold you down girl, like the #V is supposed to.. #NuhLetGo "
           +Symbol()+"  Profit: "+OrderTP[orderindex]);
         Alert("IN-PROFIT Count #"+countprofit[orderindex]);
        }

      //Alert(orderindex+Symbol()+" c: "+curprofit[orderindex]+" p: "+prevprofit[orderindex]); //TEST
      
     } //end individual order logic
     if(orderindex==(OrdersTotal()-1)) // logic for last order and final accruing of values
     {
       BTCUSD_buytotal=BTCUSD_buycount;BTCUSD_selltotal=BTCUSD_sellcount;
       ETHUSD_buytotal=ETHUSD_buycount;ETHUSD_selltotal=ETHUSD_sellcount;
     }
  }
 } // END ORDERS CHECK
 FileClose(handle); // END FILE HANDLING
 
//+------------------------------------------------------------------+

// BEGIN PRICING LOGIC
//Set Modes Based on Price

//Last Modes
   lastmode[c] = lastmode[c-1]; //add previous value to last modes array at index [c] 
   c++;
   if(c==15){ c=1;} //set last index in last modes array
   lastmode[0] = mode;

//Level 1
   if(price1_current>price1_last && pdnow > pdiffs[1])
     {
      mode="GOINGUP";  //if the most recent price is higher than the price from X time ago, second most recent price
     }
   if(price1_current<price1_last && pdnow > pdiffs[1])
     {
      mode="GOINGDOWN";
     }
   if((price1_current>price1_last && price1>price2 && percdiff(price1,price2) > 10 && pdnow > pdiffs[1]) 
       ||(price1>price2 && price1>price3 && percdiff(price1,price2) > 10 && pdnow > pdiffs[1]))
     {
      mode="BUY";  //if the most recent price is higher than the third most recent price
     }
   if((price1_current<price1_last && price1<price2 && percdiff(price1,price2) > 10 && pdnow > pdiffs[1]) 
       ||(price1<price2 && price1<price3 && percdiff(price1,price2) > 10 && pdnow > pdiffs[1]))
     {
      mode="SELL";
     }
   if(price1>price2 && pdnow < pdiffs[1] && pdrate > 1)
     {
      mode="THINKING1";
     }
   if(price1<price2 && pdnow < pdiffs[1] && pdrate > 1)
     {
      mode="THINKING2";
     }
//Level 2
   if((lastmode[0]=="SELL" && price1>price2 && pdnow > pdiffs[1]) || (price1>price2 && pdrate > 1 && pdnow > pdiffs[1]))
     {
      mode="MAJORBUY";
     }
   if((lastmode[0]=="BUY" && price1<price2 && pdnow > pdiffs[1]) || (price1<price2 && pdrate > 1 && pdnow > pdiffs[1]))
     {
      mode="MAJORSELL";
     }

//Alert(iHigh(Symbol(),PERIOD_M1,(iHighest(Symbol(),PERIOD_M1,MODE_HIGH,10,1))));

//Reset Counts, Counts are for counting how long it stays in that mode, will count each tick.
   if(lastmode[0]!=mode && lastmode[1]!=mode)
     {
      i=0;
      j=0;
    
     }
   if(i==15)
     {
      SendNotification(Symbol()+ " Strong BUY Trend! "+price1);
     }
   if(j==15)
     {
      SendNotification(Symbol()+ " Strong SELL Trend! "+price1);
     }

//Mode Actions
   if(mode=="GOINGUP")
     {
      Print(Symbol(),goingup_msg);
     }
   if(mode=="GOINGDOWN")
     {
      Print(Symbol(),goingdown_msg);
     }
   if(mode=="BUY")
     {
      if(mode!=lastmode[0]) {trendTime = TimeCurrent();}
      Print(Symbol(),mode_buy_msg);
      if(lastmode[5]==lastmode[0] || pdrate > 1)
        {
         mode="MAJORBUY";
        }
     }
   if(mode=="SELL")
     {
      if(mode!=lastmode[0]) {trendTime = TimeCurrent();}
      Print(Symbol(),mode_sell_msg);
      if(lastmode[5]==lastmode[0] || pdrate > 5)
        {
         mode="MAJORSELL";
        }
     }
   if(mode=="MAJORBUY")
     {
      i++;
      o_mode_test="BUY";
      Print(Symbol(),mode_majorbuy_msg, "count: ",i);
      if(i==7 && trendDiff >= 20)
        {
         SendNotification(Symbol()+mode_majorbuy_msg 
          +"  Latest Price:  "+rates[0].close+" Recent Price: "+price1_last+"  2nd Price: "+rates[1].close+"  3rd Price "+rates[2].close
          +" Price1 %: "+pdnow+" vs Price2 %: "+pdiffs[1]+ " Elapsed: "+trendDiff
          +" range: "+priceRange+" rangemode: "+rangeMode
          +" high: "+ highestPrice+ " low: "+lowestPrice);
        }
     }
   if(mode=="MAJORSELL")
     {
      j++;
      o_mode_test="SELL";
      Print(Symbol(),mode_majorsell_msg, "  count: ",j);
      if(j==7 && trendDiff >=20)
        {
         SendNotification(Symbol()+mode_majorsell_msg
           +"  Latest Price:  "+rates[0].close+" Recent Price: "+price1_last+"  2nd Price: "+rates[1].close+"  3rd Price "+rates[2].close
           +" Price1 %: "+pdnow+" vs Price2 %: "+pdiffs[1]+ " Elapsed: "+trendDiff
           +" range: "+priceRange+" rangemode: "+rangeMode
           +" high: "+ highestPrice+ " low: "+lowestPrice);
        }
     }
   if(mode=="THINKING1")
     {
      trendTime = TimeCurrent();
      Print(Symbol(),mode_thinking1_msg);
     }
   if(mode=="THINKING2")
     {
      trendTime = TimeCurrent();
      Print(Symbol(),mode_thinking2_msg);
     }
//Sleep(5000);
//Alert(rates[0].close," ",rates[1].close);

// MESSAGING
   msg = praisemsgs[RandomNumber];
   Print(msg);
//Alert(praisemsgs[RandomNumber]);

//+--------------------,----------------------------------------------+

//BEGIN TREND LOGIC (AFTER MODES ARE SET)
  if(mode == "THINKING1" || mode == "THINKING2") {trendTime = 0; trendDiff = 0;}
  if((lastmode[0] == "MAJORBUY" || lastmode[1] == "MAJORBUY") && (mode == "GOINGDOWN" || mode == "SELL" 
    || mode == "MAJORSELL" || mode == "THINKING1" || mode == "THINKING2")) {trendTime = 0; trendDiff = 0;Print(Symbol()," price switch => sell");}
  if((lastmode[0] == "MAJORSELL" || lastmode[1] == "MAJORSELL") && (mode == "GOINGUP" || mode == "BUY" 
    || mode == "MAJORBUY" || mode == "THINKING1" || mode == "THINKING2")) {trendTime = 0; trendDiff = 0;Print(Symbol()," price switch => buy");}

//+------------------------------------------------------------------+

//BEGIN ORDER LOGIC
   test_account="pass"; //initial value

//BEGIN ACCOUNT CONSTRAINTS
   if((Symbol() == "BTCUSD" && BTCUSD_buytotal + BTCUSD_selltotal >= 2) 
    ||(Symbol() == "ETHUSD" && ETHUSD_buytotal + ETHUSD_selltotal >= 2)  ) // set max orders here
     {
      test_account="fail";
     }
   if(freeMargin<100) //set minimum account balance here
     {
      test_account="fail";
     }
   if(total>=1 && marginLevel<0)
     {
      Print("CHECK MARGIN LEVELS!!!",marginLevel,"%");
      SendNotification("CHECK MARGIN LEVELS!!! $"+AccountFreeMargin());
      test_account="fail";
     }
   if(AccountProfit()<-500){test_account="fail";}
   
//Alert(Symbol()," Buys ",BTCUSD_buytotal," ",ETHUSD_buytotal);
//Alert(Symbol()," Sells ",BTCUSD_selltotal," ",ETHUSD_selltotal);

//BEGIN SECOND LEVEL TESTING BEFORE PLACING ORDER
//BUY MODE
   if(o_mode_test=="BUY")
     {
      if((test_account=="pass" && trendDiff > 1 && pdrate > 1 && (rangeMode == "LOW" || rangeMode == "VERY_LOW" || rangeMode == "MEDIAN"))
         || (test_account=="pass" && trendDiff > 20 && (rangeMode == "LOW" || rangeMode == "VERY_LOW" || rangeMode == "MEDIAN"))
         || (test_account=="pass" && trendDiff > 30 && pdrate > 20 && (rangeMode == "HIGH" || rangeMode == "VERY_HIGH")))
        {
         //if price is lower than relative lowest low, then buy, and if the trend has been going on for more than 20 seconds, and all account tests are passed.
          if((Symbol() == "BTCUSD" && BTCUSD_buytotal < 1) ||
             (Symbol() == "ETHUSD" && ETHUSD_buytotal < 1))
          {
           o_mode="BUY";
          }
        }
     }

//SELL MODE
   if(o_mode_test=="SELL") 
    {
     if((test_account=="pass" && trendDiff > 5 && pdrate > 15 && (rangeMode == "HIGH" || rangeMode == "VERY_HIGH" || rangeMode == "MEDIAN"))
     || (test_account=="pass" && trendDiff > 30 && (rangeMode == "HIGH" || rangeMode == "VERY_HIGH" || rangeMode == "MEDIAN"))
     || (test_account=="pass" && trendDiff > 50 && pdrate > 70 && (rangeMode == "LOW")))
       {
         //if price is higher than relative higher high, then sell, and if the trend has been going on for more than 20 seconds, and all account tests are passed.
        if((Symbol() == "BTCUSD" && BTCUSD_selltotal < 1) ||
           (Symbol() == "ETHUSD" && ETHUSD_selltotal < 1))
        {
         o_mode="SELL";
        }
       }
    }
     
     
//+------------------------------------------------------------------+     
     
//BEGIN PLACING ORDERS
   if(o_mode=="BUY")
     {
      ticket=OrderSend(Symbol(),OP_BUY,0.01,Ask,3,0,/*Bid-StopLoss*Point,*/0,"VICTEKNIX_BUY",178768,0,Green);
      OrderTime[total] = TimeCurrent(); //set the time for the new order at current array index
     }
   if(o_mode=="SELL")
     {
      ticket=OrderSend(Symbol(),OP_SELL,0.01,Bid,3,0,/*Ask+StopLoss*Point,*/0,"VICTEKNIX_SELL",178768,0,Red);
      OrderTime[total] = TimeCurrent(); //set the time for the new order at current array index
     }

//BEGIN CLOSING ORDERS
// it is important to enter the market correctly,
// but it is more important to exit it correctly...
   for(int ordernumber=0; ordernumber<total; ordernumber++)
     {
      int selectTrue = OrderSelect(ordernumber, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL &&   // check for opened position
         OrderSymbol()==Symbol())  // check for symbol
        {
         //TAKE PROFIT LOGIC
         if  (OrderTP[ordernumber]>=50 
          || (OrderTP[ordernumber]>=30 && countprofit[ordernumber]>=1)
          || (OrderTP[ordernumber]>=20 && countprofit[ordernumber]>=2)  
          || (OrderTP[ordernumber]>=(VIC[ordernumber]-1) && countprofit[ordernumber]>=5 && OrderTP[ordernumber]>=15) 
          || (OrderTP[ordernumber]>=(VIC[ordernumber]-1) && countprofit[ordernumber]>=7 && OrderTP[ordernumber]>=10)
          || (OrderTP[ordernumber]>=5 && (NegativeTimeDiff[ordernumber] > 3600 || LowestProfit[ordernumber] < -50)) //add in logic to time order / negatives and close out sooner if order was negative for a long time
          || (OrderTP[ordernumber]>=1 && (NegativeTimeDiff[ordernumber] > 3600 || LowestProfit[ordernumber] < -100)) 
          || (OrderTP[ordernumber]>=0 && (NegativeTimeDiff[ordernumber] > 7200 || LowestProfit[ordernumber] < -150))) // for hard orders, just look to break even
          {
           Alert(Symbol()," TAKE PROFIT!");
           SendNotification(Symbol()+" TAKE PROFIT!");
           TAKEPROFIT[ordernumber]=1;
          }

         // CLOSE ORDERS LOGIC
         if(OrderType()==OP_BUY)   // long position is opened
           {
            // should it be closed?
            if(TAKEPROFIT[ordernumber]==1)
              {
               int close1True = OrderClose(OrderTicket(),OrderLots(),Bid,3,Violet); // close position
               VIC[ordernumber]=leastProfit; //reset Take Profit
               TAKEPROFIT[ordernumber]=0;
               NegativeTime[ordernumber]=0;
               ProfitTime[ordernumber]=0;
               HighestProfit[ordernumber]=0;
               LowestProfit[ordernumber]=0;

               return; // exit
              }
            // check for trailing stop
            if(BTCUSD_TrailingStop>0 || ETHUSD_TrailingStop>0)
              {
               //if profit goes above trailing stop value in dollars minus breathing room.
               if((Symbol() == "BTCUSD" && Bid-OrderOpenPrice()>((Point*BTCUSD_TrailingStop)-(Point*BreathingRoom))) 
                ||(Symbol() == "ETHUSD" && Bid-OrderOpenPrice()>((Point*ETHUSD_TrailingStop)-(Point*BreathingRoom))))
                 {
                  if((Symbol() == "BTCUSD" && OrderStopLoss()<Bid-Point*BTCUSD_TrailingStop) 
                   ||(Symbol() == "ETHUSD" && OrderStopLoss()<Bid-Point*ETHUSD_TrailingStop)
                   || (OrderStopLoss()==0))
                    {
                     int mod1True;
                     if(Symbol()=="BTCUSD") { Alert("BTC Mod TP + ",BTCUSD_TrailingStop);mod1True = OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*BTCUSD_TrailingStop,OrderTakeProfit(),0,Green); }
                     if(Symbol()=="ETHUSD") { Alert("ETH Mod TP + ",ETHUSD_TrailingStop);mod1True = OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*ETHUSD_TrailingStop,OrderTakeProfit(),0,Green); }
                     return;
                    }
                 }
              }
           }
         else // go to short position
           {
            // should it be closed?
            if(TAKEPROFIT[ordernumber]==1)
              {
               int close2True = OrderClose(OrderTicket(),OrderLots(),Ask,3,Violet); // close position
               VIC[ordernumber]=leastProfit; //reset Take Profit
               TAKEPROFIT[ordernumber]=0;
               NegativeTime[ordernumber]=0;
               ProfitTime[ordernumber]=0;
               HighestProfit[ordernumber]=0;
               LowestProfit[ordernumber]=0;
               return; // exit
              }
            // check for trailing stop
            if(BTCUSD_TrailingStop>0 || ETHUSD_TrailingStop>0)
              {
               if((Symbol() == "BTCUSD" && OrderOpenPrice()-Ask>((Point*BTCUSD_TrailingStop))) 
               || (Symbol() == "ETHUSD" && OrderOpenPrice()-Ask>((Point*ETHUSD_TrailingStop)-(Point*BreathingRoom))))
                 {
                  if((Symbol() == "BTCUSD" && OrderStopLoss()>(Ask+Point*BTCUSD_TrailingStop)) 
                   ||(Symbol() == "ETHUSD" && OrderStopLoss()>(Ask+Point*ETHUSD_TrailingStop))
                   || (OrderStopLoss()==0))
                    {
                     int mod2True;
                     if(Symbol()=="BTCUSD") { Alert("BTC Mod TP -");mod2True = OrderModify(OrderTicket(),OrderOpenPrice(),Ask+(Point*BTCUSD_TrailingStop),OrderTakeProfit(),0,Red); }
                     if(Symbol()=="ETHUSD") { Alert("ETH Mod TP -");mod2True = OrderModify(OrderTicket(),OrderOpenPrice(),Ask+(Point*ETHUSD_TrailingStop),OrderTakeProfit(),0,Red); }
                     return;
                    }
                 }
              }
           }
        }
     }


//+------------------------------------------------------------------+   
//BEGIN MESSAGES (LOGS)
   Print(" o_mode_test: ",o_mode_test," o_mode: ",o_mode," test_account: ",test_account
     ," marginLevel: ",marginLevel, " orderstotal: ",total
     ," trend: ",trendDiff);
   Print("Mode-current: ",mode, "                last[0]: ",lastmode[0],"               last[1]: ",lastmode[1],"               last[7]: ",lastmode[7],"               last[14]: ",lastmode[14]);
   Print("PD-current %: ",pdnow," vs Price2 %: ",pdiffs[1], " rate: ",pdrate);
   Print("H/L-high:  $", highestPrice, " low: $",lowestPrice," highdiff: ", highestDiff, " lowdiff: ",lowestDiff," range: ",priceRange, " Mode: ",rangeMode);
   Print("PRICE:        $",rates[0].close," Recent Price: $",price1_last,"  2nd Price: $",rates[1].close,"  3rd Price $",rates[2].close, " elapsed: ",BotTimeDiff);
   Print(begin_msg); // delimiter end

  } // End OnTick

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
//Define OnTimer Variables
//Set Percent Difference Array every x seconds.
   price1_last=price1_current;
   pdiffs[0]=pdnow;
   pdiffs[1]=pdlast;
   arrindex++;
   if(arrindex>1)
     {
      arrindex=0;  //reset arrindex after (x+1)th item (array index)
     }

   for(int z=0; z<OrdersTotal(); z++)                // Check Orders Loop every x seconds
   {
     int selectTrue=OrderSelect(z, SELECT_BY_POS, MODE_TRADES);
     if(OrderSymbol()==Symbol() && selectTrue==1 && OrderType()<=OP_SELL) {
     OrderTP[z] = OrderProfit() + OrderSwap() + OrderCommission();
     prevprofit[z]=OrderTP[z];
     
    }
  }
     
     
  } // End OnTimer
//+------------------------------------------------------------------+

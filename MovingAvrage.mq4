//|                                                         test.mq4 |
//|                                                            Jinga |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Jinga"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//--- input parameters
extern double TakeProfit=100.0;
extern double StopLoss=50.0;
extern int TrailingStop=0;
extern int Slippage=3;
extern int MagicNumber=123456;
extern double Lots=0.1;
extern int OrderDistance=5;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
  }

//+------------------------------------------------------------------+
//| Expert start function                                            |
//+------------------------------------------------------------------+
void OnTick()
  {
//--- get current rates of the symbol
   double Ask = NormalizeDouble(SymbolInfoDouble(Symbol(),SYMBOL_ASK),_Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(Symbol(),SYMBOL_BID),_Digits);

//--- declare order variables
   double BuyStopLoss,BuyTakeProfit;
   double SellStopLoss,SellTakeProfit;

//--- calculating the StopLoss and TakeProfit values for the Buy order
   BuyStopLoss=Bid-StopLoss*_Point;
   BuyTakeProfit=Bid+TakeProfit*_Point;

//--- calculating the StopLoss and TakeProfit values for the Sell order
   SellStopLoss=Ask+StopLoss*_Point;
   SellTakeProfit=Ask-TakeProfit*_Point;

//--- print the prices to log
   Print("Ask price: ", Ask, " Bid price: ", Bid);
   Print("Buy StopLoss: ", BuyStopLoss, " Buy TakeProfit: ", BuyTakeProfit);
   Print("Sell StopLoss: ", SellStopLoss, " Sell TakeProfit: ", SellTakeProfit);

//--- check if there are open orders
   if(OrderSelect(0, SELECT_BY_POS)==true) 
     {
       Print("Order already exists");
       return;
     }
//--- place Buy order
   if(OrderSend(Symbol(), OP_BUY, LotSize, Ask, 3, BuyStopLoss, BuyTakeProfit, "My order", MagicNumber, 0, clrGreen)==true) 
     {
       Print("Buy Order placed successfully");
     }
   else
     {
       Print("Buy Order failed with error: ", GetLastError());
     }
//--- place Sell order
   if(OrderSend(Symbol(), OP_SELL, LotSize, Bid, 3, SellStopLoss, SellTakeProfit, "My order", MagicNumber, 0, clrRed)==true) 
     {
       Print("Sell Order placed successfully");
     }
   else
     {
       Print("Sell Order failed with error: ", GetLastError());
     }
//+------------------------------------------------------------------+
//| Calculate the stop loss for a Buy order                          |
//+------------------------------------------------------------------+
double CalculateBuyStopLoss(double AskPrice, double stopLossPips)
  {
   return NormalizeDouble(AskPrice - stopLossPips * Point, Digits);
  }
//+------------------------------------------------------------------+
//| Calculate the take profit for a Buy order                        |
//+------------------------------------------------------------------+
double CalculateBuyTakeProfit(double AskPrice, double takeProfitPips)
  {
   return NormalizeDouble(AskPrice + takeProfitPips * Point, Digits);
  }
//+------------------------------------------------------------------+
//| Calculate the stop loss for a Sell order                         |
//+------------------------------------------------------------------+
double CalculateSellStopLoss(double BidPrice, double stopLossPips)
  {
   return NormalizeDouble(BidPrice + stopLossPips * Point, Digits);
  }

//+------------------------------------------------------------------+
//| Calculate the take profit for a Sell order                       |
//+------------------------------------------------------------------+
double CalculateSellTakeProfit(double BidPrice, double takeProfitPips)
  {
   return NormalizeDouble(BidPrice - takeProfitPips * Point, Digits);
  }
//+------------------------------------------------------------------+
//| The main function                                                |
//+------------------------------------------------------------------+
int start()
{
   double stopLossPips = 20;
   double takeProfitPips = 40;
   double lotSize = 1.0;

   double AskPrice = MarketInfo(Symbol(), MODE_ASK);
   double BidPrice = MarketInfo(Symbol(), MODE_BID);

   int total = OrdersTotal();
   if(total < 1)
   {
      // Only open a new order if there are no open orders
      if(CheckForBuySignal())
      {
         double stopLoss = CalculateBuyStopLoss(AskPrice, stopLossPips);
         double takeProfit = CalculateBuyTakeProfit(AskPrice, takeProfitPips);
         
         int ticket = OrderSend(Symbol(), OP_BUY, lotSize, AskPrice, 3, stopLoss, takeProfit, "My order", 16384, 0, Green);
         if(ticket < 0)
         {
            Print("OrderSend failed with error #", GetLastError());
            return(-1);
         }
      }
      else if(CheckForSellSignal())
      {
         double stopLoss = CalculateSellStopLoss(BidPrice, stopLossPips);
         double takeProfit = CalculateSellTakeProfit(BidPrice, takeProfitPips);

         int ticket = OrderSend(Symbol(), OP_SELL, lotSize, BidPrice, 3, stopLoss, takeProfit, "My order", 16384, 0, Red);
         if(ticket < 0)
         {
            Print("OrderSend failed with error #", GetLastError());
            return(-1);
         }
      }
   }

   return(0);
}
//+------------------------------------------------------------------+
//| Check for Buy Signal                                             |
//+------------------------------------------------------------------+
bool CheckForBuySignal()
{
   double shortMA = iMA(Symbol(), 0, shortMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);  // Short MA at the previous bar
   double longMA = iMA(Symbol(), 0, longMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);  // Long MA at the previous bar

   double currentShortMA = iMA(Symbol(), 0, shortMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 0); // Short MA at the current bar
   double currentLongMA = iMA(Symbol(), 0, longMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 0); // Long MA at the current bar

   if(shortMA < longMA && currentShortMA > currentLongMA)  // Check for crossover from below
   {
      return(true);
   }
   return(false);
}

//+------------------------------------------------------------------+
//| Check for Sell Signal                                            |
//+------------------------------------------------------------------+
bool CheckForSellSignal()
{
   double shortMA = iMA(Symbol(), 0, shortMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);  // Short MA at the previous bar
   double longMA = iMA(Symbol(), 0, longMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);  // Long MA at the previous bar

   double currentShortMA = iMA(Symbol(), 0, shortMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 0); // Short MA at the current bar
   double currentLongMA = iMA(Symbol(), 0, longMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 0); // Long MA at the current bar

   if(shortMA > longMA && currentShortMA < currentLongMA)  // Check for crossover from above
   {
      return(true);
   }
   return(false);
}
//+------------------------------------------------------------------+
//| Open Buy Order                                                   |
//+------------------------------------------------------------------+
void OpenBuyOrder()
{
   double lotSize = NormalizeDouble(AccountBalance() * risk / 1000.0, 2);  // Calculate the lot size
   double takeProfitPrice = NormalizeDouble(Ask + takeProfit * Point, Digits);  // Calculate the take profit price
   double stopLossPrice = NormalizeDouble(Ask - stopLoss * Point, Digits);  // Calculate the stop loss price

   int ticket = OrderSend(Symbol(), OP_BUY, lotSize, Ask, 3, stopLossPrice, takeProfitPrice, "Buy Order", 0, 0, Green);  // Open a buy order
   if(ticket < 0)  // Check if the order was successfully opened
   {
      Print("Error opening buy order: ", GetLastError());
   }
   else
   {
      Print("Buy order opened successfully");
   }
}

//+------------------------------------------------------------------+
//| Open Sell Order                                                  |
//+------------------------------------------------------------------+
void OpenSellOrder()
{
   double lotSize = NormalizeDouble(AccountBalance() * risk / 1000.0, 2);  // Calculate the lot size
   double takeProfitPrice = NormalizeDouble(Bid - takeProfit * Point, Digits);  // Calculate the take profit price
   double stopLossPrice = NormalizeDouble(Bid + stopLoss * Point, Digits);  // Calculate the stop loss price

   int ticket = OrderSend(Symbol(), OP_SELL, lotSize, Bid, 3, stopLossPrice, takeProfitPrice, "Sell Order", 0, 0, Red);  // Open a sell order
   if(ticket < 0)  // Check if the order was successfully opened
   {
      Print("Error opening sell order: ", GetLastError());
   }
   else
   {
      Print("Sell order opened successfully");
   }
}

//+------------------------------------------------------------------+
//| OnTick function                                                  |
//+------------------------------------------------------------------+
void OnTick()
{
   if(CheckForBuySignal() && !IsThereAnOpenOrder())
   {
      OpenBuyOrder();
   }
   else if(CheckForSellSignal() && !IsThereAnOpenOrder())
   {
      OpenSellOrder();
   }
}

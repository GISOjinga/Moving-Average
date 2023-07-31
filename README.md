# Moving Average Crossover Trading Bot for MetaTrader 4

This project contains a simple, but effective, Moving Average Crossover Trading Bot for MetaTrader 4. This trading bot is implemented in MQL4 and designed to automate trading based on moving average crossover strategies.

## Description

The trading bot is set to execute buy or sell orders whenever there is a crossover between two moving averages, which are set to different periods. This strategy is a popular method used in forex and stock trading for generating buy and sell signals.

Here's how it works:
- It generates a **Buy Signal** when the short-term moving average crosses above the long-term moving average.
- It generates a **Sell Signal** when the short-term moving average crosses below the long-term moving average.

The bot also automatically sets a predefined stop loss and take profit for every trade it enters.

## Installation

1. Download the `.mq4` file from this repository.
2. Place the file into your MetaTrader 4 platform's Experts directory. This can usually be found at `C:\Program Files (x86)\MetaTrader 4\experts\`.
3. Restart MetaTrader 4.
4. The bot will now be available in the Navigator panel under Expert Advisors.

## Configuration

The bot comes with a set of configuration options that can be adjusted according to your preferences:
- `fastMA`: The period for the fast (short-term) moving average.
- `slowMA`: The period for the slow (long-term) moving average.
- `stopLoss`: Stop loss level in points.
- `takeProfit`: Take profit level in points.
- `risk`: The risk level for the lot size calculation (based on account balance).

## Disclaimer

Trading involves a high level of risk and may not be suitable for all investors. Please use this bot at your own risk and discretion. It is recommended to test it thoroughly in a demo environment before using it in a live trading scenario.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue.

## License

This project is open source under the MIT license.

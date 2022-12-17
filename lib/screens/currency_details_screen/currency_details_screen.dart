import 'dart:convert';

import 'package:cryptoapp/models/coin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/currency.dart';
import '../../models/trade.dart';
import '../../utils/constants.dart';
import 'components/currency_chart.dart';
import 'components/trade_button.dart';
import 'components/trade_item.dart';
import 'package:http/http.dart' as http;

class CurrencyDetailsScreen extends StatefulWidget {
  final Coin currency;
  const CurrencyDetailsScreen({
    Key? key,
    required this.currency,
  }) : super(key: key);

  @override
  State<CurrencyDetailsScreen> createState() => _CurrencyDetailsScreenState();
}

class _CurrencyDetailsScreenState extends State<CurrencyDetailsScreen> {
  @override
  void initState() {
    fetchCoin();
    super.initState();
  }

List<double>coinprice=[];
  Future<void> fetchCoin() async {
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=inr&days=7&interval=daily'));

    if (response.statusCode == 200) {
      Map<String, dynamic> values;
      values = json.decode(response.body);
      print(values["prices"].length);
        for (int i = 0; i < values["prices"].length; i++) {
          if (values["prices"][i] != null) {
            int val=values["prices"][i][0];
            double price=val.toDouble();
            // Map<String, dynamic> map = values[i];
            coinprice.add(price);
          }
        }
        setState(() {
          coinprice;
        });
        // print(coinListprice.length);
    } else {
      throw Exception('Failed to load coins');
    }
  }

  Widget appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 32,
            child: Image.network(widget.currency.imageUrl),
          ),
          const SizedBox(width: 12),
          Text(
            widget.currency.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              FontAwesomeIcons.solidStar,
              color: Color(0xFFFFD029),
            ),
          ),
        ],
      ),
    );
  }

  Widget price() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.currency.price.toString(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(6, 6, 8, 6),
            decoration: BoxDecoration(
              color: widget.currency.price >= 0
                  ? const Color(0xFF409166)
                  : const Color(0xFFC84747),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  widget.currency.price >= 0
                      ? FontAwesomeIcons.caretUp
                      : FontAwesomeIcons.caretDown,
                  size: 16,
                ),
                const SizedBox(width: 2),
                Text(widget.currency.price.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget timeFrames() {
    final timeFrameList = [
      '1H',
      '8H',
      '1D',
      '1W',
      '1M',
      '3M',
      '6M',
      '1Y',
    ];

    return SizedBox(
      height: 30,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemCount: timeFrameList.length,
        itemBuilder: (_, index) => Container(
          width: 48,
          height: 28,
          decoration: BoxDecoration(
            border: Border.all(
              color: index == 0 ? kPrimaryTextColor : Colors.white,
            ),
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Center(
            child: Text(timeFrameList[index]),
          ),
        ),
      ),
    );
  }

  // Widget tradingHistory() {
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(top: 50, bottom: 80),
            children: [
              appBar(context),
              const SizedBox(height: 36),
              price(),
              const SizedBox(height: 36),
              timeFrames(),
              const SizedBox(height: 24),
              CurrencyChart(priceHistory: coinprice),
              const SizedBox(height: 36),
              // if (currency.tradeHistory.isNotEmpty) tradingHistory(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                TradeButton(tradeDirection: TradeDirection.sell),
                TradeButton(tradeDirection: TradeDirection.buy),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

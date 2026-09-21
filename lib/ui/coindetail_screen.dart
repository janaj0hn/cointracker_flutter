import 'package:flutter/material.dart';
import 'package:indiaditstask/controller/coin_controller.dart';
import 'package:indiaditstask/model/coin_model.dart';
import 'package:indiaditstask/utilis/coinchart.dart';

class CoinDetailScreen extends StatefulWidget {
  final CoinModel coin;

  const CoinDetailScreen({super.key, required this.coin});

  @override
  State<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen> {
  ApiController apiController = ApiController();
  bool isLoading = true;
  bool hasError = false;
  Future<void> getChartData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      await apiController.getChartData(widget.coin.id);
    } catch (e) {
      hasError = true;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        backgroundColor: Colors.amber,
        title: Text(widget.coin.name),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image.network(widget.coin.image, width: 70, height: 70),

            const SizedBox(height: 10),

            Text(
              widget.coin.name,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            Text(
              widget.coin.symbol.toUpperCase(),
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            Text(
              '\$${widget.coin.currentPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              '${widget.coin.priceChangePercentage24h.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 18,
                color: widget.coin.priceChangePercentage24h >= 0
                    ? Colors.green
                    : Colors.red,
              ),
            ),

            const SizedBox(height: 15),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Price Chart',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 15),

            CoinChart(
              prices: apiController.chartData,
              isLoading: isLoading,
              hasError: hasError,
            ),

            const SizedBox(height: 15),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Statistics',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Market Cap'),
                      Text('\$${formatNumber(widget.coin.marketCap)}'),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Volume'),
                      Text('\$${formatNumber(widget.coin.totalVolume)}'),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Circulating Supply'),
                      Text(formatNumber(widget.coin.circulatingSupply)),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Supply'),
                      Text(formatNumber(widget.coin.totalSupply ?? 0)),
                    ],
                  ),

                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatNumber(double number) {
  if (number >= 1000000000000) {
    return '${(number / 1000000000000).toStringAsFixed(2)}T';
  }

  if (number >= 1000000000) {
    return '${(number / 1000000000).toStringAsFixed(2)}B';
  }

  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(2)}M';
  }

  if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(2)}K';
  }

  return number.toStringAsFixed(2);
}

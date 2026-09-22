import 'package:flutter/material.dart';
import 'package:indiaditstask/controller/coin_controller.dart';
import 'package:indiaditstask/model/coin_model.dart';
import 'package:indiaditstask/ui/coindetail_screen.dart';

class CoinCard extends StatefulWidget {
  final CoinModel coin;
  final int index;
  final ApiController apiController;

  const CoinCard({
    super.key,
    required this.coin,
    required this.index,
    required this.apiController,
  });

  @override
  State<CoinCard> createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> {
  ApiController apiController = ApiController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoinDetailScreen(
              coin: widget.coin,
              apiController: widget.apiController,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(
          children: [
            SizedBox(width: 30, child: Text('${widget.index + 1}')),

            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Image.network(widget.coin.image, width: 32, height: 32),

                  const SizedBox(width: 8),

                  Text(
                    widget.coin.symbol.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Text('\$${widget.coin.currentPrice.toStringAsFixed(2)}'),
            ),

            Expanded(
              child: Text(
                '\$${formatNumber(widget.coin.totalVolume)}',
                style: TextStyle(
                  color: widget.coin.priceChangePercentage24h >= 0
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),

            Expanded(
              child: Text(
                '\$${formatNumber(widget.coin.marketCap)}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: Text(
                '\$${formatNumber(widget.coin.totalSupply ?? 0)}',
                style: const TextStyle(fontWeight: FontWeight.w500),
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

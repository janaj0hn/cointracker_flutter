import 'package:flutter/material.dart';
import 'package:indiaditstask/controller/coin_controller.dart';
import 'package:indiaditstask/ui/coindetail_screen.dart';

class WatchListScreen extends StatefulWidget {
  final ApiController apiController;

  const WatchListScreen({super.key, required this.apiController});

  @override
  State<WatchListScreen> createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  @override
  Widget build(BuildContext context) {
    final watchList = widget.apiController.watchList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My watchlist'),
        backgroundColor: Colors.amber,
      ),

      body: watchList.isEmpty
          ? const Center(child: Text('No added watchlist'))
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: ListView.builder(
                itemCount: watchList.length,
                itemBuilder: (context, index) {
                  final coin = watchList[index];

                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoinDetailScreen(
                            coin: coin,
                            apiController: widget.apiController,
                          ),
                        ),
                      );
                    },

                    onLongPress: () {
                      widget.apiController.removeFromWatchList(coin);

                      setState(() {});

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${coin.name} removed from watchlist'),
                        ),
                      );
                    },

                    leading: Image.network(coin.image, width: 40, height: 40),

                    title: Text(coin.name),

                    subtitle: Text(coin.symbol.toUpperCase()),

                    trailing: Text('\$${coin.currentPrice.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
    );
  }
}

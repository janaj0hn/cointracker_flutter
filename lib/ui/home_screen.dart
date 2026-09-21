import 'package:flutter/material.dart';
import 'package:indiaditstask/controller/coin_controller.dart';

import 'package:indiaditstask/utilis/coin_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiController apiController = ApiController();

  bool isLoading = true;

  Future<void> getCoinData() async {
    setState(() {
      isLoading = true;
    });

    await apiController.getCoins();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCoinData();
  }

  bool isSearch = false;

  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: false,

        title: isSearch
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search coin',
                  border: InputBorder.none,
                ),

                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
              )
            : Text('CoinTracker'),

        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearch = !isSearch;

                if (!isSearch) {
                  searchText = '';
                }
              });
            },
            icon: Icon(isSearch ? Icons.close : Icons.search_outlined),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 850,
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Market OverView',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 40),
                          SizedBox(
                            width: 150,
                            child: Text(
                              'Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 150,
                            child: Text(
                              'Price',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 160,
                            child: Text(
                              'Volume',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 160,
                            child: Text(
                              'MarketCap',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 120,
                            child: Text(
                              'Supply',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final coins = apiController.myCoinListData.where((
                            coin,
                          ) {
                            return coin.name.toLowerCase().contains(
                                  searchText.toLowerCase(),
                                ) ||
                                coin.symbol.toLowerCase().contains(
                                  searchText.toLowerCase(),
                                );
                          }).toList();

                          return ListView.builder(
                            itemCount: coins.length,
                            itemBuilder: (context, index) {
                              final coindata = coins[index];

                              return CoinCard(coin: coindata, index: index);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

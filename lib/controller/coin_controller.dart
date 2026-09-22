import 'package:flutter/foundation.dart';
import 'package:indiaditstask/model/coin_model.dart';
import 'package:indiaditstask/parse/coin_parse.dart';

class ApiController extends ChangeNotifier {
  final ApiParse apiParse = ApiParse();

  List<CoinModel> myCoinListData = [];

  Future<void> getCoins() async {
    myCoinListData = await apiParse.getDataParse();
  }

  List<List<dynamic>> chartData = [];

  Future<void> getChartData(String coinId) async {
    chartData = await apiParse.getChartData(coinId);
  }

  List<CoinModel> watchList = [];

  void addToWatchList(CoinModel coin) {
    if (!watchList.contains(coin)) {
      watchList.add(coin);
      notifyListeners();
    }
  }

  void removeFromWatchList(CoinModel coin) {
    if (watchList.remove(coin)) {
      notifyListeners();
    }
  }

  bool isInWatchList(CoinModel coin) {
    return watchList.contains(coin);
  }
}

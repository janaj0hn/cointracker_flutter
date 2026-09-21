import 'package:indiaditstask/model/coin_model.dart';
import 'package:indiaditstask/parse/coin_parse.dart';

class ApiController {
  final ApiParse apiParse = ApiParse();

  List<CoinModel> myCoinListData = [];

  Future<void> getCoins() async {
    myCoinListData = await apiParse.getDataParse();
  }

  List<List<dynamic>> chartData = [];

  Future<void> getChartData(String coinId) async {
    chartData = await apiParse.getChartData(coinId);
  }
}

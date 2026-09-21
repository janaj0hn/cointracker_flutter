import 'package:indiaditstask/api/api.dart';
import 'package:indiaditstask/model/coin_model.dart';

class ApiParse {
  ApiService apiService = ApiService();
  Future<List<CoinModel>> getDataParse() async {
    return await apiService.getData();
  }

  Future<List<List<dynamic>>> getChartData(String coinId) async {
    return await apiService.getChartData(coinId);
  }
}

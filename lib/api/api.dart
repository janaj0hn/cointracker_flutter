import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:indiaditstask/model/coin_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000';

  Future<List<CoinModel>> getData() async {
    final response = await http.get(Uri.parse('$baseUrl/api/coins'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return List<CoinModel>.from(data.map((coin) => CoinModel.fromJson(coin)));
    } else {
      throw Exception('Failed to load coins');
    }
  }

  Future<List<List<dynamic>>> getChartData(String coinId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/coins/$coinId/chart'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return List<List<dynamic>>.from(data['prices']);
    } else {
      throw Exception('Failed to load chart');
    }
  }
}

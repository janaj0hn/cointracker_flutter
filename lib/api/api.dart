import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:indiaditstask/model/coin_model.dart';

class ApiService {
  static const String apiKey = 'CG-RpMb1cMz2HEKsb8isUhqE8ab';

  static const String baseUrl = 'https://api.coingecko.com/api/v3';

  Future<List<CoinModel>> getData() async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/coins/markets'
        '?vs_currency=usd'
        '&order=market_cap_desc'
        '&per_page=100'
        '&page=1'
        '&sparkline=false'
        '&x_cg_demo_api_key=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => CoinModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load coins');
    }
  }

  Future<List<List<dynamic>>> getChartData(String coinId) async {
    final response = await http.get(
      Uri.parse(
        'https://api.coingecko.com/api/v3/coins/$coinId/market_chart'
        '?vs_currency=usd'
        '&days=7'
        '&x_cg_demo_api_key=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return List<List<dynamic>>.from(data['prices']);
    } else {
      throw Exception('Failed to load chart');
    }
  }
}

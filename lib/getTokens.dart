import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class getTokens {
  getTokenDetails() async {
    List<Map<dynamic, dynamic>> ethTokens = [];
    String url =
        'https://api.coingecko.com/api/v3/coins/list?include_platform=true';
    var response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        int i = 0;
        for (var data in decodedData) {
          ethTokens.add(data['platforms']);
        }
        log(ethTokens.toString());
        // log(decodedData[0]['platforms'].toString());
      }
      // log(response.body);
    } catch (e) {
      log(e.toString());
    }
  }
}

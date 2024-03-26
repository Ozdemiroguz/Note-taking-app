import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Quote {
  final String author;
  final String quote;

  Quote({required this.author, required this.quote});
}

class QuoteService {
  Future<Quote> fetchQuote(String category) async {
    var response = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/quotes?category=$category'),
      headers: {
        'X-Api-Key': dotenv.env['QuetoApiKey']!,
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)[0];
      print(data);
      return Quote(author: data['author'], quote: data['quote']);
    } else {
      throw Exception('Failed to load quote');
    }
  }
}

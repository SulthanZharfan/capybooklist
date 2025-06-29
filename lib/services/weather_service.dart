import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:capybooklist/models/weather.dart';

class WeatherService {
  final String _apiKey = '14a0dceeaa62d9ffa5d91018898f5517';

  Future<Weather> fetchWeather(String city) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

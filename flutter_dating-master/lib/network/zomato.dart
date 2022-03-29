import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:folx_dating/models/Restaurant.dart';
import 'package:geolocator/geolocator.dart';

const searchZomato = "https://developers.zomato.com/api/v2.1/search";
const restaurantZomato = "https://developers.zomato.com/api/v2.1/restaurant";

class ZomatoNetwork {
  final search_dio = Dio(BaseOptions(
      baseUrl: 'https://developers.zomato.com/api/v2.1/search',
      headers: {
        'user-key': DotEnv().env['ZOMATO_API_KEY'],
        'Accept': 'application/json',
      }));

  final rest_dio = Dio(BaseOptions(
    baseUrl: restaurantZomato,
    headers: {
      'user-key': DotEnv().env['ZOMATO_API_KEY'],
      'Accept': 'application/json',
    },
  ));

  Future<Restaurant> getRestList(String id) async {
    final response = await rest_dio.get('', queryParameters: {
      'res_id': id,
    });
    var _responseRest = response.data;
    return Restaurant(_responseRest['id'], _responseRest['name'],
        imageUrl: _responseRest['featured_image'],
        latitude: double.parse(_responseRest['location']['latitude']),
        longitude: double.parse(_responseRest['location']['longitude']),
        locality: _responseRest['location']['locality']);
  }

  Future<List> searchRest(String _restName, Position pos) async {
    final response = await search_dio.get('', queryParameters: {
      'q': _restName,
      'lat': pos != null ? pos.latitude : null,
      'lon': pos != null ? pos.longitude : null,
      'count': 20
    });
    return response.data['restaurants'];
  }
}

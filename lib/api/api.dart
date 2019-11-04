import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:achernyak_app/config.dart';
import 'package:achernyak_app/models/movie_page_result.dart';

class TmdbApi {
  static const String API_KEY = TMDB_API_KEY;
  static const String baseUrl = 'api.themoviedb.org';
  final String imageBaseUrl = 'http://image.tmdb.org/t/p/w185/';
  final HttpClient _httpClient = HttpClient();

  Future<MoviePageResult> getSerachList({String query}) async {
    final Uri uri = Uri.https(
      baseUrl,
      '3/search/movie',
      <String, String>{
        'api_key': API_KEY,
        'include_adult': 'true',
        'query': '$query',
      },
    );

    final String response = await _getRequest(uri);

    if (response.isNotEmpty) {
      return MoviePageResult.fromJSON(json.decode(response));
    } else {
      print('error');
      throw Exception('Failed to load movies list');
    } 
  }

  Future<String> _getRequest(Uri uri) async {
    final dynamic request = await _httpClient.getUrl(uri);
    final dynamic response = await request.close();
    final dynamic responseBody = await response.transform(utf8.decoder).join();

    return responseBody;
  }
}

TmdbApi api = TmdbApi();
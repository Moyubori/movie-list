import 'dart:convert';

import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/models/movie_list.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const apiKey = '052afdb6e0ab9af424e3f3c8edbb33fb';
  static const scheme = 'https';
  static const baseUrl = 'api.themoviedb.org';
  static const apiPath = '/3';

  Future<List<Movie>> searchMovies(String query) async {
    final parameters = {
      'api_key': apiKey,
      'query': query,
    };

    final Uri uri = Uri(
      scheme: scheme,
      host: baseUrl,
      path: '$apiPath/search/movie',
      queryParameters: parameters,
    );

    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    final movieList = MovieList.fromJson(json);
    final List<Movie> movieListResults = movieList.results;

    return movieListResults;
  }

  String _encode(String component) => Uri.encodeComponent(component);
}

import 'dart:convert';

import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/models/movie_list.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const apiKey = '052afdb6e0ab9af424e3f3c8edbb33fb';
  static const baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> searchMovies(String query) async {
    final parameters = {
      'api_key': apiKey,
      'query': query,
    };

    final encodedParameters = parameters.entries
        .map((entry) => '${_encode(entry.key)}=${_encode(entry.value)}')
        .join('&');

    final response =
        await http.get(Uri.parse('$baseUrl/search/movie?$encodedParameters'));
    final json = jsonDecode(response.body);
    final movieList = MovieList.fromJson(json);

    return movieList.results;
  }

  String _encode(String component) => Uri.encodeComponent(component);
}

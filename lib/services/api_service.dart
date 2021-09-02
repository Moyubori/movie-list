import 'dart:convert';

import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/models/movie_details.dart';
import 'package:flutter_recruitment_task/models/movie_list.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const apiKey = '052afdb6e0ab9af424e3f3c8edbb33fb';
  static const scheme = 'https';
  static const baseUrl = 'api.themoviedb.org';
  static const apiPath = '/3';

  Future<dynamic> _executeGET(
      {required String path, Map<String, String>? queryParameters}) async {
    final Uri uri = Uri(
      scheme: scheme,
      host: baseUrl,
      path: '$apiPath/$path',
      queryParameters: (queryParameters ?? {})..['api_key'] = apiKey,
    );
    final response = await http.get(uri);
    return jsonDecode(response.body);
  }

  Future<List<Movie>> searchMovies(String query) async {
    final json = await _executeGET(
      path: 'search/movie',
      queryParameters: {'query': query},
    );
    final MovieList movieList = MovieList.fromJson(json);
    final List<Movie> movieListResults = movieList.results;

    return movieListResults;
  }

  Future<MovieDetails> fetchMovieDetails(int id) async {
    final json = await _executeGET(path: 'movie/$id');
    final MovieDetails movieDetails = MovieDetails.fromJson(json);
    return movieDetails;
  }
}

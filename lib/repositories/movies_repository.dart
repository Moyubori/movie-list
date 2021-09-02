import 'package:flutter/cupertino.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/models/movie_details.dart';
import 'package:flutter_recruitment_task/services/api_service.dart';
import 'package:flutter_recruitment_task/utils/locator.dart';

class MoviesRepository {
  late final ApiService _apiService = locator.get();

  // TODO: add more sophisticated cache
  //  - add some timeout after which cache is cleaned
  //  - remove oldest elements, after some capacity is reached
  @visibleForTesting
  late final Map<String, List<Movie>> searchResultsCache = {};
  @visibleForTesting
  late final Map<int, MovieDetails> movieDetailsCache = {};

  Future<List<Movie>> searchMovies({required String query}) async {
    final List<Movie> fetchedMovies = await _apiService.searchMovies(query);

    searchResultsCache[query] = fetchedMovies;

    return fetchedMovies;
  }

  bool hasCachedSearchResults({required String query}) =>
      searchResultsCache.keys.contains(query);

  List<Movie> getCachedSearchResults({required String query}) =>
      searchResultsCache[query] ?? [];

  Future<MovieDetails> fetchMovieDetails({required int id}) async {
    final MovieDetails movieDetails = await _apiService.fetchMovieDetails(id);

    movieDetailsCache[id] = movieDetails;

    return movieDetails;
  }

  bool hasCachedMovieDetails({required int id}) =>
      movieDetailsCache.keys.contains(id);

  MovieDetails? getCachedMovieDetails({required int id}) =>
      movieDetailsCache[id];
}

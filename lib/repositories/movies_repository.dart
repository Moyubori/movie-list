import 'package:flutter/cupertino.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/services/api_service.dart';
import 'package:flutter_recruitment_task/utils/locator.dart';

class MoviesRepository {
  late final ApiService _apiService = locator.get();

  // TODO: add more sophisticated cache
  //  - add some timeout after which cache is cleaned
  //  - remove oldest elements, after some capacity is reached
  @visibleForTesting
  late final Map<String, List<Movie>> moviesCache = {};

  Future<List<Movie>> searchMovies({required String query}) async {
    final List<Movie> fetchedMovies = await _apiService.searchMovies(query);

    moviesCache[query] = fetchedMovies;

    return fetchedMovies;
  }

  bool hasCachedSearchResults({required String query}) =>
      moviesCache.keys.contains(query);

  List<Movie> getCachedSearchResults({required String query}) =>
      moviesCache[query] ?? [];
}

import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/services/api_service.dart';

class MoviesRepository {
  final _apiService = ApiService();

  // TODO: add more sophisticated cache
  //  - add some timeout after which cache is cleaned
  //  - remove oldest elements, after some capacity is reached
  late final Map<String, List<Movie>> _moviesCache = {};

  Future<List<Movie>> searchMovies({required String query}) async {
    final List<Movie> fetchedMovies = await _apiService.searchMovies(query);

    _moviesCache[query] = fetchedMovies;

    return fetchedMovies;
  }

  bool hasCachedSearchResults({required String query}) =>
      _moviesCache.keys.contains(query);

  List<Movie> getCachedSearchResults({required String query}) =>
      _moviesCache[query] ?? [];
}

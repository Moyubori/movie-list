import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/repositories/movies_repository.dart';
import 'package:flutter_recruitment_task/services/api_service.dart';
import 'package:flutter_recruitment_task/utils/locator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  late ApiService apiServiceMock;

  final List<Movie> mockMovies = [
    Movie(title: 'movie', voteAverage: 0.42, id: 1)
  ];

  late MoviesRepository moviesRepository;

  setUp(() {
    moviesRepository = MoviesRepository();

    apiServiceMock = ApiServiceMock();
    locator.registerSingleton<ApiService>(apiServiceMock);
    when(() => apiServiceMock.searchMovies(any<String>()))
        .thenAnswer((_) async => mockMovies);
  });

  tearDown(() async {
    await locator.reset();
  });

  group('searchMovies()', () {
    test('should call API, cache the results, and return them', () async {
      expect(moviesRepository.moviesCache.length, 0);

      final List<Movie> movies =
          await moviesRepository.searchMovies(query: "Hello World!");

      verify(() => apiServiceMock.searchMovies(any<String>()));
      expect(moviesRepository.moviesCache.length, 1);
      expect(movies, mockMovies);
    });
  });

  group('getCachedSearchResults', () {
    test('should return [] when cache does not contain the query', () {
      final List<Movie> movies =
          moviesRepository.getCachedSearchResults(query: "Hello World!");

      expect(movies, []);
    });

    test('should return cached results when cache contains the query', () {
      final String query = "Hello World!";

      moviesRepository.moviesCache[query] = mockMovies;

      final List<Movie> movies =
          moviesRepository.getCachedSearchResults(query: query);

      expect(movies, mockMovies);
    });
  });

  group('hasCachedSearchResults', () {
    test('should return false, when cache does not contain the query', () {
      final bool hasResults =
          moviesRepository.hasCachedSearchResults(query: "Hello World!");

      expect(hasResults, isFalse);
    });

    test('should return true when cache contains the query', () {
      final String query = "Hello World!";

      moviesRepository.moviesCache[query] = mockMovies;

      final bool hasResults =
          moviesRepository.hasCachedSearchResults(query: query);

      expect(hasResults, isTrue);
    });
  });
}

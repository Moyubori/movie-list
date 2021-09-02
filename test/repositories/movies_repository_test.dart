import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/models/movie_details.dart';
import 'package:flutter_recruitment_task/repositories/movies_repository.dart';
import 'package:flutter_recruitment_task/services/api_service.dart';
import 'package:flutter_recruitment_task/utils/locator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  late ApiService apiServiceMock;

  final List<Movie> mockMovies = [
    Movie(title: 'movie1', voteAverage: 0.42, id: 1),
    Movie(title: 'movie2', voteAverage: 0.43, id: 2),
  ];

  final MovieDetails mockDetails = MovieDetails(
    id: 1,
    budget: 1e6.toInt(),
    revenue: 1e8.toInt(),
  );

  late MoviesRepository moviesRepository;

  setUp(() {
    moviesRepository = MoviesRepository();

    apiServiceMock = ApiServiceMock();
    locator.registerSingleton<ApiService>(apiServiceMock);
    when(() => apiServiceMock.searchMovies(any<String>()))
        .thenAnswer((_) async => mockMovies);
    when(() => apiServiceMock.fetchMovieDetails(any<int>()))
        .thenAnswer((_) async => mockDetails);
  });

  tearDown(() async {
    await locator.reset();
  });

  group('searchMovies', () {
    test('should call API, cache the results, and return them', () async {
      expect(moviesRepository.searchResultsCache.length, 0);

      final List<Movie> movies =
          await moviesRepository.searchMovies(query: "Hello World!");

      verify(() => apiServiceMock.searchMovies(any<String>()));
      expect(moviesRepository.searchResultsCache.length, 1);
      expect(movies, mockMovies);
    });

    test('should replace cached results for the same query', () async {
      final String query = "Hello World!";

      moviesRepository.searchResultsCache[query] = [mockMovies.first];
      expect(moviesRepository.searchResultsCache.length, 1);

      final List<Movie> movies =
          await moviesRepository.searchMovies(query: "Hello World!");

      verify(() => apiServiceMock.searchMovies(any<String>()));
      expect(moviesRepository.searchResultsCache.length, 1);
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

      moviesRepository.searchResultsCache[query] = mockMovies;

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

      moviesRepository.searchResultsCache[query] = mockMovies;

      final bool hasResults =
          moviesRepository.hasCachedSearchResults(query: query);

      expect(hasResults, isTrue);
    });
  });

  group('fetchMovieDetails', () {
    test('should call API, cache the result, and return it', () async {
      expect(moviesRepository.movieDetailsCache.length, 0);

      final MovieDetails movieDetails =
          await moviesRepository.fetchMovieDetails(id: 1);

      verify(() => apiServiceMock.fetchMovieDetails(any<int>()));
      expect(moviesRepository.movieDetailsCache.length, 1);
      expect(movieDetails, mockDetails);
    });

    test('should replace cached results for the same id', () async {
      final int id = 1;

      moviesRepository.movieDetailsCache[id] = mockDetails;
      expect(moviesRepository.movieDetailsCache.length, 1);

      final MovieDetails movieDetails =
          await moviesRepository.fetchMovieDetails(id: 1);

      verify(() => apiServiceMock.fetchMovieDetails(any<int>()));
      expect(moviesRepository.movieDetailsCache.length, 1);
      expect(movieDetails, mockDetails);
    });
  });

  group('getCachedMovieDetails', () {
    test('should return null when cache does not contain the id', () {
      final MovieDetails? movieDetails =
          moviesRepository.getCachedMovieDetails(id: 1);
      expect(movieDetails, null);
    });

    test('should return cached results when cache contains the id', () {
      final int id = 1;

      moviesRepository.movieDetailsCache[id] = mockDetails;

      final MovieDetails movieDetails =
          moviesRepository.getCachedMovieDetails(id: 1)!;
      expect(movieDetails, mockDetails);
    });
  });

  group('hasCachedSearchResults', () {
    test('should return false, when cache does not contain the id', () {
      final bool hasResults = moviesRepository.hasCachedMovieDetails(id: 1);

      expect(hasResults, isFalse);
    });

    test('should return true when cache contains the id', () {
      final int id = 1;

      moviesRepository.movieDetailsCache[id] = mockDetails;

      final bool hasResults = moviesRepository.hasCachedMovieDetails(id: id);

      expect(hasResults, isTrue);
    });
  });
}

import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_list_cubit.dart';
import 'package:flutter_recruitment_task/repositories/movies_repository.dart';
import 'package:flutter_recruitment_task/utils/locator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late MoviesRepositoryMock moviesRepository;

  final List<Movie> cachedMockMovies = [
    Movie(title: 'movie1', voteAverage: 0.42, id: 1),
  ];

  final List<Movie> mockMovies = [
    Movie(title: 'movie1', voteAverage: 0.42, id: 1),
    Movie(title: 'movie2', voteAverage: 0.43, id: 2),
  ];

  late MovieListCubit cubit;

  setUp(() {
    cubit = MovieListCubit();

    cubit.stream.listen((event) {
      print(event);
    });

    moviesRepository = MoviesRepositoryMock();
    locator.registerSingleton<MoviesRepository>(moviesRepository);
    when(() =>
            moviesRepository.searchMovies(query: any<String>(named: 'query')))
        .thenAnswer((_) async => mockMovies);
  });

  tearDown(() async {
    await locator.reset();
  });

  test('should be in initial state after initialization', () {
    expect(cubit.state, MovieListState.initial());
  });

  test(
      'should emit loading and loaded states when fetching with no results cached',
      () {
    when(() => moviesRepository.hasCachedSearchResults(
        query: any<String>(named: 'query'))).thenReturn(false);

    expectLater(
      cubit.stream,
      emitsInOrder(
        [
          MovieListState.loading(),
          MovieListState.loaded(movies: mockMovies),
        ],
      ),
    );

    cubit.fetch(query: 'query');
  });

  test(
      'should emit loading and two loaded states when fetching with results cached',
      () {
    when(() => moviesRepository.hasCachedSearchResults(
        query: any<String>(named: 'query'))).thenReturn(true);
    when(() => moviesRepository.getCachedSearchResults(
        query: any<String>(named: 'query'))).thenReturn(cachedMockMovies);

    expectLater(
      cubit.stream,
      emitsInOrder(
        [
          MovieListState.loading(),
          MovieListState.loaded(movies: cachedMockMovies),
          MovieListState.loaded(movies: mockMovies),
        ],
      ),
    );

    cubit.fetch(query: 'query');
  });
}

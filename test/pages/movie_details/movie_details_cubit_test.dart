import 'package:flutter_recruitment_task/models/movie_details.dart';
import 'package:flutter_recruitment_task/pages/movie_details/movie_details_cubit.dart';
import 'package:flutter_recruitment_task/repositories/movies_repository.dart';
import 'package:flutter_recruitment_task/utils/locator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late MoviesRepositoryMock moviesRepository;

  final MovieDetails mockDetails = MovieDetails(
    id: 1,
    budget: 1e6.toInt(),
    revenue: 1e8.toInt(),
  );

  final MovieDetails cachedMockDetails = MovieDetails(
    id: 1,
    budget: 1e8.toInt(),
    revenue: 1e10.toInt(),
  );

  late MovieDetailsCubit cubit;

  setUp(() {
    cubit = MovieDetailsCubit();

    moviesRepository = MoviesRepositoryMock();
    locator.registerSingleton<MoviesRepository>(moviesRepository);
    when(() => moviesRepository.fetchMovieDetails(id: any<int>(named: 'id')))
        .thenAnswer((_) async => mockDetails);
  });

  tearDown(() async {
    await locator.reset();
  });

  test('should be in initial state after initialization', () {
    expect(cubit.state, MovieDetailsState.initial());
  });

  test(
      'should emit loading and loaded states when fetching with no results cached',
      () {
    when(() =>
            moviesRepository.hasCachedMovieDetails(id: any<int>(named: 'id')))
        .thenReturn(false);

    expectLater(
      cubit.stream,
      emitsInOrder(
        [
          MovieDetailsState.loading(),
          MovieDetailsState.loaded(movieDetails: mockDetails),
        ],
      ),
    );

    cubit.fetchDetails(id: 1);
  });

  test(
      'should emit loading and two loaded states when fetching with results cached',
      () {
    when(() =>
            moviesRepository.hasCachedMovieDetails(id: any<int>(named: 'id')))
        .thenReturn(true);
    when(() =>
            moviesRepository.getCachedMovieDetails(id: any<int>(named: 'id')))
        .thenReturn(cachedMockDetails);

    expectLater(
      cubit.stream,
      emitsInOrder(
        [
          MovieDetailsState.loading(),
          MovieDetailsState.loaded(movieDetails: cachedMockDetails),
          MovieDetailsState.loaded(movieDetails: mockDetails),
        ],
      ),
    );

    cubit.fetchDetails(id: 1);
  });
}

import 'package:flutter_recruitment_task/models/movie_details.dart';
import 'package:flutter_recruitment_task/pages/movie_details/movie_details_cubit.dart';
import 'package:flutter_recruitment_task/repositories/movies_repository.dart';
import 'package:flutter_recruitment_task/services/recommendations_service.dart';
import 'package:flutter_recruitment_task/utils/locator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late MoviesRepositoryMock moviesRepositoryMock;
  late RecommendationsServiceMock recommendationsServiceMock;

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

    moviesRepositoryMock = MoviesRepositoryMock();
    recommendationsServiceMock = RecommendationsServiceMock();
    locator.registerSingleton<MoviesRepository>(moviesRepositoryMock);
    locator
        .registerSingleton<RecommendationsService>(recommendationsServiceMock);

    registerFallbackValue<MovieDetails>(mockDetails);
    when(() =>
            moviesRepositoryMock.fetchMovieDetails(id: any<int>(named: 'id')))
        .thenAnswer((_) async => mockDetails);
    when(() => recommendationsServiceMock.isMovieRecommended(
            movieDetails: any<MovieDetails>(named: 'movieDetails')))
        .thenAnswer((_) async => false);
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
    when(() => moviesRepositoryMock.hasCachedMovieDetails(
        id: any<int>(named: 'id'))).thenReturn(false);

    expectLater(
      cubit.stream,
      emitsInOrder(
        [
          MovieDetailsState.loading(),
          MovieDetailsState.loaded(
              movieDetails: mockDetails, isRecommended: false),
        ],
      ),
    );

    cubit.fetchDetails(id: 1);
  });

  test(
      'should emit loading and two loaded states when fetching with results cached',
      () {
    when(() => moviesRepositoryMock.hasCachedMovieDetails(
        id: any<int>(named: 'id'))).thenReturn(true);
    when(() => moviesRepositoryMock.getCachedMovieDetails(
        id: any<int>(named: 'id'))).thenReturn(cachedMockDetails);

    expectLater(
      cubit.stream,
      emitsInOrder(
        [
          MovieDetailsState.loading(),
          MovieDetailsState.loaded(
              movieDetails: cachedMockDetails, isRecommended: false),
          MovieDetailsState.loaded(
              movieDetails: mockDetails, isRecommended: false),
        ],
      ),
    );

    cubit.fetchDetails(id: 1);
  });
}

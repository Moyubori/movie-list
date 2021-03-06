import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_recruitment_task/models/movie_details.dart';
import 'package:flutter_recruitment_task/repositories/movies_repository.dart';
import 'package:flutter_recruitment_task/services/recommendations_service.dart';
import 'package:flutter_recruitment_task/utils/data_loading_state.dart';
import 'package:flutter_recruitment_task/utils/locator.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  late final MoviesRepository _moviesRepository = locator.get();
  late final RecommendationsService _recommendationsService = locator.get();

  MovieDetailsCubit() : super(MovieDetailsState.initial());

  Future<void> fetchDetails({required int id}) async {
    try {
      final Future<MovieDetails> movieDetailsFuture =
          _moviesRepository.fetchMovieDetails(id: id);
      emit(MovieDetailsState.loading());
      await _showCachedDetailsIfPossible(id);
      final MovieDetails movieDetails = await movieDetailsFuture;
      final bool isRecommended = await _recommendationsService
          .isMovieRecommended(movieDetails: movieDetails);
      emit(MovieDetailsState.loaded(
          movieDetails: movieDetails, isRecommended: isRecommended));
    } catch (e) {
      emit(MovieDetailsState.failed());
      rethrow;
    }
  }

  Future<void> _showCachedDetailsIfPossible(int id) async {
    if (_moviesRepository.hasCachedMovieDetails(id: id)) {
      final MovieDetails movieDetails =
          _moviesRepository.getCachedMovieDetails(id: id)!;
      final bool isRecommended = await _recommendationsService
          .isMovieRecommended(movieDetails: movieDetails);
      emit(
        MovieDetailsState.loaded(
          movieDetails: movieDetails,
          isRecommended: isRecommended,
        ),
      );
    }
  }
}

class MovieDetailsState extends Equatable {
  final MovieDetails? movieDetails;
  final DataLoadingState loadingState;
  final bool isRecommended;

  MovieDetailsState._({
    this.movieDetails,
    required this.loadingState,
    this.isRecommended = false,
  });

  factory MovieDetailsState.failed() =>
      MovieDetailsState._(loadingState: DataLoadingState.failed);
  factory MovieDetailsState.initial() =>
      MovieDetailsState._(loadingState: DataLoadingState.initial);
  factory MovieDetailsState.loading() =>
      MovieDetailsState._(loadingState: DataLoadingState.loading);
  factory MovieDetailsState.loaded(
          {required MovieDetails movieDetails, required bool isRecommended}) =>
      MovieDetailsState._(
        movieDetails: movieDetails,
        isRecommended: isRecommended,
        loadingState: DataLoadingState.loaded,
      );

  @override
  List<Object?> get props => [movieDetails, loadingState, isRecommended];
}

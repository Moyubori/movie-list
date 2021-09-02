import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_recruitment_task/models/movie_details.dart';
import 'package:flutter_recruitment_task/repositories/movies_repository.dart';
import 'package:flutter_recruitment_task/utils/data_loading_state.dart';
import 'package:flutter_recruitment_task/utils/locator.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  late final MoviesRepository _moviesRepository = locator.get();

  MovieDetailsCubit() : super(MovieDetailsState.initial());

  Future<void> fetchDetails({required int id}) async {
    try {
      final Future<MovieDetails> movieDetailsFuture =
          _moviesRepository.fetchMovieDetails(id: id);
      emit(MovieDetailsState.loading());
      if (_moviesRepository.hasCachedMovieDetails(id: id)) {
        emit(
          MovieDetailsState.loaded(
              movieDetails: _moviesRepository.getCachedMovieDetails(id: id)!),
        );
      }
      final MovieDetails movieDetails = await movieDetailsFuture;
      emit(MovieDetailsState.loaded(movieDetails: movieDetails));
    } catch (e) {
      emit(MovieDetailsState.failed());
      rethrow;
    }
  }
}

class MovieDetailsState extends Equatable {
  final MovieDetails? movieDetails;
  final DataLoadingState loadingState;

  MovieDetailsState._({this.movieDetails, required this.loadingState});

  factory MovieDetailsState.failed() =>
      MovieDetailsState._(loadingState: DataLoadingState.failed);
  factory MovieDetailsState.initial() =>
      MovieDetailsState._(loadingState: DataLoadingState.initial);
  factory MovieDetailsState.loading() =>
      MovieDetailsState._(loadingState: DataLoadingState.loading);
  factory MovieDetailsState.loaded({required MovieDetails movieDetails}) =>
      MovieDetailsState._(
          movieDetails: movieDetails, loadingState: DataLoadingState.loaded);

  @override
  List<Object?> get props => [movieDetails, loadingState];
}

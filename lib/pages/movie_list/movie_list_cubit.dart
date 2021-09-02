import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/repositories/movies_repository.dart';
import 'package:flutter_recruitment_task/utils/data_loading_state.dart';
import 'package:flutter_recruitment_task/utils/locator.dart';
import 'package:flutter_recruitment_task/utils/movie_list_extension.dart';

class MovieListCubit extends Cubit<MovieListState> {
  late final MoviesRepository _moviesRepository = locator.get();

  MovieListCubit() : super(MovieListState.initial());

  Future<void> fetchMovies({required String query}) async {
    try {
      if (query.isEmpty) {
        emit(MovieListState.initial());
      } else {
        final Future<List<Movie>> movieListFuture =
            _moviesRepository.searchMovies(query: query);
        emit(MovieListState.loading());
        if (_moviesRepository.hasCachedSearchResults(query: query)) {
          emit(
            MovieListState.loaded(
              movies: _moviesRepository.getCachedSearchResults(query: query)
                ..sortByRating(descending: true),
            ),
          );
        }
        final List<Movie> fetchedMovies = await movieListFuture;
        emit(MovieListState.loaded(
            movies: fetchedMovies..sortByRating(descending: true)));
      }
    } catch (e) {
      emit(MovieListState.failed());
      rethrow;
    }
  }
}

class MovieListState extends Equatable {
  final List<Movie> movies;
  final DataLoadingState loadingState;

  MovieListState._({
    required this.movies,
    required this.loadingState,
  });

  factory MovieListState.failed() =>
      MovieListState._(movies: [], loadingState: DataLoadingState.failed);
  factory MovieListState.initial() =>
      MovieListState._(movies: [], loadingState: DataLoadingState.initial);
  factory MovieListState.loading() =>
      MovieListState._(movies: [], loadingState: DataLoadingState.loading);
  factory MovieListState.loaded({required List<Movie> movies}) =>
      MovieListState._(movies: movies, loadingState: DataLoadingState.loaded);

  @override
  List<Object?> get props => [movies, loadingState];
}

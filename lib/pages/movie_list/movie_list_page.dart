import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_recruitment_task/app/routes.dart' as routes;
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_card.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_list_cubit.dart';
import 'package:flutter_recruitment_task/pages/movie_list/search_box.dart';
import 'package:flutter_recruitment_task/utils/data_loading_state.dart';

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPage createState() => _MovieListPage();
}

class _MovieListPage extends State<MovieListPage> {
  late final MovieListCubit _cubit = MovieListCubit();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Movie Browser'),
        ),
        body: BlocBuilder<MovieListCubit, MovieListState>(
            bloc: _cubit,
            builder: (BuildContext context, MovieListState state) {
              return Column(
                children: <Widget>[
                  SearchBox(
                      onSubmitted: (String query) =>
                          _cubit.fetchMovies(query: query)),
                  Expanded(child: _buildContent(state)),
                ],
              );
            }),
      );

  Widget _buildContent(MovieListState state) {
    if (state.loadingState == DataLoadingState.loading) {
      return Center(child: CircularProgressIndicator());
    } else if (state.loadingState == DataLoadingState.failed) {
      return Container(
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Text("Failed loading movies..."),
      );
    } else {
      return _buildMoviesList(state.movies);
    }
  }

  Widget _buildMoviesList(List<Movie> movies) => ListView.separated(
        separatorBuilder: (context, index) => Container(
          height: 1.0,
          color: Colors.grey.shade300,
        ),
        itemBuilder: (BuildContext context, int index) {
          final Movie movie = movies[index];
          return MovieCard(
            title: movie.title,
            rating: '${(movie.voteAverage * 10).toInt()}%',
            onTap: () =>
                Navigator.pushNamed(context, routes.details, arguments: movie),
          );
        },
        itemCount: movies.length,
      );
}

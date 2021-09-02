import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/pages/movie_details/movie_details_cubit.dart';
import 'package:flutter_recruitment_task/utils/data_loading_state.dart';
import 'package:intl/intl.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailsPage({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late final MovieDetailsCubit _cubit = MovieDetailsCubit();
  late final NumberFormat _moneyFormat =
      NumberFormat.compactCurrency(symbol: '\$');

  @override
  void initState() {
    super.initState();
    _cubit.fetchDetails(id: widget.movie.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
          bloc: _cubit,
          builder: (BuildContext context, MovieDetailsState state) {
            if (state.loadingState == DataLoadingState.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.loadingState == DataLoadingState.failed) {
              return Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: Text("Failed loading movie details..."),
              );
            } else if (state.loadingState == DataLoadingState.loaded) {
              return Column(
                children: [
                  _DetailTile(
                    title: 'Budget',
                    content: _moneyFormat.format(state.movieDetails!.budget),
                  ),
                  const Divider(),
                  _DetailTile(
                    title: 'Revenue',
                    content: _moneyFormat.format(state.movieDetails!.revenue),
                  ),
                  const Divider(),
                  _DetailTile(
                    title: 'Should I watch it today?',
                    content: 'Yes',
                  ),
                  const Divider(),
                ],
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final String title;
  final String content;

  const _DetailTile({Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(height: 8.0),
          Text(
            content,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}

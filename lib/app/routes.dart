import 'package:flutter/cupertino.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/pages/movie_details/movie_details_page.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_list_page.dart';
import 'package:flutter_recruitment_task/pages/two_buttons/two_buttons_page.dart';

const String root = '/';
const String details = '/details';
const String two_buttons = '/two_buttons';

final Map<String, WidgetBuilder> routes = {
  root: (BuildContext context) => MovieListPage(),
  details: (BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    return MovieDetailsPage(movie: movie);
  },
  two_buttons: (BuildContext context) => TwoButtonsPage(),
};

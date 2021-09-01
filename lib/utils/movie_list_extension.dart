import 'package:flutter_recruitment_task/models/movie.dart';

extension MovieListUtil on List<Movie> {
  void sortByRating({bool descending = false}) {
    sort((Movie a, Movie b) =>
        a.voteAverage.compareTo(b.voteAverage) * (descending ? -1 : 1));
  }
}

import 'package:flutter_recruitment_task/models/movie_details.dart';

class RecommendationsService {
  static const int _profitThreshold = 1000000;

  // if it was an actual service, it would probably only require the movie's ID,
  // but because it's only a PoC app, I'm leaving it like that for simplicity
  Future<bool> isMovieRecommended({required MovieDetails movieDetails}) async {
    return _isTodaySunday && _profitThresholdReached(movieDetails);
  }

  bool get _isTodaySunday => DateTime.now().weekday == DateTime.sunday;

  bool _profitThresholdReached(MovieDetails movieDetails) =>
      (movieDetails.revenue - movieDetails.budget) > _profitThreshold;
}

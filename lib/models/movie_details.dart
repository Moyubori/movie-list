import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_details.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieDetails extends Equatable {
  final int id;
  final int budget;
  final int revenue;

  MovieDetails({required this.id, required this.budget, required this.revenue});

  factory MovieDetails.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsFromJson(json);

  @override
  List<Object?> get props => [budget, revenue];
}

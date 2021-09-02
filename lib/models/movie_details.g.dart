// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetails _$MovieDetailsFromJson(Map<String, dynamic> json) {
  return MovieDetails(
    id: json['id'] as int,
    budget: json['budget'] as int,
    revenue: json['revenue'] as int,
  );
}

Map<String, dynamic> _$MovieDetailsToJson(MovieDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budget': instance.budget,
      'revenue': instance.revenue,
    };

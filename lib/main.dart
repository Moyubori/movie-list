import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/app/movie_app.dart';
import 'package:flutter_recruitment_task/repositories/movies_repository.dart';
import 'package:flutter_recruitment_task/services/api_service.dart';
import 'package:flutter_recruitment_task/utils/locator.dart';

void main() {
  _registerServices();
  runApp(MovieApp());
}

void _registerServices() {
  locator.registerLazySingleton<ApiService>(() => ApiService());
  locator.registerLazySingleton<MoviesRepository>(() => MoviesRepository());
}

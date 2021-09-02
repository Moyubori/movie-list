import 'package:flutter_recruitment_task/repositories/movies_repository.dart';
import 'package:flutter_recruitment_task/services/api_service.dart';
import 'package:flutter_recruitment_task/services/recommendations_service.dart';
import 'package:mocktail/mocktail.dart';

class ApiServiceMock extends Mock implements ApiService {}

class MoviesRepositoryMock extends Mock implements MoviesRepository {}

class RecommendationsServiceMock extends Mock
    implements RecommendationsService {}

import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/app/routes.dart';

class MovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Movie Browser',
        theme: ThemeData(primarySwatch: Colors.amber),
        initialRoute: '/',
        routes: routes,
      );
}

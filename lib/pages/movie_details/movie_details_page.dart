import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/pages/movie_details/move_detail.dart';

class MovieDetailsPage extends StatefulWidget {
  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  final _details = [
    MovieDetail(title: 'Budget', content: '\$2400000'),
    MovieDetail(title: 'Revenue', content: '\$10000000'),
    MovieDetail(title: 'Should I watch it today?', content: 'Yes!'),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: ListView.separated(
          separatorBuilder: (context, index) => Container(
            height: 1.0,
            color: Colors.grey.shade300,
          ),
          itemBuilder: (context, index) => Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _details[index].title,
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(height: 8.0),
                Text(
                  _details[index].content,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          ),
          itemCount: _details.length,
        ),
      );
}

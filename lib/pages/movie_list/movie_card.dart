import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String rating;
  final VoidCallback onTap;

  const MovieCard({
    required this.title,
    required this.rating,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          height: 48.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.subtitle2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 16.0),
              Text(
                '$rating 🌟',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        ),
      );
}

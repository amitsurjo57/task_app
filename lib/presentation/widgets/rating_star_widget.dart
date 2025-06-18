import 'package:flutter/material.dart';

class RatingStarWidget extends StatefulWidget {
  final double spacing;
  final double iconSize;

  const RatingStarWidget({
    super.key,
    this.spacing = 2,
    this.iconSize = 24,
  });

  @override
  State<RatingStarWidget> createState() => _RatingStarWidgetState();
}

class _RatingStarWidgetState extends State<RatingStarWidget> {
  int _currentRate = 5;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: widget.spacing,
      children: [
        for (int i = 4; i >= 0; i--)
          GestureDetector(
            onTap: () {
              setState(() {
                _currentRate = i;
              });
            },
            child: Icon(
              _currentRate <= i ? Icons.star : Icons.star_outline,
              color: Colors.yellow,
              size: widget.iconSize,
            ),
          ),
      ],
    );
  }
}

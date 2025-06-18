import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:task_app/models/post_model.dart';

class PostWidget extends StatefulWidget {
  final PostModel postModel;

  const PostWidget({super.key, required this.postModel});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 12,
        children: [_upperHead(), _label(), _post(), _likeShareComment()],
      ),
    );
  }

  Row _upperHead() {
    return Row(
      spacing: 8,
      children: [
        CircleAvatar(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Amit Banik Surjo", style: TextStyle(fontSize: 16)),
            Text(widget.postModel.uploadTime, style: TextStyle(fontSize: 16)),
          ],
        ),
        Spacer(),
        Row(
          children: [
            for (int i = 4; i >= 0; i--)
              Icon(
                5 - widget.postModel.ratings <= i
                    ? Icons.star
                    : Icons.star_outline,
                color: Colors.yellow,
                size: 24,
              ),
            Text(
              "${widget.postModel.ratings}.0",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _label() {
    List list = [
      widget.postModel.departureAirport,
      widget.postModel.arrivalAirport,
      widget.postModel.airline,
      widget.postModel.classAirline,
      widget.postModel.travelDate,
    ];
    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (int i = 0; i < 4; i++)
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(list[i]),
          ),
      ],
    );
  }

  Widget _post() {
    return Column(
      spacing: 12,
      children: [
        ExpandableText(
          widget.postModel.captions,
          expandText: '\n\nSee More',
          collapseText: '\n\nSee Less',
          maxLines: 10,
          animation: true,
          animationDuration: Duration(milliseconds: 300),
          animationCurve: Curves.easeInOut,
          linkStyle: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Image.network(
          'https://freenaturestock.com/wp-content/uploads/freenaturestock-2285-768x1152.jpg',
        ),
        Row(
          spacing: 16,
          children: [
            Text(
              "${widget.postModel.likesCount} Like",
              style: TextStyle(fontSize: 20),
            ),
            Icon(Icons.circle, size: 4, color: Colors.grey),
            Text(
              "${widget.postModel.commentsCount} Comments",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ],
    );
  }

  Widget _likeShareComment() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _isLiked = !_isLiked;
                });
              },
              label: Text(
                "Like",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              icon: Icon(
                _isLiked
                    ? Icons.favorite_outlined
                    : Icons.favorite_border_outlined,
                color: Colors.black,
                size: 20,
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              label: Text(
                "Share",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              icon: Icon(Icons.share, color: Colors.black, size: 20),
            ),
          ],
        ),
        Row(
          spacing: 8,
          children: [
            CircleAvatar(),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Write Your Comment",
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                cursorColor: Colors.black,
              ),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.send, size: 28)),
          ],
        ),
      ],
    );
  }
}

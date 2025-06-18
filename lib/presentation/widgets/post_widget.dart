import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:task_app/presentation/widgets/rating_star_widget.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({super.key});

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
            Text("1 day ago", style: TextStyle(fontSize: 16)),
          ],
        ),
        Spacer(),
        RatingStarWidget(),
      ],
    );
  }

  Widget _label() {
    List list = ["LHR-DEL", "Air India", "Business Class", "July 2023"];
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 8,
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
      ),
    );
  }

  Widget _post() {
    return Column(
      spacing: 12,
      children: [
        ExpandableText(
          "Flutter is an open-source UI software development kit created by Google. It can be used to develop cross platform applications from a single codebase for the web,[4] Fuchsia, Android, iOS, Linux, macOS, and Windows.[5] First described in 2015,[6][7] Flutter was released in May 2017. Flutter is used internally by Google in apps such as Google Pay[8][9] and Google Earth[10][11] as well as by other software developers including ByteDance[12][13] and Alibaba.[14][15]"
          "Flutter ships applications with its own rendering engine which directly outputs pixel data to the screen.[16][17] This is in contrast to many other UI frameworks that rely on the target platform to provide a rendering engine, such as native Android apps which rely on the device-level Android SDK or IOS SDK which use the target platform's built-in UI stack. Flutter's control of its rendering pipeline simplifies multi-platform support as identical UI code can be used for all target platforms",
          expandText: 'See More',
          collapseText: 'See Less',
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
            Text("30 Like", style: TextStyle(fontSize: 20)),
            Icon(Icons.circle, size: 4, color: Colors.grey),
            Text("20 Comments", style: TextStyle(fontSize: 20)),
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

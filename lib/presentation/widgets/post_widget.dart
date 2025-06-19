import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:task_app/models/post_model.dart';
import 'package:task_app/presentation/widgets/facebook_photo_collage.dart';

import '../../main.dart';

class PostWidget extends StatefulWidget {
  final PostModel postModel;

  const PostWidget({super.key, required this.postModel});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool _isLiked = false;

  String? _userName;
  String? _userImage;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    String postId = widget.postModel.id;

    final postData = await supaBase.from('posts').select().eq('id', postId);

    String userId = '';

    for (var data in postData) {
      userId = data["user_id"];
    }

    final userData = await supaBase.from('user_list').select().eq('id', userId);

    for (var data in userData) {
      _userName = data['name'];
      _userImage = data['image_url'];
    }

    setState(() {});
  }

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
        CircleAvatar(backgroundImage: NetworkImage(_userImage ?? '')),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_userName ?? '', style: TextStyle(fontSize: 16)),
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
        FacebookPhotoCollage(
          imageUrls: [for (int i = 0; i < 5; i++) widget.postModel.images[i]],
        ),
        Row(
          spacing: 16,
          children: [
            Text("30 Like", style: TextStyle(fontSize: 20)),
            Icon(Icons.circle, size: 4, color: Colors.grey),
            Text("30 Comments", style: TextStyle(fontSize: 20)),
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

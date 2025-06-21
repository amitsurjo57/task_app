import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:task_app/models/post_model.dart';
import 'package:task_app/presentation/screens/comment_screen.dart';
import 'package:task_app/presentation/screens/photo_screen.dart';
import 'package:task_app/presentation/widgets/facebook_photo_collage.dart';
import 'package:task_app/service/shared_preference_service.dart';

import '../../main.dart';

class PostWidget extends StatefulWidget {
  final PostModel postModel;

  const PostWidget({super.key, required this.postModel});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final TextEditingController _commentController = TextEditingController();
  bool _isLiked = false;
  int _likesCount = 0;
  int _commentsCount = 0;
  String? _userName;
  String? _userImage;

  bool _inProgress = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
    _thePostIsLiked();
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  Future<void> _onSendComment() async {
    if (_commentController.text.isEmpty) {
      return;
    }

    try {
      String? userID = await SharedPreferenceService().getUserId();

      DateTime dateTime = DateTime.now();

      _inProgress = true;
      setState(() {});
      final commentsData = await supaBase.from('comments').insert({
        'body': _commentController.text,
        'user_id': userID ?? '',
        'upload_time': '${dateTime.day} / ${dateTime.month} / ${dateTime.year}',
        'likes': [],
        'post_id': widget.postModel.id,
      });

      debugPrint("New comment id: ${commentsData['id']}");

      String commentID = commentsData['id'];

      final postData = await supaBase
          .from('posts')
          .select()
          .eq('id', widget.postModel.id)
          .single();

      List<String> commentsList = List<String>.from(postData['comments'] ?? []);
      debugPrint("$commentsList");

      commentsList.add(commentID);
      _commentsCount = commentsList.length;
      debugPrint("$commentsList");
      await supaBase
          .from('posts')
          .update({'comments': commentsList})
          .eq('id', widget.postModel.id);

      _inProgress = false;
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Something went wrong")));
      }
      _inProgress = false;
      setState(() {});
    }
  }

  Future<void> _thePostIsLiked() async {
    SharedPreferenceService sharedPreferenceService = SharedPreferenceService();

    String? userID = await sharedPreferenceService.getUserId();

    try {
      final postData = await supaBase
          .from('posts')
          .select()
          .eq('id', widget.postModel.id)
          .single();

      List<String> likesList = List<String>.from(postData['likes'] ?? []);

      _likesCount = List<String>.from(postData['likes'] ?? []).length;
      _commentsCount = List<String>.from(postData['comments'] ?? []).length;

      if (likesList.contains(userID)) {
        _isLiked = true;
      } else {
        _isLiked = false;
      }

      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Something went wrong")));
      }
    }
  }

  Future<void> _onTapLiked() async {
    SharedPreferenceService sharedPreferenceService = SharedPreferenceService();

    String? userID = await sharedPreferenceService.getUserId();

    try {
      final postData = await supaBase
          .from('posts')
          .select()
          .eq('id', widget.postModel.id)
          .single();

      List<String> likesList = List<String>.from(postData['likes'] ?? []);
      debugPrint("$likesList");

      if (_isLiked) {
        _isLiked = false;
        likesList.remove(userID);
        _likesCount = likesList.length;
        debugPrint("When Unliked: $likesList");
        await supaBase
            .from('posts')
            .update({'likes': List<String>.from(likesList)})
            .eq('id', widget.postModel.id);
        setState(() {});
      } else {
        _isLiked = true;
        likesList.add(userID ?? " ");
        _likesCount = likesList.length;
        debugPrint("When Liked: $likesList");
        await supaBase
            .from('posts')
            .update({'likes': List<String>.from(likesList)})
            .eq('id', widget.postModel.id);
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Something went wrong")));
      }
    }
  }

  Future<void> _getUserData() async {
    String postId = widget.postModel.id;

    final postData = await supaBase
        .from('posts')
        .select()
        .eq('id', postId)
        .single();

    String userId = postData['user_id'];

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
            for (int i = 0; i < 5; i++)
              Icon(
                widget.postModel.ratings > i ? Icons.star : Icons.star_outline,
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
        widget.postModel.images.length > 5
            ? GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PhotoScreen(imageUrls: widget.postModel.images),
                    ),
                  );
                  _getUserData();
                  _thePostIsLiked();
                },
                child: FacebookPhotoCollage(
                  imageUrls: [
                    for (int i = 0; i < 5; i++) widget.postModel.images[i],
                  ],
                ),
              )
            : GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PhotoScreen(imageUrls: widget.postModel.images),
                    ),
                  );
                  _getUserData();
                  _thePostIsLiked();
                },
                child: FacebookPhotoCollage(
                  imageUrls: [
                    for (int i = 0; i < widget.postModel.images.length; i++)
                      widget.postModel.images[i],
                  ],
                ),
              ),
        Row(
          spacing: 16,
          children: [
            Text("$_likesCount Like", style: TextStyle(fontSize: 20)),
            Icon(Icons.circle, size: 4, color: Colors.grey),
            GestureDetector(
              onTap: () async {
                final data = await supaBase
                    .from('posts')
                    .select()
                    .eq('id', widget.postModel.id)
                    .single();
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentScreen(
                        commentsID: List<String>.from(data['comments']),
                      ),
                    ),
                  );
                }
              },
              child: Text(
                "$_commentsCount Comments",
                style: TextStyle(fontSize: 20),
              ),
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
              onPressed: _onTapLiked,
              label: Text(
                "Like",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              icon: Icon(
                _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
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
            CircleAvatar(backgroundImage: NetworkImage(_userImage ?? "")),
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: "Write Your Comment",
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                cursorColor: Colors.black,
              ),
            ),
            Visibility(
              visible: !_inProgress,
              replacement: CircularProgressIndicator(),
              child: IconButton(
                onPressed: _onSendComment,
                icon: Icon(Icons.send, size: 28),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

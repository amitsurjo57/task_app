import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:task_app/models/comments_model.dart';

import '../../main.dart';
import '../../service/shared_preference_service.dart';

class CommentWidget extends StatefulWidget {
  final CommentsModel commentsModel;

  const CommentWidget({super.key, required this.commentsModel});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final TextEditingController _replyController = TextEditingController();

  bool _isUpvoted = false;
  int _upvotedCount = 0;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
    _replyController.dispose();
  }

  Future<void> _getData() async {
    SharedPreferenceService sharedPreferenceService = SharedPreferenceService();

    String? userID = await sharedPreferenceService.getUserId();

    try {
      final commentData = await supaBase
          .from('comments')
          .select()
          .eq('id', widget.commentsModel.id)
          .single();

      List<String> upvoteList = List<String>.from(commentData['likes'] ?? []);

      _upvotedCount = List<String>.from(commentData['likes'] ?? []).length;

      if (upvoteList.contains(userID)) {
        _isUpvoted = true;
      } else {
        _isUpvoted = false;
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

  Future<void> _onTapUpvote() async {
    SharedPreferenceService sharedPreferenceService = SharedPreferenceService();

    String? userID = await sharedPreferenceService.getUserId();

    try {
      final commentData = await supaBase
          .from('comments')
          .select()
          .eq('id', widget.commentsModel.id)
          .single();

      List<String> upvoteList = List<String>.from(commentData['likes'] ?? []);

      if (_isUpvoted) {
        _isUpvoted = false;
        upvoteList.remove(userID ?? "");
        await supaBase
            .from('comments')
            .update({'likes': upvoteList})
            .eq('id', widget.commentsModel.id);
        _upvotedCount = upvoteList.length;
        setState(() {});
      } else {
        _isUpvoted = true;
        upvoteList.add(userID ?? "");
        await supaBase
            .from('comments')
            .update({'likes': upvoteList})
            .eq('id', widget.commentsModel.id);
        _upvotedCount = upvoteList.length;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [_headerPart(), _mainPart(), _lowerPart(context)],
      ),
    );
  }

  Widget _lowerPart(BuildContext context) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: _onTapUpvote,
          label: Text("Upvote"),
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            iconColor: Colors.black,
          ),
          icon: Icon(
            _isUpvoted ? Icons.thumb_up : Icons.thumb_up_outlined,
          ),
        ),
        Text("$_upvotedCount"),
      ],
    );
  }

  ExpandableText _mainPart() {
    return ExpandableText(
      widget.commentsModel.caption,
      maxLines: 5,
      expandText: "\n\nSee More",
      collapseText: "\n\n See Less",
    );
  }

  Row _headerPart() {
    return Row(
      spacing: 12,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(widget.commentsModel.userImage),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.commentsModel.userName, style: TextStyle(fontSize: 20)),
            Text(widget.commentsModel.time, style: TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }
}

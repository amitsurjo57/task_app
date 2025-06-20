import 'package:flutter/material.dart';
import 'package:task_app/models/comments_model.dart';
import 'package:task_app/presentation/widgets/comment_widget.dart';

import '../../main.dart';

class CommentScreen extends StatefulWidget {
  final List<String> commentsID;

  const CommentScreen({super.key, required this.commentsID});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final List<CommentWidget> _listOfCommentWidget = [];
  bool _inProgress = false;

  @override
  void initState() {
    super.initState();
    _getAllComments();
  }

  Future<void> _getAllComments() async {
    _listOfCommentWidget.clear();
    try {
      _inProgress = true;
      setState(() {});
      for (var cmt in widget.commentsID) {
        final commentData = await supaBase
            .from('comments')
            .select()
            .eq('id', cmt)
            .single();

        final userData = await supaBase
            .from('user_list')
            .select()
            .eq('id', commentData['user_id'])
            .single();

        _listOfCommentWidget.add(
          CommentWidget(
            commentsModel: CommentsModel(
              id: commentData['id'],
              userName: userData['name'],
              userImage: userData['image_url'],
              time: commentData['upload_time'],
              caption: commentData['body'],
              upvote: [],
              replies: [],
            ),
          ),
        );
      }

      _inProgress = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comments")),
      body: RefreshIndicator(
        onRefresh: _getAllComments,
        child: Visibility(
          visible: !_inProgress,
          replacement: Center(child: CircularProgressIndicator()),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.separated(
              itemCount: _listOfCommentWidget.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) => _listOfCommentWidget[index],
            ),
          ),
        ),
      ),
    );
  }
}

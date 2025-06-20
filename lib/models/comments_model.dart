class CommentsModel {
  final String id;
  final String userName;
  final String userImage;
  final String time;
  final String caption;
  final List<String> upvote;
  final List<String> replies;

  CommentsModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.time,
    required this.caption,
    required this.upvote,
    required this.replies,
  });
}

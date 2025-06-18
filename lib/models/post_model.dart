class PostModel {
  final bool isLiked;
  final String captions;
  final List<String> images;
  final String userId;
  final List<String> commentsId;
  final String uploadTime;
  final String departureAirport;
  final String arrivalAirport;
  final String airline;
  final String classAirline;
  final String travelDate;
  final int likesCount;
  final int commentsCount;
  final int ratings;

  PostModel({
    required this.isLiked,
    required this.captions,
    required this.images,
    required this.userId,
    required this.commentsId,
    required this.uploadTime,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.airline,
    required this.classAirline,
    required this.travelDate,
    required this.likesCount,
    required this.commentsCount,
    required this.ratings,
  });
}

class PostModel {
  final String id;
  final String captions;
  final List<String> images;
  final String userId;
  final List<String> comments;
  final List<String> likes;
  final String uploadTime;
  final String departureAirport;
  final String arrivalAirport;
  final String airline;
  final String classAirline;
  final String travelDate;
  final int ratings;

  PostModel({
    required this.id,
    required this.captions,
    required this.images,
    required this.userId,
    required this.comments,
    required this.likes,
    required this.uploadTime,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.airline,
    required this.classAirline,
    required this.travelDate,
    required this.ratings,
  });
}

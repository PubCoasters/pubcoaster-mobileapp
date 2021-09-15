class SinglePost {
  final String uuid;
  final String? picLink;
  final String bar;
  final String description;
  final String location;
  final String createdAt;
  final String? editedAt;
  final int rating;
  final String? createdBy;
  final bool? anonymous;
  final String? busyness;
  final String? neighborhood;
  final List<dynamic> comments;
  final List<dynamic> likes;

  SinglePost(
      {required this.uuid,
      this.picLink,
      this.anonymous,
      this.busyness,
      required this.bar,
      required this.comments,
      required this.createdAt,
      this.createdBy,
      required this.likes,
      required this.location,
      required this.description,
      this.editedAt,
      this.neighborhood,
      required this.rating});

  factory SinglePost.fromJson(Map<String, dynamic> json) {
    if (json['anonymous'] == false && json['neighborhood'] != null) {
      return SinglePost(
          uuid: json['uuid'],
          picLink: json['picLink'],
          bar: json['bar'],
          description: json['description'],
          location: json['location'],
          editedAt: json['editedAt'],
          anonymous: json['anonymous'],
          busyness: json['busyness'],
          rating: json['rating'],
          comments: json['comments'],
          likes: json['likes'],
          createdAt: json['createdAt'],
          neighborhood: json['neighborhood'],
          createdBy: json['createdBy']);
    } else if (json['anonymous'] == false && json['neighborhood'] == null) {
      return SinglePost(
          uuid: json['uuid'],
          picLink: json['picLink'],
          bar: json['bar'],
          description: json['description'],
          location: json['location'],
          busyness: json['busyness'],
          editedAt: json['editedAt'],
          anonymous: json['anonymous'],
          rating: json['rating'],
          comments: json['comments'],
          likes: json['likes'],
          createdAt: json['createdAt'],
          createdBy: json['createdBy']);
    } else if (json['anonymous'] == true && json['neighborhood'] != null) {
      return SinglePost(
          uuid: json['uuid'],
          picLink: json['picLink'],
          bar: json['bar'],
          description: json['description'],
          location: json['location'],
          editedAt: json['editedAt'],
          busyness: json['busyness'],
          anonymous: json['anonymous'],
          rating: json['rating'],
          comments: json['comments'],
          likes: json['likes'],
          createdAt: json['createdAt'],
          neighborhood: json['neighborhood']);
    } else {
      return SinglePost(
          uuid: json['uuid'],
          picLink: json['picLink'],
          bar: json['bar'],
          description: json['description'],
          location: json['location'],
          busyness: json['busyness'],
          editedAt: json['editedAt'],
          anonymous: json['anonymous'],
          rating: json['rating'],
          comments: json['comments'],
          likes: json['likes'],
          createdAt: json['createdAt']);
    }
  }
}

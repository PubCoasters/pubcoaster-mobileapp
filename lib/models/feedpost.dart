class FeedPost {
  final String uuid;
  final String? picLink;
  final String bar;
  final String description;
  final String location;
  final String createdAt;
  final int rating;
  final String? editedAt;
  final int numComments;
  final int numLikes;
  final String? neighborhood;
  final bool anonymous;
  final String? createdBy;
  final String? busyness;

  FeedPost({
    required this.uuid,
    this.picLink,
    required this.bar,
    required this.description,
    required this.location,
    required this.createdAt,
    required this.rating,
    this.editedAt,
    this.neighborhood,
    required this.numComments,
    required this.numLikes,
    required this.anonymous,
    this.createdBy,
    this.busyness,
  });

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    if (json['anonymous'] == false && json['neighborhood'] != null) {
      return FeedPost(
        uuid: json['uuid'],
        picLink: json['picLink'],
        bar: json['bar'],
        description: json['description'],
        location: json['location'],
        editedAt: json['editedAt'],
        anonymous: json['anonymous'],
        rating: json['rating'],
        numComments: json['numComments'],
        numLikes: json['numLikes'],
        createdAt: json['createdAt'],
        neighborhood: json['neighborhood'],
        createdBy: json['createdBy'],
        busyness: json['busyness'],
      );
    } else if (json['anonymous'] == false && json['neighborhood'] == null) {
      return FeedPost(
        uuid: json['uuid'],
        picLink: json['picLink'],
        bar: json['bar'],
        description: json['description'],
        location: json['location'],
        editedAt: json['editedAt'],
        anonymous: json['anonymous'],
        rating: json['rating'],
        numComments: json['numComments'],
        numLikes: json['numLikes'],
        createdAt: json['createdAt'],
        createdBy: json['createdBy'],
        busyness: json['busyness'],
      );
    } else if (json['anonymous'] == true && json['neighborhood'] != null) {
      return FeedPost(
        uuid: json['uuid'],
        picLink: json['picLink'],
        bar: json['bar'],
        description: json['description'],
        location: json['location'],
        editedAt: json['editedAt'],
        anonymous: json['anonymous'],
        rating: json['rating'],
        numComments: json['numComments'],
        numLikes: json['numLikes'],
        createdAt: json['createdAt'],
        neighborhood: json['neighborhood'],
        busyness: json['busyness'],
      );
    } else {
      return FeedPost(
        uuid: json['uuid'],
        picLink: json['picLink'],
        bar: json['bar'],
        description: json['description'],
        location: json['location'],
        editedAt: json['editedAt'],
        anonymous: json['anonymous'],
        rating: json['rating'],
        numComments: json['numComments'],
        numLikes: json['numLikes'],
        createdAt: json['createdAt'],
        busyness: json['busyness'],
      );
    }
  }
}

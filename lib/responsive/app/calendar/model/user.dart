class UserImage {
  final String userID;
  final String imageUrl;
  final String name;

  UserImage({
    required this.userID,
    required this.imageUrl,
    required this.name,
  });

  factory UserImage.fromJson(Map<String, dynamic> json) {
    return UserImage(
        userID: json['userID'], imageUrl: json['imageUrl'], name: json['name']);
  }
}

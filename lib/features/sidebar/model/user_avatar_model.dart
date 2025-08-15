class UserAvatar {
  final String id;
  final String fName;
  final String lName;
  final String email;
  final String? avatar;

  UserAvatar({
    required this.id,
    required this.fName,
    required this.lName,
    required this.email,
    this.avatar,
  });

  factory UserAvatar.fromJson(Map<String, dynamic> json) {
    return UserAvatar(
      id: json['id'],
      fName: json['fName'],
      lName: json['lName'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }

  String get fullName => '$fName $lName';
}

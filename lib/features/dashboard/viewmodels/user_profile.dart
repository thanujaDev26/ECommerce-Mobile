import 'user_model.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String gender;
  final DateTime birthday;
  final String location;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.birthday,
    required this.location,
  });

  int get age {
    final now = DateTime.now();
    int years = now.year - birthday.year;
    if (now.month < birthday.month ||
        (now.month == birthday.month && now.day < birthday.day)) {
      years--;
    }
    return years;
  }

  factory UserProfile.fromUserModel(UserModel user) {
    return UserProfile(
      id: user.id,
      name: user.name,
      email: user.email,
      mobile: user.mobile,
      gender: user.sex,
      birthday: DateTime.parse(user.birthday),
      location: user.address.city,
    );
  }
}

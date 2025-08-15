class UserProfileModel {
  final String id;
  final String fName;
  final String lName;
  final String email;
  final String? avatar;
  final String? mobile;
  final String? addressLine;
  final String? city;
  final String? district;
  final String? province;
  final String? postalCode;
  final String? sex;
  final String? birthday;
  final String? createdAt;

  UserProfileModel({
    required this.id,
    required this.fName,
    required this.lName,
    required this.email,
    this.avatar,
    this.mobile,
    this.addressLine,
    this.city,
    this.district,
    this.province,
    this.postalCode,
    this.sex,
    this.birthday,
    this.createdAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      fName: json['fName'],
      lName: json['lName'],
      email: json['email'],
      avatar: json['avatar'],
      mobile: json['mobile'],
      addressLine: json['address_line'],
      city: json['city'],
      district: json['district'],
      province: json['province'],
      postalCode: json['postalCode'],
      sex: json['sex'],
      birthday: json['birthday'],
      createdAt: json['createdAt'],
    );
  }

  String get fullName => '$fName $lName';
}

class Address {
  final String line;
  final String city;
  final String district;
  final String province;
  final String postalCode;

  Address({
    required this.line,
    required this.city,
    required this.district,
    required this.province,
    required this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      line: json['line'],
      city: json['city'],
      district: json['district'],
      province: json['province'],
      postalCode: json['postalCode'],
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String sex;
  final String birthday;
  final Address address;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.sex,
    required this.birthday,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      sex: json['sex'],
      birthday: json['birthday'],
      address: Address.fromJson(json['address']),
    );
  }
}

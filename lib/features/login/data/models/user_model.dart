class UserModel {
  final String name;
  final String type;
  final String email;
  final String phone;
  final String? image;
  final String password;

  UserModel({
    required this.name,
    required this.type,
    required this.email,
    required this.phone,
    this.image,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      type: json['type'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'email': email,
      'phone': phone,
      'image': image,
      'password': password,
    };
  }
}

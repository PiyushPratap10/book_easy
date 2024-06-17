import 'package:json_annotation/json_annotation.dart';
@JsonSerializable()
class User {
  String name;
  String email;
  String password;
  String number;
  int servicesOngoing;
  int totalBookings;
  String address;
  String? profileImage;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.number,
    this.servicesOngoing = 0,
    this.totalBookings = 0,
    this.address = 'Street 150',
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}


User _$UserFromJson(Map<String, dynamic> json) => User(
      name: json['name'],
      email: json['email'],
      password: json["password"],
      number: json['number'],
      servicesOngoing: json['services_ongoing'] ?? 0,
      totalBookings: json['total_bookings'] ?? 0,
      address: json['address'] ?? 'Street 150',
      profileImage: json['profile_image']
      
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      "name": instance.name,
      "email": instance.email,
      "password": instance.password,
      "number": instance.number,
      "servicesOngoing":instance.servicesOngoing,
      "totalBookings": instance.totalBookings,
      "address":instance.address,
      "profileImage":instance.profileImage
    };
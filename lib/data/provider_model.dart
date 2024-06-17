import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ServiceProvider {
  String name;
  String email;
  String password;
  String number;
  String serviceType;
  bool currentlyBooked;
  int totalServices;
  int charge;
  String address;
  String? profileImage;

  ServiceProvider({
    required this.name,
    required this.email,
    required this.password,
    required this.number,
    required this.serviceType,
    this.currentlyBooked = false,
    this.address = "Street 150",
    this.totalServices = 0,
    this.charge = 500,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) =>
      _$ProviderFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceProviderToJson(this);
}

ServiceProvider _$ProviderFromJson(Map<String, dynamic> json) => ServiceProvider(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      number: json['number'] as String? ?? '',
      password: json['password'] as String? ?? '',
      serviceType: json['service_type'] as String? ?? '',
      currentlyBooked: json['currently_booked'] as bool? ?? false,
      totalServices: json['total_services'] as int? ?? 0,
      charge: json['charge'] as int? ?? 0,
    );

Map<String, dynamic> _$ServiceProviderToJson(ServiceProvider instance) => <String, dynamic>{
      "name": instance.name,
      "email": instance.email,
      "password": instance.password,
      "number": instance.number,
      'service_type': instance.serviceType,
      'currently_booked': instance.currentlyBooked,
      'total_services': instance.totalServices,
      'charge': instance.charge,
      'address': instance.address
    };

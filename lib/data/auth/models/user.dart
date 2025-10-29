import 'dart:convert';
import 'package:ecommerce_app/domain/auth/entity/user.dart';

class UserModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String image;
  final int gender;
  final String status;
  final String walletId;
  final double accountBalance;

  UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
    required this.gender,
    required this.status,
    required this.walletId,
    required this.accountBalance,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'image': image,
      'gender': gender,
      'status': status,
      'walletId': walletId,
      'accountBalance': accountBalance,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId']?.toString() ?? '',
      firstName: map['firstName']?.toString() ?? '',
      lastName: map['lastName']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
      gender: map['gender'] is int
          ? map['gender'] as int
          : int.tryParse(map['gender']?.toString() ?? '0') ?? 0,
      status: map['status']?.toString() ?? 'Pending',
      walletId: map['walletId']?.toString() ?? '',
      accountBalance: map['accountBalance'] is double
          ? map['accountBalance']
          : double.tryParse(map['accountBalance']?.toString() ?? '0.0') ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      image: image,
      gender: gender,
    );
  }
}

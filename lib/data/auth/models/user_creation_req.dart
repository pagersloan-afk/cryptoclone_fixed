class UserCreationReq {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  int? gender;
  String? age;

  // ✅ New fields for crypto onboarding
  String? phoneNumber;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? country;
  String? postalCode;

  UserCreationReq({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.gender,
    this.age,
    this.phoneNumber,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.country,
    this.postalCode,
  });
}

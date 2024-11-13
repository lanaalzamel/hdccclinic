class Medicaltech {
  int id;
  String name;
  String specialization;
  String address;
  String phoneNumber;
  String telefone;
  String email;
  String apiToken;

  Medicaltech({
    required this.id,
    required this.name,
    required this.specialization,
    required this.address,
    required this.phoneNumber,
    required this.telefone,
    required this.email,
    required this.apiToken,
  });

  factory Medicaltech.fromJson(Map<String, dynamic> json) {
    return Medicaltech(
      id: json['id'] ?? 0, // Default value if 'id' is null
      name: json['name'] ?? '', // Default value if 'name' is null
      specialization: json['specialization'] ?? '', // Default value if 'specialization' is null
      address: json['address'] ?? '', // Default value if 'address' is null
      phoneNumber: json['phoneNumber'] ?? '', // Default value if 'phoneNumber' is null
      telefone: json['telefone'] ?? '', // Default value if 'telefone' is null
      email: json['email'] ?? '', // Default value if 'email' is null
      apiToken: json['api_token'] ?? '', // Default value if 'apiToken' is null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'address': address,
      'phoneNumber': phoneNumber,
      'telefone': telefone,
      'email': email,
      'apiToken': apiToken,
    };
  }
}
class Lab {
  Medicaltech medicaltech;
  String tokenType;

  Lab({
    required this.medicaltech,
    required this.tokenType,
  });

  factory Lab.fromJson(Map<String, dynamic> json) {
    return Lab(
      medicaltech: Medicaltech.fromJson(json['medicaltech'] ?? {}), // Initialize with an empty map if 'medicaltech' is null
      tokenType: json['token_type'] ?? '', // Default value if 'token_type' is null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicaltech': medicaltech.toJson(),
      'token_type': tokenType,
    };
  }
}

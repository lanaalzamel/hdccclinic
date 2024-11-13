class Requestmodel {
  int? id;
  int? medicalTechId;
  int? doctorId;
  int? patientId;
  String? requestType;
  DateTime? requestDate;
  String? imagePath;
  DateTime? deliveryDate;
  String? color;
  dynamic? details;
  int? cost;
  dynamic orderImage;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Requestmodel({
    this.id,
    this.medicalTechId,
    this.doctorId,
    this.patientId,
    this.requestType,
    this.requestDate,
    this.imagePath,
    required this.deliveryDate,
    this.color,
    this.details,
    required this.cost,
     this.orderImage,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Requestmodel.fromJson(Map<String, dynamic> json) {
    return Requestmodel(
      id: json['id'],
      medicalTechId: json['medical_tech_id'],
      doctorId: json['doctor_id'],
      patientId: json['patient_id'],
      requestType: json['request_type'],
      requestDate: json['request_date'] != null ? DateTime.parse(json['request_date']) : null,
      imagePath: json['image_path'],
      deliveryDate: DateTime.parse(json['delivery_date']),
      color: json['color'],
      details: json['details'],
      cost: json['cost'],
      orderImage: json['order_image'],
      status: json['status'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medical_tech_id': medicalTechId,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'request_type': requestType,
      'request_date': requestDate?.toIso8601String(),
      'image_path': imagePath,
      'delivery_date': deliveryDate?.toIso8601String(),
      'color': color,
      'details': details,
      'cost': cost,
      'order_image': orderImage,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

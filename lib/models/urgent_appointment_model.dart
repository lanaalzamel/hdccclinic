class Emergency {
  final String patientId;
  final String reason;

  Emergency({required this.patientId, required this.reason});

  Map<String, dynamic> toJson() => {
    'patient_id': patientId,
    'reason': reason,
  };
}

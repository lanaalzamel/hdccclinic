class ServerConfig {
  // static const domainNameServer = 'http://10.0.2.2:8000/';
  // static const domainNameServer = 'http://127.0.0.1:8000/';

  static const domainNameServer = 'http://192.168.1.4:8000/';

  static const register = 'api/register';
  static const loginpatient = 'api/loginpatient';
  static const loginlaboratory = 'api/loginmedicaltech';
  static const getdoctors = 'api/doctors';
  static const resetpasswordcode = 'api/password/resett';
  static const forgetpassword = 'api/password/email';
  static const validatecode = 'api/password/reset';
  static const check_valid = 'api/check-token';
  static const urgentappointment = 'api/appointmentsurgant';
  static const logout = 'api/logoutusers';
  static const showdoctor = 'api/doctorsForMobile';
  static const recommendation = 'api/recommendations';
  static const sendFCMtoken = 'api/store-patient-device-token';
  static const getavailableappointment = 'api/doctor/available-appointments';
  static const patient_send_message = 'api/patient/send-message';
  static const getMessages = 'api/getMessages';


  static String nextAppointment(int id) {
    return 'api/appointments/next/$id';
  }

  static String fetchPatientChats(int id) {
    return 'api/patient/$id/chats';
  }

  static String appointmentBYStatus(int id, String status) {
    return 'api/appointments/status/$status/$id';
  }

  static String payments(int id) {
    return 'api/patients/$id/payments';
  }

  static String regular_appointmrnt(int id) {
    return 'api/appointments/book/$id';
  }

  static String medical_history(int id) {
    return 'api/showMedicalRecordForMobile/$id';
  }

  static String cancelappointment(int appointment_id) {
    return 'api/appointments/cancel/$appointment_id';
  }

  static String Show_AllRequests_Sent_For_Medical_Tech_That_are_not_updated(
      int lab_id) {
    return 'api/Show_AllRequests_Sent_For_Medical_Tech_That_are_not_updated/$lab_id';
  }

  static String showTodayRequests(int lab_id) {
    return 'api/lab-requests/today/$lab_id';
  }

  static String UpdateRequest(int lab_id) {
    return 'api/lab-requests/$lab_id';
  }

  static String showUpdatedRequest(int lab_id) {
    return 'api/Show_Requests_updated/$lab_id';
  }


}

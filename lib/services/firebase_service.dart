
import 'package:cloud_firestore/cloud_firestore.dart';
class FirebaseService {
  Future<void> sendDetails( List<String> imageUrls) async {
    CollectionReference labRequests = FirebaseFirestore.instance.collection('labRequests');

    return labRequests
        .add({
      'imageUrls': imageUrls,
    })
        .then((value) => print("Lab image Added"))
        .catchError((error) => print("Failed to add lab request: $error"));
  }
}

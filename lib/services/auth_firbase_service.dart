import 'package:firebase_auth/firebase_auth.dart';

Future<void> authenticateWithFirebase(String firebaseToken) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCustomToken(firebaseToken);
    print("Firebase Authentication successful: ${userCredential.user?.uid}");
  } catch (e) {
    print("Firebase Authentication failed: $e");
  }
}

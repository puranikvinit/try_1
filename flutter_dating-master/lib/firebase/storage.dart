// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:folx_dating/auth/auth.dart';
// import 'package:path_provider/path_provider.dart';
//
// firebase_storage.FirebaseStorage storage =
//     firebase_storage.FirebaseStorage.instance;
// firebase_storage.Reference ref =
//     firebase_storage.FirebaseStorage.instance.ref(getCurrentUser().uid);
//
// User getCurrentUser() {
//   return FireBase.auth.currentUser;
// }
//
// Future<void> uploadExample() async {
//   Directory appDocDir = await getApplicationDocumentsDirectory();
//   String filePath = '${appDocDir.absolute}/file-to-upload.png';
//   // ...
//   // e.g. await uploadFile(filePath);
// }
//
// Future<void> uploadFile(String filePath) async {
//   File file = File(filePath);
//
//   try {
//     await firebase_storage.FirebaseStorage.instance
//         .ref('uploads/file-to-upload.png')
//         .putFile(file);
//   } on firebase_core.FirebaseException catch (e) {
//     // e.g, e.code == 'canceled'
//   }
// }

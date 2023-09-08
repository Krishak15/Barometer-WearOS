// import 'package:flutter/foundation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirebaseDataProvider with ChangeNotifier {
//   double latitude = 0.0;
//   double longitude = 0.0;

//   Future<void> fetchData() async {
//     try {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('phone_location')
//           .doc('location_document')
//           .get();

//       if (snapshot.exists) {
//         latitude = snapshot['latitude'];
//         longitude = snapshot['longitude'];

//         if (kDebugMode) {
//           print("-------${longitude = snapshot['longitude']}------");
//         }
//         notifyListeners();
//       }
//     } catch (error) {
//       if (kDebugMode) {
//         print('Error fetching data: $error');
//       }
//     }
//   }
// }

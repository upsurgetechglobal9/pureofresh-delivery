
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../commons/shared_prefs.dart';
import '../firebase_path.dart';
import '../models/delivery_boy_info_models.dart';

class FirebaseUserRepository {
  final _firebaseFirestore = FirebaseFirestore.instance;
  final driverToken = Constants.prefs!.getString("token");

  Future<void> createUser(
      FirebaseDriverProfileDetailsModel driverDetails) async {
    try {
      return await _firebaseFirestore

          .collection(FirebasePath.driver)
          .doc(driverDetails.driverId)
          .set(driverDetails.toJson());
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateUser(
      FirebaseDriverProfileDetailsModel driverDetails) async {
    try {
      return await _firebaseFirestore
          .collection(FirebasePath.driver)
          .doc(driverDetails.driverId)
          .update(driverDetails.toJson());
    } catch (error) {
      rethrow;
    }
  }

  Future<void> manageUser(
      FirebaseDriverProfileDetailsModel firebaseUserProfileDetails) async {
    try {
      final existingUserData =
          await fetchUserData(userId: firebaseUserProfileDetails.driverId);
      if (existingUserData != null) {
        await updateUser(firebaseUserProfileDetails);
      } else {
        await createUser(firebaseUserProfileDetails);
      }
    } catch (error) {
      Fluttertoast
          .showToast(msg: error.toString());
  
    }
  }

  Stream<FirebaseDriverProfileDetailsModel?> streamUserDetails(
      {required String userId}) {
    try {
      return _firebaseFirestore
          .collection(FirebasePath.driver)
          .doc(userId)
          .snapshots(includeMetadataChanges: true)
          .map((snaps) {
        final userDetails = snaps.data();
        if (userDetails != null) {
          return FirebaseDriverProfileDetailsModel.fromJson(userDetails);
        } else {
          return null;
        }
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<FirebaseDriverProfileDetailsModel?> fetchUserData(
      {required String userId}) async {
    try {
      return await _firebaseFirestore
          .collection(FirebasePath.driver)
          .doc(userId)
          .get()
          .then(
            (response) => response.data() != null
                ? FirebaseDriverProfileDetailsModel.fromJson(response.data()!)
                : null,
          );
    } catch (e) {
      // Record the error in Firebase Crashlytics
          Fluttertoast.showToast(msg: e.toString());
      return null;
    }
  }
}

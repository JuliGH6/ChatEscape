import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_escape/models/trip_model.dart';

class FirestoreService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> addTrip(TripModel trip) async{
    DocumentReference docRef = await _db.collection('trips').add(trip.toJson());
    return docRef.id;
  }

  Future<void> addAvailability(String tripId, String userId, Map<String, dynamic> availability) async{
    await _db.collection('trips').doc(tripId).collection('availability').doc(userId).set(availability);
  }

  Future<void> deleteTrip(String tripId) async{
    await _db.collection('trips').doc(tripId).delete();
  }

  Future<bool> checkIfExists(String tripId) async {
    var doc = await _db.collection('trips').doc(tripId).get();
    return doc.exists;
  }

  Future<void> addUserToTrip(String tripId, String userId) async {
    await _db.collection('trips').doc(tripId).update({
      'userId': FieldValue.arrayUnion([userId]),
    });
  }

  Future<String> getUserName(String userId) async {
    return await _db.collection("users").doc(userId).get().then((doc) {
      final data = doc.data() as Map<String, dynamic>;
      print('\n\n\n\n ${data['name']} \n\n\n\n');
      return data['name'];
    });
  }
}
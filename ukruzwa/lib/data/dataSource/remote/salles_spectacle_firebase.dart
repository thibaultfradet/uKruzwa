import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukruzwa/domain/models/salle_spectacle.dart';

Future<void> createSalleSpectacle(SalleSpectacle salleSpectacleCreate) async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  DocumentReference docRef = await db
      .collection("SalleSpectacle")
      .add(salleSpectacleCreate.toFirestore());
  //on reset l'id en base avec l'id du document
  await docRef.update({'idSalleSpectacle': docRef.id});
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukruzwa/domain/models/sonorisation.dart';

Future<String> createSonorisation(Sonorisation sonorisationCreate) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final docSonorisation = db.collection("Sonorisation").doc();
  try {
    await docSonorisation
        .set(sonorisationCreate.toFirestore(docSonorisation.id));
  } catch (exception) {
    return "";
  }
  return docSonorisation.id;
}

Future<Sonorisation> retrieveSonorisation(String idSonorisation) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final docSonorisation = db.collection("Sonorisation").doc(idSonorisation);

  var getDataSonorisation = await docSonorisation.get();
  Map<String, dynamic>? dataSonorisation = getDataSonorisation.data();

  return Sonorisation.fromJSON(dataSonorisation!);
}

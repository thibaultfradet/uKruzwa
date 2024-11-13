import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/data/dataSource/remote/firebase.dart';
import 'package:ukruzwa/domain/models/Instrument.dart';
import 'package:ukruzwa/domain/models/Personne.dart';
import 'package:ukruzwa/domain/models/Style.dart';
import 'package:ukruzwa/domain/models/Ville.dart';
import 'package:ukruzwa/presentation/blocs/postuler/postuler_event.dart';
import 'package:ukruzwa/presentation/blocs/postuler/postuler_state.dart';

class PostulerBloc extends Bloc<PostulerEvent, PostulerState> {
  PostulerBloc() : super(PostulerStateInitial([], [])) {
    //State/Event initial
    on<PostulerEvent>((event, emit) async {
      List<Style> styleDisponible = await findAllStyle();
      List<Instrument> instrumentDisponible = await findAllInstrument();
      emit(PostulerStateInitial(styleDisponible, instrumentDisponible));
    });

    //Event ajout du postulat
    on<PostulerEventUtilisateurValider>((event, emit) async {
      bool isCreateSuccess = false;

      /* 
      On va créer le postulat pour cela on récupère l'utilisateur actif afin de récupérer ses infos dans la bdd firestore et créer l'objet candidat en base
      */
      Candidat candidatTemp = Candidat(
        "",
        "nom",
        "prenom",
        "mail",
        Ville(
          codePostal: "",
          idVille: -1,
          nomVille: "",
        ),
      );
      isCreateSuccess = await createPostulat(
          event.groupeConcerner.idGroupe, candidatTemp, [], []);

      emit(PostulerStateCreateStatut(isSuccess: isCreateSuccess));
    });
  }
}

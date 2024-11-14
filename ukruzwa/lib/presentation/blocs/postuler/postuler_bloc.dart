import 'package:firebase_auth/firebase_auth.dart';
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

      List<Style> styleDisponible = await findAllStyle();
      List<Instrument> instrumentDisponible = await findAllInstrument();

      /* 
      On va créer le postulat pour cela on récupère l'utilisateur actif afin de récupérer ses infos dans la bdd firestore et créer l'objet candidat en base
      */
      List<int> listeIdStylesSaisies = [];
      List<int> listeIdInstrumentsSaisies = [];
      /* 
      pour chaque instrument/style on vérifie si il est dans la base de données
      => si pas dans la liste du findAll alors on le créer en base 
      => Dans tt les cas on recup l'id associer pour créer les listes
      */
      for (var i = 0; i < event.instrumentsJoues.length; i++) {
        Instrument? instrumentTemp;
        instrumentTemp = instrumentDisponible
            .where((instrument) =>
                instrument.nomInstrument == event.instrumentsJoues[i])
            .first;
        //valeur null donc pas trouver dans la liste donc pas dans la bdd
        if (instrumentTemp == null) {
          int maxIdInstrument = await getMaxIdInstrument();
          instrumentTemp = Instrument(
            idInstrument: maxIdInstrument,
            nomInstrument: event.instrumentsJoues[i],
          );
          createInstrument(instrumentTemp);
        }
        listeIdInstrumentsSaisies.add(instrumentTemp.idInstrument);
      }
      for (var i = 0; i < event.stylesJoues.length; i++) {
        Style? styleTemp;
        styleTemp = styleDisponible
            .where((style) => style.nomStyle == event.stylesJoues[i])
            .first;
        //valeur null donc pas trouver dans la liste donc pas dans la bdd
        if (styleTemp == null) {
          int maxIdStyle = await getMaxIdStyle();
          styleTemp = Style(
            idStyle: maxIdStyle,
            nomStyle: event.instrumentsJoues[i],
          );
          createStyle(styleTemp);
        }
        listeIdStylesSaisies.add(styleTemp.idStyle);
      }
      final FirebaseAuth auth = FirebaseAuth.instance;

      //Objet candidat pour faire un retrieve
      Personne personneTemp = Personne(
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
      personneTemp = await retrievePersonne(auth.currentUser!.email!);
      isCreateSuccess = await createPostulat(
          event.groupeConcerner.idGroupe, personneTemp, [], []);

      emit(PostulerStateCreateStatut(isSuccess: isCreateSuccess));
    });
  }
}

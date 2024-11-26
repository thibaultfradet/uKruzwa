import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/data/dataSource/remote/salles_spectacle_firebase.dart';
import 'package:ukruzwa/data/dataSource/remote/ville_firebase.dart';
import 'package:ukruzwa/domain/models/salle_spectacle.dart';
import 'package:ukruzwa/domain/models/ville.dart';
import 'package:ukruzwa/presentation/blocs/ajoutsallesp/ajout_sallesp_event.dart';
import 'package:ukruzwa/presentation/blocs/ajoutsallesp/ajout_sallesp_state.dart';

class AjoutSalleSpBloc extends Bloc<AjoutSalleSpEvent, AjoutSalleSpState> {
  AjoutSalleSpBloc() : super(AjoutSalleSpStateInitial()) {
    //Etat initial
    on<AjoutSalleSpEvent>((event, emit) async {
      emit(AjoutSalleSpStateInitial());
    });

    //L'utilisateur valide sa création
    on<ASPCreate>((event, emit) async {
      //Création longue donc on emit un state de chargement en attendant
      emit(ASPLoading());
      try {
        Ville? villeTemp;
        String idVille = "";

        //Récupération de toutes les villes de la base de données
        List<Ville> villeDisponible = await findAllVille();
        try {
          villeTemp = villeDisponible
              .where(
                (ville) =>
                    ville.codePostal == event.codePostalSalle &&
                    ville.nomVille == event.villeSalle,
              )
              .first;
        } catch (e) {
          // ville pas trouver dans celle disponible => null
          villeTemp = null;
        }
        //Si ville à null alors l'objet n'existe pas donc on le crée en base
        if (villeTemp == null) {
          villeTemp = Ville(
              idVille: "",
              codePostal: event.codePostalSalle,
              nomVille: event.villeSalle);
          //On crée la ville en base
          idVille = await createVille(villeTemp);
        }

        //Création objet spectacle en base
        SalleSpectacle spCreate = SalleSpectacle(
            "",
            event.nomSalle,
            //Si la ville à été créer auparavant on la retrieve en se basant sur l'id récupérer du create sinon on assigne l'objet recuperer du .where
            idVille == "" ? await retrieveVille(idVille) : villeTemp,
            event.nbPlaceMaximum,
            event.possederSonorisation,
            event.possederIngenieur,
            event.estPublique);
        createSalleSpectacle(spCreate);

        //Si encore pas catch alors la création a reussi on emit donc le state
        emit(ASPSuccess());
      } catch (e) {
        //Non réussi => on emit le state failure
        emit(ASPFailure());
      }
    });
  }
}

import 'package:ukruzwa/data/dataSource/remote/groupe_firebase.dart';
import 'package:ukruzwa/data/dataSource/remote/instrument_firebase.dart';
import 'package:ukruzwa/data/dataSource/remote/personne_firebase.dart';
import 'package:ukruzwa/data/dataSource/remote/style_firebase.dart';
import 'package:ukruzwa/data/dataSource/remote/ville_firebase.dart';
import 'package:ukruzwa/domain/models/groupe.dart';
import 'package:ukruzwa/domain/models/instrument.dart';
import 'package:ukruzwa/domain/models/personnne.dart';
import 'package:ukruzwa/domain/models/style.dart';
import 'package:ukruzwa/domain/models/ville.dart';
import 'package:ukruzwa/presentation/blocs/ajoutgroupe/ajoutgroupe_event.dart';
import 'package:ukruzwa/presentation/blocs/ajoutgroupe/ajoutgroupe_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/utils/constants/current_user.dart';

class AjoutgroupeBloc extends Bloc<AjoutgroupeEvent, AjoutgroupeState> {
  AjoutgroupeBloc()
      : super(AjoutgroupeStateInitial(
          contactDisponible: [],
          instrumentDisponible: [],
          styleDisponible: [],
          villeDisponible: [],
        )) {
    //Etat initial
    on<AjoutgroupeEvent>((event, emit) async {
      List<Ville> villeDisponible = await findAllVille();
      List<Style> styleDisponible = await findAllStyle();
      List<Instrument> instrumentDisponible = await findAllInstrument();
      List<Contact> contactDisponible = await findAllContact();
      emit(AjoutgroupeStateInitial(
          villeDisponible: villeDisponible,
          styleDisponible: styleDisponible,
          contactDisponible: contactDisponible,
          instrumentDisponible: instrumentDisponible));
    });

    //Création d'un groupe event
    on<AGEventCreate>((event, emit) async {
      Groupe groupeCreate;

      //Pour comparer avec des .where et recuperer les items

      List<Ville> villeDisponible = await findAllVille();
      List<Style> styleDisponible = await findAllStyle();
      List<Instrument> instrumentDisponible = await findAllInstrument();
      List<Contact> contactDisponible = await findAllContact();

      /* Récupération des id des objets connus => si pas connus alors on les créer en base et on récupère leurs ids */
      //Ville de repetition
      Ville? villeRepetition;
      // try car .first si pas trouver provoque une exception
      try {
        villeRepetition = villeDisponible
            .where((ville) =>
                ville.codePostal == event.codePostalVilleRepetition &&
                ville.nomVille == event.nomVilleRepetition)
            .first;
      } catch (e) {
        // ville pas trouver dans celle disponible => null
        villeRepetition = null;
      }

      //Si ville à null alors l'objet n'existe pas donc on le crée en base
      if (villeRepetition == null) {
        villeRepetition = Ville(
            codePostal: event.codePostalVilleRepetition,
            nomVille: event.nomVilleRepetition);
        //On crée la ville en base
        createVille(villeRepetition);
      }

      //style
      //pour chaque item saisies par l'utilisateur
      List<Style> listeStyleDuGroupe = [];
      for (var i = 0; i < event.stylesDuGroupe.length; i++) {
        Style? styleDuGroupe;
        //try car .first provoque exception si pas trouver
        try {
          styleDuGroupe = styleDisponible
              .where((style) => style.nomStyle == event.stylesDuGroupe[i])
              .first;
        } catch (e) {
          styleDuGroupe = null;
        }
        //Si style à null alors l'objet n'existe pas on le créer en base
        if (styleDuGroupe == null) {
          styleDuGroupe = Style(
            nomStyle: event.stylesDuGroupe[i],
          );
          // On créer le style
          createStyle(styleDuGroupe);
        }
        listeStyleDuGroupe.add(styleDuGroupe);
      }

      //instrument
      //pour chaque item saisies par l'utilisateur
      List<Instrument> listeInstrumentDuGroupe = [];
      for (var i = 0; i < event.instrumentsDuGroupe.length; i++) {
        Instrument? instrumentDuGroupe;
        // try car .first provoque exception si pas trouver
        try {
          instrumentDuGroupe = instrumentDisponible
              .where((instrument) =>
                  instrument.nomInstrument == event.instrumentsDuGroupe[i])
              .first;
        } catch (e) {
          instrumentDuGroupe = null;
        }
        //Si instrument à null alors l'objet n'existe pas on le créer en base
        if (instrumentDuGroupe == null) {
          instrumentDuGroupe =
              Instrument(nomInstrument: event.instrumentsDuGroupe[i]);

          //On créer l'instrument en base
          createInstrument(instrumentDuGroupe);
        }
        listeInstrumentDuGroupe.add(instrumentDuGroupe);
      }

      // On vérifie si le contact existe si il n'existe pas en base alors on le créer
      // Dans touts les cas on associe son numéro de téléphone
      Contact? contactGroupe;
      //try car .first fait exception si pas trouver
      try {
        contactGroupe = contactDisponible
            .where((contactItem) =>
                contactItem.mail == CurrentUser.getUserCurrent.email)
            .first;
      }
      //Contact pas existent dans la table contact donc on le met a null pour le créer en base
      catch (e) {
        contactGroupe = null;
      }

      //Si contact a null alors il n'existe pas en base donc on le créer
      if (contactGroupe == null) {
        Personne user =
            await retrievePersonneByMail(CurrentUser.getUserCurrent.email!);
        createContact(user);

        //Une fois créer on créer un objet contact = à l'objet personne
        contactGroupe = user as Contact;
      }

      // on n'utilise que les paramètre non nullable car rapport uniquement avec la page ajout groupe et pas sono
      groupeCreate = Groupe(
        idGroupe: "",
        nomGroupe: event.nomGroupe,
        numeroRemplacementContact: event.numeroRemplacementContact,
        possederSonorisation: event.possederSonorisation,
        villeRepetition: villeRepetition,
        personneAContacter: contactGroupe,
        stylesDuGroupe: listeStyleDuGroupe,
        instrumentsDuGroupe: listeInstrumentDuGroupe,
        endroitsDejaJoues: [],
      );

      try {
        //Création longue donc on emit un state de chargement en attendant
        emit(AGLoading());

        //Appel de la méthode de création
        createGroupe(groupeCreate);
        //Réussi => on emit le state success
        emit(AGSuccess(groupeCreate.possederSonorisation));
      } catch (e) {
        //Non réussi => on emit le state failure
        emit(AGFailure());
      }
    });
  }
}

class Instrument {
  final String? idInstrument;
  final String nomInstrument;

  /* Constructeur vide */
  Instrument.empty()
      : idInstrument = "",
        nomInstrument = '';
  /* Constructeur surcharger */
  Instrument({this.idInstrument, required this.nomInstrument});

  /* FONCTION DE CONVERSION */
  Map<String, dynamic> toFirestore(String idInstrument) {
    return {
      'idInstrument': idInstrument,
      'NomInstrument': nomInstrument,
    };
  }

  factory Instrument.fromJSON(Map<String, dynamic> json) {
    return Instrument(
      nomInstrument: json["NomInstrument"],
      idInstrument: json["idInstrument"],
    );
  }
}

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
  /* FONCTION DE CONVERSION */
  Map<String, dynamic> toFirestore() {
    return {
      'NomInstrument': nomInstrument,
    };
  }

  factory Instrument.fromJSON(Map<String, dynamic> json) {
    return Instrument(
      nomInstrument: json["NomInstrument"],
    );
  }
}

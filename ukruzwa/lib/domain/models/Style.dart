class Style {
  final int? idStyle;
  final String nomStyle;

  /* Constructeur vide */
  Style.empty()
      : idStyle = 0,
        nomStyle = '';
  /* Constructeur surcharger */
  Style({this.idStyle, required this.nomStyle});

  /* FONCTION DE CONVERSION */
  Map<String, dynamic> toFirestore() {
    return {
      'NomStyles': nomStyle,
    };
  }

  factory Style.fromJSON(Map<String, dynamic> json) {
    return Style(
      nomStyle: json["NomStyle"],
    );
  }
}

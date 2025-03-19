class Style {
  String? idStyle;
  final String nomStyle;

  /* Constructeur vide */
  Style.empty()
      : idStyle = "",
        nomStyle = '';
  /* Constructeur surcharger */
  Style({this.idStyle, required this.nomStyle});

  /* FONCTION DE CONVERSION */
  Map<String, dynamic> toFirestore(String idStyle) {
    return {
      'idStyle': idStyle,
      'NomStyle': nomStyle,
    };
  }

  factory Style.fromJSON(Map<String, dynamic> json) {
    return Style(
      idStyle: json["idStyle"],
      nomStyle: json["NomStyle"],
    );
  }
}

class SymbolLookUp {
  String description;
  String displaySymbol;
  String symbol;
  String type;

  SymbolLookUp({
    required this.description,
    required this.displaySymbol,
    required this.symbol,
    required this.type,
  });

  factory SymbolLookUp.fromJson(Map<String, dynamic> json) => SymbolLookUp(
        description: json["description"],
        displaySymbol: json["displaySymbol"],
        symbol: json["symbol"],
        type: json["type"],
      );
}

class SymbolLookUp {
  String description;
  String displaySymbol;
  String symbol;
  String type;
  double? porcentChange, currentPrice;
  List<double>? prices;

  SymbolLookUp({
    required this.description,
    required this.displaySymbol,
    required this.symbol,
    required this.type,
    this.porcentChange,
    this.currentPrice,
    this.prices = const [],
  });

  factory SymbolLookUp.fromJson(Map<String, dynamic> json) => SymbolLookUp(
        description: json["description"],
        displaySymbol: json["displaySymbol"],
        symbol: json["symbol"],
        type: json["type"],
      );

  SymbolLookUp copyWith({
    String? description,
    String? displaySymbol,
    String? symbol,
    String? type,
    double? porcentChange,
    double? currentPrice,
    List<double>? prices,
  }) {
    return SymbolLookUp(
      description: description ?? this.description,
      displaySymbol: displaySymbol ?? this.displaySymbol,
      symbol: symbol ?? this.symbol,
      type: type ?? this.type,
      porcentChange: porcentChange ?? this.porcentChange,
      currentPrice: currentPrice ?? this.currentPrice,
      prices: prices ?? this.prices,
    );
  }
}

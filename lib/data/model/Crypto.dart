class Crypto {
  String id;
  String name;
  String symbol;
  double changePercent24Hr;
  double priceUsd;
  double marketCapUsd;
  int rank;

  Crypto(this.id, this.name, this.symbol, this.changePercent24Hr, this.priceUsd,
      this.marketCapUsd, this.rank);

  factory Crypto.mapJsonObject(Map<String, dynamic> mapJsonObject) {
    return Crypto(
        mapJsonObject['id'],
        mapJsonObject['name'],
        mapJsonObject['symbol'],
        double.parse(mapJsonObject['changePercent24Hr']),
        double.parse(mapJsonObject['priceUsd']),
        double.parse(mapJsonObject['marketCapUsd']),
        int.parse(mapJsonObject['rank']));
  }
}

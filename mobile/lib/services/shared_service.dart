class SharedService {
  // Données partagées
  Map<String, dynamic> resultESP = {"": "", "": ""}; // Exemple avec deux clés
  List<List<int>> resultPath = [];

  // Méthode pour alimenter resultESP
  void updateResultESP(String key, dynamic value) {
    if (resultESP.containsKey(key)) {
      resultESP[key] = value;
    } else {
      throw Exception("Key '$key' does not exist in resultESP");
    }
  }

  // Méthode pour alimenter resultPath
  void updateResultPath(List<List<int>> value) {
    resultPath = value;
  }

  // Exemple d'initialisation (charge depuis une API ou une configuration locale)
  Future<void> initialize() async {
    // Initialisation statique ou avec des données externes
    resultESP = {
      "key1": "DefaultESP1",
      "key2": "DefaultESP2",
    };

    resultPath = [
      [1, 2, 3],
      [4, 5, 6]
    ];
  }

  // Méthode pour obtenir les données
  Map<String, dynamic> getResults() {
    return {
      "resultESP": resultESP,
      "resultPath": resultPath,
    };
  }
}

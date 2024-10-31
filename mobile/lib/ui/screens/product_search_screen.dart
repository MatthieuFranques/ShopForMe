import 'package:flutter/material.dart';

class SearchProductPage extends StatefulWidget {
  @override
  _SearchProductPageState createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  final TextEditingController _searchController = TextEditingController();

  //Liste de test de produits type d'une grande surface
  List<String> allProducts = [
    //Fruits
    'pomme', 'banane', 'orange', 'fraise', 'kiwi', 'ananas', 'raisin', 'melon', 'pastèque', 
    'mangue', 'poire', 'cerise', 'pêche', 'abricot', 'framboise', 'myrtille',
    
    //Légumes
    'carotte', 'tomate', 'salade', 'poivron', 'courgette', 'aubergine', 'brocoli', 'chou-fleur', 
    'épinard', 'oignon', 'ail', 'poireau', 'patate douce', 'pomme de terre', 'navet', 'radis',
    
    //Viandes et poissons
    'poulet', 'boeuf', 'porc', 'agneau', 'saumon', 'thon', 'crevettes', 'dinde', 'merlan', 
    'jambon', 'bacon', 'escalope', 'filet mignon', 'saucisse', 'moule', 'huître',
    
    //Produits laitiers
    'lait', 'fromage', 'yaourt', 'beurre', 'crème fraîche', 'lait de soja', 'lait d’amande', 
    'camembert', 'emmental', 'chèvre', 'parmesan', 'mozzarella',
    
    //Boulangerie et viennoiseries
    'pain', 'baguette', 'croissant', 'pain de mie', 'brioche', 'pain complet', 'pain aux céréales',
    
    //Produits de base et conserves
    'riz', 'pâtes', 'farine', 'sucre', 'huile d’olive', 'huile de tournesol', 'vinaigre', 
    'moutarde', 'sel', 'poivre', 'épices', 'café', 'thé', 'confiture', 'nutella', 'compote', 
    'thon en boîte', 'sardines en boîte',
    
    //Boissons
    'eau', 'jus d’orange', 'soda', 'vin rouge', 'vin blanc', 'bière', 'coca-cola', 'limonade', 
    'sirop de menthe', 'eau gazeuse',
    
    //Produits sucrés
    'chocolat', 'bonbons', 'gâteau', 'biscuit', 'glace', 'miel', 'pâte d’amande', 'pâte à tartiner',
    
    //Produits ménagers
    'lessive', 'liquide vaisselle', 'savon', 'éponge', 'papier toilette', 'sac poubelle', 
    'essuie-tout', 'désinfectant', 'poudre à récurer', 'produit pour le sol'
  ];
  List<String> filteredProducts = [];

  @override
  void initState() {
    super.initState();

    //Filtre en fonction des caractères tapés dans la search bar (par ordre de frappe)
    _searchController.addListener(() {
      setState(() {
        String query = _searchController.text.toLowerCase();

        if (query.isNotEmpty) {
          List<String> startingWithQuery = allProducts
              .where((product) => product.toLowerCase().startsWith(query))
              .toList();

          List<String> containingQuery = allProducts
              .where((product) => product.toLowerCase().contains(query) && !product.toLowerCase().startsWith(query))
              .toList();

          filteredProducts = startingWithQuery + containingQuery;
        } else {
          filteredProducts = [];
        }
      });
    });

  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Product',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 1, 28, 64),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //Search Bar
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher un produit',
                  hintStyle: const TextStyle(
                    color: Colors.white, 
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0), 
                ),
                style: const TextStyle(color: Colors.white, fontSize: 32),
              ),
            ),
            SizedBox(height: 20),
            
            //affichage des produits correspondant aux caractères tapés dans la search bar
            if (filteredProducts.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          title: Text(
                            product,
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            //TODO : Ajout du produit à la liste de courses
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

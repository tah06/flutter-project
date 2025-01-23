import 'package:final_flutter_project/beer_add_dialog.dart';
import 'package:flutter/material.dart';
import '../model/beer.dart';
import '../service/beer_service.dart';
import 'beer_edit_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Beer's List",
      home: const BeerListScreen(),
    );
  }
}

class BeerListScreen extends StatefulWidget {
  const BeerListScreen({super.key});

  @override
  State<BeerListScreen> createState() => _BeerListScreenState();
}

class _BeerListScreenState extends State<BeerListScreen> {
  late Future<List<Beer>> beers;
  final BeerService _beerService = BeerService(); // Create an instance of BeerService

  @override
  void initState() {
    super.initState();
    beers = _beerService.loadBeers();
  }

  // Method to handle delete action
  void deleteBeer(int index) {
    setState(() {
      beers.then((beerList) {
        _beerService.deleteBeer(
            beerList, index); // Call delete method from BeerService
        beers = Future.value(beerList); // Refresh the state
      });
    });
  }

  // Method to handle beer addition callback (after adding a new beer)
  void onBeerUpdated() {
    setState(() {
      beers = _beerService.loadBeers(); // Refresh the list after adding the beer
    });
  }

  void onBeerAdded() {
    setState(() {
      beers = _beerService.loadBeers(); // Refresh the list after adding the beer
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beer List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Action à effectuer lorsque le bouton est cliqué, par exemple ouvrir un dialog pour ajouter une bière.
                BeerAddDialog.showAddDialog(
                  context,
                  _beerService,
                  onBeerAdded,
                );
              },
              icon: Icon(Icons.add),
              label: Text('Add Beer'),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Beer>>(
              future: beers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No beers found'));
                } else {
                  // Display the beers
                  List<Beer> beerList = snapshot.data!;
                  return ListView.builder(
                    itemCount: beerList.length,
                    itemBuilder: (context, index) {
                      Beer beer = beerList[index];
                      return ListTile(
                        title: Text(beer.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(child: Text(beer.rating)),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                BeerEditDialog.showEditDialog(
                                  context,
                                  index,
                                  beer,
                                  beerList,
                                  _beerService,
                                  onBeerUpdated, // Callback to refresh the beer list
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                deleteBeer(index);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BeerDetails(myData: beer),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BeerDetails extends StatelessWidget {
  final Beer myData;

  const BeerDetails({super.key, required this.myData});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Beer Detail"),
      ),
      body: Column(
        children: [
          Center(child: Text("Name : "+myData.name)),
          Center(child: Text("Category : "+myData.category)),
          Center(child: Text("Origine : "+myData.countryOfOrigin)),
          Center(child: Text("Rating : "+myData.rating))
        ],
      ),
    );
  }
}

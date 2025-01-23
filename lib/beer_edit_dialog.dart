import 'package:flutter/material.dart';
import '../model/beer.dart';
import '../service/beer_service.dart';

class BeerEditDialog {
  static Future<void> showEditDialog(
      BuildContext context,
      int index,
      Beer beer,
      List<Beer> beerList,  // Add this parameter to accept the beer list
      BeerService beerService,
      Function() onBeerUpdated,
      ) async {
    TextEditingController nameController = TextEditingController(text: beer.name);
    TextEditingController categoryController = TextEditingController(text: beer.category);
    TextEditingController origineController = TextEditingController(text: beer.countryOfOrigin);
    TextEditingController ratingController = TextEditingController(text: beer.rating);
    TextEditingController commentsController = TextEditingController(text: beer.comments);


    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to close
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Beer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Beer Name'),
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Beer category'),
              ),
              TextField(
                controller: origineController,
                decoration: InputDecoration(labelText: 'origine'),
              ),
              TextField(
                controller: ratingController,
                decoration: InputDecoration(labelText: 'Rating'),
              ),
              TextField(
                controller: commentsController,
                decoration: InputDecoration(labelText: 'Comments'),
              ),

            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                // Call modifyBeer to save the changes
                beerService.modifyBeer(
                  beerList,
                  index,
                  nameController.text,
                  categoryController.text,
                  origineController.text,
                  ratingController.text,
                  commentsController.text,
                );
                Navigator.of(context).pop();

                // Notify the parent widget that the beer was updated
                onBeerUpdated();
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:final_flutter_project/beer_edit_dialog.dart';
import 'package:flutter/material.dart';
import '../model/beer.dart';
import '../service/beer_service.dart';

class BeerAddDialog {
  static void showAddDialog(
      BuildContext context,
      BeerService beerService,
      Function() onBeerAdded,
      ) async{
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _categoryController = TextEditingController();
    final _countryController = TextEditingController();
    final _ratingController = TextEditingController();
    DateTime? _tastedDate;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Beer'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the beer name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the category';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _countryController,
                  decoration: InputDecoration(labelText: 'Country of Origin'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the country of origin';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ratingController,
                  decoration: InputDecoration(labelText: 'Rating'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the rating';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      _tastedDate == null
                          ? 'Select Tasted Date'
                          : 'Tasted Date: ',
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          _tastedDate = pickedDate;
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() && _tastedDate != null) {
                  final newBeer = Beer(
                    name: _nameController.text,
                    category: _categoryController.text,
                    countryOfOrigin: _countryController.text,
                    rating: _ratingController.text,
                    tastedDate: _tastedDate!, // Include the tasted date
                  );
                  beerService.addBeer(newBeer);
                  onBeerAdded();
                  Navigator.of(context).pop();
                } else if (_tastedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a tasted date')),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}


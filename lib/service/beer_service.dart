import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/beer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BeerService {
  final String _beersKey = 'beers_list';

  // Method to load the JSON file and parse it
  Future<List<Beer>> loadBeers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? beersJson = prefs.getString(_beersKey);

    if (beersJson != null) {
      List<dynamic> jsonList = json.decode(beersJson);
      List<Beer> beers = jsonList.map((json) => Beer.fromJson(json)).toList();
      return beers;
    } else {
      // If no data in SharedPreferences, load from the default JSON file
      String jsonString = await rootBundle.loadString('assets/Data.json');
      List<dynamic> jsonList = json.decode(jsonString);
      List<Beer> beers = jsonList.map((json) => Beer.fromJson(json)).toList();
      await saveBeers(beers); // Save to SharedPreferences for future use
      return beers;
    }
  }

  // Method to save the list of beers to SharedPreferences
  Future<void> saveBeers(List<Beer> beers) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String beersJson = json.encode(beers.map((beer) => beer.toJson()).toList());
    await prefs.setString(_beersKey, beersJson);
  }

  // Method to add a beer to the list and save to SharedPreferences
  Future<List<Beer>> addBeer(Beer beer) async {
    final prefs = await SharedPreferences.getInstance();
    List<Beer> beers = await loadBeers();
    beers.add(beer);
    await prefs.setString(_beersKey, json.encode(beers.map((b) => b.toJson()).toList()));
    return beers;  // Return the updated list so the UI can refresh
  }


  // Method to delete a beer from the list and save to SharedPreferences
  Future<void> deleteBeer(List<Beer> beerList, int index) async {
    beerList.removeAt(index);
    await saveBeers(beerList);
  }

  // Method to modify a beer's details and save to SharedPreferences
  Future<void> modifyBeer(
      List<Beer> beerList,
      int index,
      String newName,
      String newCategory,
      String newCountryOfOrigin,
      String newRating,
      String newComments,
      ) async {
    beerList[index].name = newName;
    beerList[index].category = newCategory;
    beerList[index].countryOfOrigin = newCountryOfOrigin;
    beerList[index].rating = newRating;
    beerList[index].comments = newComments;
    await saveBeers(beerList);
  }
}

import 'package:allerguard/models/allergy.dart';
import 'package:allerguard/scan_result/button_return.dart';
import 'package:allerguard/scan_result/header_result.dart';
import 'package:allerguard/scan_result/result_tile.dart';
import 'package:allerguard/services/openfoodfact_service.dart';
import 'package:flutter/material.dart';
import 'package:allerguard/services/database_service.dart';
import 'package:intl/intl.dart';

class ScanResult extends StatefulWidget {
  final String barcode;

  const ScanResult({super.key, required this.barcode});

  @override
  State<ScanResult> createState() => _ScanResultState();
}

class _ScanResultState extends State<ScanResult> {
  final DatabaseService _databaseService = DatabaseService();

  Future<Map<String, dynamic>> getData() {
    return FoodData.get(widget.barcode);
  }

  Future<List<Allergy>> getAllergies() {
    return _databaseService.allergies();
  }

  List<List<String>> dissociateAllergens(
      List<String> items, List<Allergy> allergies) {
    List<String> founded = [];
    List<String> notFounded = [];

    for (String i in items) {
      bool isPresent = allergies.where((a) => a.item == i).any((_) => true);
      if (isPresent) {
        founded.add(i);
      } else {
        notFounded.add(i);
      }
    }
    return [founded, notFounded];
  }

  Future<void> addAllergy(String item) async {
    // Ajout dans la base de données
    await _databaseService.add(item);
  }

  Future<void> addScannedProduct(String barcode, String productName, String imgURL) async {
    String scanDate = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
    await _databaseService.addScannedProduct(barcode, productName, scanDate, imgURL);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([getData(), getAllergies()]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        } else {
          final String barcode = widget.barcode;
          final Map<String, dynamic> jsonData =
          snapshot.data![0] as Map<String, dynamic>;
          final List<Allergy> allergies = snapshot.data![1] as List<Allergy>;
          final String productName = jsonData['product_name_fr'] ?? 'Unknown';
          final String imgURL = jsonData['image_front_url'] ?? '';
          final additives = jsonData['additives_original_tags'];
          List<String> additivesString = [];
          if (additives is List<dynamic>) {
            additivesString = additives.cast<String>();
          }
          final allergens = jsonData['allergens_tags'];
          List<String> allergensString = [];
          if (allergens is List<dynamic>) {
            allergensString = allergens.cast<String>();
          }

          // Ajout du produit scanné à la base de données
          addScannedProduct(barcode, productName, imgURL);

          final dissociatedAdditives =
          dissociateAllergens(additivesString, allergies);
          final dissociatedAllergenes =
          dissociateAllergens(allergensString, allergies);

          final bool foundAllergies =
              additivesString.isNotEmpty || allergensString.isNotEmpty;

          return Scaffold(
            backgroundColor: foundAllergies
                ? const Color.fromRGBO(255, 255, 255, 1.0)
                : const Color.fromRGBO(134, 222, 223, 1.0),
            body: Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 10.0, right: 10.0),
              child: Column(
                children: [
                  HeaderResult(
                    productName: productName,
                    barCode: barcode,
                    imgURL: imgURL, // Ajout de l'URL de l'image
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        if (additives.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 5),
                            child: Text(
                              'Additifs',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ...dissociatedAdditives[0].map((item) => ResultTile(
                          item: item,
                          alert: true,
                          addAllergy: addAllergy,
                        )),
                        ...dissociatedAdditives[1].map((item) => ResultTile(
                          item: item,
                          alert: false,
                          addAllergy: addAllergy,
                        )),
                        if (allergens.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 5),
                            child: Text(
                              'Allergènes',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ...dissociatedAllergenes[0].map((item) => ResultTile(
                          item: item,
                          alert: true,
                          addAllergy: addAllergy,
                        )),
                        ...dissociatedAllergenes[1].map((item) => ResultTile(
                          item: item,
                          alert: false,
                          addAllergy: addAllergy,
                        )),
                      ],
                    ),
                  ),
                  const ButtonReturn(),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

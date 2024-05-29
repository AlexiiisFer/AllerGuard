import 'package:allerguard/home/allergy_tile.dart';
import 'package:allerguard/models/allergy.dart';
import 'package:flutter/material.dart';
import 'package:allerguard/services/database_service.dart';

class Allergies extends StatefulWidget {
  const Allergies({super.key});

  @override
  State<Allergies> createState() => _AllergiesState();
}

class _AllergiesState extends State<Allergies> {
  late Future<List<Allergy>> allergiesList = getAllergies();
  final DatabaseService _databaseService = DatabaseService();

  Future<List<Allergy>> getAllergies() async {
    return await _databaseService.allergies();
  }

  Future<void> deleteAllergy(Allergy allergy) async {
    // Suppression de la base de données
    await _databaseService.delete(allergy.id);
    // Actualisation des données
    setState(() {
      allergiesList = getAllergies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Allergy>>(
      future: allergiesList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
              'Commencez par scanner un aliment pour ajouter des intolérances',
            ),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return AllergyTile(
                allergy: snapshot.data![index],
                deleteAllergy: deleteAllergy,
              );
            },
          );
        }
      },
    );
  }
}

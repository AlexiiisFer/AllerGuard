import 'package:flutter/material.dart';
import 'package:allerguard/models/scanned_product.dart';
import 'package:allerguard/services/database_service.dart';

class HistoryScreen extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService();

  HistoryScreen({super.key});

  Future<List<ScannedProduct>> fetchScannedProducts() {
    return _databaseService.getScannedProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des produits scannés'),
      ),
      body: FutureBuilder<List<ScannedProduct>>(
        future: fetchScannedProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun produit scanné trouvé.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(
                    snapshot.data![index].imgURL,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(snapshot.data![index].productName),
                  subtitle: Text('Code-barres: ${snapshot.data![index].barcode}\nDate: ${snapshot.data![index].scanDate}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

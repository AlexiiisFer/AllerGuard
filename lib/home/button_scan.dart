import 'package:allerguard/barcode_scanner/barcode_scanner.dart';
import 'package:flutter/material.dart';

class ButtonScan extends StatelessWidget {
  const ButtonScan({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      backgroundColor: const Color.fromRGBO(0, 0, 255, 1.0), // Couleur de fond bleu
      foregroundColor: Colors.white, // Couleur du texte blanc
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ElevatedButton(
        style: style,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BarcodeScanner()),
          );
        },
        child: const Text('SCAN'),
      ),
    );
  }
}

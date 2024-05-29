import 'package:allerguard/home/allergies.dart';
import 'package:allerguard/history/history_screen.dart';
import 'package:allerguard/home/button_scan.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AllerGuard'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Allergies'),
              Tab(text: 'Historique'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const Allergies(),
            HistoryScreen(), // Assurez-vous qu'il n'y a pas 'const' ici
          ],
        ),
        bottomNavigationBar: const Padding(
          padding: EdgeInsets.all(16.0),
          child: ButtonScan(),
        ),
      ),
    );
  }
}

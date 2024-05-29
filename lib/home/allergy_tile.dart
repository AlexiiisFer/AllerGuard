import 'package:allerguard/models/allergy.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class AllergyTile extends StatelessWidget {
  final Allergy allergy;
  final Function(Allergy) deleteAllergy;

  const AllergyTile({
    super.key,
    required this.allergy,
    required this.deleteAllergy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(allergy.item, style: const TextStyle(fontSize: 18)),
        trailing: IconButton(
          icon: SvgPicture.asset('assets/icons/delete-bin-fill.svg'),
          onPressed: () => deleteAllergy(allergy),
        ),
      ),
    );
  }
}

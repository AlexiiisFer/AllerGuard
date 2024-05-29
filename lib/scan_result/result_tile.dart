import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class ResultTile extends StatefulWidget {
  final String item;
  final bool alert;
  final Function(String) addAllergy;

  const ResultTile({
    super.key,
    required this.item,
    required this.alert,
    required this.addAllergy,
  });

  @override
  State<ResultTile> createState() => _ResultTile();
}

class _ResultTile extends State<ResultTile> {
  late bool alertState = widget.alert;

  @override
  Widget build(BuildContext context) {
    if (alertState) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/icons/alert-fill.svg',
                colorFilter: const ColorFilter.mode(Colors.orange, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 10),
            Text(widget.item),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Text(widget.item),
            const Spacer(),
            IconButton(
              onPressed: () => setState(() {
                widget.addAllergy(widget.item);
                alertState = true;
              }),
              icon: SvgPicture.asset('assets/icons/add-circle-fill.svg'),
            ),
          ],
        ),
      );
    }
  }
}

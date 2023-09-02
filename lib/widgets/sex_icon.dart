import 'package:flutter/material.dart';

class SexIcon extends StatefulWidget {
  final String sex;
  const SexIcon({super.key, required this.sex});

  @override
  State<SexIcon> createState() => _SexIconState();
}

class _SexIconState extends State<SexIcon> {
  @override
  Widget build(BuildContext context) {
    return Icon(
      widget.sex == "Macho" ? Icons.male_rounded : Icons.female_outlined,
      color: widget.sex == "Macho" ? Colors.blue[400] : Colors.pink[300],
    );
  }
}

import 'package:flutter/material.dart';

class ResidenceDropdown extends StatefulWidget {
  const ResidenceDropdown({Key? key}) : super(key: key);

  @override
  _ResidenceDropdownState createState() => _ResidenceDropdownState();
}

class _ResidenceDropdownState extends State<ResidenceDropdown> {
  final currentResidences = [
    'Miller',
    'Walston',
    'Cheney',
    'Earnhardt',
  ];
  String? value;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      items: currentResidences.map(buildMenuItem).toList(),
      onChanged: (value) => setState(() => this.value = value),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
}

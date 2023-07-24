import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:flutter/material.dart';

class AdvancedSearch extends StatefulWidget {
  const AdvancedSearch({Key? key}) : super(key: key);

  @override
  _AdvancedSearchState createState() => _AdvancedSearchState();
}

class _AdvancedSearchState extends State<AdvancedSearch> {
  var _selectedList = 'Select';
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: 150,
      height: 40,
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: kPrimaryColor, width: 40),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedList,
            iconEnabledColor: kPrimaryColor,
            icon: Icon(Icons.arrow_drop_down),
            isDense: true,
            isExpanded: true,
            items: [
              DropdownMenuItem(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('Select'),
                  ),
                  value: 'Select'),
              DropdownMenuItem(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('Seafood'),
                  ),
                  value: 'Seafood'),
              DropdownMenuItem(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('Pizza'),
                  ),
                  value: 'Pizza'),
              DropdownMenuItem(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('Spicy'),
                  ),
                  value: 'Spicy'),
            ],
            onChanged: (value) {
              setState(() {
                _selectedList = value!;
              });
            },
          ),
        ),
      ),
    );
  }
}

import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/src/intl/date_format.dart';

class AddNewCard extends StatefulWidget {
  const AddNewCard({Key? key}) : super(key: key);

  @override
  _AddNewCardState createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {
  TextEditingController dateinput = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String card_no;
  late String expire_date;
  late String cvv;

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios)),
        title: Text(
          'Add New Card',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
        ),
      ),
      backgroundColor: kPrimaryLightColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              width: 370,
              child: Image.asset('assets/images/master.jpg',
                  fit: BoxFit.cover, height: 200),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    _buildCardNumber(),
                    SizedBox(height: 20),
                    _buildExpireDate(),
                    SizedBox(height: 20),
                    _buildCvC(),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 360,
                      height: 50,
                      child: MaterialButton(
                        color: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Buy Now',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _buildCardNumber() {
    return TextFormField(
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) {},
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        labelText: 'xxxx xxxx xxxx xxxx',
        labelStyle: TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        // fillColor: kPrimaryColor,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  TextFormField _buildExpireDate() {
    return TextFormField(
      controller: dateinput,
      cursorColor: kPrimaryColor,
      onChanged: (value) {},
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        labelText: 'Expire Date',
        suffixIcon: Icon(
          Icons.calendar_today_outlined,
          color: Colors.grey,
        ),
        labelStyle: TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        fillColor: Colors.grey,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2019),
          lastDate: DateTime(2222),
        );

        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

          setState(() {
            dateinput.text = formattedDate;
          });
        }
      },
    );
  }

  TextFormField _buildCvC() {
    return TextFormField(
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) {},
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        labelText: 'CVC',
        labelStyle: TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        fillColor: Colors.grey,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

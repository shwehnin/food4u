import 'package:flutter/material.dart';

class DebitCreditCard extends StatefulWidget {
  const DebitCreditCard({Key? key}) : super(key: key);

  @override
  _DebitCreditCardState createState() => _DebitCreditCardState();
}

class _DebitCreditCardState extends State<DebitCreditCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Debit/Credit Cards',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/add_card');
                      },
                      child: Text(
                        'ADD NEW CARD',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/images/visa.jpg',
                  width: 100,
                  height: 50,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

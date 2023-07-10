import 'package:flutter/material.dart';
import 'package:frebase_signin/screens/OffilnePaymentComplete.dart';
import 'package:frebase_signin/screens/Upi_Payments.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 250, 186, 123),
        title: Text('Payment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Options',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('UPI'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Payment_Page(
                      name: '',
                      phoneNumber: '',
                      amount: 200.00,
                    ),
                  ),
                );
                // Handle UPI payment option
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text('Pay on Spot'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OfflinePayment(),
                  ),
                );
                // Handle cash on delivery payment option
              },
            ),
          ],
        ),
      ),
    );
  }
}

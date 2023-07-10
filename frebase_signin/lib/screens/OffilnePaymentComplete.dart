import 'package:flutter/material.dart';

class OfflinePayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/your_image.png', // Replace with your image path
              height: 200,
              width: 200,
            ),
            SizedBox(height: 20),
            const Text(
              'Your Appoinment has been booked',
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

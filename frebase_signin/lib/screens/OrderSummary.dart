import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'PaymentOptions_page.dart';

class OrderSummaryPage extends StatelessWidget {
  final service;
  final String name;
  final String phoneNumber;
  final String date;
  final String time;
  final String stylistName;

  const OrderSummaryPage(
    this.service,
    this.name,
    this.phoneNumber,
    this.date,
    this.time,
    this.stylistName,
  );

  void _storeOrderSummaryData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentReference serviceRef =
        await firestore.collection('Service Details').add({
      'title': service['title'],
      'duration': service['duration'],
      'price': service['price'],
    });
    print('service details stored successfully');

    DocumentReference customerRef =
        await firestore.collection('Customer Details').add({
      'serviceId': serviceRef.id,
      'name': name,
      'phoneNumber': phoneNumber,
    });
    print('customer details stored successfully');

    await firestore.collection('Stylist Name').add({
      'serviceId': serviceRef.id,
      'stylistName': stylistName,
    });
    print('stylist name stored successfully');

    await firestore.collection('Booking Details').add({
      'serviceId': serviceRef.id,
      'customerId': customerRef.id,
      'date': date,
      'time': time,
    });
    print('booking details stored successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 250, 186, 123),
        title: Text('Order Summary'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 10),
            Text('Title: ${service['title']}'),
            Text('Duration: ${service['duration']} mins'),
            Text('Price: ₹${service['price']}'),
            SizedBox(height: 20),
            Text(
              'Customer Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 10),
            Text('Name: $name'),
            Text('Phone Number: $phoneNumber'),
            const SizedBox(height: 20),
            const Text(
              'Stylist Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 10),
            Text('Stylist Name: $stylistName'),
            const SizedBox(height: 20),
            const Text(
              'Booking Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 10),
            Text('Date: $date'),
            Text('Time: $time'),
            const SizedBox(height: 20),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    _storeOrderSummaryData();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentPage()),
                    );
                    // Add your payment logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('Make Payment'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

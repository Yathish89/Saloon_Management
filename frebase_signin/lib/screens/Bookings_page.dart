import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingsPage extends StatelessWidget {
  final String? customerName;
  final TextEditingController _nameController = TextEditingController();

  BookingsPage({this.customerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Your Name:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _nameController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String enteredName = _nameController.text.trim();
                if (enteredName.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookingsPage(customerName: enteredName),
                    ),
                  );
                }
              },
              child: Text('Retrieve Booking Details'),
            ),
            SizedBox(height: 20),
            Text(
              customerName != null ? 'Bookings for $customerName' : 'Bookings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Customer Details')
                    .where('name', isEqualTo: customerName)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LinearProgressIndicator();
                  }

                  List<QueryDocumentSnapshot> customers = snapshot.data!.docs;
                  if (customers.isEmpty) {
                    return Text('No bookings found for this user.');
                  }

                  String serviceId = customers.first['serviceId'];

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('Service Details')
                        .doc(serviceId)
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> serviceSnapshot) {
                      if (serviceSnapshot.hasError) {
                        return Text('Error: ${serviceSnapshot.error}');
                      }

                      if (serviceSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return LinearProgressIndicator();
                      }

                      DocumentSnapshot serviceData = serviceSnapshot.data!;
                      Map<String, dynamic> bookingData = {
                        'title': serviceData['title'],
                        'duration': serviceData['duration'],
                        'price': serviceData['price'],
                      };

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text('Title: ${bookingData['title']}'),
                            subtitle:
                                Text('Duration: ${bookingData['duration']}'),
                          ),
                          SizedBox(height: 20),
                          Text('Booking Details:'),
                          SizedBox(height: 10),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Booking Details')
                                .where('serviceId', isEqualTo: serviceId)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> bookingSnapshot) {
                              if (bookingSnapshot.hasError) {
                                return Text('Error: ${bookingSnapshot.error}');
                              }

                              if (bookingSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return LinearProgressIndicator();
                              }

                              List<QueryDocumentSnapshot> bookings =
                                  bookingSnapshot.data!.docs;
                              if (bookings.isEmpty) {
                                return Text('No bookings found for this user.');
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: bookings.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Map<String, dynamic> bookingData =
                                      bookings[index].data()
                                          as Map<String, dynamic>;
                                  return ListTile(
                                    title: Text('Date: ${bookingData['date']}'),
                                    subtitle:
                                        Text('Time: ${bookingData['time']}'),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

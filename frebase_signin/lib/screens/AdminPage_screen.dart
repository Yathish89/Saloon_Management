import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frebase_signin/utils/notifi_service.dart';

class OrderDetails {
  final String id;
  final String serviceName;
  final String name;
  final String phoneNumber;
  final String date;
  final String time;
  final String stylistName;
  final String serviceTitle;
  final int serviceDuration;
  final int servicePrice;

  OrderDetails({
    required this.id,
    required this.serviceName,
    required this.name,
    required this.phoneNumber,
    required this.date,
    required this.time,
    required this.stylistName,
    required this.serviceTitle,
    required this.serviceDuration,
    required this.servicePrice,
  });
}

class UserProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<OrderDetails>> getOrderDetails() {
    return _firestore
        .collection('Service Details')
        .snapshots()
        .asyncMap<List<OrderDetails>>((serviceSnapshot) async {
      final serviceDocs = serviceSnapshot.docs;
      final serviceData = await Future.wait(serviceDocs.map((doc) async {
        final service = doc.data();
        final serviceId = doc.id; // Get the serviceId

        final customerSnapshot = await _firestore
            .collection('Customer Details')
            .where('serviceId',
                isEqualTo: serviceId) // Query customer details using serviceId
            .get();

        final customerData = customerSnapshot.docs.isNotEmpty
            ? customerSnapshot.docs[0].data() as Map<String, dynamic>?
            : null;

        final bookingSnapshot = await _firestore
            .collection('Booking Details')
            .where('serviceId',
                isEqualTo: serviceId) // Query booking details using serviceId
            .get();

        final bookingData = bookingSnapshot.docs.isNotEmpty
            ? bookingSnapshot.docs[0].data() as Map<String, dynamic>?
            : null;

        final stylistSnapshot = await _firestore
            .collection('Stylist Name')
            .where('serviceId',
                isEqualTo: serviceId) // Query stylist details using serviceId
            .get();

        final stylistData = stylistSnapshot.docs.isNotEmpty
            ? stylistSnapshot.docs[0].data() as Map<String, dynamic>?
            : null;

        return OrderDetails(
          id: serviceId,
          serviceName: service['title'] ?? '',
          name: customerData?['name'] ?? '',
          phoneNumber: customerData?['phoneNumber'] ?? '',
          date: bookingData?['date'] ?? '',
          time: bookingData?['time'] ?? '',
          stylistName: stylistData?['stylistName'] ?? '',
          serviceTitle: service['title'] ?? '',
          serviceDuration: service['duration'] ?? 0,
          servicePrice: service['price'] ?? 0,
        );
      }));

      return serviceData;
    });
  }
}

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  // ...

  @override
  Widget build(BuildContext context) {
    final userProvider = UserProvider();

    void deleteOrder(String orderId) {
      // Delete the order from all three collections using the orderId
      FirebaseFirestore.instance
          .collection('Booking Details')
          .where('serviceId', isEqualTo: orderId)
          .get()
          .then((bookingSnapshot) {
        if (bookingSnapshot.docs.isNotEmpty) {
          final bookingDocId = bookingSnapshot.docs[0].id;
          FirebaseFirestore.instance
              .collection('Booking Details')
              .doc(bookingDocId)
              .delete()
              .then((_) {
            // Booking details successfully deleted
            log('Booking details deleted successfully');
          }).catchError((error) {
            // An error occurred while deleting the booking details
            log('Failed to delete booking details: $error');
          });
        }
      }).catchError((error) {
        // An error occurred while fetching the booking details
        log('Failed to fetch booking details: $error');
      });

      FirebaseFirestore.instance
          .collection('Service Details')
          .doc(orderId)
          .delete()
          .then((_) {
        // Service details successfully deleted
        log('Service details deleted successfully');
      }).catchError((error) {
        // An error occurred while deleting the service details
        log('Failed to delete service details: $error');
      });

      FirebaseFirestore.instance
          .collection('Stylist Name')
          .where('serviceId', isEqualTo: orderId)
          .get()
          .then((stylistSnapshot) {
        if (stylistSnapshot.docs.isNotEmpty) {
          final stylistDocId = stylistSnapshot.docs[0].id;
          FirebaseFirestore.instance
              .collection('Stylist Name')
              .doc(stylistDocId)
              .delete()
              .then((_) {
            // Booking details successfully deleted
            log('stylist name deleted successfully');
          }).catchError((error) {
            // An error occurred while deleting the booking details
            log('Failed to delete stylist name: $error');
          });
        }
      }).catchError((error) {
        // An error occurred while fetching the booking details
        log('Failed to fetch stylist name: $error');
      });

      FirebaseFirestore.instance
          .collection('Customer Details')
          .where('serviceId', isEqualTo: orderId)
          .get()
          .then((customerSnapshot) {
        if (customerSnapshot.docs.isNotEmpty) {
          final customerDocId = customerSnapshot.docs[0].id;
          FirebaseFirestore.instance
              .collection('Customer Details')
              .doc(customerDocId)
              .delete()
              .then((_) {
            // Customer details successfully deleted
            log('Customer details deleted successfully');
          }).catchError((error) {
            // An error occurred while deleting the customer details
            log('Failed to delete customer details: $error');
          });
        }
      }).catchError((error) {
        // An error occurred while fetching the customer details
        log('Failed to fetch customer details: $error');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: StreamBuilder<List<OrderDetails>>(
        stream: userProvider.getOrderDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final orderDetailsList = snapshot.data!;
            return ListView.builder(
              itemCount: orderDetailsList.length,
              itemBuilder: (context, index) {
                final orderDetails = orderDetailsList[index];
                return ListTile(
                  title: Text(orderDetails.serviceName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customer Name: ${orderDetails.name}'),
                      Text('Phone Number: ${orderDetails.phoneNumber}'),
                      Text('Date: ${orderDetails.date}'),
                      Text('Time: ${orderDetails.time}'),
                      Text('Stylist Name: ${orderDetails.stylistName}'),
                      Text('Service Title: ${orderDetails.serviceTitle}'),
                      Text(
                          'Service Duration: ${orderDetails.serviceDuration} mins'),
                      Text('Service Price: ₹${orderDetails.servicePrice}'),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => {
                      NotificationService().showNotification(
                          title: 'Sample title', body: 'It works!'),
                    },
                    /* onPressed: () {

                      deleteOrder(orderDetails.id);
                    },*/
                    child: Text('completed Order'),
                  ),
                  onTap: () {
                    NotificationService().showNotification(
                        title: 'Sample title', body: 'It works!');

                    // Handle order details navigation if needed
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

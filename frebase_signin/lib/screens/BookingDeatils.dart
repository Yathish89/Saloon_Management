// ignore: file_names
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'OrderSummary.dart';

class BookingDialog extends StatefulWidget {
  final service;

  const BookingDialog(this.service);

  @override
  _BookingDialogState createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = now;
    final DateTime lastDate = now.add(const Duration(days: 7));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    // ignore: unused_local_variable
    final TimeOfDay now = TimeOfDay.now();
    const TimeOfDay earliest = TimeOfDay(hour: 10, minute: 0);
    final TimeOfDay latest = TimeOfDay(hour: 22, minute: 0);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      helpText: 'Select Time',
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
      initialEntryMode: TimePickerEntryMode.input,
    );

    if (picked != null && picked != selectedTime) {
      if (picked.hour < earliest.hour ||
          picked.hour > latest.hour ||
          (picked.hour == earliest.hour && picked.minute < earliest.minute) ||
          (picked.hour == latest.hour && picked.minute > latest.minute)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Time'),
              content: Text('Please select a time between 10 AM and 10 PM.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _selectTime(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          selectedTime = picked;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Fill Details'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
                prefixText: '+91-',
              ),
              keyboardType: TextInputType.phone,
              maxLength: 10,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date',
                        hintText: 'Select date',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(selectedDate),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Time',
                        hintText: 'Select time',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      child: Text(
                        selectedTime.format(context),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 218, 142, 105),
          ),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String name = nameController.text;
            String phoneNumber = phoneNumberController.text;
            String date = DateFormat('yyyy-MM-dd').format(selectedDate);
            String time = selectedTime.format(context);

            Navigator.pop(context);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderSummaryPage(
                  widget.service,
                  name,
                  phoneNumber,
                  date,
                  time,
                  'John Doe', // Provide the stylist name here
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.brown,
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frebase_signin/screens/BookingDeatils.dart';

void main() {
  runApp(MaterialApp(
    home: DetailScreen({
      'stylistName': 'Cameron Thomas',
      'salonName': 'Sesscors Sounds',
      'rating': '4.5',
      'rateAmount': '125',
      'bgColor': Color(0xffF7F5F9),
      'imgUrl': 'assets/images/stylist1.png',
    }),
  ));
}

var serviceList = [
  {'title': 'Men\'s Hair Cut', 'duration': 45, 'price': 100},
  {'title': 'Shaving', 'duration': 25, 'price': 80},
  {'title': 'Color & Blow Dry', 'duration': 90, 'price': 300},
  {'title': 'Oil Treatment', 'duration': 30, 'price': 70},
];

class DetailScreen extends StatelessWidget {
  final stylist;

  DetailScreen(this.stylist);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 3 + 20,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/detail_bg.png',
                      fit: BoxFit.fill,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.purple.withOpacity(0.1),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 50,
                left: 20,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 3 - 30,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 80,
                        ),
                        Text(
                          'Service List',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(height: 20),
                        ServiceTile(
                          serviceList[0],
                          Color.fromARGB(255, 225, 219, 219),
                        ),
                        ServiceTile(
                          serviceList[1],
                          Color.fromARGB(255, 225, 219, 219),
                        ),
                        ServiceTile(
                          serviceList[2],
                          Color.fromARGB(255, 225, 219, 219),
                        ),
                        ServiceTile(
                          serviceList[3],
                          Color.fromARGB(255, 225, 219, 219),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 3 - 120,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        height: MediaQuery.of(context).size.height / 6 + 20,
                        decoration: BoxDecoration(
                          color: stylist['bgColor'],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Positioned(
                              top: 10,
                              right: -25,
                              child: Image.asset(
                                stylist['imgUrl'],
                                scale: 1.7,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            stylist['stylistName'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 0,
                          ),
                          Text(
                            stylist['salonName'],
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                size: 16,
                                color: Color(0xffFF8573),
                              ),
                              SizedBox(width: 5),
                              Text(
                                stylist['rating'],
                                style: TextStyle(
                                  color: Color(0xffFF8573),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '(${stylist['rateAmount']})',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceTile extends StatelessWidget {
  final service;
  final Color backgroundColor;

  ServiceTile(this.service, this.backgroundColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                service['title'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${service['duration']} mins',
                style: TextStyle(
                  color: const Color.fromARGB(255, 89, 87, 87),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '₹${service['price']}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => BookingDialog(service),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 154, 129, 120),
                ),
                child: Text('Book Now'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

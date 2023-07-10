import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'DetailScreen_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.username}) : super(key: key);

  final String username;

  String? get routeName => null;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> stylistData = [
    {
      'stylistName': 'Jones',
      'salonName': 'Sessor Sounds',
      'rating': '4.8',
      'rateAmount': '56',
      'imgUrl': 'assets/images/stylist1.png',
      'bgColor': Color(0xffFFF0EB),
    },
    {
      'stylistName': 'Robert',
      'salonName': ' Sessor Sounds',
      'rating': '4.7',
      'rateAmount': '80',
      'imgUrl': 'assets/images/stylist2.png',
      'bgColor': Color(0xffEBF6FF),
    },
    {
      'stylistName': 'Stokes',
      'salonName': 'Sessors Sound',
      'rating': '4.7',
      'rateAmount': '70',
      'imgUrl': 'assets/images/stylist3.png',
      'bgColor': Color(0xffFFF3EB),
    }
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 251, 251, 251),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 198, 133),
          title: Text('Home'),
          /* actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed out");
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/signin',
                    (route) => false,
                  );
                });
              },
            ),
          ],*/
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'CHOOSE YOUR STYLE !!!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color.fromARGB(255, 255, 147, 24),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(255, 255, 169, 169),
                      width: 5.0,
                    ),
                    borderRadius: BorderRadius.all(
                        const Radius.circular(4.0)), // Add border radius
                  ),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      aspectRatio: BorderSide.strokeAlignCenter,
                      enlargeCenterPage: true,
                      viewportFraction: 0.3,
                    ),
                    items: [
                      Image.asset('assets/images/hair1.png', fit: BoxFit.cover),
                      Image.asset('assets/images/hair2.png', fit: BoxFit.cover),
                      Image.asset('assets/images/hair3.png', fit: BoxFit.cover),
                      Image.asset('assets/images/hair4.png', fit: BoxFit.cover),
                      Image.asset('assets/images/hair5.png', fit: BoxFit.cover),
                      Image.asset('assets/images/hair6.png', fit: BoxFit.cover),
                      Image.asset('assets/images/hair7.png', fit: BoxFit.cover),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50),
                        Text(
                          'Hair Stylist',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Column(
                          children: stylistData.map((stylist) {
                            return StylistCard(stylist);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StylistCard extends StatelessWidget {
  final Map<String, dynamic> stylist;

  StylistCard(this.stylist);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 4 - 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: stylist['bgColor'],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 20,
            right: -60,
            child: Image.asset(
              stylist['imgUrl'],
              width: MediaQuery.of(context).size.width * 0.60,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40, left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  stylist['stylistName'],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  stylist['salonName'],
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
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
                      color: Color(0xff4E295B),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      stylist['rating'],
                      style: TextStyle(
                        color: Color(0xff4E295B),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(stylist),
                      ),
                    );
                  },
                  color: Color.fromARGB(255, 91, 56, 41),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'View Profile',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

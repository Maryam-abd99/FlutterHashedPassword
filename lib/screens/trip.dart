import 'package:app/screens/book_trip.dart';
import 'package:app/screens/edit_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Trip extends StatefulWidget {
  const Trip({super.key, required this.id, required this.title});

  final String id;
  final String title;

  @override
  State<Trip> createState() => _TripState();
}

class _TripState extends State<Trip> {
  bool loading = true;
  bool isError = false;
  dynamic data;
  dynamic user;
  dynamic bookings;

  getData() async {
    try {
      final auth = FirebaseAuth.instance;
      final db = FirebaseFirestore.instance;
      if (auth.currentUser != null) {
        var userData = await db.collection("users").doc(auth.currentUser!.uid).get();
        setState(() {
          user = userData["user_type"] == 2 ? 2 : 1;
        });
      } else {
        setState(() {
          user = 0;
        });
      }

      var eventData = await db.collection("trips").doc(widget.id).get();
      var bookingsData = await db.collection("bookings").where("trip_id", isEqualTo: widget.id).get();
      return setState(() {
        data = eventData;
        bookings = bookingsData.docs;
        loading = false;
      });
    } catch (e) {
      print(e);
      return setState(() {
        isError = true;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46932c),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: loading
      ? Center(
        child: Text("Loading..."),
      )
      : isError
      ? Center(
        child: Text("An error occured"),
      )
      : SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data["body"],
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Current slots:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text(data["slots"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding (
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Current bookings:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text(bookings.length.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding (
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Date:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text(data["date"].toDate().toString().split(" ")[0], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            user != 2
            ? SizedBox()
            : SizedBox(height: 20,),
            user != 2
            ? SizedBox()
            : Container(
                  width: widthSize * 0.9,
                  height: heightSize * 0.065,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF46932c)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BookTrip(id: widget.id, title: widget.title, date: data["date"].toDate().toString().split(" ")[0],),
                        )
                      ).then((value) => getData());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF46932c),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                      )
                    ),
                    child: Text(
                      "Book trip",
                      style: TextStyle(
                        color: Color(0xFF46932c),
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                  ),
                ),
          ],
        )
      ),
    );
  }
}
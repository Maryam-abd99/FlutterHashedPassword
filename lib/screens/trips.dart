import 'package:app/screens/admin_trips.dart';
import 'package:app/screens/trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Trips extends StatefulWidget {
  const Trips({super.key});

  @override
  State<Trips> createState() => _TripsState();
}

class _TripsState extends State<Trips> {
  var trips;
  var user;
  bool loading = true;
  bool isError = false;

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

      var tripsData = await db.collection("trips").get();
      return setState(() {
        trips = tripsData.docs;
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46932c),
        title: Text(
          "Trips",
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body: loading
      ? Center(
        child: Text("Loading..."),
      )
      : isError
      ? Center(
        child: Text("An error has occured"),
      )
      : trips.length == 0
      ? Center(
        child: Text(
          "No trips added yet"
        ),
      )
      : SingleChildScrollView(
        child: ListView.separated(
          itemCount: trips.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Trip(id: trips[index].id, title: trips[index].data()["title"],),
                  )
                ).then((value) => getData());
              },
              title: Text(
                trips[index].data()["title"]
              ),
              subtitle: Text(
                "Date: ${trips[index].data()["date"].toDate().toString().split(" ")[0]}     Slots ${trips[index].data()["slots"].toString()}"
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 1.5,
            );
          },
        ),
      ),
      floatingActionButton: user == 2
      ? SizedBox()
      : user == 0
      ? SizedBox()
      : FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AdminTrips(),
            )
          ).then((value) => getData());
        },
        backgroundColor: Color(0xFF46932c),
        child: Icon(
          Icons.admin_panel_settings,
          color: Colors.white,
        ),
      ),
    );
  }
}
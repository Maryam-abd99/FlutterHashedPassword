import 'package:app/screens/add_slots.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddTripSlots extends StatefulWidget {
  const AddTripSlots({super.key});

  @override
  State<AddTripSlots> createState() => _AddTripSlotsState();
}

class _AddTripSlotsState extends State<AddTripSlots> {
  var trips;
  bool loading = true;
  bool isError = false;

  getData() async {
    try {
      final db = FirebaseFirestore.instance;
      var tripsData = await db.collection("trips").orderBy("date", descending: false).get();
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
        backgroundColor: Color(0xFF46923c),
        title: Text(
          "Select trip",
          style: TextStyle(color: Colors.white),
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
                    builder: (context) => AddSlots(id: trips[index].id,),
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
    );
  }
}
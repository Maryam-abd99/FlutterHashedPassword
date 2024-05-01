// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddSlots extends StatefulWidget {
  const AddSlots({super.key, required this.id});

  final String id;

  @override
  State<AddSlots> createState() => _AddSlotsState();
}

class _AddSlotsState extends State<AddSlots> {
  bool loading = true;
  bool isError = false;
  int slots = 1;
  late int oldSlots;
  late String title;
  var bookings = [];

  getData() async {
    try {
      final db = FirebaseFirestore.instance;
      var tripData = await db.collection("trips").doc(widget.id).get();
      var bookingsData = await db.collection("bookings").where("trip_id", isEqualTo: widget.id).get();
      return setState(() {
        title = tripData["title"];
        oldSlots = tripData["slots"];
        loading = false;
        bookings = bookingsData.docs;
      });
    } catch (e) {
      print(e);
      return setState(() {
        isError = true;
        loading = false;
      });
    }
  }

  addSlots() async {
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("trips").doc(widget.id).update({
        "slots": oldSlots + slots
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating slots"), backgroundColor: Color(0xFF46923c),)
      );
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
          "Add slots",
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
      : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding (
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Title:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding (
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Current slots:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text(oldSlots.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                  Text("Slots after adding:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  Text("${slots + oldSlots}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                ],
              ),
            ),
            SizedBox(height: 20,),
            Text("Slots to add"),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      if (slots == 1) {
                        return;
                      } else {
                        setState(() {
                          slots = slots - 1;
                        });
                      }
                    },
                    icon: Icon(Icons.remove),
                    color: Color(0xFF46932c),
                  ),
                  Text(slots.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        slots = slots + 1;
                      });
                    },
                    icon: Icon(Icons.add),
                    color: Color(0xFF46932c),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
                  width: widthSize * 0.9,
                  height: heightSize * 0.065,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF46932c)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      await addSlots();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF46932c),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                      )
                    ),
                    child: Text(
                      "Add slots",
                      style: TextStyle(
                        color: Color(0xFF46932c),
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
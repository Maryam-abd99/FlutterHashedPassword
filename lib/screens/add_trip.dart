// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddTrip extends StatefulWidget {
  const AddTrip({super.key});

  @override
  State<AddTrip> createState() => _AddTripState();
}

class _AddTripState extends State<AddTrip> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  int slots = 1;
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  addTrip() async {
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("trips").add({
        "title": titleController.text,
        "body": bodyController.text,
        "slots": slots,
        "date": selectedDate
      });
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding trip"), backgroundColor: Color(0xFF46923c),)
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF46932c),
        title: Text(
          "Add trip",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20,),
                SizedBox(
                  width: widthSize * 0.9,
                  child: Expanded(
                    child: TextFormField(
                      controller: titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a title";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      cursorColor: Colors.green,
                      decoration: InputDecoration(
                        hintText: "Title",
                        hintStyle: TextStyle(fontSize: 15),
                        contentPadding: EdgeInsets.only(left: 30),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50),),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF46923c)),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF46923c),width: 2.0,),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: widthSize * 0.9,
                  child: TextFormField(
                    minLines: 6,
                    maxLines: null,
                    controller: bodyController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a body";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.multiline,
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                      hintText: "Body",
                      hintStyle: TextStyle(fontSize: 15),
                      contentPadding: EdgeInsets.only(left: 30, top: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF46923c)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF46923c),width: 2.0,),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Selected Date: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      Text(selectedDate.toLocal().toString().split(" ")[0], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: widthSize * 0.9,
                  height: heightSize * 0.065,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF46932c)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF46932c),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                      )
                    ),
                    child: Text(
                      "Change trip date",
                      style: TextStyle(
                        color: Color(0xFF46932c),
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Slots"
                ),
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
                SizedBox(height: 30,),
                Container(
                  width: widthSize * 0.9,
                  height: heightSize * 0.065,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF46932c)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await addTrip();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF46932c),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                      )
                    ),
                    child: Text(
                      "Add trip",
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
        ),
      ),
    );
  }
}
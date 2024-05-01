// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditEvent extends StatefulWidget {
  const EditEvent({super.key, required this.id});

  final String id;

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  bool loading = true;
  bool isError = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  getData() async {
    try {
      final db = FirebaseFirestore.instance;
      var eventData = await db.collection("events").doc(widget.id).get();
      return setState(() {
        titleController.text = eventData["title"];
        bodyController.text = eventData["body"];
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

  editBird() async {
    try {
      await FirebaseFirestore.instance.collection("events").doc(widget.id).set({
        "title": titleController.text,
        "body": bodyController.text
      });
      return Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error editing event"), backgroundColor: Color(0xFF46923c),)
      );
    }
  }

  deleteBird() async {
    try {
      await FirebaseFirestore.instance.collection("events").doc(widget.id).delete();
      Navigator.of(context).pop();
      return Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting event"), backgroundColor: Color(0xFF46923c),)
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
          "Edit event",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: loading
      ? Center(
        child: Text(
          "Loading..."
        ),
      )
      : isError
      ? Center(
        child: Text(
          "An error has occured"
        ),
      )
      : Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
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
                      contentPadding: EdgeInsets.only(left: 30),
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
                Container(
                width: widthSize*0.9,
                height: heightSize * 0.065,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF46923c)),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await editBird();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF46923c), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    "Edit event",
                    style: TextStyle(
                      color: Color(0xFF46923c),
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: widthSize*0.9,
                height: heightSize * 0.065,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    await deleteBird();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    "Delete event",
                    style: TextStyle(
                      color: Colors.red,
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
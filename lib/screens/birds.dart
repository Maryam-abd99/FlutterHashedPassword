// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:app/screens/add_bird.dart';
import 'package:app/screens/bird.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Birds extends StatefulWidget {
  const Birds({super.key});

  @override
  State<Birds> createState() => _BirdsState();
}

class _BirdsState extends State<Birds> {
  var birds;
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

      var birdsData = await db.collection("birds").get();
      return setState(() {
        birds = birdsData.docs;
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
          "Birds",
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
      : birds.length == 0
      ? Center(
        child: Text("No birds added yet"),
      )
      : SingleChildScrollView(
        child: ListView.separated(
          itemCount: birds.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Bird(id: birds[index].id, title: birds[index].data()["title"]),
                  )
                )
                .then((value) => getData());
              },
              title: Text(
                birds[index].data()["title"]
              ),
            );
          },
          separatorBuilder:(context, index) {
            return Divider(
              thickness: 1.5,
            );
          },
        )
      ),
      floatingActionButton: user == 2
      ? SizedBox()
      : user == 0
      ? SizedBox()
      : FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddBird())
          )
          .then((value) => getData());
        },
        backgroundColor: Color(0xFF46923c),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ), 
    );
  }
}
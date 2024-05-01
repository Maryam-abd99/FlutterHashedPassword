// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables

import 'package:app/root.dart';
import 'package:app/screens/add_admin.dart';
import 'package:app/screens/change_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Logged extends StatefulWidget {
  const Logged({super.key});

  @override
  State<Logged> createState() => _LoggedState();
}

class _LoggedState extends State<Logged> {
  var data;
  bool loading = true;
  getUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    print(FirebaseAuth.instance.currentUser!.displayName);
    final db = FirebaseFirestore.instance;
    final data1 = await db.collection("users").doc(uid).get();
    return setState(() {
      data = data1;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }
  @override
  Widget build(BuildContext context) {
    return loading
    ? Center(
      child: Text("Loading..."),
    )
    : SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Center(
            child: Text(
              "${data["full_name"]}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Center(
            child: Text(
              data["user_type"] == 0 ? "Super Admin" : data["user_type"] == 1 ? "Admin" : data["account_type"] == "email" ? "Email user" : "Google user",
              style: TextStyle(
                fontSize: 16
              ),
            ),
          ),
          Divider(
            thickness: 2,
          ),
          data["account_type"] == "google"
          ? SizedBox()
          : Column(
            children: [
              ListTile(
                title: Text("Change name"),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder:(context) => ChangeName(),)
                  ).then((value) => getUserData());
                },
              ),
              Divider(
                thickness: 1.5,
              ),
              ListTile(
                title: Text("Change password"),
              ),
              Divider(
                thickness: 1.5,
              ),
            ],
          ),
          data["user_type"] == 0
          ? ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddAdmin(),
                )
              );
            },
            title: Text("Add admin"),
          )
          : SizedBox(),
          data["user_type"] == 0
          ? Divider(
            thickness: 1.5,
          )
          : SizedBox(),
          ListTile(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Root()),
                (route) => false
              );
            },
            title: Text(
              "Logout",
              style: TextStyle(
                color: Colors.red
              ),
            ),
          )
        ],
      ),
    );
  }
}
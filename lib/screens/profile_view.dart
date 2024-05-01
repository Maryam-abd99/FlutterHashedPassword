import 'package:app/screens/logged.dart';
import 'package:app/screens/not_logged.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool loading = true;
  bool logged = false;
  checkAuth() {
    setState(() {
      loading = true;
    });
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        logged = true;
        loading = false;
      });
    } else {
      setState(() {
        logged = false;
        loading = false;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: loading
      ? Center(
        child: CircularProgressIndicator(color: Color(0xff46923c),),
      )
      : logged
      ? Logged()
      : NotLogged()
    );
  }
}
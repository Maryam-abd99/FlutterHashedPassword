// ignore_for_file: prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:app/root.dart';
import 'package:app/screens/forget_password.dart';
import 'package:app/screens/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:firebase_auth/firebase_auth.dart";

class NotLogged extends StatefulWidget {
  const NotLogged({super.key});

  @override
  State<NotLogged> createState() => _NotLoggedState();
}

class _NotLoggedState extends State<NotLogged> {

  signInWithGoogle() async {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text("To be implemented later on."), backgroundColor: Color(0xff46923c),)
    // );
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken
      );
      final auth = FirebaseAuth.instance;
      await auth.signInWithCredential(cred);
      final db = FirebaseFirestore.instance;
      await db.collection("users").doc(auth.currentUser!.uid).set({
        "uid": auth.currentUser!.uid,
        "email": auth.currentUser!.email,
        "full_name": auth.currentUser!.displayName,
        "user_type": 2,
        "account_type": "google"
      });
            return Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (conext) => Root()), (route) => false);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error"), backgroundColor: Color(0xff46923c),)
      );
    }
  }

  signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      return Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (conext) => Root()), (route) => false);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == "invalid-credential") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid credentials"), backgroundColor: Color(0xff46923c),)
        );
      } else if (e.code == "wrong-password") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Firebase error"), backgroundColor: Color(0xff46923c),)
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error"), backgroundColor: Color(0xff46923c),)
      );
    }
  }
  bool secureText = true;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: heightSize*0.05),
                  Text("Login to your account",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widthSize*0.055
                    ),),
                ],
              ),
              //2 image
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/undraw_Access_account_re_8spm.png',
                    // width: widthSize,
                    height: heightSize*0.27,
                  )
                ],
              ),
              Container(
                // color: Colors.pink,
                  padding: EdgeInsets.only(top:17,left: 40.0,bottom: 10,), // Add padding from the left side
                  alignment: Alignment.centerLeft,
                  child: Text('Username', style: TextStyle(fontWeight:FontWeight.bold,fontSize: widthSize*0.045,),
                  )
              ),
              //Email
              SizedBox(
                width: widthSize*0.8,
                child: TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter email";
                    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                      return "Please enter valid email";
                    } else {
                      return null;
                    }
                  },
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
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
              SizedBox(height: heightSize*0.012),
              // text pass
              Container(
                // color: Colors.pink,
                  padding: EdgeInsets.only(left: 40.0,bottom: 10,), // Add padding from the left side
                  alignment: Alignment.centerLeft,
                  child: Text('Password', style: TextStyle(fontWeight:FontWeight.bold,fontSize: widthSize*0.045,),
                  )
              ),
              //Password
              SizedBox(
                width: widthSize*0.8,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter password";
                    } else if (value.length < 7) {
                      return "Password must be 7 characters or longer";
                    } else {
                      return null;
                    }
                  },
                  controller: passwordController,
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                      hintText: "Enter your password",
                      hintStyle: TextStyle(fontSize: 15),
                      contentPadding: EdgeInsets.only(left: 30),
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF46923c)),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF46923c),width: 2.0,),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    suffixIcon: IconButton(
                      icon: Icon(secureText ? Icons.visibility:Icons.visibility_off,color: Color(0xFF46923c),size: widthSize*0.05,),
                      onPressed: (){
                        setState(() {
                          secureText = !secureText;
                        });
                      },
                    )
                  ),
                  obscureText: secureText,
                ),
              ),
              //Forget pass
              Container(
                alignment: Alignment.topRight,
                padding: EdgeInsets.only(right: 35,bottom: 15,),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ForgetPassword(),
                      )
                    );
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Color(0xFF054C94), // Make the text appear like a hyperlink
                    ),
                  ),
                ),
              ),
              //Button
              Container(
                width: widthSize * 0.8,
                height: heightSize * 0.065,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF46923c)),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await signIn();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background when it's not clicked
                    foregroundColor: Color(0xFF46923c), // White background when it's clicked
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(color: Color(0xFF46923c), fontWeight: FontWeight.bold, fontSize: widthSize*0.058,),
                  ),
                ),
              ),
              SizedBox(height: heightSize*0.012,),
              //Google
              Container(
                width: widthSize * 0.8,
                height: heightSize * 0.065,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF46923c)),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ElevatedButton(
                  onPressed: signInWithGoogle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background when it's not clicked
                    foregroundColor: Color(0xFF46923c), // White background when it's clicked
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/GIcon.png"),
                      Text(
                        'Login with Google',
                        style: TextStyle(color: Color(0xFF46923c), fontSize: widthSize*0.044,),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: heightSize*0.012,),
              //Don't have an account
              RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Sign up',
                      style: TextStyle(color: Color(0xFF054C94),fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:(context) => Register(),
                          )
                        );
                      }
                    ),
                  ],
                ),
              ),
          ],
        )
      ),
    );
  }
}
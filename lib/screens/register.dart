// ignore_for_file: use_build_context_synchronously

import "package:app/root.dart";
import "package:app/screens/terms_and_confitions.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";

//hash
import 'dart:convert';
//add crypto: 3.0.3 in pubspec.yaml
import 'package:crypto/crypto.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool secureText = true;
  bool agreedToTerms = false;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  double widthSize = 0.0;
  double heightSize = 0.0;
  createUser() async {
    try {
      final creds = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final db = FirebaseFirestore.instance;

      // Hash the password using SHA-256 algorithm
      String hashedPassword = sha256.convert(utf8.encode(passwordController.text)).toString();

      await db.collection("users").doc(creds.user?.uid).set({
        "uid": creds.user?.uid,
        "email": emailController.text,
        "full_name": nameController.text,
        "user_type": 2,
        "account_type": "email",
        // Store the hashed password
        "password": hashedPassword,
      });
      return Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Root()), (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Weak password"), backgroundColor: Color(0xff46923c),)
        );
      } else if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email already user"), backgroundColor: Color(0xff46923c),)
        );
      }
     } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error"), backgroundColor: Color(0xff46923c),)
      );
     }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    widthSize = MediaQuery.of(context).size.width;
    heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff46923c),
        title: Text(
          "Register",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: heightSize*0.08,),
              //main text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sign up for a new account",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widthSize*0.055
                    ),),
                  SizedBox(height: heightSize*0.009,),
                  Text("Let's help you meet your task",
                    style: TextStyle(
                        letterSpacing: widthSize*0.0007,
                        color: Colors.grey[700],
                        fontSize: widthSize*0.04
                    ),),
                ],
              ),
              SizedBox(height: heightSize*0.04,),
              //text full name
              Container(
                padding: EdgeInsets.only(top: 17, left: 40, bottom: 10),
                alignment: Alignment.centerLeft,
                child: Text("Full name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: widthSize*0.045)),
              ),
              //first and last name
              SizedBox(
                width: widthSize*0.8,
                child: TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your full name";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.name,
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                    hintText: "Enter your full name",
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
              // text email
              Container(
                // color: Colors.pink,
                  padding: EdgeInsets.only(top:17,left: 40.0,bottom: 10,), // Add padding from the left side
                  alignment: Alignment.centerLeft,
                  child: Text('Email', style: TextStyle(fontWeight:FontWeight.bold,fontSize: widthSize*0.045,),
                  )
              ),
              //Email
              SizedBox(
                width: widthSize*0.8,
                child: TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                      return "Please enter valid email";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
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
              SizedBox(height: heightSize*0.02),
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
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter password";
                    } else if (value.length < 7) {
                      return "Password must be 7 characters or longer";
                    } else if (value != confirmPasswordController.text) {
                      return "Passwords dont match";
                    } else {
                      return null;
                    }
                  },
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
              // text Confirm pass
              Container(
                // color: Colors.pink,
                  padding: EdgeInsets.only(top:17,left: 40.0,bottom: 10,), // Add padding from the left side
                  alignment: Alignment.centerLeft,
                  child: Text('Confirm password', style: TextStyle(fontWeight:FontWeight.bold,fontSize: widthSize*0.045,),
                  )
              ),
              //Confirm password
              SizedBox(
                width: widthSize*0.8,
                child: TextFormField(
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter password";
                    } else if (value.length < 7) {
                      return "Password must be 7 characters or longer";
                    } else if (value != passwordController.text) {
                      return "Passwords dont match";
                    } else {
                      return null;
                    }
                  },
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                      hintText: "Enter confirm password",
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
              //Terms and conditions
              Padding(
                padding: const EdgeInsets.only(left: 30,bottom: 30,),
                child: Row(
                  children: [
                    Checkbox(
                      value: agreedToTerms,
                      onChanged: (newValue) {
                        setState(() {
                          agreedToTerms = newValue ?? false;
                        });
                      },
                    ),
                    Text(
                      'Agree to ',
                      style: TextStyle(color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TermsAndConditionsPage()),
                        );
                      },
                      child: Text(
                        'Terms and Conditions',
                        style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF054C94),),
                      ),
                    ),
                  ],
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
                    if (agreedToTerms != true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Agree to terms"), backgroundColor: Color(0xFF46923c),)
                      );
                    } else {
                      if (_formKey.currentState!.validate()) {
                        await createUser();
                      }
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
                    'Register',
                    style: TextStyle(color: Color(0xFF46923c), fontWeight: FontWeight.bold, fontSize: widthSize*0.058,),
                  ),
                ),
              ),
              SizedBox(height: heightSize*0.012,),
              //Have an account
              RichText(
                text: TextSpan(
                  text: "Already have an account? ",
                  style: TextStyle(color: Colors.black,),
                  children: [
                    TextSpan(
                      text: 'Sign in',
                      style: TextStyle(color: Color(0xFF054C94),fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pop();
                        },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
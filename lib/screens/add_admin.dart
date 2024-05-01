// ignore_for_file: use_build_context_synchronously
import "package:cloud_functions/cloud_functions.dart";
import "package:flutter/material.dart";

class AddAdmin extends StatefulWidget {
  const AddAdmin({super.key});

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  bool secureText = true;
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  double widthSize = 0.0;
  double heightSize = 0.0;
  addAdmin() async {
    try {
      final function = await FirebaseFunctions.instance.httpsCallable("addAdmin").call(
        {
          "email": emailController.text,
          "password": passwordController.text,
          "first_name": fNameController.text,
          "last_name": lNameController.text
        }
      );

      print(function.data);
      if (function.data["success"] == true) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Admin added successfully"), backgroundColor: Color(0xFF46932c),)
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Adding admin failed"), backgroundColor: Color(0xFF46932c),)
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error has occured"), backgroundColor: Color(0xFF46932c),)
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
          "Add Admin",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: heightSize*0.08,),
              //text first and last name
              SizedBox(
                height: heightSize*0.055,
                child: (
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            // color: Colors.pink,
                              padding: EdgeInsets.only(left: 39.0,), // Add padding from the left side
                              alignment: Alignment.centerLeft,
                              child: Text('First name', style: TextStyle(fontWeight:FontWeight.bold,fontSize: widthSize*0.045,),
                              )
                          ),
                        ),
                        SizedBox(width: widthSize*0.03,),
                        Expanded(
                          child: Container(
                            // color: Colors.pink,
                              padding: EdgeInsets.only(left: 10.0,), // Add padding from the left side
                              alignment: Alignment.centerLeft,
                              child: Text('Last name', style: TextStyle(fontWeight:FontWeight.bold,fontSize: widthSize*0.045,),
                              )
                          ),
                        ),
                      ],
                    )
                ),
              ),
              //first and last name
              SizedBox(
                width: widthSize*0.8,
                child: (
                  Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                            controller: fNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your first name";
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                              hintText: "First name",
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
                          ),),
                      SizedBox(width: widthSize*0.03,),
                      Expanded(
                        child: TextFormField(
                          controller: lNameController,
                          validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your last name";
                              } else {
                                return null;
                              }
                            },
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
                            hintText: "Last name",
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
                        ),),
                    ],
                  )
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
              SizedBox(height: 20,),
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
                      await addAdmin();
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
                    'Add admin',
                    style: TextStyle(color: Color(0xFF46923c), fontWeight: FontWeight.bold, fontSize: widthSize*0.058,),
                  ),
                ),
              ),
              SizedBox(height: heightSize*0.012,),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
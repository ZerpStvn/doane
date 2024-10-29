import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/controller/signup.dart';
import 'package:doane/controller/widget/buttoncall.dart';
import 'package:doane/page/homepage.dart';
import 'package:doane/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCont extends StatefulWidget {
  const LoginCont({super.key});

  @override
  State<LoginCont> createState() => _LoginContState();
}

class _LoginContState extends State<LoginCont> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String errormessage = "";
  bool isloading = false;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _email.text = "doane@doanechurch.com";
    _pass.text = "123456";
  }

  @override
  Widget build(BuildContext context) {
    double widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: widthsize < 788 ? widthsize * 0.90 : widthsize * 0.30,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: maincolor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: PrimaryFont(
                          title: "DOANE CHURCH MANAGEMENT",
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter your Email";
                          }
                          return null;
                        },
                        controller: _email,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          label: PrimaryFont(
                            title: "Email Address",
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter your Password";
                          }
                          return null;
                        },
                        controller: _pass,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          label: PrimaryFont(
                            title: "Password",
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          prefixIcon: Icon(
                            Icons.key_outlined,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const UserRegistration()));
                          },
                          child: const Text(
                            "Don't have an account? Pre Register",
                            style: TextStyle(color: Colors.white),
                          )),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 260,
                        height: 55,
                        child: ButtonCallback(
                          function: handlesubmit,
                          title: "Submit",
                        ),
                      ),
                      const SizedBox(height: 10),
                      errormessage.isNotEmpty
                          ? PrimaryFont(
                              title: errormessage,
                              color: Colors.red,
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> handlesubmit() async {
    setState(() {
      isloading = true;
    });
    try {
      if (_formkey.currentState!.validate()) {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text,
          password: _pass.text,
        );

        // Store the user’s UID to persist login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', userCredential.user!.uid);

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          int verifStatus = userDoc['verif'] ?? 0;

          if (verifStatus == 3 && mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          } else if (verifStatus == 2) {
            setState(() {
              errormessage = "Not yet Verified";
              isloading = false;
            });
          } else {
            setState(() {
              errormessage = "Verification status unknown";
              isloading = false;
            });
          }
        } else {
          setState(() {
            errormessage = "User data not found";
            isloading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        errormessage = "Password and Email did not match";
        isloading = false;
      });
    }
  }


}

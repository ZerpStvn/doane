import 'package:doane/controller/widget/buttoncall.dart';
import 'package:doane/controller/widget/textformfield.dart';
import 'package:doane/utils/const.dart';
import 'package:flutter/material.dart';

class LoginCont extends StatefulWidget {
  const LoginCont({super.key});

  @override
  State<LoginCont> createState() => _LoginContState();
}

class _LoginContState extends State<LoginCont> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String errormesage = "";

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _pass.dispose();
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
              width: widthsize * 0.30,
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
                      const SizedBox(
                        height: 40,
                      ),
                      Textformfield(
                          textEditingController: _email,
                          labeltitle: "Email Address",
                          favicon: const Icon(
                            Icons.email_outlined,
                            color: Colors.white,
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Textformfield(
                          textEditingController: _pass,
                          labeltitle: "Password",
                          favicon: const Icon(
                            Icons.key_outlined,
                            color: Colors.white,
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 260,
                        height: 55,
                        child: ButtonCallback(function: () {}, title: "Submit"),
                      )
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
}

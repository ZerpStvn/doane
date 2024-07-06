import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/controller/widget/buttoncall.dart';
import 'package:doane/utils/const.dart';
import 'package:flutter/material.dart';

class MinistryListCont extends StatefulWidget {
  const MinistryListCont({super.key});

  @override
  State<MinistryListCont> createState() => _MinistryListContState();
}

class _MinistryListContState extends State<MinistryListCont> {
  final TextEditingController _ministryname = TextEditingController();
  bool isloading = false;

  @override
  void dispose() {
    _ministryname.dispose();
    super.dispose();
  }

  Future handleadd() async {
    setState(() {
      isloading = true;
    });
    try {
      FirebaseFirestore.instance
          .collection('ministry')
          .add({"name": _ministryname.text});
      setState(() {
        isloading = false;
      });
      _showSnackbar("Added Ministry ");
    } catch (error) {
      debugPrint("Error $error");
      setState(() {
        isloading = false;
      });
      _showSnackbar("Error Adding Ministry ");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 210,
            child: TextFormField(
              controller: _ministryname,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter  name';
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: 'Ministry Name', border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          isloading == false
              ? SizedBox(
                  height: 30,
                  child: ButtonCallback(
                      fcolor: Colors.white,
                      bgcolor: maincolor,
                      function: () {
                        handleadd();
                      },
                      title: "ADD MINISTRY"),
                )
              : const CircularProgressIndicator()
        ],
      ),
    );
  }
}

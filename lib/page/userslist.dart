import 'package:doane/controller/globalbutton.dart';
import 'package:doane/controller/userForm.dart';
import 'package:doane/page/tablelistuser.dart';
import 'package:flutter/material.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  bool isloadd = false;

  void handleadded() {
    setState(() {
      isloadd = !isloadd;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: GlobalButton(
              oncallback: () {
                handleadded();
              },
              title: isloadd == false ? "Add User" : "View Users"),
        ),
        isloadd
            ? const UserForm(
                isedit: false,
              )
            : const UsersDatalist()
      ],
    );
  }
}

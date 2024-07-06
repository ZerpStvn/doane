import 'package:doane/controller/ministrylist.dart';
import 'package:doane/page/userslist.dart';
import 'package:doane/utils/const.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentpage = 0;

  Widget currentpages() {
    if (currentpage == 0) {
      return const UsersList();
    } else if (currentpage == 1) {
      return const MinistryListCont();
    } else {
      return const UsersList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Drawer(
              backgroundColor: const Color.fromARGB(255, 71, 139, 171),
              shape: const RoundedRectangleBorder(),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: PrimaryFont(
                      title: "DOANE MIS",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      size: 26,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        currentpage = 0;
                      });
                    },
                    leading: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    title: const PrimaryFont(
                      title: "Users",
                      color: Colors.white,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        currentpage = 1;
                      });
                    },
                    leading: const Icon(
                      Icons.note_outlined,
                      color: Colors.white,
                    ),
                    title: const PrimaryFont(
                      title: "Ministry",
                      color: Colors.white,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        currentpage = 1;
                      });
                    },
                    leading: const Icon(
                      Icons.notification_add,
                      color: Colors.white,
                    ),
                    title: const PrimaryFont(
                      title: "Announcement",
                      color: Colors.white,
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.event,
                      color: Colors.white,
                    ),
                    title: const PrimaryFont(
                      title: "Events",
                      color: Colors.white,
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.leaderboard,
                      color: Colors.white,
                    ),
                    title: const PrimaryFont(
                      title: "Attendance",
                      color: Colors.white,
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.church_outlined,
                      color: Colors.white,
                    ),
                    title: const PrimaryFont(
                      title: "Pledges",
                      color: Colors.white,
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.church_outlined,
                      color: Colors.white,
                    ),
                    title: const PrimaryFont(
                      title: "Sermons list",
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [currentpages()],
              ),
            ),
          )
        ],
      ),
    );
  }
}

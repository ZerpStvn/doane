import 'package:doane/controller/ministrylist.dart';
import 'package:doane/page/announcement.dart';
import 'package:doane/page/archive_event.dart';
import 'package:doane/page/attendance.dart';
import 'package:doane/page/event.dart';
import 'package:doane/page/finance.dart';
import 'package:doane/page/pledge.dart';
import 'package:doane/page/uploadDocuments.dart';
import 'package:doane/page/userslist.dart';
import 'package:doane/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePageTest extends StatefulWidget {
  const HomePageTest({super.key});

  @override
  State<HomePageTest> createState() => _HomePageTestState();
}

class _HomePageTestState extends State<HomePageTest> {
  int currentpage = 0;
  List<Map<String, dynamic>> usersobject = [];
  User? currentuser = FirebaseAuth.instance.currentUser;

  Widget currentpages() {
    if (currentpage == 0) {
      return const UsersList();
    } else if (currentpage == 1) {
      return const MinistryListCont();
    } else if (currentpage == 2) {
      return const AnnouncementPage();
    } else if (currentpage == 3) {
      return const EventsPage();
    } else if (currentpage == 4) {
      return const Attendance();
    } else if (currentpage == 5) {
      return const PledgesPage();
    } else if (currentpage == 6) {
      return const ArchivePage();
    } else if (currentpage == 7) {
      return const FileUploadPage();
    } else if (currentpage == 8) {
      return const FinancePage();
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
            flex: 1,
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
                      size: 34,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
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
                  const SizedBox(
                    height: 17,
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
                  const SizedBox(
                    height: 17,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        currentpage = 2;
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
                  const SizedBox(
                    height: 17,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        currentpage = 3;
                      });
                    },
                    leading: const Icon(
                      Icons.event,
                      color: Colors.white,
                    ),
                    title: const PrimaryFont(
                      title: "Events",
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        currentpage = 4;
                      });
                    },
                    leading: const Icon(
                      Icons.leaderboard,
                      color: Colors.white,
                    ),
                    title: const PrimaryFont(
                      title: "Attendance",
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        currentpage = 5;
                      });
                    },
                    leading: const Icon(
                      Icons.church_outlined,
                      color: Colors.white,
                    ),
                    title: const PrimaryFont(
                      title: "Pledges",
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        currentpage = 6;
                      });
                    },
                    leading: const Icon(
                      Icons.archive_outlined,
                      color: Colors.white,
                    ),
                    title: const PrimaryFont(
                      title: "Archive",
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        currentpage = 7;
                      });
                    },
                    leading: const Icon(
                      Icons.edit_document,
                      color: Colors.white,
                    ),
                    title: const PrimaryFont(
                      title: "Document",
                      color: Colors.white,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        currentpage = 8;
                      });
                    },
                    leading: const Icon(
                      Icons.credit_card,
                      color: Colors.white,
                    ),
                    title: const PrimaryFont(
                      title: "Finance",
                      color: Colors.white,
                    ),
                  ),

                  // ListTile(
                  //   onTap: () {},
                  //   leading: const Icon(
                  //     Icons.church_outlined,
                  //     color: Colors.white,
                  //   ),
                  //   title: const PrimaryFont(
                  //     title: "Sermons list",
                  //     color: Colors.white,
                  //   ),
                  // ),
                  const SizedBox(
                    height: 140,
                  ),
                  ListTile(
                    onTap: () {
                      //handlelogout();
                    },
                    leading: const Icon(
                      Icons.logout_rounded,
                      color: Colors.white,
                    ),
                    title: const PrimaryFont(
                      title: "Logout",
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  currentpages(),
                  // userrole == 'admin' || userrole == "staff"
                  //     ? currentpages()
                  //     : currentpagesuser()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

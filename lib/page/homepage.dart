import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/controller/ministrylist.dart';
import 'package:doane/page/announcement.dart';
import 'package:doane/page/event.dart';
import 'package:doane/page/pledge.dart';
import 'package:doane/page/userslist.dart';
import 'package:doane/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentpage = 0;
  List<Map<String, dynamic>> usersobject = [];
  User? currentuser = FirebaseAuth.instance.currentUser;
  String? userrole;

  Widget currentpages() {
    if (currentpage == 0) {
      return const UsersList();
    } else if (currentpage == 1) {
      return const MinistryListCont();
    } else if (currentpage == 2) {
      return const AnnouncementPage();
    } else if (currentpage == 3) {
      return const EventsPage();
    } else if (currentpage == 5) {
      return const PledgesPage();
    } else {
      return const UsersList();
    }
  }

  Future<void> getuserData() async {
    try {
      DocumentSnapshot userobjects = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentuser!.uid)
          .get();

      if (userobjects.exists) {
        setState(() {
          var usersobjectfetch = userobjects.data() as Map<String, dynamic>;

          final String userrolefetched = usersobjectfetch['role'].toString();
          debugPrint("User Data: $usersobjectfetch");

          switch (userrolefetched) {
            case "0":
              userrole = "admin";
              debugPrint("User Role: $userrole");
              break;
            case "Member":
              userrole = "member";
              break;
            case "Staff":
              userrole = "staff";
              break;
            case "Volunteer":
              userrole = "volunteer";
              break;
            default:
              userrole = "admin";
              break;
          }
        });
      }
    } catch (error) {
      debugPrint("$error");
    }
  }

  @override
  void initState() {
    super.initState();
    getuserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          userrole == 'admin' || userrole == "staff"
              ? Expanded(
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
                )
              : Expanded(
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

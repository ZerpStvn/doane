import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/controller/globalbutton.dart';
import 'package:doane/controller/login.dart';
import 'package:doane/controller/ministrylist.dart';
import 'package:doane/front/indexmain.dart';
import 'package:doane/page/announcement.dart';
import 'package:doane/page/archive_event.dart';
import 'package:doane/page/attendance.dart';
import 'package:doane/page/event.dart';
import 'package:doane/page/finance.dart';
import 'package:doane/page/memberpage.dart';
import 'package:doane/page/pledge.dart';
import 'package:doane/page/uploadDocuments.dart';
import 'package:doane/page/user/attendevent.dart';
import 'package:doane/page/user/list_pledges.dart';
import 'package:doane/page/user/pledge.dart';
import 'package:doane/page/user/profile.dart';
import 'package:doane/page/userslist.dart';
import 'package:doane/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    } else if (currentpage == 4) {
      return const Attendance();
    } else if (currentpage == 5) {
      return const AdminPledge();
    } else if (currentpage == 6) {
      return const ArchivePage();
    } else if (currentpage == 7) {
      return const FileUploadPage();
    } else if (currentpage == 8) {
      return const FinancePage();
    } else if (currentpage == 9) {
      return const MembersPage();
    } else {
      return const UsersList();
    }
  }

  //userside
  Widget currentpagesuser() {
    if (currentpage == 0) {
      return userrole == "admin" || userrole == null
          ? const UsersList()
          : const AttendEventPage();
    } else if (currentpage == 1) {
      return const MinistryListCont();
    } else if (currentpage == 2) {
      return const UserPledges();
    } else if (currentpage == 3) {
      return UserProfile(isedit: true, userid: currentuser!.uid);
    } else if (currentpage == 5) {
      return const AdminPledge();
    } else if (currentpage == 4) {
      return const ListUserPledges();
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

  Future<void> handlelogout() async {
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginCont()),
            (route) => false);
      });
    } catch (err) {
      debugPrint("$err");
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthsize = MediaQuery.of(context).size.width;

    return Scaffold(
      body: widthsize > 768
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                userrole == 'admin' || userrole == "staff"
                    ? Expanded(
                        flex: 1,
                        child: Drawer(
                          backgroundColor: maincolor,
                          shape: const RoundedRectangleBorder(),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 150,
                                  child: DrawerHeader(
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  "https://images.unsplash.com/photo-1438232992991-995b7058bbb3?q=80&w=2073&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"))),
                                      child: Container()),
                                ),
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
                                const SizedBox(
                                  height: 13,
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

                                ListTile(
                                  onTap: () {
                                    setState(() {
                                      currentpage = 9;
                                    });
                                  },
                                  leading: const Icon(
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                  title: const PrimaryFont(
                                    title: "Message",
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
                                    handlelogout();
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
                      )
                    : Expanded(
                        flex: 1,
                        child: Drawer(
                          backgroundColor: maincolor,
                          shape: const RoundedRectangleBorder(),
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 150,
                                child: DrawerHeader(
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                "https://images.unsplash.com/photo-1438232992991-995b7058bbb3?q=80&w=2073&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"))),
                                    child: Container()),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 15.0),
                                child: PrimaryFont(
                                  title: "DOANE MIS",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(
                                height: 13,
                              ),
                              ListTile(
                                onTap: () {
                                  setState(() {
                                    currentpage = 0;
                                  });
                                },
                                leading: const Icon(
                                  Icons.event,
                                  color: Colors.white,
                                ),
                                title: const PrimaryFont(
                                  title: "Attend Events",
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 13,
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
                                height: 13,
                              ),
                              ListTile(
                                onTap: () {
                                  setState(() {
                                    currentpage = 2;
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
                                    currentpage = 4;
                                  });
                                },
                                leading: const Icon(
                                  Icons.list_alt_outlined,
                                  color: Colors.white,
                                ),
                                title: const PrimaryFont(
                                  title: "List Of Pledges",
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 13,
                              ),
                              ListTile(
                                onTap: () {
                                  setState(() {
                                    currentpage = 3;
                                  });
                                },
                                leading: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                title: const PrimaryFont(
                                  title: "Profile",
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              const SizedBox(
                                height: 13,
                              ),
                              ListTile(
                                onTap: () {
                                  logout();
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
                        userrole == 'admin' || userrole == "staff"
                            ? currentpages()
                            : currentpagesuser()
                      ],
                    ),
                  ),
                )
              ],
            )
          : Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                        textAlign: TextAlign.center,
                        "Only Available In Desktop View\nFor Awesome Experience"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GlobalButton(
                      oncallback: () {
                        logout();
                      },
                      title: "Return Home")
                ],
              ),
            ),
    );
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Mainpage()),
        (route) => false,
      );
    }
  }
}

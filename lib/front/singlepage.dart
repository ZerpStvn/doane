import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:doane/controller/login.dart';
import 'package:doane/front/announcementfront.dart';
import 'package:doane/front/event.dart';
import 'package:doane/front/indexmain.dart';
import 'package:doane/utils/const.dart';
import 'package:flutter/material.dart';

class PreRegistrationPage extends StatefulWidget {
  final String docsID;
  final int page;
  const PreRegistrationPage(
      {super.key, required this.docsID, required this.page});

  @override
  State<PreRegistrationPage> createState() => _PreRegistrationPageState();
}

class _PreRegistrationPageState extends State<PreRegistrationPage> {
  final TextEditingController fname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController pnum = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String checkimage(String dataimage) {
    if (dataimage.isEmpty) {
      return "https://images.unsplash.com/photo-1499652848871-1527a310b13a?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
    } else if (dataimage == "") {
      return "https://images.unsplash.com/photo-1499652848871-1527a310b13a?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
    } else {
      return dataimage;
    }
  }

  @override
  void dispose() {
    super.dispose();
    fname.dispose();
    email.dispose();
    pnum.dispose();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> eventRegister(String eventname) async {
    try {
      if (_formkey.currentState!.validate()) {
        FirebaseFirestore.instance
            .collection("newAttendance")
            .doc(widget.docsID)
            .collection('attendee')
            .add({
          'attendedAt': Timestamp.now(),
          'email': email.text,
          'eventId': widget.docsID,
          'eventname': eventname,
          'phone': pnum.text,
          'userId': 'notmember',
          'userName': fname.text,
        });

        _showSnackbar("Your Are now Registered");
      }
    } catch (e) {
      _showSnackbar("Error Registration, Please Try Again Later");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: widget.page == 0
                    ? FirebaseFirestore.instance
                        .collection('announcements')
                        .doc(widget.docsID)
                        .get()
                    : FirebaseFirestore.instance
                        .collection('events')
                        .doc(widget.docsID)
                        .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          "There's an Error loading the data, Please Try Again Later ${snapshot.error}"),
                    );
                  } else {
                    var datafile = snapshot.data!.data();
                    return Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width * 0.40,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  colorFilter: const ColorFilter.mode(
                                      Color.fromARGB(154, 0, 0, 0),
                                      BlendMode.multiply),
                                  image: NetworkImage(
                                      checkimage(datafile!['image'])))),
                        ),
                        Positioned(
                            top: 80,
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 5,
                                      width: 30,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    PrimaryFont(
                                      title: widget.page == 1
                                          ? "Doane Church Events"
                                          : "Announcements",
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      size: 21,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 5,
                                      width: 30,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                PrimaryFont(
                                  title: datafile['title'],
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  size: 45,
                                ),
                                PrimaryFont(
                                  title:
                                      "${datafile['date']} ${datafile['time']}",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  size: 25,
                                ),
                                widget.page == 1
                                    ? PrimaryFont(
                                        title: "Venue: ${datafile['venue']} ",
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        size: 25,
                                      )
                                    : Container(),
                                PrimaryFont(
                                  title: datafile['others'],
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  size: 14,
                                ),
                                // const PrimaryFont(
                                //   textAlign: TextAlign.center,
                                //   title:
                                //       "Far far away, behind the word mountains, far from the countries Vokalia and\nConsonantia, there live the blind texts.",
                                //   color: Colors.white,
                                //   fontWeight: FontWeight.normal,
                                //   size: 21,
                                // ),
                                widget.page == 1
                                    ? Form(
                                        key:
                                            _formkey, // Ensure this key is initialized
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.40,
                                          height: 300,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 45),
                                              const PrimaryFont(
                                                title: "PRE REGISTRATION",
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                size: 25,
                                              ),
                                              const SizedBox(height: 15),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                      controller: fname,
                                                      decoration:
                                                          const InputDecoration(
                                                        label: PrimaryFont(
                                                          title: "Full name",
                                                          color: Colors.white,
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please enter your full name';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Expanded(
                                                    child: TextFormField(
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                      controller: email,
                                                      decoration:
                                                          const InputDecoration(
                                                        label: PrimaryFont(
                                                          title: "Email",
                                                          color: Colors.white,
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please enter your email';
                                                        }
                                                        // Simple email validation
                                                        if (!RegExp(
                                                                r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                                                            .hasMatch(value)) {
                                                          return 'Please enter a valid email';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Expanded(
                                                    child: TextFormField(
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                      controller: pnum,
                                                      decoration:
                                                          const InputDecoration(
                                                        label: PrimaryFont(
                                                          title: "Phone Number",
                                                          color: Colors.white,
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please enter your phone number';
                                                        }
                                                        if (!RegExp(r'^[0-9]+$')
                                                            .hasMatch(value)) {
                                                          return 'Please enter a valid phone number';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                              SizedBox(
                                                height: 48,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: maincolor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              9),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    eventRegister(
                                                        datafile['title']);
                                                  },
                                                  child: const PrimaryFont(
                                                    title: "REGISTER NOW",
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            )),
                        Positioned(
                            top: 30,
                            left: 30,
                            right: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const PrimaryFont(
                                  title: "ANNOUNCEMENT",
                                  color: Colors.white,
                                  size: 24,
                                ),
                                Row(
                                  children: [
                                    // TextButton(
                                    //   onPressed: () {},
                                    //   child: const PrimaryFont(
                                    //     title: "Events",
                                    //     color: Colors.white,
                                    //   ),
                                    // ),
                                    // const SizedBox(
                                    //   width: 15,
                                    // ),
                                    // TextButton(
                                    //   onPressed: () {},
                                    //   child: const PrimaryFont(
                                    //     title: "Anouncements",
                                    //     color: Colors.white,
                                    //   ),
                                    // ),
                                    // const SizedBox(
                                    //   width: 15,
                                    // ),
                                    // TextButton(
                                    //   onPressed: () {},
                                    //   child: const PrimaryFont(
                                    //     title: "Contact",
                                    //     color: Colors.white,
                                    //   ),
                                    // ),
                                    // const SizedBox(
                                    //   width: 15,
                                    // ),
                                    SizedBox(
                                      height: 48,
                                      width: 100,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: maincolor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          9))),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Mainpage()));
                                          },
                                          child: const PrimaryFont(
                                            title: "Home",
                                            color: Colors.white,
                                          )),
                                    ),
                                  ],
                                )
                              ],
                            ))
                      ],
                    );
                  }
                }),
            widget.page == 0
                ? const AnnouncementFront()
                : const EventsFrontpage()
          ],
        ),
      ),
    );
  }
}

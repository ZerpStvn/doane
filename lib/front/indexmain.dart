import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/controller/login.dart';
import 'package:doane/front/event.dart';
import 'package:doane/utils/const.dart';
import 'package:flutter/material.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.40,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Color.fromARGB(154, 0, 0, 0), BlendMode.multiply),
                          image: NetworkImage(
                              "https://images.unsplash.com/photo-1437603568260-1950d3ca6eab?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"))),
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
                            const PrimaryFont(
                              title: "DOANE BAPTIST",
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
                        const PrimaryFont(
                          title: "We Love God, We",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          size: 45,
                        ),
                        const PrimaryFont(
                          title: "Believed in God",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          size: 45,
                        ),
                        // const PrimaryFont(
                        //   textAlign: TextAlign.center,
                        //   title:
                        //       "Far far away, behind the word mountains, far from the countries Vokalia and\nConsonantia, there live the blind texts.",
                        //   color: Colors.white,
                        //   fontWeight: FontWeight.normal,
                        //   size: 21,
                        // ),
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
                          title: "DOANE BAPTIST CHURCH",
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
                                              BorderRadius.circular(9))),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginCont()));
                                  },
                                  child: const PrimaryFont(
                                    title: "Login",
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        )
                      ],
                    ))
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: 650,
                    width: 630,
                    child: Image.network(
                        fit: BoxFit.cover,
                        "https://images.unsplash.com/photo-1587293094245-15c3520d3894?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")),
                const SizedBox(
                  width: 50,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    PrimaryFont2(
                      title: "Welcome to Doane Church",
                      size: 45,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    PrimaryFont2(
                      title:
                          "Far far away,creative behind the word mountains, far from the\ncountries Vokalia and Consonantia, there live the success blind texts.\nSeparated they live in Bookmarksgrove",
                      size: 21,
                      fontWeight: FontWeight.normal,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    PrimaryFont2(
                      title:
                          "A small river named Duden flows by their place and supplies it with\nthe necessary regelialia. It is a paradisematic country, in which\nroasted parts of sentences fly into your mouth.",
                      size: 21,
                      fontWeight: FontWeight.normal,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 430,
                      child: ListTile(
                        leading: Icon(
                          Icons.arrow_forward_ios,
                          color: maincolor,
                        ),
                        title: PrimaryFont2(
                            title: "Even the all-powerful Pointing"),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 430,
                      child: ListTile(
                        leading: Icon(
                          Icons.arrow_forward_ios,
                          color: maincolor,
                        ),
                        title: PrimaryFont2(title: "Behind the word mountains"),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 430,
                      child: ListTile(
                        leading: Icon(
                          Icons.arrow_forward_ios,
                          color: maincolor,
                        ),
                        title: PrimaryFont2(
                            title: "Separated they live in Bookmarksgrove"),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 120,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 2,
                  width: 50,
                  color: Colors.black,
                ),
                const SizedBox(
                  width: 10,
                ),
                const PrimaryFont(
                  title: "Anouncements",
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  size: 21,
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 2,
                  width: 50,
                  color: Colors.black,
                ),
              ],
            ),
            const SizedBox(
              height: 19,
            ),
            Center(
              child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('announcements')
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else if (!snapshot.hasData) {
                      return Container();
                    } else {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                mainAxisExtent: 360),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var datafile = snapshot.data!.docs[index].data();
                          return Stack(
                            children: [
                              Container(
                                height: 340,
                                width: 340,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: const DecorationImage(
                                        colorFilter: ColorFilter.mode(
                                            Color.fromARGB(139, 0, 0, 0),
                                            BlendMode.multiply),
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            "https://images.unsplash.com/photo-1499652848871-1527a310b13a?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"))),
                              ),
                              Positioned(
                                  bottom: 45,
                                  left: 20,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      PrimaryFont(
                                        title: "${datafile['title']}",
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        size: 25,
                                      ),
                                      PrimaryFont(
                                        title:
                                            "${datafile['date']} ${datafile['time']}",
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        size: 17,
                                      ),
                                      PrimaryFont(
                                        title: "${datafile['venue']}",
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        size: 17,
                                      ),
                                    ],
                                  ))
                            ],
                          );
                        },
                      );
                    }
                  }),
            ),
            const EventsFrontpage()
          ],
        ),
      ),
    );
  }
}

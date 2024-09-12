import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/controller/login.dart';
import 'package:doane/front/event.dart';
import 'package:doane/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  final String _url = "https://www.facebook.com/DBCiloilo/";

  Future<void> urllaunchUrl() async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw 'Could not launch $_url';
    }
  }

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
                          title: "I Love God, I",
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
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  height: 240,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              Color.fromARGB(150, 0, 0, 0), BlendMode.darken),
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://images.unsplash.com/photo-1633917526048-c05a2da4b1a5?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"))),
                ),
                const Positioned(
                    left: 30,
                    bottom: 0,
                    top: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Join us at 9 AM, 11 AM, 1 PM or 5 PM on Sundays.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Childcare is available at 9 AM, 11 AM and 5 PM.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ))
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  height: 440,
                  color: Colors.black,
                  child: const Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Our Vision',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Declaration Church exists to develop disciples who will declare and demonstrate the Gospel to Bryan/College Station and beyond.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                )),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 40),
                    height: 440,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Color.fromARGB(150, 0, 0, 0), BlendMode.darken),
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://images.squarespace-cdn.com/content/v1/5fa17126c93d1d77d88ca067/9cee8551-09f8-4730-84a0-1ae4e02882ca/IMG_8606+%281%29.jpg?format=1500w"))),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Column(
              children: [
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
                const Text(
                    textAlign: TextAlign.center,
                    "We’re excited to share some important updates with you! Be sure to\ncheck our latest announcement for exciting news about our mission and upcoming events")
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
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 40),
                    height: 440,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Color.fromARGB(150, 0, 0, 0), BlendMode.darken),
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://images.unsplash.com/photo-1605385264783-7c02b7f297e2?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"))),
                  ),
                ),
                Expanded(
                    child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  height: 440,
                  color: Colors.black,
                  child: const Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Our Mission',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Our mission at Doane Baptist Church is to glorify God by proclaiming the Gospel of Jesus Christ, nurturing discipleship through the teaching of God’s Word, and fostering a loving, Christ-centered community. .',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
            const EventsFrontpage(),
            const SizedBox(
              height: 19,
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  height: 440,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'OUR DAILY DEVOTION',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Start your day with inspiration and guidance! Be sure to check our Daily Devotion for uplifting messages rooted in God’s Word. Whether youre seeking encouragement, wisdom, or a moment of reflection, our devotionals are here to help you grow spiritually every day.',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            height: 40,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 1, color: Colors.black))),
                                onPressed: urllaunchUrl,
                                child: const Text(
                                  "VISIT US",
                                  style: TextStyle(color: Colors.black),
                                )))
                      ],
                    ),
                  ),
                )),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 40),
                    height: 440,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Color.fromARGB(150, 0, 0, 0), BlendMode.darken),
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://images.unsplash.com/photo-1543702404-38c2035462ad?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"))),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DOANE',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Baptist, member of a group of Protestant Christians who share the basic beliefs of most Protestants but who insist that only believers should be baptized',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          )),
                      const SizedBox(
                        width: 40,
                      ),
                      Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Discovery',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "About us",
                                    style: TextStyle(color: Colors.white),
                                  )),
                              const SizedBox(
                                height: 5,
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Scheduled Mass",
                                    style: TextStyle(color: Colors.white),
                                  )),
                              TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Events",
                                    style: TextStyle(color: Colors.white),
                                  )),
                              TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Announcement",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ],
                          )),
                      const Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Socials',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                textColor: Colors.white,
                                iconColor: Colors.white,
                                leading: Icon(Icons.facebook),
                                title: Text("Facebook"),
                              ),
                              ListTile(
                                textColor: Colors.white,
                                iconColor: Colors.white,
                                leading: Icon(Icons.play_arrow_outlined),
                                title: Text("Youtube"),
                              ),
                              ListTile(
                                textColor: Colors.white,
                                iconColor: Colors.white,
                                leading: Icon(Icons.search_outlined),
                                title: Text("Google"),
                              )
                            ],
                          )),
                      const Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contact Us',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                textColor: Colors.white,
                                iconColor: Colors.white,
                                leading: Icon(Icons.email_outlined),
                                title: Text("dbcincilo@gmail.com"),
                              ),
                              ListTile(
                                textColor: Colors.white,
                                iconColor: Colors.white,
                                leading: Icon(Icons.pin_drop_outlined),
                                title: Text(
                                    "Bonifacio Drive, Iloilo City, Philippines"),
                              )
                            ],
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.99,
                    height: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const ListTile(
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    leading: Icon(Icons.copyright_outlined),
                    title: Text("Doane 2024"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//  <script type="module">
    //   // Import the functions you need from the SDKs you need
    //   import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.3/firebase-app.js";
    //   // TODO: Add SDKs for Firebase products that you want to use
    //   // https://firebase.google.com/docs/web/setup#available-libraries

    //   // Your web app's Firebase configuration
    //   const firebaseConfig = {
    //     apiKey: "AIzaSyAC7BHGoMbxGXeBdejCiS2sjMdpOGAk_v4",
    //     authDomain: "doane-c693d.firebaseapp.com",
    //     projectId: "doane-c693d",
    //     storageBucket: "doane-c693d.appspot.com",
    //     messagingSenderId: "857987860304",
    //     appId: "1:857987860304:web:967be0c41e4a453e128e55",
    //   };

    //   // Initialize Firebase
    //   const app = initializeApp(firebaseConfig);
    // </script>
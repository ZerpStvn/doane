import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/utils/const.dart';
import 'package:flutter/material.dart';

class EventsFrontpage extends StatelessWidget {
  const EventsFrontpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 50,
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
                  title: "Events",
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
                "We have an exciting event coming up at Doane Baptist Church, and we’d love for you to be a part of it!\nBe sure to check our events page for more details and mark your calendar so you don’t miss out.")
          ],
        ),
        const SizedBox(
          height: 19,
        ),
        Center(
          child: FutureBuilder(
              future: FirebaseFirestore.instance.collection('events').get(),
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
                                        "https://images.unsplash.com/photo-1555483618-92870e63614e?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"))),
                          ),
                          Positioned(
                              bottom: 45,
                              left: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
        )
      ],
    );
  }
}

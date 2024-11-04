import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/front/singlepage.dart';
import 'package:doane/utils/const.dart';
import 'package:flutter/material.dart';

class AnnouncementFront extends StatefulWidget {
  const AnnouncementFront({super.key});

  @override
  State<AnnouncementFront> createState() => _AnnouncementFrontState();
}

class _AnnouncementFrontState extends State<AnnouncementFront> {
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
  Widget build(BuildContext context) {
    double widthsize = MediaQuery.of(context).size.width;
    return Column(
      children: [
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
              future:
                  FirebaseFirestore.instance.collection('announcements').get(),
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
                    gridDelegate: widthsize > 646
                        ? const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            mainAxisExtent: 360)
                        : const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            mainAxisExtent: 260,
                          ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var datafile = snapshot.data!.docs[index].data();
                      var dataID = snapshot.data!.docs[index].id;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PreRegistrationPage(
                                      docsID: dataID, page: 0)));
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: 340,
                              width: 340,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                      colorFilter: const ColorFilter.mode(
                                          Color.fromARGB(139, 0, 0, 0),
                                          BlendMode.multiply),
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          checkimage(datafile['image'])))),
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
                                      size: widthsize > 646 ? 25 : 15,
                                    ),
                                    PrimaryFont(
                                      title:
                                          "${datafile['date']} ${datafile['time']}",
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      size: widthsize > 646 ? 17 : 10,
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
                        ),
                      );
                    },
                  );
                }
              }),
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/front/singlepage.dart';
import 'package:doane/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsFrontpage extends StatefulWidget {
  const EventsFrontpage({super.key});

  @override
  State<EventsFrontpage> createState() => _EventsFrontpageState();
}

class _EventsFrontpageState extends State<EventsFrontpage> {
  String checkimage(String dataimage) {
    if (dataimage.isEmpty) {
      return "https://images.unsplash.com/photo-1499652848871-1527a310b13a?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
    } else if (dataimage == "") {
      return "https://images.unsplash.com/photo-1499652848871-1527a310b13a?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
    } else {
      return dataimage;
    }
  }

  // Helper function to parse date and time and categorize events
  String _getEventCategory(String date, String time) {
    try {
      // Define the formats based on your input
      final DateFormat dateFormat =
          DateFormat('MMM d, yyyy'); // Example: Nov 4, 2024
      final DateFormat timeFormat = DateFormat('h:mm a'); // Example: 5:19 PM

      // Parse the date and time
      final DateTime eventDateTime = DateTime(
        dateFormat.parse(date).year,
        dateFormat.parse(date).month,
        dateFormat.parse(date).day,
        timeFormat.parse(time).hour,
        timeFormat.parse(time).minute,
      );

      final DateTime now = DateTime.now();

      // Determine the category based on comparison with current time
      if (eventDateTime.isAfter(now)) {
        return "Upcoming";
      } else if (eventDateTime.isBefore(now)) {
        return "Past";
      } else {
        return "Ongoing";
      }
    } catch (e) {
      return "Unknown"; // Handle invalid date or time formats
    }
  }

  Color eventCategoryColor(category) {
    switch (category) {
      case "Past":
        return Colors.red;
      case "Upcoming":
        return Colors.green;
      case "Ongoing":
        return Colors.orange;
      default:
        return Colors.grey; // For unknown or uncategorized cases
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthsize = MediaQuery.of(context).size.width;
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
                "We have an exciting event coming up at Doane Baptist Church, and we'd love for you to be a part of it!\nBe sure to check our events page for more details and mark your calendar so you don’t miss out.")
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

                      final String category = _getEventCategory(
                        datafile['date'],
                        datafile['time'],
                      );
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PreRegistrationPage(
                                      statusevent: category,
                                      docsID: dataID,
                                      page: 1)));
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
                                top: 15,
                                left: 20,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: eventCategoryColor(category),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    category,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                )),
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
                                      size: widthsize > 656 ? 25 : 17,
                                    ),
                                    widthsize > 646
                                        ? PrimaryFont(
                                            title:
                                                "${datafile['date']} ${datafile['time']}",
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            size: 17,
                                          )
                                        : PrimaryFont(
                                            title:
                                                "${datafile['date']}\n${datafile['time']}",
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
                        ),
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

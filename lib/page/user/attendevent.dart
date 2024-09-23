import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AttendEventPage extends StatefulWidget {
  const AttendEventPage({super.key});

  @override
  State<AttendEventPage> createState() => _AttendEventPageState();
}

class _AttendEventPageState extends State<AttendEventPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userName;
  String? userId;
  String? email;
  String? phone;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        userName = userDoc['name'];
        email = userDoc['email'];
        phone = userDoc['phone'];
        userId = user.uid;
      });
    }
  }

  String checkimage(String dataimage) {
    if (dataimage.isEmpty) {
      return "https://images.unsplash.com/photo-1499652848871-1527a310b13a?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
    } else if (dataimage == "") {
      return "https://images.unsplash.com/photo-1499652848871-1527a310b13a?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
    } else {
      return dataimage;
    }
  }

  Future<void> _attendEvent(String eventId, String eventname) async {
    if (userId != null) {
      try {
        await FirebaseFirestore.instance
            .collection('newAttendance')
            .doc(eventId)
            .collection('attendee')
            .doc(userId)
            .set({
          'eventId': eventId,
          'userId': userId,
          'phone': phone ?? 'Anonymous',
          'email': email ?? "Anonymous",
          'userName': userName ?? 'Anonymous',
          'attendedAt': Timestamp.now(),
          'eventname': eventname
        });
        _showSnackbar('You have successfully attended the event.');
        setState(() {});
      } catch (e) {
        _showSnackbar('Error attending event: $e');
      }
    } else {
      _showSnackbar('You must be logged in to attend an event.');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<bool> checkAttendance(String eventId) async {
    try {
      QuerySnapshot attendanceSnapshot = await FirebaseFirestore.instance
          .collection('newAttendance')
          .doc(eventId)
          .collection('attendee')
          .where('userId', isEqualTo: userId)
          .get();

      if (attendanceSnapshot.docs.isNotEmpty) {
        return true; // User has attended
      }
    } catch (error) {
      debugPrint("Error checking attendance: $error");
    }

    return false; // User has not attended or an error occurred
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('events').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LinearProgressIndicator());
        }

        final events = snapshot.data!.docs;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2 / 2.5),
          itemCount: events.length,
          itemBuilder: (context, index) {
            var event = events[index];

            return FutureBuilder<bool>(
              future: checkAttendance(event.id),
              builder: (context, attendanceSnapshot) {
                if (attendanceSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Container();
                }

                bool hasAttended = attendanceSnapshot.data ?? false;

                return SizedBox(
                  width: 29,
                  height: 20,
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event['title'] ?? 'No Title',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          event['image'] != null
                              ? Image.network(
                                  checkimage(event['image']),
                                  fit: BoxFit.cover,
                                  height: 180,
                                  width: MediaQuery.of(context).size.width,
                                )
                              : const SizedBox(height: 8),
                          Text('Venue: ${event['venue'] ?? 'No Venue'}'),
                          Text('Date: ${event['date'] ?? 'No Date'}'),
                          Text('Time: ${event['time'] ?? 'No Time'}'),
                          const SizedBox(height: 8),
                          Text(
                            'Others: ${event['others'] ?? 'No Details'}',
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: hasAttended
                                      ? const Color.fromARGB(97, 108, 175,
                                          110) // Grey out if attended
                                      : maincolor,
                                  shape: const RoundedRectangleBorder(),
                                ),
                                onPressed: hasAttended
                                    ? null
                                    : () {
                                        _attendEvent(event.id, event['title']);
                                      },
                                child: Text(
                                  hasAttended ? 'Registered' : 'Attend Event',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

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

  Future<void> _attendEvent(String eventId) async {
    if (userId != null) {
      try {
        await FirebaseFirestore.instance.collection('attendance').add({
          'eventId': eventId,
          'userId': userId,
          'phone': phone ?? 'Anonymous',
          'email': email ?? "Anonymous",
          'userName': userName ?? 'Anonymous',
          'attendedAt': Timestamp.now(),
        });
        _showSnackbar('You have successfully attended the event.');
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
                              "https://images.unsplash.com/photo-1540575467063-178a50c2df87?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
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
                                backgroundColor: maincolor,
                                shape: const RoundedRectangleBorder()),
                            onPressed: () => _attendEvent(event.id),
                            child: const Text(
                              'Attend Event',
                              style: TextStyle(color: Colors.white),
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
  }
}

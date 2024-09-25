import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/utils/const.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class VisualAnalytics extends StatefulWidget {
  final String eventID;
  const VisualAnalytics({super.key, required this.eventID});

  @override
  State<VisualAnalytics> createState() => _VisualAnalyticsState();
}

class _VisualAnalyticsState extends State<VisualAnalytics> {
  int totalMembers = 0;
  int totalNonMembers = 0;
  final int requiredAttendees = 230; // Required number of attendees

  @override
  void initState() {
    super.initState();
    _fetchAttendeesData();
    _fetchAttendeesData2();
  }

  // Function to fetch attendee data from Firestore
  Future<void> _fetchAttendeesData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('newAttendance')
          .doc(widget.eventID)
          .collection('attendee')
          .get();

      if (snapshot.docs.isEmpty) {
        // Handle the case where there are no attendees
        setState(() {
          totalMembers = 0;
          totalNonMembers = 0;
        });
        return;
      }

      int members = 0;
      int nonMembers = 0;

      for (var doc in snapshot.docs) {
        // Ensure 'userId' exists in each document
        final userId = doc.data()['userId'] ??
            'notmember'; // Default to 'notmember' if field is missing
        if (userId == 'notmember') {
          nonMembers++;
        } else {
          members++;
        }
      }

      setState(() {
        totalMembers = members;
        totalNonMembers = nonMembers;
      });
    } catch (e) {
      print('Error fetching attendees: $e');
    }
  }

  // Function to fetch attendee data from Firestore
// Function to fetch attendee data from Firestore
  List<Map<String, dynamic>> attendeesData2 = [];
  Future<void> _fetchAttendeesData2() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('newAttendance')
          .doc(widget.eventID)
          .collection('attendee')
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          attendeesData2 = [];
        });
        return;
      }

      List<Map<String, dynamic>> fetchedData = [];

      for (var doc in snapshot.docs) {
        // Collecting the document's data into a Map
        final data = doc.data();
        fetchedData.add({
          'userName': data['userName'] ?? '',
          'email': data['email'] ?? '',
          'eventName': data['eventname'] ?? '',
          'attendedAt': data['attendedAt'] ?? '',
          'phone': data['phone'] ?? '',
        });
      }

      setState(() {
        attendeesData2 = fetchedData; // Set the attendee data in the state
      });
    } catch (e) {
      print('Error fetching attendees: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total attendees
    int totalAttendees = totalMembers + totalNonMembers;

    // Prepare pie chart sections based on members and non-members
    final pieSectionsAttendees = [
      PieChartSectionData(
        value: totalMembers.toDouble(),
        color: Colors.green,
        title: 'Members: $totalMembers',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: totalNonMembers.toDouble(),
        color: Colors.red,
        title: 'Non-Members: $totalNonMembers',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ];

    // Prepare pie chart sections based on total attendees vs required attendees
    final pieSectionsRequired = [
      PieChartSectionData(
        value: totalAttendees.toDouble(),
        color: Colors.blue,
        title: 'Attendees: $totalAttendees',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: (requiredAttendees - totalAttendees).toDouble(),
        color: Colors.orange,
        title: 'Remaining: ${requiredAttendees - totalAttendees}',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Attendance Analytics"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Attendance Analytics",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Row to display both pie charts side by side
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pie chart for members and non-members
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: PieChart(
                          PieChartData(
                            sections: pieSectionsAttendees,
                            centerSpaceRadius: 80,
                            sectionsSpace: 2,
                            pieTouchData: PieTouchData(
                              touchCallback:
                                  (FlTouchEvent event, pieTouchResponse) {},
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const LegendItem(color: Colors.green, text: 'Members'),
                      const LegendItem(color: Colors.red, text: 'Non-Members'),
                    ],
                  ),
                ),
                // Pie chart for total attendees vs required attendees
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: PieChart(
                          PieChartData(
                            sections: pieSectionsRequired,
                            centerSpaceRadius: 80,
                            sectionsSpace: 2,
                            pieTouchData: PieTouchData(
                              touchCallback:
                                  (FlTouchEvent event, pieTouchResponse) {},
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const LegendItem(color: Colors.blue, text: 'Attendees'),
                      const LegendItem(color: Colors.orange, text: 'Remaining'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor: const WidgetStatePropertyAll(maincolor),
                  headingTextStyle: const TextStyle(color: Colors.white),
                  columns: const [
                    DataColumn(label: Text('User Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Event Name')),
                    DataColumn(label: Text('Phone')),
                  ],
                  rows: attendeesData2.map((attendee) {
                    return DataRow(cells: [
                      DataCell(Text(attendee['userName'])),
                      DataCell(Text(attendee['email'])),
                      DataCell(Text(attendee['eventName'])),
                      DataCell(Text(attendee['phone'])),
                    ]);
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// LegendItem widget for displaying legends
class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(text),
        const SizedBox(width: 16),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/page/analytics.dart';
import 'package:flutter/material.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  // Function to delete attendance
  // Future<void> _deleteAttendance(String docId) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('attendance')
  //         .doc(docId)
  //         .delete();
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Attendance deleted successfully')),
  //       );
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error deleting attendance: $e')),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Field
          SizedBox(
            width: 250,
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by Username or Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          // Attendance Data Table
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('events').get(),
            builder: (context, snapshot) {
              // Handle errors
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              // Show loading indicator
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Handle no data scenario
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No attendance data found.'));
              }

              // Extract the attendance data
              final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                  attendances = snapshot.data!.docs
                      .cast<QueryDocumentSnapshot<Map<String, dynamic>>>();

              // Filter attendances by search term
              final filteredAttendances = attendances.where((doc) {
                final data = doc.data();
                final title = (data['title'] ?? '').toString().toLowerCase();
                final others = (data['others'] ?? '').toString().toLowerCase();
                return title.contains(_searchTerm.toLowerCase()) ||
                    others.contains(_searchTerm.toLowerCase());
              }).toList();

              // Show message if no results found after filtering
              if (filteredAttendances.isEmpty) {
                return const Center(child: Text('No results found.'));
              }

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(Colors.blue),
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Event Title',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Description',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Date',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Time',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Venue',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Actions',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  rows: filteredAttendances.map((doc) {
                    final data = doc.data();
                    // final attendedAtTimestamp = data['attendedAt'];

                    return DataRow(cells: [
                      DataCell(Text(data['title'] ?? '')),
                      DataCell(Text(data['others'] ?? '')),
                      DataCell(Text(data['date'] ?? '')),
                      DataCell(Text(data['time'] ?? '')),
                      DataCell(Text(data['venue'] ?? '')),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.analytics, color: Colors.red),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VisualAnalytics(eventID: doc.id)));
                          },
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

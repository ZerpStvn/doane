import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/utils/const.dart';
import 'package:flutter/material.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  Future<void> _deleteAttendance(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('attendance')
          .doc(docId)
          .delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attendance deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting attendance: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('attendance').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final attendances = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final userName =
                    data['userName']?.toString().toLowerCase() ?? '';
                final email = data['email']?.toString().toLowerCase() ?? '';
                return userName.contains(_searchTerm.toLowerCase()) ||
                    email.contains(_searchTerm.toLowerCase());
              }).toList();

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(maincolor),
                  columns: const [
                    DataColumn(
                        label: Text(
                      'UserName',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataColumn(
                        label: Text('Email',
                            style: TextStyle(color: Colors.white))),
                    DataColumn(
                        label: Text('Phone',
                            style: TextStyle(color: Colors.white))),
                    DataColumn(
                        label: Text('Event ID',
                            style: TextStyle(color: Colors.white))),
                    DataColumn(
                        label: Text('Attended At',
                            style: TextStyle(color: Colors.white))),
                    DataColumn(
                        label: Text('Actions',
                            style: TextStyle(color: Colors.white))),
                  ],
                  rows: attendances.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return DataRow(cells: [
                      DataCell(Text(data['userName'] ?? '')),
                      DataCell(Text(data['email'] ?? '')),
                      DataCell(Text(data['phone'] ?? '')),
                      DataCell(Text(data['eventId'] ?? '')),
                      DataCell(Text(data['attendedAt'].toDate().toString())),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteAttendance(doc.id),
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

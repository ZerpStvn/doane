import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListUserPledges extends StatefulWidget {
  const ListUserPledges({super.key});

  @override
  State<ListUserPledges> createState() => _ListUserPledgesState();
}

class _ListUserPledgesState extends State<ListUserPledges> {
  final userAuth = FirebaseAuth.instance;
  String searchQuery = '';
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search field
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 340,
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by Pledge Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
        ),

        // Date range picker
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              final pickedDateRange = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (pickedDateRange != null) {
                setState(() {
                  startDate = pickedDateRange.start;
                  endDate = pickedDateRange.end;
                });
              }
            },
            child: Text(
              startDate == null || endDate == null
                  ? 'Select Date Range'
                  : 'Selected Date Range: ${startDate!.toLocal()} - ${endDate!.toLocal()}',
            ),
          ),
        ),

        // Clear Filters Button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                searchQuery = ''; // Clear search query
                startDate = null; // Clear start date
                endDate = null; // Clear end date
              });
            },
            child: const Text('Clear Filters'),
          ),
        ),

        // StreamBuilder to display pledges
        StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collectionGroup('cpledge').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error fetching data.'));
            }

            // Check if there is any data
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No pledges found.'));
            }

            // Filter pledges based on search query and date range
            final pledges = snapshot.data!.docs.where((doc) {
              final pledgeName = (doc['pledgename'] as String).toLowerCase();
              final createdDate = (doc['created'] as Timestamp).toDate();

              bool matchesSearchQuery =
                  pledgeName.contains(searchQuery.toLowerCase());
              bool matchesDateRange = true;

              if (startDate != null && endDate != null) {
                // Ensure the date range includes the entire day on the endDate
                final endOfDay = DateTime(
                    endDate!.year, endDate!.month, endDate!.day, 23, 59, 59);
                matchesDateRange = createdDate.isAfter(startDate!) &&
                    createdDate.isBefore(endOfDay.add(const Duration(days: 1)));
              }

              return matchesSearchQuery && matchesDateRange;
            }).toList();

            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.blue),
                headingTextStyle: const TextStyle(color: Colors.white),
                columns: const [
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Created')),
                  DataColumn(label: Text('Pledge Name')),
                  DataColumn(label: Text('Type')),
                ],
                rows: pledges.map((doc) {
                  final amount = doc['amount'];
                  final created = (doc['created'] as Timestamp).toDate();
                  final pledgeName = doc['pledgename'];
                  final type = doc['type'];

                  return DataRow(
                    cells: [
                      DataCell(Text(amount.toString())),
                      DataCell(Text(created.toString())),
                      DataCell(Text(pledgeName)),
                      DataCell(Text(type)),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}

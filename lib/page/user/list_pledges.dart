import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/utils/const.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

            // Filter pledges based on search query
            final pledges = snapshot.data!.docs.where((doc) {
              return (doc['pledgename'] as String)
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
            }).toList();

            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              child: DataTable(
                headingRowColor: const WidgetStatePropertyAll(maincolor),
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
                  final pledgename = doc['pledgename'];
                  final type = doc['type'];

                  return DataRow(
                    cells: [
                      DataCell(Text(amount.toString())),
                      DataCell(Text(created.toString())),
                      DataCell(Text(pledgename)),
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

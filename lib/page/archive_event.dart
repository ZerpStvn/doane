import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:doane/utils/const.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Function to fetch the archived data based on search
  Stream<QuerySnapshot> _getArchivedData() {
    if (_searchQuery.isEmpty) {
      return FirebaseFirestore.instance.collection('archive').snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('archive')
          .where('name_lower',
              isGreaterThanOrEqualTo: _searchQuery.toLowerCase())
          .where('name_lower',
              isLessThanOrEqualTo: '${_searchQuery.toLowerCase()}\uf8ff')
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.30,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _searchQuery = _searchController.text;
                      });
                    },
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream: _getArchivedData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final archivedData = snapshot.data!.docs;

                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(maincolor),
                    columns: const [
                      DataColumn(
                        label: PrimaryFont(
                          title: 'Name / Title',
                          color: Colors.white,
                        ),
                      ),
                      DataColumn(
                        label: PrimaryFont(
                          title: 'Type',
                          color: Colors.white,
                        ),
                      ),
                      DataColumn(
                        label: PrimaryFont(
                          title: 'Date Created',
                          color: Colors.white,
                        ),
                      ),
                      DataColumn(
                        label: PrimaryFont(
                          title: 'Description',
                          color: Colors.white,
                        ),
                      ),
                    ],
                    rows: archivedData.map((data) {
                      // Safely access fields by checking if they exist
                      Map<String, dynamic>? dataMap =
                          data.data() as Map<String, dynamic>?;

                      String nameOrTitle = '';
                      String description = '';
                      String type = '';
                      String date = '';

                      if (dataMap != null) {
                        nameOrTitle = dataMap.containsKey('name')
                            ? dataMap['name']
                            : dataMap.containsKey('title')
                                ? dataMap['title']
                                : 'No Name or Title';

                        description = dataMap.containsKey('description')
                            ? dataMap['description']
                            : 'none';

                        type = dataMap.containsKey('type')
                            ? dataMap['type']
                            : 'Unknown Type';

                        date = dataMap.containsKey('date')
                            ? dataMap['date']
                            : 'Unknown Date';
                      }

                      return DataRow(cells: [
                        DataCell(Text(nameOrTitle)),
                        DataCell(Text(type)),
                        DataCell(Text(date)),
                        DataCell(Text(description)),
                      ]);
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ));
  }
}

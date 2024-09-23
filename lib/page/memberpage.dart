import 'package:doane/page/message.dart';
import 'package:doane/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MembersPageState createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  String searchQuery = '';
  String searchRole = '';
  bool ischat = false;
  String? userid;
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];

  Future<void> fetchUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    final allUsers = snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();

    setState(() {
      users = allUsers;
      filteredUsers = users; // Initially show all users
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void searchUsers(String query) {
    final results = users.where((user) {
      final name = user['name'].toString().toLowerCase();
      final role = user['role'].toString().toLowerCase();
      final searchLower = query.toString().toLowerCase();

      return name.contains(searchLower) || role.contains(searchLower);
    }).toList();

    setState(() {
      filteredUsers = results.isNotEmpty || query.isNotEmpty ? results : users;
    });
  }

  String safeToString(dynamic value) {
    if (value == null) return 'N/A';
    return value.toString();
  }

  void chatuser(String userid1) {
    if (userid1.isNotEmpty) {
      setState(() {
        ischat = true;
        userid = userid1;
      });
    } else {
      setState(() {
        ischat = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ischat == true
        ? MessagePage(
            userId: userid!,
          )
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 230,
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Search by Name or Role',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.trim();
                          });
                          searchUsers(searchQuery); // Trigger the local search
                        },
                      ),
                    ),
                  ],
                ),
              ),
              filteredUsers.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DataTable(
                          headingRowColor:
                              const WidgetStatePropertyAll(maincolor),
                          headingTextStyle:
                              const TextStyle(color: Colors.white),
                          columns: const [
                            DataColumn(
                              label: Text('Name'),
                            ),
                            DataColumn(label: Text('Ministry')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Message')),
                          ],
                          rows: filteredUsers.map((user) {
                            return DataRow(cells: [
                              DataCell(Text(safeToString(user['name']))),
                              DataCell(Text(safeToString(user['ministry']))),
                              DataCell(Text(safeToString(user['email']))),
                              DataCell(IconButton(
                                onPressed: () {
                                  chatuser(user['id']);
                                  // print("${user['id']}");
                                },
                                icon: const Icon(Icons.chat_bubble_outline),
                              ))
                            ]);
                          }).toList(),
                        ),
                      ),
                    )
                  : const Center(child: Text('No results found')),
            ],
          );
  }
}

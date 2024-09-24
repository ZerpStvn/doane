import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/controller/globalbutton.dart';
import 'package:doane/controller/userForm.dart';
import 'package:doane/utils/const.dart';
import 'package:flutter/material.dart';

class UsersDatalist extends StatefulWidget {
  const UsersDatalist({super.key});

  @override
  State<UsersDatalist> createState() => _UsersDatalistState();
}

class _UsersDatalistState extends State<UsersDatalist> {
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  bool isSelectAll = false;
  bool isedit = false;
  bool isview = false;
  String? userid;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future fetchUsers() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isNotEqualTo: 0)
          .get();

      if (usersSnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> fetchedUsers = [];
        for (var doc in usersSnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          Timestamp createdTimestamp = data['created'] ?? Timestamp.now();
          DateTime createdDate = createdTimestamp.toDate();
          bool isOldMember = DateTime.now().difference(createdDate).inDays > 30;

          fetchedUsers.add({
            'id': doc.id,
            'selected': false, // To track selection state
            'name': data['name']?.toString() ?? '',
            // 'ministry': data['ministry']?.toString() ?? '',
            'email': data['email']?.toString() ?? '',
            'role': data['role']?.toString() ?? '',
            'membershipStatus': data['membershipStatus']?.toString() ?? '',
            'phone': data['phone']?.toString() ?? '',
            'created': createdDate,
            'memberStatus': isOldMember ? 'Old Member' : 'New Member',
            'verif': data['verif'],
          });
        }

        setState(() {
          users = fetchedUsers;
          filteredUsers = fetchedUsers;
          isLoading = false;
        });
      }
    } catch (error) {
      debugPrint("Error $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchUsers(String query) {
    final results = users.where((user) {
      final name = user['name'].toLowerCase();
      final searchLower = query.toLowerCase();

      return name.contains(searchLower);
    }).toList();

    setState(() {
      filteredUsers = results.isNotEmpty || query.isNotEmpty ? results : users;
    });
  }

  void deleteSelectedUsers() async {
    final selectedUsers =
        filteredUsers.where((user) => user['selected']).toList();

    for (var user in selectedUsers) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user['id'])
          .delete();
    }

    fetchUsers();
  }

  void selectAll(bool? selected) {
    setState(() {
      isSelectAll = selected ?? false;
      filteredUsers = filteredUsers.map((user) {
        user['selected'] = isSelectAll;
        return user;
      }).toList();
    });
  }

  Future<void> updatedata(String id) async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .update({"verif": 3});
      setState(() {
        fetchUsers();
      });
      _showSnackbar("user is now verified");
    } catch (error) {
      _showSnackbar("There was an error, Please try again later");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isedit == false
        ? Padding(
            padding: const EdgeInsets.all(11.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.50,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _searchController,
                          onChanged: searchUsers,
                          decoration: const InputDecoration(
                            labelText: 'Search Users',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Expanded(
                      //   flex: 1,
                      //   child: SizedBox(
                      //       height: 50,
                      //       width: 30,
                      //       child: GlobalButton(
                      //         oncallback: () {
                      //           deleteSelectedUsers();
                      //         },
                      //         title: 'Delete Selected',
                      //       )
                      //       // ElevatedButton(
                      //       //   onPressed: deleteSelectedUsers,
                      //       //   child: const Text("Delete Selected"),
                      //       // ),
                      //       ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          DataTable(
                            showCheckboxColumn: false,
                            headingRowColor:
                                const WidgetStatePropertyAll(maincolor),
                            headingRowHeight: 30,
                            border: TableBorder.all(
                                width: 0.10, color: Colors.black),
                            headingTextStyle:
                                const TextStyle(color: Colors.white),
                            columns: [
                              // DataColumn(
                              //   label: const Text("Select"),
                              //   onSort: (int columnIndex, bool ascending) {
                              //     selectAll(ascending);
                              //   },
                              // ),
                              // const DataColumn(label: Text("Icon")),
                              DataColumn(
                                label: const Text("Name"),
                                onSort: (int columnIndex, bool ascending) {
                                  setState(() {
                                    if (ascending) {
                                      filteredUsers.sort((a, b) =>
                                          a['name'].compareTo(b['name']));
                                    } else {
                                      filteredUsers.sort((a, b) =>
                                          b['name'].compareTo(a['name']));
                                    }
                                  });
                                },
                              ),
                              // const DataColumn(label: Text("Ministry")),
                              const DataColumn(label: Text("Email")),
                              const DataColumn(label: Text("Role")),
                              const DataColumn(label: Text("Status")),
                              const DataColumn(label: Text("Phone")),
                              const DataColumn(label: Text("Membership")),
                              const DataColumn(label: Text("Actions")),
                            ],
                            rows: List<DataRow>.generate(
                              filteredUsers.length,
                              (index) {
                                final user = filteredUsers[index];
                                return DataRow(
                                  selected: user['selected'],
                                  onSelectChanged: (bool? selected) {
                                    setState(() {
                                      user['selected'] = selected ?? false;
                                    });
                                  },
                                  cells: [
                                    // DataCell(Checkbox(
                                    //   value: user['selected'],
                                    //   onChanged: (bool? selected) {
                                    //     setState(() {
                                    //       user['selected'] = selected ?? false;
                                    //     });
                                    //   },
                                    // )),
                                    // DataCell(Container(
                                    //   height: 40,
                                    //   width: 40,
                                    //   decoration: const BoxDecoration(
                                    //     image: DecorationImage(
                                    //       image: NetworkImage("assets/man.png"),
                                    //       fit: BoxFit.cover,
                                    //     ),
                                    //   ),
                                    // )),
                                    DataCell(Text(user['name'])),
                                    // DataCell(Text(user['ministry'])),
                                    DataCell(Text(user['email'])),
                                    DataCell(Text(user['role'])),
                                    DataCell(GestureDetector(
                                      onTap: () {
                                        user['verif'] != 3
                                            ? updatedata(user['id'])
                                            : null;
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: user['verif'] != 3
                                                  ? Colors.red
                                                  : maincolor),
                                          child: Text(
                                            user['verif'] == 3
                                                ? user['membershipStatus']
                                                : "Not Verified",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )),
                                    )),
                                    DataCell(Text(user['phone'])),
                                    // New DataCell for Member Status (Old/New)
                                    DataCell(Text(user['memberStatus'])),

                                    DataCell(Row(
                                      children: [
                                        Expanded(
                                          child: IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              handleDeleteUser(user['id']);
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () {
                                              setState(() {
                                                isedit = true;
                                                userid = user['id'];
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: IconButton(
                                            icon: const Icon(Icons.visibility),
                                            onPressed: () {
                                              setState(() {
                                                isedit = true;
                                                userid = user['id'];
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    )),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          )
        : useform();
  }

  Widget useform() {
    if (isedit == true) {
      return UserForm(
        isedit: true,
        userid: userid,
      );
    } else {
      return Container();
    }
  }

  Future handleDeleteUser(String id) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(id).delete();
      _showSnackbar("Deleted User");
      fetchUsers();
    } catch (error) {
      debugPrint("Error $error");
      _showSnackbar("Error Deleting User");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

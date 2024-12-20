import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminPledge extends StatefulWidget {
  const AdminPledge({super.key});

  @override
  State<AdminPledge> createState() => _AdminPledgeState();
}

class _AdminPledgeState extends State<AdminPledge> {
  final _amountController = TextEditingController();
  final _pledgeamountController = TextEditingController();
  final _pledgenameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _formkey2 = GlobalKey<FormState>();
  final userAuth = FirebaseAuth.instance;
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredPledges = [];

  DateTime? _selectedDate;
  List<Map<String, dynamic>> pledges = [];

  @override
  void initState() {
    super.initState();
    fetchPledges(); // Fetch pledges when the widget initializes
    _searchController.addListener(_filterPledges);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> addPledges() async {
    try {
      if (_formkey.currentState!.validate()) {
        FirebaseFirestore.instance.collection('addedpledges').add({
          'amount': double.parse(_amountController.text),
          'description': _descriptionController.text,
          'name': _pledgenameController.text,
          'type': "Pledge",
          'created': Timestamp.now(),
        }).then((value) {
          _showSnackbar("Pledge added successfully");
          fetchPledges(); // Refresh the pledge list
        });
      }
    } catch (error) {
      _showSnackbar("Error Adding Pledges, Please Try Again Later");
    }
  }

  Future<void> addPledges2(String id, String name, double pledgetotal) async {
    try {
      if (_formkey2.currentState!.validate()) {
        double pledgeAmount = double.parse(_pledgeamountController.text);
        if (pledgeAmount > pledgetotal) {
          _showSnackbar("Pledge amount exceeds the remaining pledge total.");
          return;
        }

        var totalvalue = pledgetotal - pledgeAmount;

        await FirebaseFirestore.instance
            .collection('listPledges')
            .doc(id)
            .collection('cpledge')
            .add({
          'amount': pledgeAmount, // Storing the amount as double
          'pledgeid': id,
          'pledgename': name,
          'userid': userAuth.currentUser!.uid,
          'type': "Pledge",
          'created': Timestamp.now(),
        });

        _showSnackbar("Pledge added successfully");

        // Update the 'amount' in the 'newPledges' collection to the new total value
        await FirebaseFirestore.instance
            .collection('newPledges')
            .doc(userAuth.currentUser!.uid)
            .collection('pledge')
            .doc(id)
            .update({
          'amount': totalvalue, // Updating the amount to reflect the new total
        });

        // Refresh the UI
        setState(() {
          fetchPledges();
        });
      }
    } catch (error) {
      _showSnackbar("Error Adding Pledges, Please Try Again Later");
    }
  }

  Future<void> fetchPledges() async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('addedpledges').get();

      setState(() {
        pledges = snapshot.docs
            .map((doc) => {
                  'id': doc.id, // Fetch the document ID
                  'amount': doc['amount'], // The amount should be a double
                  'name': doc['name'],
                  'description': doc['description'],
                  'created': doc['created'],
                })
            .toList();
      });
    } catch (error) {
      _showSnackbar("Error fetching pledges.");
    }
  }

  void showPledgeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Pledge"),
          content: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _pledgenameController,
                  decoration: const InputDecoration(labelText: 'Pledge Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a name' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration:
                      const InputDecoration(labelText: 'Pledge Description'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null,
                ),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter an amount' : null,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                addPledges();
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void showPledgeDialog2(String id, String name, double pledgetotal) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Pledge"),
          content: Form(
            key: _formkey2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _pledgeamountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter an amount' : null,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                addPledges2(id, name, pledgetotal);
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
    _pledgeamountController.dispose();
    _pledgenameController.dispose();
    _searchController.dispose();
    _descriptionController.dispose();
  }

  void _filterPledges() {
    String query = _searchController.text.toLowerCase();

    setState(() {
      filteredPledges = pledges.where((pledge) {
        bool matchesSearch = pledge['name'].toLowerCase().contains(query);

        if (_selectedDate != null) {
          bool matchesDate = pledge['created']
                  .isAtSameMomentAs(_selectedDate!) ||
              (pledge['created'].isAfter(_selectedDate!) &&
                  pledge['created']
                      .isBefore(_selectedDate!.add(const Duration(days: 1))));
          return matchesSearch && matchesDate;
        }

        return matchesSearch;
      }).toList();
    });
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _filterPledges();
      });
    }
  }

  void _clearFilter() {
    setState(() {
      _selectedDate = null;
      _searchController.clear();
      filteredPledges = List.from(pledges); // Reset filtered list
    });
  }

  void refresh() {
    setState(() {
      _filterPledges();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.40,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search Pledges',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _selectDate,
                    child: const Text("Filter by Date"),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _clearFilter,
                    icon: const Icon(Icons.clear),
                    tooltip: "Clear Filters",
                  ),
                  IconButton(
                    onPressed: refresh,
                    icon: const Icon(Icons.refresh),
                    tooltip: "refresh",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    onPressed: showPledgeDialog,
                    child: const Text(
                      "Add Pledge",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            pledges.isEmpty
                ? const Text("No Pledges Available")
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2 / 1.9,
                    ),
                    itemCount: filteredPledges.length,
                    itemBuilder: (context, index) {
                      var pledge = filteredPledges[index];
                      var pledgeID = pledge['id']; // Correct access to ID
                      return Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 210,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(8),
                                        image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                'https://images.unsplash.com/photo-1499652848871-1527a310b13a?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'))),
                                  ),
                                  Positioned(
                                      child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: pledge['amount'] != 0
                                            ? Colors.transparent
                                            : Colors.red),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              deletepledge(pledge['id']);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            )),
                                        // Text(
                                        //   pledge['amount'] != 0
                                        //       ? "Ongoing"
                                        //       : "Finished",
                                        //   style: const TextStyle(
                                        //       color: Colors.white),
                                        // ),
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                              Text(
                                pledge['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text("Amount: Php ${pledge['amount']}"),
                              const SizedBox(height: 5),
                              Text("Description: ${pledge['description']}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> deletepledge(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('addedpledges')
          .doc(id)
          .delete();
      setState(() {
        fetchPledges();
      });
    } catch (error) {
      debugPrint("$error");
    }
  }
}

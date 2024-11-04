// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:doane/utils/const.dart';

// class UserPledges extends StatefulWidget {
//   const UserPledges({super.key});

//   @override
//   State<UserPledges> createState() => _UserPledgesState();
// }

// class _UserPledgesState extends State<UserPledges> {
//   final _amountController = TextEditingController();
//   final _numberTimesController = TextEditingController();
//   final _frequencyController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _startDateController = TextEditingController();
//   final _endDateController = TextEditingController();
//   bool isLoading = false;
//   DateTime? _selectedStartDate;
//   DateTime? _selectedEndDate;
//   String? _selectedName;
//   List<String> _membersList = [];
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     _fetchMembers();
//   }

//   Future<void> _fetchMembers() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('role', isEqualTo: 'Member')
//           .get();
//       setState(() {
//         _membersList =
//             querySnapshot.docs.map((doc) => doc['name'] as String).toList();
//         if (_membersList.isNotEmpty) {
//           _selectedName = _membersList[0];
//         }
//       });
//     } catch (e) {
//       debugPrint('Error fetching members: $e');
//     }
//   }

//   Future<void> _selectDate(BuildContext context,
//       TextEditingController controller, bool isStart) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: isStart
//           ? _selectedStartDate ?? DateTime.now()
//           : _selectedEndDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isStart) {
//           _selectedStartDate = picked;
//           controller.text = DateFormat.yMMMd().format(_selectedStartDate!);
//         } else {
//           _selectedEndDate = picked;
//           controller.text = DateFormat.yMMMd().format(_selectedEndDate!);
//         }
//       });
//     }
//   }

//   double _calculateTotalAmount() {
//     double amount = double.tryParse(_amountController.text) ?? 0;
//     int numberOfTimes = int.tryParse(_numberTimesController.text) ?? 0;
//     return amount * numberOfTimes;
//   }

//   Future<void> _submitPledge() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         isLoading = true;
//       });

//       try {
//         await FirebaseFirestore.instance.collection('pledges').add({
//           'name': _selectedName,
//           'amount': _amountController.text,
//           'startDate': _startDateController.text,
//           'endDate': _endDateController.text,
//           'frequency': _frequencyController.text,
//           'numberTimes': _numberTimesController.text,
//           'totalAmount': _calculateTotalAmount().toString(),
//           'description': _descriptionController.text,
//         });
//         _showSnackbar('Pledge submitted successfully!');
//         _clearForm();
//       } catch (e) {
//         _showSnackbar('Error submitting pledge: $e');
//       }

//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void _showSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   void _clearForm() {
//     _amountController.clear();
//     _descriptionController.clear();
//     _startDateController.clear();
//     _endDateController.clear();
//     _frequencyController.clear();
//     _numberTimesController.clear();
//     _selectedStartDate = null;
//     _selectedEndDate = null;
//     _selectedName = _membersList.isNotEmpty ? _membersList[0] : null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Add Pledge',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _membersList.isNotEmpty
//                             ? DropdownButtonFormField<String>(
//                                 value: _selectedName,
//                                 decoration: const InputDecoration(
//                                   labelText: 'Member Name',
//                                   border: OutlineInputBorder(),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                 ),
//                                 items: _membersList
//                                     .map((name) => DropdownMenuItem<String>(
//                                           value: name,
//                                           child: Text(name),
//                                         ))
//                                     .toList(),
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _selectedName = value!;
//                                   });
//                                 },
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please select a name';
//                                   }
//                                   return null;
//                                 },
//                               )
//                             : const Text('Loading members...'),
//                       ),
//                       const SizedBox(
//                         width: 19,
//                       ),
//                       Expanded(
//                         child: TextFormField(
//                           controller: _amountController,
//                           decoration: const InputDecoration(
//                             labelText: 'Amount',
//                             border: OutlineInputBorder(),
//                             filled: true,
//                             fillColor: Colors.white,
//                           ),
//                           keyboardType: TextInputType.number,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter the pledge amount';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _startDateController,
//                     decoration: InputDecoration(
//                       labelText: 'Start Date',
//                       border: const OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Colors.white,
//                       suffixIcon: IconButton(
//                         icon: const Icon(Icons.calendar_today),
//                         onPressed: () {
//                           _selectDate(context, _startDateController, true);
//                         },
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the start date';
//                       }
//                       return null;
//                     },
//                     readOnly: true,
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _endDateController,
//                     decoration: InputDecoration(
//                       labelText: 'End Date',
//                       border: const OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Colors.white,
//                       suffixIcon: IconButton(
//                         icon: const Icon(Icons.calendar_today),
//                         onPressed: () {
//                           _selectDate(context, _endDateController, false);
//                         },
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the end date';
//                       }
//                       return null;
//                     },
//                     readOnly: true,
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _frequencyController,
//                     decoration: const InputDecoration(
//                       labelText: 'Frequency',
//                       border: OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the frequency';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _numberTimesController,
//                     decoration: const InputDecoration(
//                       labelText: 'Number of Times',
//                       border: OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the number of times';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _descriptionController,
//                     decoration: const InputDecoration(
//                       labelText: 'Description',
//                       border: OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the description';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     decoration: const InputDecoration(
//                       labelText: 'Total Amount',
//                       border: OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                     readOnly: true,
//                     controller: TextEditingController(
//                       text: _calculateTotalAmount().toStringAsFixed(2),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   isLoading
//                       ? const Center(child: CircularProgressIndicator())
//                       : ElevatedButton(
//                           onPressed: _submitPledge,
//                           child: const Text('Submit Pledge'),
//                         ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 32),
//             const Text(
//               'Pledge List',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             StreamBuilder<QuerySnapshot>(
//               stream:
//                   FirebaseFirestore.instance.collection('pledges').snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 }
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CircularProgressIndicator();
//                 }

//                 final pledges = snapshot.data!.docs;

//                 return SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.90,
//                   child: DataTable(
//                     border: TableBorder.all(width: 1, color: Colors.black),
//                     headingRowColor: WidgetStateProperty.all(maincolor),
//                     columns: const [
//                       DataColumn(
//                           label: PrimaryFont(
//                         title: 'Name',
//                         color: Colors.white,
//                       )),
//                       DataColumn(
//                           label: PrimaryFont(
//                         title: 'Amount',
//                         color: Colors.white,
//                       )),
//                       DataColumn(
//                           label: PrimaryFont(
//                         title: 'Start Date',
//                         color: Colors.white,
//                       )),
//                       DataColumn(
//                           label: PrimaryFont(
//                         title: 'End Date',
//                         color: Colors.white,
//                       )),
//                       DataColumn(
//                           label: PrimaryFont(
//                         title: 'Frequency',
//                         color: Colors.white,
//                       )),
//                       DataColumn(
//                           label: PrimaryFont(
//                         title: 'Number of Times',
//                         color: Colors.white,
//                       )),
//                       DataColumn(
//                           label: PrimaryFont(
//                         title: 'Total Amount',
//                         color: Colors.white,
//                       )),
//                       DataColumn(
//                           label: PrimaryFont(
//                         title: 'Actions',
//                         color: Colors.white,
//                       )),
//                     ],
//                     rows: pledges.map((pledge) {
//                       return DataRow(cells: [
//                         DataCell(Text(pledge['name'])),
//                         DataCell(Text(pledge['amount'])),
//                         DataCell(Text(pledge['startDate'])),
//                         DataCell(Text(pledge['endDate'])),
//                         DataCell(Text(pledge['frequency'])),
//                         DataCell(Text(pledge['numberTimes'])),
//                         DataCell(Text(pledge['totalAmount'])),
//                         DataCell(
//                           IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed: () {
//                               _deletePledge(pledge.id);
//                             },
//                           ),
//                         ),
//                       ]);
//                     }).toList(),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _deletePledge(String pledgeId) async {
//     try {
//       DocumentSnapshot pledgeDoc = await FirebaseFirestore.instance
//           .collection('pledges')
//           .doc(pledgeId)
//           .get();

//       if (pledgeDoc.exists) {
//         Map<String, dynamic> pledgeData =
//             pledgeDoc.data() as Map<String, dynamic>;

//         pledgeData['type'] = 'pledge';

//         await FirebaseFirestore.instance.collection('archive').add(pledgeData);
//         await FirebaseFirestore.instance
//             .collection('pledges')
//             .doc(pledgeId)
//             .delete();

//         _showSnackbar('Pledge deleted and archived successfully!');
//       } else {
//         _showSnackbar('Pledge not found!');
//       }
//     } catch (e) {
//       _showSnackbar('Error deleting and archiving pledge: $e');
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPledges extends StatefulWidget {
  const UserPledges({super.key});

  @override
  State<UserPledges> createState() => _UserPledgesState();
}

class _UserPledgesState extends State<UserPledges> {
  final _amountController = TextEditingController();
  final _pledgeamountController = TextEditingController();
  final _pledgenameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _formkey2 = GlobalKey<FormState>();
  final userAuth = FirebaseAuth.instance;

  List<Map<String, dynamic>> pledges = [];

  @override
  void initState() {
    super.initState();
    fetchPledges(); // Fetch pledges when the widget initializes
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> addPledges() async {
    try {
      if (_formkey.currentState!.validate()) {
        FirebaseFirestore.instance
            .collection('newPledges')
            .doc(userAuth.currentUser!.uid)
            .collection('pledge')
            .add({
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

  Future<void> addPledges2(
    String id,
    String name,
    double pledgetotal,
  ) async {
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
          'amount': pledgeAmount,
          'pledgeid': id,
          'pledgename': name,
          'userid': userAuth.currentUser!.uid,
          'type': "Pledge",
          'created': Timestamp.now(),
        });

        _showSnackbar("Pledge added successfully");

        // Update the amount in the 'newPledges' collection, setting amount to zero if necessary
        await FirebaseFirestore.instance
            .collection('newPledges')
            .doc(userAuth.currentUser!.uid)
            .collection('pledge')
            .doc(id)
            .set({
          'pledgename': name,
          'amount': totalvalue,
        }, SetOptions(merge: true));

        // Refresh the UI after the update is complete
        await fetchPledges();
        setState(() {});
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

  void showPledgeDialog2(
    String id,
    String name,
    double pledgetotal,
  ) {
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
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
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
                      childAspectRatio: 2 / 2.5,
                    ),
                    itemCount: pledges.length,
                    itemBuilder: (context, index) {
                      var pledge = pledges[index];
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
                                            ? maincolor
                                            : Colors.red),
                                    child: Text(
                                      pledge['amount'] != 0
                                          ? "Pledges"
                                          : "Finished",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  )),
                                  Positioned(
                                      left: 0,
                                      bottom: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        height: 90,
                                        width: 150,
                                        color: const Color.fromARGB(
                                            137, 105, 105, 105),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              pledge['name'],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                                "Amount: Php ${pledge['amount']}"),
                                            const SizedBox(height: 5),
                                            Text(
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                                "Description: ${pledge['description']}"),
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('newPledges')
                                      .doc(userAuth.currentUser!.uid)
                                      .collection('pledge')
                                      .doc(pledge['id'])
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData ||
                                        snapshot.data?.data() == null) {
                                      return Container();
                                    } else if (snapshot.hasError) {
                                      return Container();
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text("Updating...");
                                    } else {
                                      var datasnapshot = snapshot.data!.data();
                                      return Text(
                                          "Remaining Pledge: Php ${datasnapshot!['amount']}");
                                    }
                                  }),
                              const SizedBox(
                                height: 20,
                              ),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('newPledges')
                                      .doc(userAuth.currentUser!.uid)
                                      .collection('pledge')
                                      .doc(pledge['id'])
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container();
                                    } else if (snapshot.hasError ||
                                        snapshot.data?.data() == null) {
                                      return SizedBox(
                                        height: 28,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                            ),
                                          ),
                                          onPressed: () {
                                            double amount = 0.0;

                                            if (pledge['amount'] is int) {
                                              amount = (pledge['amount'] as int)
                                                  .toDouble();
                                            } else if (pledge['amount']
                                                is double) {
                                              amount = pledge['amount'];
                                            } else if (pledge['amount']
                                                is String) {
                                              amount = double.tryParse(
                                                      pledge['amount']) ??
                                                  0.0;
                                            }

                                            showPledgeDialog2(pledgeID,
                                                pledge['name'], amount);
                                          },
                                          child: const Text(
                                            "Add",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container();
                                    } else {
                                      var datasnapshot = snapshot.data!.data();
                                      return datasnapshot!['amount'] == 0
                                          ? Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Colors.red),
                                              child: const Text(
                                                "Finished",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : SizedBox(
                                              height: 28,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            9),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  double amount = 0.0;

                                                  if (pledge['amount'] is int) {
                                                    amount = (pledge['amount']
                                                            as int)
                                                        .toDouble();
                                                  } else if (pledge['amount']
                                                      is double) {
                                                    amount = pledge['amount'];
                                                  } else if (pledge['amount']
                                                      is String) {
                                                    amount = double.tryParse(
                                                            pledge['amount']) ??
                                                        0.0;
                                                  }

                                                  if (datasnapshot['amount'] !=
                                                      null) {
                                                    double amount2 = 0.0;
                                                    if (datasnapshot['amount']
                                                        is int) {
                                                      amount2 = (datasnapshot[
                                                              'amount'] as int)
                                                          .toDouble();
                                                    } else if (datasnapshot[
                                                        'amount'] is double) {
                                                      amount2 = datasnapshot[
                                                          'amount'];
                                                    } else if (datasnapshot[
                                                        'amount'] is String) {
                                                      amount2 = double.tryParse(
                                                              datasnapshot[
                                                                  'amount']) ??
                                                          0.0;
                                                    }
                                                    showPledgeDialog2(
                                                        pledgeID,
                                                        pledge['name'],
                                                        amount2);
                                                  } else {
                                                    showPledgeDialog2(pledgeID,
                                                        pledge['name'], amount);
                                                  }
                                                },
                                                child: const Text(
                                                  "Add",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            );
                                    }
                                  }),
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
}

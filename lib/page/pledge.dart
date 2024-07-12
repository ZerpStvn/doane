import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doane/utils/const.dart';

class PledgesPage extends StatefulWidget {
  const PledgesPage({super.key});

  @override
  State<PledgesPage> createState() => _PledgesPageState();
}

class _PledgesPageState extends State<PledgesPage> {
  final _amountController = TextEditingController();
  final _numberTimesController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  bool isLoading = false;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  String? _selectedName;
  List<String> _membersList = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Member')
          .get();
      setState(() {
        _membersList =
            querySnapshot.docs.map((doc) => doc['name'] as String).toList();
        // Ensure uniqueness of members' names
        _membersList = _membersList.toSet().toList();
        if (_membersList.isNotEmpty) {
          _selectedName = _membersList[0];
        }
      });
    } catch (e) {
      debugPrint('Error fetching members: $e');
    }
  }

  Future<void> _selectDate(BuildContext context,
      TextEditingController controller, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? _selectedStartDate ?? DateTime.now()
          : _selectedEndDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _selectedStartDate = picked;
          controller.text = DateFormat.yMMMd().format(_selectedStartDate!);
        } else {
          _selectedEndDate = picked;
          controller.text = DateFormat.yMMMd().format(_selectedEndDate!);
        }
      });
    }
  }

  double _calculateTotalAmount() {
    double amount = double.tryParse(_amountController.text) ?? 0;
    int numberOfTimes = int.tryParse(_numberTimesController.text) ?? 0;
    return amount * numberOfTimes;
  }

  Future<void> _submitPledge() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        await FirebaseFirestore.instance.collection('pledges').add({
          'name': _selectedName,
          'amount': _amountController.text,
          'startDate': _startDateController.text,
          'endDate': _endDateController.text,
          'frequency': _frequencyController.text,
          'numberTimes': _numberTimesController.text,
          'totalAmount': _calculateTotalAmount().toString(),
          'description': _descriptionController.text,
        });
        _showSnackbar('Pledge submitted successfully!');
        _clearForm();
      } catch (e) {
        _showSnackbar('Error submitting pledge: $e');
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _clearForm() {
    _amountController.clear();
    _descriptionController.clear();
    _startDateController.clear();
    _endDateController.clear();
    _frequencyController.clear();
    _numberTimesController.clear();
    _selectedStartDate = null;
    _selectedEndDate = null;
    _selectedName = _membersList.isNotEmpty ? _membersList[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Pledge',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _membersList.isNotEmpty
                            ? DropdownButtonFormField<String>(
                                value: _selectedName,
                                decoration: const InputDecoration(
                                  labelText: 'Member Name',
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                items: _membersList
                                    .map((name) => DropdownMenuItem<String>(
                                          value: name,
                                          child: Text(name),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedName = value!;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a name';
                                  }
                                  return null;
                                },
                              )
                            : const Text('Loading members...'),
                      ),
                      const SizedBox(
                        width: 19,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the pledge amount';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _startDateController,
                    decoration: InputDecoration(
                      labelText: 'Start Date',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          _selectDate(context, _startDateController, true);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the start date';
                      }
                      return null;
                    },
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _endDateController,
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          _selectDate(context, _endDateController, false);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the end date';
                      }
                      return null;
                    },
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _frequencyController,
                    decoration: const InputDecoration(
                      labelText: 'Frequency',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the frequency';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _numberTimesController,
                    decoration: const InputDecoration(
                      labelText: 'Number of Times',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the number of times';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Total Amount',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    readOnly: true,
                    controller: TextEditingController(
                      text: _calculateTotalAmount().toStringAsFixed(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _submitPledge,
                          child: const Text('Submit Pledge'),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Pledge List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('pledges').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final pledges = snapshot.data!.docs;

                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: DataTable(
                    //border: TableBorder.all(width: 1, color: Colors.black),
                    headingRowColor: MaterialStateProperty.all(maincolor),
                    columns: const [
                      DataColumn(
                          label: PrimaryFont(
                        title: 'Name',
                        color: Colors.white,
                      )),
                      DataColumn(
                          label: PrimaryFont(
                        title: 'Amount',
                        color: Colors.white,
                      )),
                      DataColumn(
                          label: PrimaryFont(
                        title: 'Start Date',
                        color: Colors.white,
                      )),
                      DataColumn(
                          label: PrimaryFont(
                        title: 'End Date',
                        color: Colors.white,
                      )),
                      DataColumn(
                          label: PrimaryFont(
                        title: 'Frequency',
                        color: Colors.white,
                      )),
                      DataColumn(
                          label: PrimaryFont(
                        title: 'Number of Times',
                        color: Colors.white,
                      )),
                      DataColumn(
                          label: PrimaryFont(
                        title: 'Total Amount',
                        color: Colors.white,
                      )),
                      DataColumn(
                          label: PrimaryFont(
                        title: 'Actions',
                        color: Colors.white,
                      )),
                    ],
                    rows: pledges.map((pledge) {
                      return DataRow(cells: [
                        DataCell(Text(pledge['name'])),
                        DataCell(Text(pledge['amount'])),
                        DataCell(Text(pledge['startDate'])),
                        DataCell(Text(pledge['endDate'])),
                        DataCell(Text(pledge['frequency'])),
                        DataCell(Text(pledge['numberTimes'])),
                        DataCell(Text(pledge['totalAmount'])),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deletePledge(pledge.id);
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
      ),
    );
  }

  Future<void> _deletePledge(String pledgeId) async {
    try {
      await FirebaseFirestore.instance
          .collection('pledges')
          .doc(pledgeId)
          .delete();
      _showSnackbar('Pledge deleted successfully!');
    } catch (e) {
      _showSnackbar('Error deleting pledge: $e');
    }
  }
}

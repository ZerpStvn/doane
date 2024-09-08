import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:doane/utils/const.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  Map<String, double> userPledgeTotals = {}; // Store each user's total pledge
  double overallTotal = 0.0; // Store the overall total of all pledges
  bool isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    _calculateTotals(); // Calculate the totals on page load
  }

  // Function to calculate the total pledges for each user and the overall total
  Future<void> _calculateTotals() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot pledgesSnapshot =
          await FirebaseFirestore.instance.collection('pledges').get();

      Map<String, double> totals = {};
      double overall = 0.0;

      for (var doc in pledgesSnapshot.docs) {
        var pledgeData = doc.data() as Map<String, dynamic>;
        String userName = pledgeData['name'];
        double pledgeAmount = double.tryParse(pledgeData['totalAmount']) ?? 0.0;

        // Add pledge amount to the user's total
        if (totals.containsKey(userName)) {
          totals[userName] = totals[userName]! + pledgeAmount;
        } else {
          totals[userName] = pledgeAmount;
        }

        // Add to overall total
        overall += pledgeAmount;
      }

      setState(() {
        userPledgeTotals = totals;
        overallTotal = overall;
        isLoading = false;
      });
    } catch (e) {
      _showSnackbar('Error calculating totals: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to show a snackbar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Function to delete pledge
  Future<void> _deletePledge(String pledgeId) async {
    try {
      DocumentSnapshot pledgeDoc = await FirebaseFirestore.instance
          .collection('pledges')
          .doc(pledgeId)
          .get();

      if (pledgeDoc.exists) {
        Map<String, dynamic> pledgeData =
            pledgeDoc.data() as Map<String, dynamic>;

        pledgeData['type'] = 'pledge';

        await FirebaseFirestore.instance.collection('archive').add(pledgeData);
        await FirebaseFirestore.instance
            .collection('pledges')
            .doc(pledgeId)
            .delete();

        _showSnackbar('Pledge deleted and archived successfully!');
      } else {
        _showSnackbar('Pledge not found!');
      }
    } catch (e) {
      _showSnackbar('Error deleting and archiving pledge: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Finance Overview',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Display overall total
          Row(
            children: [
              const Text(
                'Overall Total Pledged: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '\Php ${overallTotal.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const SizedBox(height: 32),

          // Detailed table of all pledges
          const Text(
            'Pledge Details',
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
                return const Center(child: CircularProgressIndicator());
              }

              final pledges = snapshot.data!.docs;

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DataTable(
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
                          icon: const Icon(Icons.delete, color: Colors.red),
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
    );
  }
}

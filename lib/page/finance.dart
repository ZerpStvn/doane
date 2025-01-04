import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:doane/utils/const.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  Map<String, double> userPledgeTotals = {}; // Store each user's total pledge
  double overallTotal = 0.0; // Store the overall total of all pledges
  bool isLoading = false; // Loading state
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _numberTimesController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _amountController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _frequencyController.dispose();
    _numberTimesController.dispose();
    _totalAmountController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _calculateTotals(); // Calculate the totals on page load
  }

  Future<void> _calculateTotals() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot pledgesSnapshot =
          await FirebaseFirestore.instance.collection('finance').get();

      Map<String, double> totals = {};
      double overall = 0.0;

      for (var doc in pledgesSnapshot.docs) {
        var pledgeData = doc.data() as Map<String, dynamic>;
        String userName = pledgeData['name'];
        double pledgeAmount = double.tryParse(pledgeData['totalAmount']) ?? 0.0;

        if (totals.containsKey(userName)) {
          totals[userName] = totals[userName]! + pledgeAmount;
        } else {
          totals[userName] = pledgeAmount;
        }

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

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _deletePledge(String pledgeId) async {
    try {
      DocumentSnapshot pledgeDoc = await FirebaseFirestore.instance
          .collection('pledges')
          .doc(pledgeId)
          .get();

      if (pledgeDoc.exists) {
        Map<String, dynamic> pledgeData =
            pledgeDoc.data() as Map<String, dynamic>;

        pledgeData['type'] = 'finance';

        await FirebaseFirestore.instance.collection('archive').add(pledgeData);
        await FirebaseFirestore.instance
            .collection('pledges')
            .doc(pledgeId)
            .delete();

        _showSnackbar('Finance deleted and archived successfully!');
      } else {
        _showSnackbar('Finance not found!');
      }
    } catch (e) {
      _showSnackbar('Error deleting and archiving pledge: $e');
    }
  }

  // Function to generate PDF report
  // Function to generate PDF report
  Future<void> _generatePDFReport() async {
    final pdf = pw.Document();

    // Fetch the pledge data from Firestore
    QuerySnapshot pledgesSnapshot =
        await FirebaseFirestore.instance.collection('finance').get();

    // Create PDF content
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Finance Overview',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text(
                  'Overall Total Pledged: Php ${overallTotal.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 24),
              pw.Text('Finance Details',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),

              // Table of all pledge details
              // ignore: deprecated_member_use
              pw.Table.fromTextArray(
                context: context,
                headers: [
                  'Name',
                  'Amount',
                  'Start Date',
                  'End Date',
                  'Frequency',
                  'Number of Times',
                  'Total Amount',
                ],
                data: pledgesSnapshot.docs.map((doc) {
                  var pledgeData = doc.data() as Map<String, dynamic>;
                  return [
                    pledgeData['name'] ?? 'N/A',
                    pledgeData['amount'] ?? 'N/A',
                    pledgeData['startDate'] ?? 'N/A',
                    pledgeData['endDate'] ?? 'N/A',
                    pledgeData['frequency'] ?? 'N/A',
                    pledgeData['numberTimes'] ?? 'N/A',
                    pledgeData['totalAmount'] ?? 'N/A',
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    // Trigger the download in the browser
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: _showAddPledgeDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add New Finance'),
          ),

          const SizedBox(height: 32),

          const Text(
            'Finance Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Finance Overview',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Overall Total Finances: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Php ${overallTotal.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SizedBox(height: 32),
          const Text(
            'Finance Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('finance').snapshots(),
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
                  headingRowColor: WidgetStateProperty.all(maincolor),
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
          const SizedBox(height: 24),

          // Button to generate PDF report
          ElevatedButton.icon(
            onPressed: _generatePDFReport,
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('Download Report as PDF'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddPledgeDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Finance"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField("Name", _nameController),
                _buildTextField("Amount", _amountController),
                _buildTextField("Start Date", _startDateController),
                _buildTextField("End Date", _endDateController),
                _buildTextField("Frequency", _frequencyController),
                _buildTextField("Number of Times", _numberTimesController),
                _buildTextField("Total Amount", _totalAmountController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: _addPledge,
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

// Helper function to build a TextField
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: label == "Amount" ||
              label == "Total Amount" ||
              label == "Number of Times"
          ? TextInputType.number
          : TextInputType.text,
    );
  }

// Function to add a new pledge to Firestore
  Future<void> _addPledge() async {
    try {
      // Get values from controllers
      String name = _nameController.text.trim();
      String amount = _amountController.text.trim();
      String startDate = _startDateController.text.trim();
      String endDate = _endDateController.text.trim();
      String frequency = _frequencyController.text.trim();
      String numberTimes = _numberTimesController.text.trim();
      String totalAmount = _totalAmountController.text.trim();

      // Validate required fields
      if (name.isEmpty || amount.isEmpty || totalAmount.isEmpty) {
        _showSnackbar("Please fill in the required fields.");
        return;
      }

      // Save the pledge data to Firestore
      await FirebaseFirestore.instance.collection('finance').add({
        'name': name,
        'amount': amount,
        'startDate': startDate,
        'endDate': endDate,
        'frequency': frequency,
        'numberTimes': numberTimes,
        'totalAmount': totalAmount,
      });

      // Clear controllers and close the dialog
      _clearControllers();
      Navigator.of(context).pop();

      _showSnackbar("Pledge added successfully!");
    } catch (e) {
      _showSnackbar("Error adding pledge: $e");
    }
  }

// Clear all controllers
  void _clearControllers() {
    _nameController.clear();
    _amountController.clear();
    _startDateController.clear();
    _endDateController.clear();
    _frequencyController.clear();
    _numberTimesController.clear();
    _totalAmountController.clear();
  }
}

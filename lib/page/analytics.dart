import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/controller/widget/buttoncall.dart';
import 'package:doane/utils/const.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class VisualAnalytics extends StatefulWidget {
  final String eventID;
  const VisualAnalytics({super.key, required this.eventID});

  @override
  State<VisualAnalytics> createState() => _VisualAnalyticsState();
}

class _VisualAnalyticsState extends State<VisualAnalytics> {
  int totalMembers = 0;
  int totalNonMembers = 0;
  final int requiredAttendees = 230;

  @override
  void initState() {
    super.initState();
    _fetchAttendeesData();
    _fetchAttendeesData2();
  }

  Future<void> _fetchAttendeesData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('newAttendance')
          .doc(widget.eventID)
          .collection('attendee')
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          totalMembers = 0;
          totalNonMembers = 0;
        });
        return;
      }

      int members = 0;
      int nonMembers = 0;

      for (var doc in snapshot.docs) {
        final userId = doc.data()['userId'] ?? 'notmember';
        if (userId == 'notmember') {
          nonMembers++;
        } else {
          members++;
        }
      }

      setState(() {
        totalMembers = members;
        totalNonMembers = nonMembers;
      });
    } catch (e) {
      print('Error fetching attendees: $e');
    }
  }

  List<Map<String, dynamic>> attendeesData2 = [];
  Future<void> _fetchAttendeesData2() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('newAttendance')
          .doc(widget.eventID)
          .collection('attendee')
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          attendeesData2 = [];
        });
        return;
      }

      List<Map<String, dynamic>> fetchedData = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        fetchedData.add({
          'userName': data['userName'] ?? 'N/A',
          'email': data['email'] ?? 'N/A',
          'eventName': data['eventname'] ?? 'N/A',
          'attendedAt': data['attendedAt'] ?? 'N/A',
          'phone': data['phone'] ?? 'N/A',
        });
      }

      setState(() {
        attendeesData2 = fetchedData;
      });
    } catch (e) {
      print('Error fetching attendees: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalAttendees = totalMembers + totalNonMembers;

    final pieSectionsAttendees = [
      PieChartSectionData(
        value: totalMembers.toDouble(),
        color: Colors.green,
        title: 'Members: $totalMembers',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: totalNonMembers.toDouble(),
        color: Colors.red,
        title: 'Non-Members: $totalNonMembers',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ];

    final remainingAttendees = (requiredAttendees - totalAttendees)
        .clamp(0, requiredAttendees)
        .toDouble();
    final pieSectionsRequired = [
      PieChartSectionData(
        value: totalAttendees.toDouble(),
        color: Colors.blue,
        title: 'Pre-Registered: $totalAttendees',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: remainingAttendees,
        color: Colors.orange,
        title: 'Remaining: ${remainingAttendees.toInt()}',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Attendance Analytics"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Attendance Analytics",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: PieChart(
                          PieChartData(
                            sections: pieSectionsAttendees,
                            centerSpaceRadius: 80,
                            sectionsSpace: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const LegendItem(color: Colors.green, text: 'Members'),
                      const LegendItem(color: Colors.red, text: 'Non-Members'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: PieChart(
                          PieChartData(
                            sections: pieSectionsRequired,
                            centerSpaceRadius: 80,
                            sectionsSpace: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const LegendItem(
                          color: Colors.blue, text: 'Pre-Registered'),
                      const LegendItem(color: Colors.orange, text: 'Remaining'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            attendeesData2.isEmpty
                ? Container()
                : ButtonCallback(
                    bgcolor: maincolor,
                    fcolor: Colors.white,
                    function: () {
                      _generatePdfAndPrint(context);
                    },
                    title: "Print Attendance"),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: attendeesData2.isEmpty
                  ? const Center(child: Text('No attendees data available'))
                  : SingleChildScrollView(
                      child: DataTable(
                        headingRowColor:
                            const WidgetStatePropertyAll(maincolor),
                        headingTextStyle: const TextStyle(color: Colors.white),
                        columns: const [
                          DataColumn(label: Text('User Name')),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Event Name')),
                          DataColumn(label: Text('Phone')),
                        ],
                        rows: attendeesData2.map((attendee) {
                          return DataRow(cells: [
                            DataCell(Text(attendee['userName'])),
                            DataCell(Text(attendee['email'])),
                            DataCell(Text(attendee['eventName'])),
                            DataCell(Text(attendee['phone'])),
                          ]);
                        }).toList(),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  void _generatePdfAndPrint(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                'Pre-Registered Data',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text('User Name',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text('Email',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text('Event Name',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text('Phone',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text('Remarks',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                    ],
                  ),
                  // Table Rows
                  ...attendeesData2.map(
                    (attendee) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(attendee['userName'] ?? ''),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(attendee['email'] ?? ''),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(attendee['eventName'] ?? ''),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(attendee['phone'] ?? ''),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(''),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    // Print the PDF
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(text),
        const SizedBox(width: 16),
      ],
    );
  }
}

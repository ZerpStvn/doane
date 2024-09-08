import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/controller/widget/buttoncall.dart';
import 'package:doane/utils/const.dart';
import 'package:flutter/material.dart';

class MinistryListCont extends StatefulWidget {
  const MinistryListCont({super.key});

  @override
  State<MinistryListCont> createState() => _MinistryListContState();
}

class _MinistryListContState extends State<MinistryListCont> {
  final TextEditingController _ministryname = TextEditingController();
  bool isloading = false;
  List<Map<String, dynamic>> ministry = [];

  @override
  void dispose() {
    _ministryname.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    handlegetministry();
  }

  Future handlegetministry() async {
    try {
      QuerySnapshot ministryget =
          await FirebaseFirestore.instance.collection('ministry').get();

      if (ministryget.docs.isNotEmpty) {
        List<Map<String, dynamic>> fetchedMinistries = [];
        for (var doc in ministryget.docs) {
          fetchedMinistries.add({
            ...doc.data() as Map<String, dynamic>,
            'id': doc.id, // Store the document ID for deletion
          });
        }

        setState(() {
          ministry = fetchedMinistries;
        });
      }
    } catch (error) {
      debugPrint("Error $error");
    }
  }

  Future handleadd() async {
    setState(() {
      isloading = true;
    });
    try {
      FirebaseFirestore.instance
          .collection('ministry')
          .add({"name": _ministryname.text});
      setState(() {
        isloading = false;
      });
      _showSnackbar("Added Ministry ");
      handlegetministry();
    } catch (error) {
      debugPrint("Error $error");
      setState(() {
        isloading = false;
      });
      _showSnackbar("Error Adding Ministry ");
    }
  }

  Future handledelete(String id) async {
    try {
      DocumentSnapshot ministryDoc =
          await FirebaseFirestore.instance.collection('ministry').doc(id).get();

      if (ministryDoc.exists) {
        Map<String, dynamic> ministryData =
            ministryDoc.data() as Map<String, dynamic>;

        ministryData['type'] = 'ministry';

        await FirebaseFirestore.instance
            .collection('archive')
            .add(ministryData);

        await FirebaseFirestore.instance
            .collection('ministry')
            .doc(id)
            .delete();

        _showSnackbar("Deleted and Archived Ministry");
        handlegetministry();
      } else {
        _showSnackbar("Ministry not found");
      }
    } catch (error) {
      debugPrint("Error $error");
      _showSnackbar("Error Deleting Ministry");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 210,
            child: TextFormField(
              controller: _ministryname,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name';
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: 'Ministry Name', border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          isloading == false
              ? SizedBox(
                  height: 40,
                  child: ButtonCallback(
                      fcolor: Colors.white,
                      bgcolor: maincolor,
                      function: () {
                        handleadd();
                      },
                      title: "ADD MINISTRY"),
                )
              : const CircularProgressIndicator(),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DataTable(
                showCheckboxColumn: true,
                headingRowColor: const MaterialStatePropertyAll(maincolor),
                headingRowHeight: 30,
                border: TableBorder.all(width: 0.10, color: Colors.black),
                headingTextStyle: const TextStyle(color: Colors.white),
                columns: const [
                  DataColumn(
                      label: PrimaryFont(
                    title: "Index",
                    color: Colors.white,
                  )),
                  DataColumn(
                      label: PrimaryFont(
                    title: "Icon",
                    color: Colors.white,
                  )),
                  DataColumn(
                      label: PrimaryFont(
                    title: "Name",
                    color: Colors.white,
                  )),
                  DataColumn(
                      label: PrimaryFont(
                    title: "Actions",
                    color: Colors.white,
                  )),
                ],
                rows: List<DataRow>.generate(
                  ministry.length,
                  (index) => DataRow(
                    cells: [
                      DataCell(Text('${index + 1}')),
                      DataCell(Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage("assets/church.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )),
                      DataCell(Text(ministry[index]['name'] ?? '')),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              handledelete(ministry[index]['id']);
                            },
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/controller/globalbutton.dart';
import 'package:doane/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final _titleController = TextEditingController();
  final _venueController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _othersController = TextEditingController();
  bool isLoading = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  Uint8List? _imageData;
  String? _imageName;
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat.yMMMd().format(_selectedDate!);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = _selectedTime!.format(context);
      });
    }
  }

  Future<void> _pickImage() async {
    final imageInfo = await ImagePickerWeb.getImageInfo();

    if (imageInfo != null && imageInfo.data != null) {
      setState(() {
        _imageData = imageInfo.data;
        _imageName = imageInfo.fileName;
      });
    }
  }

  Future<void> _submitAnnouncement() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      String? imageUrl;
      if (_imageData != null && _imageName != null) {
        imageUrl = await _uploadImageToFirebase(_imageData!, _imageName!);
      }

      try {
        await FirebaseFirestore.instance.collection('events').add({
          'title': _titleController.text,
          'venue': _venueController.text,
          'date': _dateController.text,
          'time': _timeController.text,
          'image': imageUrl ?? "",
          'others': _othersController.text,
        });
        _showSnackbar('events submitted successfully!');
        _clearForm();
      } catch (e) {
        _showSnackbar('Error submitting events: $e');
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String?> _uploadImageToFirebase(
      Uint8List imageData, String imageName) async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_$imageName';
      Reference storageReference =
          FirebaseStorage.instance.ref().child('events/$fileName');
      SettableMetadata metadata = SettableMetadata(contentType: 'image/png');
      UploadTask uploadTask = storageReference.putData(imageData, metadata);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      _showSnackbar('Error uploading image: $e');
      return null;
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _clearForm() {
    _titleController.clear();
    _venueController.clear();
    _dateController.clear();
    _timeController.clear();
    _othersController.clear();
    _imageData = null;
    _imageName = null;
    _selectedDate = null;
    _selectedTime = null;
  }

  String? userrole;
  User? currentuser = FirebaseAuth.instance.currentUser;
  Future<void> getuserData() async {
    try {
      DocumentSnapshot userobjects = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentuser!.uid)
          .get();

      if (userobjects.exists) {
        setState(() {
          var usersobjectfetch = userobjects.data() as Map<String, dynamic>;

          final String userrolefetched = usersobjectfetch['role'].toString();
          debugPrint("User Data: $usersobjectfetch");

          switch (userrolefetched) {
            case "0":
              userrole = "admin";
              debugPrint("User Role: $userrole");
              break;
            case "Member":
              userrole = "member";
              break;
            case "Staff":
              userrole = "staff";
              break;
            case "Volunteer":
              userrole = "volunteer";
              break;
            default:
              userrole = "admin";
              break;
          }
        });
      }
    } catch (error) {
      debugPrint("$error");
    }
  }

  @override
  void initState() {
    super.initState();
    getuserData();
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
                    'Add Events',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the events title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _venueController,
                    decoration: const InputDecoration(
                      labelText: 'Venue',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the venue';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          _selectDate(context);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the date';
                      }
                      return null;
                    },
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _timeController,
                    decoration: InputDecoration(
                      labelText: 'Time',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () {
                          _selectTime(context);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the time';
                      }
                      return null;
                    },
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: TextEditingController(
                            text: _imageName ?? '',
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Image',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          readOnly: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an image';
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.image),
                        onPressed: _pickImage,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _othersController,
                    decoration: const InputDecoration(
                      labelText: 'Others',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GlobalButton(
                          oncallback: () {
                            _submitAnnouncement();
                          },
                          title: "Submit Events"),
                  // ElevatedButton(
                  //   onPressed: _submitAnnouncement,
                  //   child: const Text('Submit Events'),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Events List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('events').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final announcements = snapshot.data!.docs;

                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: DataTable(
                    //border: TableBorder.all(width: 1, color: Colors.black),
                    headingRowColor: WidgetStateProperty.all(maincolor),
                    columns: const [
                      DataColumn(
                          label: Text('Title',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Venue',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Date',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Time',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Image',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Others',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Actions',
                              style: TextStyle(color: Colors.white))),
                    ],
                    rows: announcements.map((announcement) {
                      debugPrint("${announcement['image']}");
                      return DataRow(cells: [
                        DataCell(
                            PrimaryFont(title: "${announcement['title']}")),
                        DataCell(
                            PrimaryFont(title: "${announcement['venue']}")),
                        DataCell(PrimaryFont(title: "${announcement['date']}")),
                        DataCell(PrimaryFont(title: "${announcement['time']}")),
                        announcement['image'] == null
                            ? const DataCell(Text("No Image"))
                            : DataCell(Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(announcement['image']),
                                  ),
                                ),
                              )),
                        DataCell(Text(announcement['others'])),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteAnnouncement(announcement.id);
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

  Future<void> _deleteAnnouncement(String announcementId) async {
    try {
      DocumentSnapshot eventDoc = await FirebaseFirestore.instance
          .collection('events')
          .doc(announcementId)
          .get();

      if (eventDoc.exists) {
        Map<String, dynamic> eventData =
            eventDoc.data() as Map<String, dynamic>;
        eventData['type'] = 'event';
        await FirebaseFirestore.instance.collection('archive').add(eventData);
        await FirebaseFirestore.instance
            .collection('events')
            .doc(announcementId)
            .delete();

        _showSnackbar('Event deleted and archived successfully!');
      } else {
        _showSnackbar('Event not found!');
      }
    } catch (e) {
      _showSnackbar('Error deleting and archiving event: $e');
    }
  }
}

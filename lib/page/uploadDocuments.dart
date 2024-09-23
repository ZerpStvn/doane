// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html; // For downloading files on web
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/utils/const.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FileUploadPage extends StatefulWidget {
  const FileUploadPage({super.key});

  @override
  State<FileUploadPage> createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  bool isLoading = false;

  // Function to upload file
  Future<void> _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;
      setState(() {
        isLoading = true;
      });

      try {
        // Extract file type (extension)
        String fileType = file.extension ?? 'Unknown';

        // Upload to Firebase Storage
        String fileName = file.name;
        String filePath = 'uploads/$fileName';
        Reference storageReference =
            FirebaseStorage.instance.ref().child(filePath);

        UploadTask uploadTask = storageReference.putData(file.bytes!);

        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Save file info to Firestore
        await FirebaseFirestore.instance.collection('files').add({
          'name': fileName,
          'url': downloadUrl,
          'type': fileType, // Store the file type
          'uploadedAt': DateFormat.yMMMd().format(DateTime.now()),
        });

        _showSnackbar('File uploaded successfully!');
      } catch (e) {
        _showSnackbar('Error uploading file: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Function to download file
  void _downloadFile(String url) {
    // ignore: unused_local_variable
    html.AnchorElement anchorElement = html.AnchorElement(href: url)
      ..setAttribute('download', '')
      ..click();
  }

  // Function to archive and delete file
  Future<void> _deleteAndArchiveFile(String fileId, String fileName,
      String fileUrl, String fileType, String uploadedAt) async {
    try {
      // Archive the file metadata to the 'archive' collection
      await FirebaseFirestore.instance.collection('archive').add({
        'name': fileName,
        'url': fileUrl,
        'type': fileType,
        'uploadedAt': uploadedAt,
        'deletedAt':
            DateFormat.yMMMd().format(DateTime.now()), // Add the deletion time
      });

      // Delete the file from Firebase Storage
      Reference storageReference = FirebaseStorage.instance.refFromURL(fileUrl);
      await storageReference.delete();

      // Delete the file metadata from Firestore (from 'files' collection)
      await FirebaseFirestore.instance.collection('files').doc(fileId).delete();

      _showSnackbar('File archived and deleted successfully!');
    } catch (e) {
      _showSnackbar('Error deleting file: $e');
    }
  }

  // Function to display Snackbar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: maincolor,
                        shape: const RoundedRectangleBorder()),
                    onPressed: _uploadFile,
                    child: const Text(
                      'Upload File',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('files').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final files = snapshot.data!.docs;

                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(Colors.blueGrey),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'File Name',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'File Type',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Uploaded At',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Actions',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    rows: files.map((file) {
                      String fileId = file.id; // The document ID in Firestore
                      String fileName = file['name'];
                      String fileUrl = file['url'];
                      String fileType = file['type'] ?? 'Unknown File Type';
                      String uploadedAt = file['uploadedAt'];

                      return DataRow(cells: [
                        DataCell(Text(fileName)),
                        DataCell(Text(fileType)),
                        DataCell(Text(uploadedAt)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.download),
                                onPressed: () {
                                  _downloadFile(fileUrl);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteAndArchiveFile(fileId, fileName,
                                      fileUrl, fileType, uploadedAt);
                                },
                              ),
                            ],
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
}

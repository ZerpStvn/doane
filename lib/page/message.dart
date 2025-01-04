import 'package:doane/controller/globalbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MessagePage extends StatefulWidget {
  final String userId;
  const MessagePage({
    super.key,
    required this.userId,
  });

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  User? currentuser = FirebaseAuth.instance.currentUser;

  void sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    await FirebaseFirestore.instance
        .collection('messages')
        .doc(widget.userId)
        .collection('chaters')
        .add({
      'text': _messageController.text.trim(),
      'senderId': currentuser!.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
    await FirebaseFirestore.instance.collection('notifcations').add({
      'title': _messageController.text.trim(),
      'venue': "",
      'date': "",
      'time': "",
      'image': "",
      'others': "",
      'userid': widget.userId,
      'created': Timestamp.now(),
      'type': 'message',
    });
    _messageController.clear();
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void clearMessages() async {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(widget.userId)
        .delete();
    debugPrint("Deleting document with ID: ${widget.userId}");

    setState(() {});
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime
    return DateFormat('MMMM d, h:mm a').format(dateTime); // Format the DateTime
  }

  Widget buildMessageItem(Map<String, dynamic> message) {
    bool isSentByUser = message['senderId'] != widget.userId;
    return Align(
      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isSentByUser ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['text'],
              style: TextStyle(
                color: isSentByUser ? Colors.white : Colors.black,
              ),
            ),
            Text(
              formatTimestamp(message['timestamp']),
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('messages')
                .doc(widget.userId)
                .collection('chaters')
                .orderBy('timestamp', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No messages yet.'));
              }

              final messages = snapshot.data!.docs.map((doc) {
                return doc.data() as Map<String, dynamic>;
              }).toList();

              return ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return buildMessageItem(messages[index]);
                },
              );
            },
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    flex: 1,
                    child: GlobalButton(
                        oncallback: () {
                          sendMessage();
                        },
                        title: "Send")),
              ],
            ),
          )
        ],
      ),
    );
  }
}

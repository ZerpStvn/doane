import 'package:doane/controller/globalbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

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
  // Function to send a message
  void sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return; // Don't send empty messages
    }

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(currentuser!.uid)
        .collection('messages')
        .doc(widget.userId)
        .collection('chaters')
        .add({
      'text': _messageController.text.trim(),
      'senderId': widget.userId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget buildMessageItem(Map<String, dynamic> message) {
    bool isSentByUser = message['senderId'] == widget.userId;
    return Align(
      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isSentByUser ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message['text'],
          style: TextStyle(
            color: isSentByUser ? Colors.white : Colors.black,
          ),
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
                .collection('chats')
                .doc(currentuser!.uid)
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
                SizedBox(
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

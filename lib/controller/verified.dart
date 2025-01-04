import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmailService {
  // Replace these with your actual EmailJS service details
  final String serviceId = 'service_5e41hms';
  final String templateId = 'template_2nfqmvj';
  final String userId = 'fEmPUfIR5y-gQU-Mu';

  Future<void> sendMailVerified({
    required String recipientEmail,
    required String message,
  }) async {
    final Uri url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    try {
      var response = await http.post(
        url,
        headers: {
          'origin': 'http://localhost', // Required for EmailJS
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'message': message, // Dynamic message content
            'to_name': recipientEmail,
          },
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Email sent successfully: ${response.body}');
      } else {
        debugPrint(
            'Failed to send email. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (error) {
      debugPrint('Error sending email: $error');
    }
  }
}

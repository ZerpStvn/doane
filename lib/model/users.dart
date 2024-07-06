import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FetchUser {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController ageController;
  final TextEditingController birthController;
  final TextEditingController phoneController;
  final TextEditingController bioController;
  final TextEditingController emergencyContactNameController;
  final TextEditingController emergencyContactPhoneController;
  final TextEditingController additionalNotesController;
  final TextEditingController denominationController;
  final TextEditingController congregationController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final String userId;

  FetchUser({
    required this.nameController,
    required this.emailController,
    required this.addressController,
    required this.ageController,
    required this.birthController,
    required this.phoneController,
    required this.bioController,
    required this.emergencyContactNameController,
    required this.emergencyContactPhoneController,
    required this.additionalNotesController,
    required this.denominationController,
    required this.congregationController,
    required this.usernameController,
    required this.passwordController,
    required this.userId,
  });

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

        nameController.text = data['name'] ?? '';
        emailController.text = data['email'] ?? '';
        addressController.text = data['address'] ?? '';
        ageController.text = data['age'] ?? '';
        birthController.text = data['dateOfBirth'] ?? '';
        phoneController.text = data['phone'] ?? '';
        bioController.text = data['bio'] ?? '';
        emergencyContactNameController.text =
            data['emergencyContactName'] ?? '';
        emergencyContactPhoneController.text =
            data['emergencyContactPhone'] ?? '';
        additionalNotesController.text = data['additionalNotes'] ?? '';
        denominationController.text = data['denomination'] ?? '';
        congregationController.text = data['congregation'] ?? '';
        usernameController.text = data['username'] ?? '';
        passwordController.text = data['password'] ?? '';

        // Handle any non-String fields separately if necessary
      }
    } catch (error) {
      debugPrint("Error fetching user data: $error");
    }
  }
}

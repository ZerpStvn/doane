// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/controller/widget/buttoncall.dart';
import 'package:doane/model/users.dart';
import 'package:doane/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  final bool? isedit;
  final String? userid;
  const UserProfile({super.key, this.isedit, this.userid});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _ageController = TextEditingController();
  final _birthController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  final _emergencyContactNameController = TextEditingController();
  final _emergencyContactPhoneController = TextEditingController();
  final _additionalNotesController = TextEditingController();
  final _denominationController = TextEditingController();
  final _congregationController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String _role = 'Member';
  bool _isBaptised = false;
  String _gender = 'Male';
  String _maritalStatus = 'Single';
  String _membershipStatus = 'Active';
  String? _ministry;
  List<String> _ministryList = [];
  bool isloading = false;
  late FetchUser _fetchUser;
  @override
  void initState() {
    super.initState();
    _fetchMinistries();
    fetchuserdata();
  }

  Future<void> _fetchMinistries() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('ministry').get();
      setState(() {
        _ministryList =
            querySnapshot.docs.map((doc) => doc['name'] as String).toList();
        if (_ministryList.isNotEmpty) {
          _ministry = _ministryList[0];
        }
      });
    } catch (e) {
      debugPrint('Error fetching ministries: $e');
    }
  }

  Future<void> fetchuserdata() async {
    if (widget.isedit!) {
      _fetchUser = FetchUser(
        nameController: _nameController,
        emailController: _emailController,
        addressController: _addressController,
        ageController: _ageController,
        birthController: _birthController,
        phoneController: _phoneController,
        bioController: _bioController,
        emergencyContactNameController: _emergencyContactNameController,
        emergencyContactPhoneController: _emergencyContactPhoneController,
        additionalNotesController: _additionalNotesController,
        denominationController: _denominationController,
        congregationController: _congregationController,
        usernameController: _usernameController,
        passwordController: _passwordController,
        userId: widget.userid!,
      );
      _fetchUser.fetchUserData();
    } else {
      debugPrint("Not inview");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _ageController.dispose();
    _birthController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    _additionalNotesController.dispose();
    _denominationController.dispose();
    _congregationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(String uid) async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': _nameController.text,
          'email': _emailController.text,
          'address': _addressController.text,
          'age': _ageController.text,
          'dateOfBirth': _birthController.text,
          'phone': _phoneController.text,
          'gender': _gender,
          'maritalStatus': _maritalStatus,
          'membershipStatus': _membershipStatus,
          'role': _role,
          'ministry': _ministry,
          'isBaptised': _isBaptised,
          'emergencyContactName': _emergencyContactNameController.text,
          'emergencyContactPhone': _emergencyContactPhoneController.text,
          'bio': _bioController.text,
          'additionalNotes': _additionalNotesController.text,
          'denomination': _denominationController.text,
          'congregation': _congregationController.text,
          'username': _usernameController.text,
          'password': _passwordController.text,
        });
        _showSnackbar('Form submitted successfully!');
      } catch (e) {
        _showSnackbar('Error submitting form: $e');
      }
    }
  }

  Future<void> _submitFormEdit(String uid) async {
    setState(() {
      isloading = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'name': _nameController.text,
          'email': _emailController.text,
          'address': _addressController.text,
          'age': _ageController.text,
          'dateOfBirth': _birthController.text,
          'phone': _phoneController.text,
          'gender': _gender,
          'maritalStatus': _maritalStatus,
          'membershipStatus': _membershipStatus,
          'role': _role,
          'ministry': _ministry,
          'isBaptised': _isBaptised,
          'emergencyContactName': _emergencyContactNameController.text,
          'emergencyContactPhone': _emergencyContactPhoneController.text,
          'bio': _bioController.text,
          'additionalNotes': _additionalNotesController.text,
          'denomination': _denominationController.text,
          'congregation': _congregationController.text,
          'username': _usernameController.text,
          'password': _passwordController.text,
        });
        _showSnackbar('Form Updated successfully!');
        setState(() {
          isloading = false;
        });
      } catch (e) {
        _showSnackbar('Error submitting form: $e');
        setState(() {
          isloading = false;
        });
      }
    }
  }

  Future<void> handleCreateAccount() async {
    setState(() {
      isloading = true;
    });
    try {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((uid) {
        _submitForm(uid.user!.uid);
        setState(() {
          isloading = false;
        });
      });
    } catch (error) {
      _showSnackbar("Error creating account: $error");
      setState(() {
        isloading = false;
      });
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PERSONAL INFORMATION',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        readOnly: widget.isedit == false ? false : true,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(labelText: 'Address'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _ageController,
                        decoration: const InputDecoration(labelText: 'Age'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your age';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _birthController,
                        decoration:
                            const InputDecoration(labelText: 'Date of Birth'),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your date of birth';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        decoration:
                            const InputDecoration(labelText: 'Phone Number'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: ['Male', 'Female', 'Other']
                      .map((gender) => DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _maritalStatus,
                  decoration:
                      const InputDecoration(labelText: 'Marital Status'),
                  items: ['Single', 'Married', 'Divorced', 'Widowed']
                      .map((status) => DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _maritalStatus = value!;
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _membershipStatus,
                  decoration:
                      const InputDecoration(labelText: 'Membership Status'),
                  items: ['Active', 'Inactive', 'Visitor']
                      .map((status) => DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _membershipStatus = value!;
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _role,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: ['Member', 'Staff', 'Volunteer']
                      .map((role) => DropdownMenuItem<String>(
                            value: role,
                            child: Text(role),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _role = value!;
                    });
                  },
                ),
                _ministryList.isNotEmpty
                    ? DropdownButtonFormField<String>(
                        value: _ministry,
                        decoration:
                            const InputDecoration(labelText: 'Ministry'),
                        items: _ministryList
                            .map((ministry) => DropdownMenuItem<String>(
                                  value: ministry,
                                  child: Text(ministry),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _ministry = value!;
                          });
                        },
                      )
                    : const Text('No Ministries available...'),
                SwitchListTile(
                  title: const Text('Baptised'),
                  value: _isBaptised,
                  onChanged: (value) {
                    setState(() {
                      _isBaptised = value;
                    });
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emergencyContactNameController,
                        decoration: const InputDecoration(
                            labelText: 'Emergency Contact Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter emergency contact name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _emergencyContactPhoneController,
                        decoration: const InputDecoration(
                            labelText: 'Emergency Contact Phone'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter emergency contact phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(labelText: 'Brief Bio'),
                  maxLines: 3,
                ),
                TextFormField(
                  controller: _additionalNotesController,
                  decoration:
                      const InputDecoration(labelText: 'Additional Notes'),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Religion Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _denominationController,
                  decoration: const InputDecoration(labelText: 'Denomination'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your denomination';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _congregationController,
                  decoration:
                      const InputDecoration(labelText: 'Current Congregation'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current congregation';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Login Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                widget.isedit == false
                    ? isloading
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            height: 40,
                            child: ButtonCallback(
                                function: () {
                                  handleCreateAccount();
                                },
                                bgcolor: maincolor,
                                fcolor: Colors.white,
                                title: "SUBMIT INFORMATION"),
                          )
                    : isloading
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            height: 40,
                            child: ButtonCallback(
                                function: () {
                                  _submitFormEdit(widget.userid!);
                                },
                                bgcolor: maincolor,
                                fcolor: Colors.white,
                                title: "UPDATE INFORMATION"),
                          )
              ],
            ),
          ),
        ));
  }
}

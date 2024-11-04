// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doane/controller/login.dart';
import 'package:doane/controller/widget/buttoncall.dart';
import 'package:doane/model/users.dart';
import 'package:doane/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserForm extends StatefulWidget {
  final bool? isedit;
  final String? userid;
  const UserForm({super.key, this.isedit, this.userid});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
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
  final _newMinistryController = TextEditingController();
  int isnext = 0;
  // String _role = 'Member';
  bool _isBaptised = false;
  String _gender = 'Male';
  String _maritalStatus = 'Single';
  // String _membershipStatus = 'Active';
  final List<String> _selectedMinistries = [];
  List<String> _ministryList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMinistries();
  }

  Future<void> _fetchMinistries() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('ministry').get();
      setState(() {
        _ministryList =
            querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (e) {
      debugPrint('Error fetching ministries: $e');
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
    _newMinistryController.dispose();
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
          'membershipStatus': 'Active',
          'role': 'member',
          'ministries': _selectedMinistries,
          'isBaptised': _isBaptised,
          'emergencyContactName': _emergencyContactNameController.text,
          'emergencyContactPhone': _emergencyContactPhoneController.text,
          'bio': _bioController.text,
          'additionalNotes': _additionalNotesController.text,
          'denomination': _denominationController.text,
          'congregation': _congregationController.text,
          'username': _usernameController.text,
          'password': _passwordController.text,
          'created': Timestamp.now(),
          'verif': 3
        });
        _showSnackbar('Form submitted successfully!');
      } catch (e) {
        _showSnackbar('Error submitting form: $e');
      }
    }
  }

  Future<void> handleCreateAccount() async {
    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      _submitForm(userCredential.user!.uid);

      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.code == 'email-already-in-use'
          ? "The email is already in use by another account."
          : e.code == 'weak-password'
              ? "The password is too weak."
              : e.code == 'invalid-email'
                  ? "The email address is not valid."
                  : "Error creating account: ${e.message}";

      _showSnackbar(errorMessage);

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      _showSnackbar("Error creating account: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _addMinistry() {
    if (_newMinistryController.text.isNotEmpty &&
        !_selectedMinistries.contains(_newMinistryController.text)) {
      setState(() {
        _selectedMinistries.add(_newMinistryController.text);
        _newMinistryController.clear();
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // New Method to pick the Date of Birth and calculate age
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthController.text = DateFormat('yyyy-MM-dd').format(picked);
        _ageController.text = _calculateAge(picked).toString();
      });
    }
  }

  // Function to calculate the age from the date of birth
  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Widget changenextcontent() {
    if (isnext == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PERSONAL INFORMATION',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Name'),
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
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Email'),
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Address'),
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
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Age'),
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _birthController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Date of Birth'),
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
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone Number'),
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
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Gender'),
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
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _maritalStatus,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Marital Status'),
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _newMinistryController,
                decoration: const InputDecoration(
                    labelText: 'Add a Ministry', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addMinistry,
                child: const Text('Add Ministry'),
              ),
              if (_selectedMinistries.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  children: _selectedMinistries
                      .map((ministry) => Chip(
                            label: Text(ministry),
                            onDeleted: () {
                              setState(() {
                                _selectedMinistries.remove(ministry);
                              });
                            },
                          ))
                      .toList(),
                ),
              const SizedBox(height: 26),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: maincolor,
                //   ),
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                //   child: const Text(
                //     "< Go Back",
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _nameController.text.isEmpty ||
                            _addressController.text.isEmpty ||
                            _ageController.text.isEmpty ||
                            _birthController.text.isEmpty ||
                            _phoneController.text.isEmpty
                        ? Colors.grey
                        : maincolor,
                  ),
                  onPressed: _nameController.text.isEmpty ||
                          _addressController.text.isEmpty ||
                          _ageController.text.isEmpty ||
                          _birthController.text.isEmpty ||
                          _phoneController.text.isEmpty
                      ? null
                      : () {
                          setState(() {
                            isnext = 1;
                          });
                        },
                  child: const Text(
                    "Next >",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    } else if (isnext == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _emergencyContactNameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
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
                          border: OutlineInputBorder(),
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Brief Bio'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _additionalNotesController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Additional Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Baptised'),
                value: _isBaptised,
                onChanged: (value) {
                  setState(() {
                    _isBaptised = value;
                  });
                },
              ),
              const SizedBox(height: 26),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maincolor,
                  ),
                  onPressed: () {
                    setState(() {
                      isnext = 0;
                    });
                  },
                  child: const Text(
                    "< Go Back",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _emergencyContactNameController.text.isEmpty ||
                                _emergencyContactPhoneController.text.isEmpty ||
                                _bioController.text.isEmpty ||
                                _additionalNotesController.text.isEmpty
                            ? Colors.grey
                            : maincolor,
                  ),
                  onPressed: _emergencyContactNameController.text.isEmpty ||
                          _emergencyContactPhoneController.text.isEmpty ||
                          _bioController.text.isEmpty ||
                          _additionalNotesController.text.isEmpty
                      ? null
                      : () {
                          setState(() {
                            isnext = 2;
                          });
                        },
                  child: const Text(
                    "Next >",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    } else if (isnext == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Religion Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _denominationController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Denomination'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your denomination';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _congregationController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Current Congregation'),
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Email Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Email Address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Password'),
                obscureText: true,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {});
                  } else {
                    value.isEmpty;
                    setState(() {});
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 40,
                          child: ButtonCallback(
                              function: () {
                                setState(() {
                                  isnext = 1;
                                });
                              },
                              bgcolor: maincolor,
                              fcolor: Colors.white,
                              title: "< Go Back"),
                        ),
                        SizedBox(
                          height: 40,
                          child: ButtonCallback(
                              function: () {
                                handleCreateAccount();
                              },
                              bgcolor: _usernameController.text.isEmpty ||
                                      _passwordController.text.isEmpty
                                  ? Colors.grey
                                  : maincolor,
                              fcolor: Colors.white,
                              title: "SUBMIT INFORMATION"),
                        ),
                      ],
                    )
            ],
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: IconButton(
                                onPressed: () {
                                  // setState(() {
                                  //   isnext = 0;
                                  // });
                                },
                                icon: Icon(
                                  Icons.person_outline,
                                  color: isnext == 0
                                      ? Colors.blueAccent
                                      : Colors.black,
                                ))),
                        Expanded(
                          child: Container(
                            color:
                                isnext == 1 ? Colors.blueAccent : Colors.grey,
                            height: 2,
                            width: MediaQuery.of(context).size.width * 0.40,
                          ),
                        ),
                        Expanded(
                            child: IconButton(
                                onPressed: () {
                                  // setState(() {
                                  //   isnext = 1;
                                  // });
                                },
                                icon: Icon(
                                  Icons.church_outlined,
                                  color: isnext == 1
                                      ? Colors.blueAccent
                                      : Colors.black,
                                ))),
                        Expanded(
                          child: Container(
                            color:
                                isnext == 2 ? Colors.blueAccent : Colors.grey,
                            height: 2,
                            width: MediaQuery.of(context).size.width * 0.40,
                          ),
                        ),
                        Expanded(
                            child: IconButton(
                                onPressed: () {
                                  // setState(() {
                                  //   isnext = 2;
                                  // });
                                },
                                icon: Icon(
                                  Icons.login_outlined,
                                  color: isnext == 2
                                      ? Colors.blueAccent
                                      : Colors.black,
                                )))
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    changenextcontent()
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

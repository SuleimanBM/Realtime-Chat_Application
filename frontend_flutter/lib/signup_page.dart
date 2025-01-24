// ignore_for_file: unused_field, unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend_flutter/chat_page.dart';
import 'package:frontend_flutter/login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers to avoid memory leaks
    _emailController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> sendData() async {
    const url =
        'http://10.10.10.61:3000/auth/register'; // Replace with your API endpoint
    final Map<String, dynamic> payload = {
      'email': _emailController.text,
      'username': _userNameController.text,
      "password": _passwordController.text
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 201) {
        // Success
        print('Data sent successfully: ${response.body}');
        final jsonData = json.decode(response.body);
        if (jsonData['token'] != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Chatpage(),
            ),
          );
        }
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //const Icon(Icons.chat, size: 100, color: Colors.blue),
            Image.asset('assets/QuickChat.png', width: 200, height: 200),
            Text("Sign up", style: TextStyle(fontSize: 30,color: const Color.fromARGB(255, 3, 6, 34)),),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Email TextField
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),

                  // Username TextField
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: _userNameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        labelText: "Username",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        if (value.length < 3) {
                          return "Username must be at least 3 characters";
                        }
                        return null;
                      },
                    ),
                  ),

                  // Password TextField
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                  ),

                  // Confirm Password TextField
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: "Confirm Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),

                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState != null &&
                          _formKey.currentState!.validate()) {
                        final email = _emailController.text;
                        final userName = _userNameController.text;

                        // Show success dialog
                        sendData();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Form Submitted'),
                            content: Text('Name: $userName\nEmail: $email'),
                          ),
                        );
                      } else {
                        // Show a SnackBar for validation errors
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fix the errors in the form'),
                          ),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                  InkWell(
                      child: const Text("Already have an account? Login"),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

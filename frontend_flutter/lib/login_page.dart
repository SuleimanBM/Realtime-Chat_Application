import 'package:flutter/material.dart';
import 'package:frontend_flutter/chat_page.dart';
import 'package:frontend_flutter/signup_page.dart';
import 'package:provider/provider.dart';
import 'package:frontend_flutter/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String token = "";
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

  @override
  Widget build(BuildContext context) {
    final myProvider = context.watch<MyProvider>();
    
    Future<void> sendData() async {
      const url =
          'http://10.10.11.240:3000/auth/login'; // Replace with your API endpoint
      final Map<String, dynamic> payload = {
        'username': _userNameController.text,
        "password": _passwordController.text
      };

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(payload),
        );

        if (response.statusCode == 200) {
          // Success
          print('Data sent successfully: ${response.body}');
          final jsonData = json.decode(response.body);
          token = jsonData['token'];
          if (token != null) {
             myProvider.setToken(token);
              print("Saved to provider: ${myProvider.token}");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(),
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
            Image.asset('assets/QuickChat.png', width: 100, height: 100),
            const Text(
              "Sign up",
              style:
                  TextStyle(fontSize: 30, color: Color.fromARGB(255, 3, 6, 34)),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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

                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState != null &&
                          _formKey.currentState!.validate()) {
                        final email = _emailController.text;
                        final userName = _userNameController.text;

                        // Show success dialog
                        sendData();
                       
                        // showDialog(
                        //   context: context,
                        //   builder: (context) => AlertDialog(
                        //     title: const Text('Form Submitted'),
                        //     content: Text('Name: $userName\nEmail: $email'),
                        //   ),
                        // );
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
                      child: const Text("Don't have an account? Sign up"),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
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

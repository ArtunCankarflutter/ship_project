import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  int selectedQuestion = 1;

  Future<void> createAccount() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        answerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    final url = Uri.parse("http://localhost/register.php");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "secret_question": selectedQuestion,
          "secret_answer": answerController.text.trim(),
        }),
      );
      final data = json.decode(response.body);
      if (data['status'] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created successfully!")),
        );
        Navigator.pop(context); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Create a New Account",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              autofocus: false,
              decoration: const InputDecoration(
                labelText: "Email Address",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              autofocus: false,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: "Select Your Secret Question",
                border: OutlineInputBorder(),
              ),
              value: selectedQuestion,
              items: const [
                DropdownMenuItem(value: 1, child: Text("Your favorite color?")),
                DropdownMenuItem(value: 2, child: Text("Your pet's name?")),
                DropdownMenuItem(value: 3, child: Text("Your first school?")),
                DropdownMenuItem(value: 4, child: Text("Your favorite movie?")),
                DropdownMenuItem(value: 5, child: Text("Your hometown?")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedQuestion = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: answerController,
              autofocus: false,
              decoration: const InputDecoration(
                labelText: "Answer",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: createAccount,
              child: const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}





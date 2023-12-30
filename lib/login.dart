import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:health_project/register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primaryColor: Colors.white,
        backgroundColor: Colors.white,
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController idCardController = TextEditingController();

  void _login() async {
    String firstname = firstnameController.text;
    String idCard = idCardController.text;

    String apiUrl = 'http://localhost:8080//health/login.php';

    Map<String, dynamic> requestBody = {
      'firstname': firstname,
      'id_card': idCard,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        print('Login Successfully');
        _showSuccessfulDialog(firstname);
      } else {
        print('Login Failed');
        _showErrorDialog('Invalid credentials');
      }
    } catch (error) {
      print('Connection Error: $error');
      _showErrorDialog('Connection error');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessfulDialog(String firstName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Welcome'),
          content: Text('Welcome, $firstName!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _goToRegisterPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image(
              image: AssetImage('images/heartbeat.png'),
              width: 200.0,
              height: 100.0,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: firstnameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                prefixIcon: Image.asset(
                  'images/profile.png',
                  height: 20.0,
                  width: 20.0,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: idCardController,
              decoration: InputDecoration(
                labelText: 'ID Card',
                prefixIcon: Image.asset(
                  'images/lock.png',
                  height: 20.0,
                  width: 20.0,
                ),
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 8.0),
            InkWell(
              onTap: _goToRegisterPage,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.transparent),
                ),
                child: Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

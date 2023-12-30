import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:health_project/login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? selectedTitle; // Declare selectedTitle here

  TextEditingController idCardController = TextEditingController();
  TextEditingController titlenameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController heartValueController = TextEditingController();
  TextEditingController pulseValueController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != dateOfBirthController.text) {
      setState(() {
        dateOfBirthController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  void _register() async {
    String idCard = idCardController.text;
    String titlename = selectedTitle ?? '';
    String firstname = firstnameController.text;
    String lastname = lastnameController.text;
    String dateOfBirth = dateOfBirthController.text;
    String heartValue = heartValueController.text;
    String pulseValue = pulseValueController.text;

    // String? selectedTitle;

    String apiUrl = 'http://localhost:8080/health/register.php';

    Map<String, dynamic> requestBody = {
      'id_card': idCard,
      'titlename': titlename,
      'firstname': firstname,
      'lastname': lastname,
      'date_of_birth': dateOfBirth,
      'heart_value': heartValue,
      'pulse_value': pulseValue,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // ประมวลผลข้อมูลหลังจากที่ลงทะเบียนสำเร็จ
        // ตัวอย่างเช่นการแสดงข้อความหรือ navigation ไปหน้าอื่น
        print('Register Successful');
        _showSuccessfulDialog('Register Successful');
      } else {
        print('Register Failed');
        // ประมวลผลเมื่อลงทะเบียนไม่สำเร็จ
        _showErrorDialog('Invalid credentials');
      }
    } catch (error) {
      print('Connection Error: $error');
      // ประมวลผลเมื่อเกิดข้อผิดพลาดในการเชื่อมต่อ
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

  void _showSuccessfulDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Successful'),
          content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              buildTextField(
                controller: idCardController,
                labelText: 'ID Card',
                prefixIcon: 'images/id-card.png',
              ),
              SizedBox(height: 10.0),
              buildTextFieldWithDropdown(
                controller: titlenameController,
                labelText: 'Title Name',
                prefixIcon: 'images/profile.png',
                dropdownItems: ['Miss', 'Mr.', 'Mrs.'],
                selectedItem: selectedTitle,
                onChanged: (String? value) {
                  setState(() {
                    selectedTitle = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              buildTextField(
                controller: firstnameController,
                labelText: 'First Name',
                prefixIcon: 'images/profile.png',
              ),
              SizedBox(height: 16.0),
              buildTextField(
                controller: lastnameController,
                labelText: 'Last Name',
                prefixIcon: 'images/profile.png',
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: buildTextField(
                    controller: dateOfBirthController,
                    labelText: 'Date of Birth',
                    prefixIcon: 'images/schedule.png',
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              buildTextField(
                controller: heartValueController,
                labelText: 'Heart Value',
                prefixIcon: 'images/core.png',
              ),
              SizedBox(height: 16.0),
              buildTextField(
                controller: pulseValueController,
                labelText: 'Pulse Value',
                prefixIcon: 'images/pulse.png',
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _register,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldWithDropdown({
    required TextEditingController controller,
    required String labelText,
    required String prefixIcon,
    List<String>? dropdownItems,
    String? selectedItem,
    ValueChanged<String?>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InputDecorator(
          decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: Image.asset(
              prefixIcon,
              height: 20.0,
              width: 20.0,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedItem,
              hint: Text('Select Title'), // Add a hint for the dropdown
              items: dropdownItems?.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  })?.toList() ??
                  [],
              onChanged: onChanged,
            ),
          ),
        ),
        if (dropdownItems != null) SizedBox(height: 8.0),
      ],
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String prefixIcon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Image.asset(
          prefixIcon,
          height: 20.0,
          width: 20.0,
        ),
      ),
    );
  }
}

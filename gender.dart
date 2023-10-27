import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GenderScreen extends StatefulWidget {
  late String? personName;

  GenderScreen({required this.personName});

  @override
  _GenderScreenState createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String? gender;
  Color? displayColor;
  TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchGender();
  }

  Future<void> fetchGender() async {
    try {
      final response = await http.get(Uri.parse('https://api.genderize.io/?name=${widget.personName}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        gender = data['gender'];

        setState(() {
          displayColor = gender == 'male' ? Colors.blue : Colors.pink;
        });
      } else {
        // Handle API error
        print('API request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or parsing error
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gender Prediction'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Enter a name',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.personName = _nameController.text;
                  fetchGender();
                });
              },
              child: Text('Predict Gender'),
            ),
            SizedBox(height: 20),
            Text('Person: ${widget.personName}'),
            SizedBox(height: 20),
            Text('Gender: $gender'),
            SizedBox(height: 20),
            Container(
              width: 200,
              height: 200,
              color: displayColor ?? Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

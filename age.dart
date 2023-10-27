import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'dart:ui' as ui;

class AgeScreen extends StatefulWidget {
  @override
  _AgeScreenState createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  String? personName;
  int? age;

  final String jovenImageName = 'assets/images/joven.jpg';
  final String adultoImageName = 'assets/images/adulto.jpg';
  final String ancianoImageName = 'assets/images/anciano.jpg';

  late Uint8List jovenImageData;
  late Uint8List adultoImageData;
  late Uint8List ancianoImageData;

  late ui.Image jovenImage;
  late ui.Image adultoImage;
  late ui.Image ancianoImage;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    jovenImageData = (await rootBundle.load('$jovenImageName')).buffer.asUint8List();
    adultoImageData = (await rootBundle.load('$adultoImageName')).buffer.asUint8List();
    ancianoImageData = (await rootBundle.load('$ancianoImageName')).buffer.asUint8List();

    final jovenCodec = await ui.instantiateImageCodec(jovenImageData);
    final adultoCodec = await ui.instantiateImageCodec(adultoImageData);
    final ancianoCodec = await ui.instantiateImageCodec(ancianoImageData);

    final jovenFrame = await jovenCodec.getNextFrame();
    final adultoFrame = await adultoCodec.getNextFrame();
    final ancianoFrame = await ancianoCodec.getNextFrame();

    setState(() {
      jovenImage = jovenFrame.image;
      adultoImage = adultoFrame.image;
      ancianoImage = ancianoFrame.image;
    });
  }

  String getAgeMessage(int age) {
    if (age < 18) {
      return 'Es una persona joven';
    } else if (age < 54) {
      return 'Es una persona adulta';
    } else {
      return 'Es una persona anciana';
    }
  }

  Future<void> fetchAge() async {
    if (personName == null || personName!.isEmpty) {
      return;
    }

    try {
      final response =
          await http.get(Uri.parse('https://api.agify.io/?name=$personName'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        age = data['age'];

        setState(() {});
      } else {
        // Handle API error
        print('API request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or parsing error
      print('Error: $error');
    }
  }

  ImageProvider getImageProvider() {
    if (age != null) {
      if (age! < 18) {
        return MemoryImage(jovenImageData);
      } else if (age! < 54) {
        return MemoryImage(adultoImageData);
      } else {
        return MemoryImage(ancianoImageData);
      }
    }
    return const AssetImage('assets/images/placeholder.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Age Prediction'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (jovenImage != null) // Display the image only if it's loaded
              CircleAvatar(
                radius: 50,
                backgroundImage: getImageProvider(),
              ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  personName = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Enter a name',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                fetchAge();
              },
              child: Text('Predict Age'),
            ),
            SizedBox(height: 20),
            if (age != null) Text('Age: $age'),
            if (age != null) SizedBox(height: 20),
            if (age != null) Text(getAgeMessage(age!)),
          ],
        ),
      ),
    );
  }
}

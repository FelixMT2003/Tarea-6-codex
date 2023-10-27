import 'package:flutter/material.dart';
import '../about.dart';
import '../age.dart';
import '../gender.dart';
import '../news.dart';
import '../university.dart';
import '../weather.dart';

void main() {
  runApp(SidebarApp());
}

class SidebarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sidebar App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _views = [
    GenderScreen(personName: '',),
    AgeScreen(),
    UniversityScreen(),
    WeatherScreen(),
    NewsScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('COTEAU'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg'))),
              child: Text(
                'Coteau',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.input),
              title: const Text('Genero'),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.numbers),
              title: const Text('Edad'),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Universidades'),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.wb_sunny),
              title: const Text('Clima'),
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('Noticias'),
              onTap: () {
                setState(() {
                  _currentIndex = 4;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Acerca de'),
              onTap: () {
                setState(() {
                  _currentIndex = 5;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _views[_currentIndex],
    );
  }
}

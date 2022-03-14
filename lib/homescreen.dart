import 'package:flutter/material.dart';
import 'feed.dart';
import 'profile.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.asset('images/logo.png', height: 40),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        selectedItemColor: const Color.fromARGB(255, 255, 0, 0),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "homescreen"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "search"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "profilescreen"),
        ],
        onTap: (value) {
          setState(
            () {
              _selectedIndex = value;
            },
          );
          _pageController.animateToPage(value,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
        },
        currentIndex: _selectedIndex,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(
            () {
              _selectedIndex = index;
            },
          );
        },
        children: const [
          Feed(),
          SearchScreen(),
          Profile(),
        ],
      ),
    );
  }
}

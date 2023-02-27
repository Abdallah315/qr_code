import 'package:flutter/material.dart';

class PagesScreen extends StatefulWidget {
  const PagesScreen({Key? key}) : super(key: key);

  @override
  State<PagesScreen> createState() => _PagesState();
}

class _PagesState extends State<PagesScreen> {
  int selectedIndex = 0;
  final List pages = [
    // const HomeScreen(),
    // const RoomsScreen(),
    // const SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          currentIndex: selectedIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.access_time_filled,
                  color: Colors.red,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.wysiwyg_sharp,
                  color: Colors.cyan,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.workspaces,
                  color: Colors.green,
                ),
                label: ''),
          ],
        ),
        body: pages[selectedIndex],
      ),
    );
  }
}

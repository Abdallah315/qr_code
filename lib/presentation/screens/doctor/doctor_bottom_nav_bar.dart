import 'package:flutter/material.dart';
import 'package:flutter_qr_code/presentation/screens/doctor/doctor_home_screen.dart';

class DoctorBottomNavBar extends StatefulWidget {
  const DoctorBottomNavBar({Key? key}) : super(key: key);

  @override
  State<DoctorBottomNavBar> createState() => _DoctorBottomNavBarState();
}

class _DoctorBottomNavBarState extends State<DoctorBottomNavBar> {
  int selectedIndex = 0;
  final List pages = [
    const DoctorHomeScreen(),
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
            // BottomNavigationBarItem(
            //     icon: Icon(
            //       Icons.wysiwyg_sharp,
            //       color: Colors.cyan,
            //     ),
            //     label: ''),
            // BottomNavigationBarItem(
            //     icon: Icon(
            //       Icons.workspaces,
            //       color: Colors.green,
            //     ),
            //     label: ''),
          ],
        ),
        body: pages[selectedIndex],
      ),
    );
  }
}

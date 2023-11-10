
import 'package:festa/views/home/screenhome.dart';
import 'package:festa/views/widgets/navbar/bottom.dart';
import 'package:flutter/material.dart';


class ScreenMainPage extends StatelessWidget {
  ScreenMainPage({
    super.key,
  });

  final _pages = [
    const ScreenHome(),
   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: indexChangeNotifier,
          builder: (context, int index, _) {
            return _pages[index];
          },
        ),
      ),
      bottomNavigationBar: const BottomNavigationScreen(),
    );
  }
}

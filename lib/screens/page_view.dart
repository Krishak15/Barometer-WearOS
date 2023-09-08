import 'package:barometer_app/screens/graph_screen.dart';
import 'package:barometer_app/screens/main_screen.dart';
import 'package:flutter/material.dart';

class MyPageView extends StatefulWidget {
  const MyPageView({super.key});

  @override
  MyPageViewState createState() => MyPageViewState();
}

class MyPageViewState extends State<MyPageView> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
      scrollDirection: Axis.vertical,
      children: const [
        MainScreen(),
        GraphScreen(),
      ],
    );
  }
}

// import 'package:barometer_app/screens/details_screen.dart';

// import 'package:barometer_app/screens/main_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:rotary_scrollbar/rotary_scrollbar.dart';

// class MyPageView extends StatefulWidget {
//   const MyPageView({super.key});

//   @override
//   MyPageViewState createState() => MyPageViewState();
// }

// final PageStorageBucket bucket = PageStorageBucket();

// class MyPageViewState extends State<MyPageView> {
//   final pageController = PageController();
 

//     @override
//   void initState() {
//     super.initState();
//     pageController.addListener(() {
//       setState(() {
//         _currentPageIndex = pageController.page?.round() ?? 0;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: RotaryScrollWrapper(
//         rotaryScrollbar: RotaryScrollbar(controller: pageController),
//         child: PageView(
//           controller: pageController,
//           // onPageChanged: (index) {
//           //   setState(() {
//           //     _currentPageIndex = index;
//           //   });
//           // },
//           scrollDirection: Axis.vertical,
//           children: const [
//             MainScreen(),
//             DetailsScreen(),
//           ],
//         ),
//       ),
//     );
//   }
// }

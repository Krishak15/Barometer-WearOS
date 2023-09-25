import 'package:flutter/material.dart';
import 'package:rotary_scrollbar/rotary_scrollbar.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with AutomaticKeepAliveClientMixin {
  final scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.black,
        body: RotaryScrollWrapper(
            rotaryScrollbar: RotaryScrollbar(
                width: 4,
                scrollMagnitude: 100,
                controller: scrollController,
                hasHapticFeedback: true,
                autoHide: true),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                controller: scrollController,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Pincode: 673121",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            )));
  }

  @override
  bool get wantKeepAlive => true;
}

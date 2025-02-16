import 'dart:ui';

import 'package:barometer_app/lava_lamp/lava_clock.dart';
import 'package:barometer_app/screens/mobile_view/mobile_view_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class MainScreenMobile extends StatefulWidget {
  const MainScreenMobile({super.key});

  @override
  State<MainScreenMobile> createState() => _MainScreenMobileState();
}

class _MainScreenMobileState extends State<MainScreenMobile> {
  final watch = WatchConnectivity();

  @override
  void initState() {
    super.initState();
    watch.messageStream.listen((event) {
      refreshData(event);
    });
  }

  void refreshData(Map<String, dynamic> value) {
    if (value['pressureData'].toString().isNotEmpty) {
      context.read<MobileViewProvider>().pressureValue =
          value['pressureData'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            LavaAnimation(
                child: SizedBox(
              height: size.height,
              width: size.width,
            )),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: SizedBox(
                width: size.width,
                height: size.height,
              ),
            ),
            SizedBox(
              height: size.height,
              width: size.width,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Consumer<MobileViewProvider>(
                        builder: (context, provider, _) {
                      return Visibility(
                        visible: provider.pressureData != "",
                        child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 0.2),
                                color: Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/atm-pressure.png",
                                    height: 16,
                                    width: 16,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    provider.pressureData ?? '',
                                    style: GoogleFonts.dmSans(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    " hPa",
                                    style: GoogleFonts.dmSans(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            )),
                      );
                    }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

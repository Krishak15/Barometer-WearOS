import 'package:barometer_app/plugins/marquee-2.2.3/lib/marquee.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/reverse_geocoding/geocodingapi.dart';

class CustomMarquee extends StatelessWidget {
  const CustomMarquee(
      {super.key, required this.displayName, required this.revGeoCoding});

  final String displayName;
  final ReverseGeoCodingProvider revGeoCoding;

  @override
  Widget build(BuildContext context) {
    return Marquee(
      text: displayName,
      startAfter: Duration(seconds: revGeoCoding.isLoading ? 5 : 0),
      fadingEdgeEndFraction: 0.15,
      fadingEdgeStartFraction: 0.15,
      showFadingOnlyWhenScrolling: false,
      style: GoogleFonts.poppins(
          wordSpacing: 1,
          fontWeight: FontWeight.w400,
          fontSize: 11,
          color: Colors.white),
      crossAxisAlignment: CrossAxisAlignment.center,
      blankSpace: 20.0,
      velocity: 50.0,
      pauseAfterRound: const Duration(seconds: 5),
      startPadding: 4.0,
      accelerationDuration: const Duration(seconds: 2),
      accelerationCurve: Curves.linear,
      decelerationDuration: const Duration(milliseconds: 500),
      decelerationCurve: Curves.easeOut,
    );
  }
}

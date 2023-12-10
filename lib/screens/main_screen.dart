import 'package:barometer_app/screens/details_screen.dart';
import 'package:barometer_app/services/elevation/altitude_api.dart';
import 'package:barometer_app/services/broadcast/sensor_data.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import 'package:marquee/marquee.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lava_lamp/lava_clock.dart';

import '../services/reverse_geocoding/geocodingapi.dart';
import '../services/reverse_geocoding/revgeocoding_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    Provider.of<ReverseGeoCodingProvider>(context, listen: false).saveTime();

    super.initState();

    _loadSavedTime();
  }

  @override
  void didChangeDependencies() {
    if (kDebugMode) {
      print("didChangedDependencies");
    }

    Provider.of<ReverseGeoCodingProvider>(context, listen: false)
        .fetchApiData(context);

    Provider.of<ReverseGeoCodingProvider>(context, listen: false).saveTime();

    _loadSavedTime();

    super.didChangeDependencies();
  }

  late String savedTime;

  _loadSavedTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    savedTime = prefs.getString('saved_time') ?? 'No time saved yet';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: FutureBuilder<void>(
        future: Provider.of<SensorDataProvider>(context, listen: false)
            .initPlatformState(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildStreamBuilder(context);
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error initializing sensor data'));
          } else {
            return SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Container(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 1.2,
                )),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildStreamBuilder(BuildContext context) {
    //RevGeoCoding Data
    final revGeoCode =
        Provider.of<ReverseGeoCodingProvider>(context, listen: true)
            .reverseGeoModel;

    return _buildBody(revGeoCode);
  }

  Widget _buildBody(
    ReverseGeoGeocodingModel? revGeoCode,

    // bool revGeoLoading,
  ) {
    String locationName = "Unknown";
    String displayName = "Unknown";

    if (revGeoCode != null) {
      displayName = revGeoCode.displayName!;
    } else {
      displayName = "Unknown";
    }

    if (revGeoCode != null) {
      if (revGeoCode.address!.yes != null) {
        locationName = revGeoCode.address!.yes!;
      } else if (revGeoCode.address!.it != null) {
        locationName = revGeoCode.address!.it!;
      } else if (revGeoCode.address!.village != null) {
        locationName = revGeoCode.address!.village!;
      } else {
        locationName = displayName;
      }
    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        alignment: Alignment.center,
        children: [
          const LavaAnimation(
              child: SizedBox(
            height: double.infinity,
            width: 100,
          )),
          GlassContainer(
            height: MediaQuery.of(context).size.height,
            blur: 10,
            width: MediaQuery.of(context).size.width,
            borderWidth: 0.1,
            color: Colors.transparent,

            borderGradient: const LinearGradient(
              colors: [
                Colors.white,
                Colors.white,
                Colors.lightBlueAccent,
                Colors.lightBlueAccent
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.39, 0.40, 1.0],
            ),
            // color: Colors.white.withOpacity(0.1),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Provider.of<ReverseGeoCodingProvider>(context, listen: false)
                      .saveTime();
                  Provider.of<ReverseGeoCodingProvider>(context, listen: false)
                      .fetchApiData(context);
                  _loadSavedTime();
                },
                child: Padding(
                  padding: EdgeInsets.all(displayName == "Unknown" ? 15 : 0),
                  child: Consumer<ReverseGeoCodingProvider>(
                      builder: (context, revGeoCoding, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        revGeoCoding.isLoading
                            ? const SizedBox(
                                height: 9,
                                width: 9,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 0.5,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(
                                EvaIcons.refresh_outline,
                                color: Colors.white,
                                size: 10,
                              ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          savedTime,
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 11),
                        )
                      ],
                    );
                  }),
                ),
              ),
              displayName == "Unknown"
                  ? const SizedBox()
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              EvaIcons.pin_outline,
                              size: 13,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Consumer<ReverseGeoCodingProvider>(
                                builder: (context, revGeoCoding, child) {
                              return Stack(
                                children: [
                                  revGeoCoding.isLoading
                                      ? const SizedBox()
                                      : SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        const DetailsScreen(),
                                                  ));
                                                  HapticFeedback.lightImpact();
                                                },
                                                child: const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 1),
                                                  child: Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: 18,
                                    child: revGeoCoding.isLoading == false
                                        ? GestureDetector(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    const DetailsScreen(),
                                              ));
                                              HapticFeedback.lightImpact();
                                            },
                                            child: Marquee(
                                              startAfter: Duration(
                                                  seconds:
                                                      revGeoCoding.isLoading
                                                          ? 5
                                                          : 0),
                                              fadingEdgeEndFraction: 0.35,
                                              fadingEdgeStartFraction: 0.15,
                                              showFadingOnlyWhenScrolling:
                                                  false,
                                              text: displayName,
                                              style: GoogleFonts.poppins(
                                                  wordSpacing: 1,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 11,
                                                  color: Colors.white),
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              blankSpace: 20.0,
                                              velocity: 50.0,
                                              pauseAfterRound:
                                                  const Duration(seconds: 5),
                                              startPadding: 4.0,
                                              accelerationDuration:
                                                  const Duration(seconds: 2),
                                              accelerationCurve: Curves.linear,
                                              decelerationDuration:
                                                  const Duration(
                                                      milliseconds: 500),
                                              decelerationCurve: Curves.easeOut,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Text(
                                                  locationName,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 18, left: 22, right: 22, top: 0),
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 0.2),
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(15)),
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
                          Consumer<SensorDataProvider>(
                              builder: (context, sensorStream, child) {
                            return Text(
                              sensorStream.latestPressure
                                  .toStringAsFixed(1)
                                  .toString(),
                              style: GoogleFonts.dmSans(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            );
                          }),
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
              ),
              Consumer<AltitudeApiProvider>(
                  builder: (context, elevationData, child) {
                return elevationData.isLoading == false
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/altitude.png",
                            height: 16,
                            width: 16,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${elevationData.elevation.toStringAsFixed(0).toString()} m",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      )
                    : const SizedBox();
              })
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

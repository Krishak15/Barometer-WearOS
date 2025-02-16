import 'package:barometer_app/mixins/_mixin.dart';
import 'package:barometer_app/screens/details_screen.dart';
import 'package:barometer_app/services/elevation/altitude_api.dart';
import 'package:barometer_app/services/broadcast/sensor_data.dart';
import 'package:barometer_app/services/weather/api/weather_api_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

import '../lava_lamp/lava_clock.dart';
import '../services/reverse_geocoding/geocodingapi.dart';
import '../services/reverse_geocoding/model/revgeocoding_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin, dataMixin {
  @override
  void initState() {
    Provider.of<ReverseGeoCodingProvider>(context, listen: false).saveTime();

    super.initState();

    Provider.of<SensorDataProvider>(context, listen: false).initPlatformState();
    Future.microtask(() async {
      //to load last refresh time
      loadSavedTime();

      //get all data related to weather
      await context.read<WeatherApiService>().getWeatherData();

      //barometer data
      final pressure = SensorDataProvider().latestPressure;

      sendMessage(pressure.toString());
    });
  }

  final watch = WatchConnectivity();

  ///[sendMessage] function to send data to companion app (Android)
  sendMessage(String text) {
    final message = {
      'pressureData': text,
    };
    watch.sendMessage(message);
  }

  @override
  void didChangeDependencies() {
    if (kDebugMode) {
      print("didChangedDependencies");
    }

    Provider.of<ReverseGeoCodingProvider>(context, listen: false)
        .fetchApiData(context);
    Provider.of<ReverseGeoCodingProvider>(context, listen: false).saveTime();

    loadSavedTime();

    super.didChangeDependencies();
  }

  late String savedTime;

  void loadSavedTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedTime = prefs.getString('saved_time') ?? 'No time saved yet';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return PopScope(
      onPopInvoked: (didPop) {},
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: FutureBuilder<void>(
          future: Provider.of<SensorDataProvider>(context, listen: false)
              .initPlatformState(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _buildStreamBuilder(context);
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text('Error initializing sensor data'));
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
      ),
    );
  }

  Widget _buildStreamBuilder(BuildContext context) {
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
          LavaAnimation(
              color: changeWeatherTheme(
                  context, context.read<WeatherApiService>()),
              child: const SizedBox(
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
          Consumer<ReverseGeoCodingProvider>(
              builder: (context, revGeoCoding, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: !revGeoCoding.isLoading,
                  child: Text(
                    'Last Fetch',
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 6),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Provider.of<ReverseGeoCodingProvider>(context,
                            listen: false)
                        .saveTime();
                    Provider.of<ReverseGeoCodingProvider>(context,
                            listen: false)
                        .fetchApiData(context);
                    await context.read<WeatherApiService>().getWeatherData();
                    loadSavedTime();
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: const Offset(0.0, 0.0),
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOutCubic,
                        )),
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: Consumer<ReverseGeoCodingProvider>(
                      key: ValueKey(revGeoCoding.isLoading),
                      builder: (context, revGeoCoding, child) {
                        return revGeoCoding.isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 9,
                                    width: 9,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 0.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Fetching...",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white, fontSize: 11),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    EvaIcons.refresh_outline,
                                    color: Colors.white,
                                    size: 10,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    savedTime,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white, fontSize: 11),
                                  ),
                                ],
                              );
                      },
                    ),
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
                                                    HapticFeedback
                                                        .lightImpact();
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
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
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
                                                text: displayName,
                                                startAfter: Duration(
                                                    seconds:
                                                        revGeoCoding.isLoading
                                                            ? 5
                                                            : 0),
                                                fadingEdgeEndFraction: 0.15,
                                                fadingEdgeStartFraction: 0.15,
                                                showFadingOnlyWhenScrolling:
                                                    false,
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
                                                accelerationCurve:
                                                    Curves.linear,
                                                decelerationDuration:
                                                    const Duration(
                                                        milliseconds: 500),
                                                decelerationCurve:
                                                    Curves.easeOut,
                                              )

                                              // CustomMarquee(
                                              //   displayName: displayName,
                                              //   revGeoCoding: revGeoCoding,
                                              // ),
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
                      bottom: 5, left: 22, right: 22, top: 5),
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
                              String pressureValue = sensorStream.latestPressure
                                  .toStringAsFixed(1)
                                  .toString();

                              sendMessage(pressureValue);
                              return GestureDetector(
                                onTap: () {
                                  sendMessage(pressureValue);
                                },
                                child: Text(
                                  pressureValue,
                                  style: GoogleFonts.dmSans(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
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
                Consumer2<AltitudeApiProvider, WeatherApiService>(
                    builder: (context, elevationData, weatherService, child) {
                  return elevationData.isLoading == false
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: FlutterCarousel(
                            options: CarouselOptions(
                                autoPlay: true,
                                height: 50,
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 1500),
                                autoPlayCurve: Curves.easeOutCubic,
                                showIndicator: true,
                                enableInfiniteScroll: true,
                                slideIndicator: const CircularSlideIndicator(
                                  slideIndicatorOptions: SlideIndicatorOptions(
                                      indicatorRadius: 2,
                                      itemSpacing: 7,
                                      enableAnimation: true),
                                ),
                                indicatorMargin: 5),
                            items: [
                              CarouselRowItem(
                                icon: "assets/altitude.png",
                                title:
                                    "${elevationData.elevation.toStringAsFixed(0).toString()} m",
                              ),
                              CarouselRowItem(
                                icon: "assets/thermometer.png",
                                title:
                                    "${weatherService.openWeatherDataModel?.main.temp.toStringAsFixed(0).toString()}\u2103",
                              ),
                              CarouselRowItem(
                                icon: "assets/humidity.png",
                                title:
                                    "${weatherService.openWeatherDataModel?.main.humidity.toStringAsFixed(0).toString()}%",
                              ),
                            ],
                          ),
                        )
                      : const SizedBox();
                })
              ],
            );
          }),
        ],
      ),
    );
  }

  List<Widget> list = [];

  @override
  bool get wantKeepAlive => true;
}

class CarouselRowItem extends StatelessWidget {
  final String icon;
  final String title;
  const CarouselRowItem({
    required this.icon,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          icon,
          height: 16,
          width: 16,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          title,
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}

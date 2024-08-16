import 'dart:math';

import 'package:barometer_app/lava_lamp/lava_clock.dart';
import 'package:barometer_app/mixins/_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:wearable_rotary/wearable_rotary.dart';

import '../rotary_controller/rotarysubscription.dart';
import '../services/reverse_geocoding/geocodingapi.dart';
import '../services/weather/api/weather_api_services.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> with dataMixin {
  int _focusedIndex = 0;

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
      // HapticFeedback.lightImpact();
    });
  }

  @override
  void dispose() {
    super.dispose();
    rotarySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    //View
    return Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          height: double.infinity,
          width: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Center(
                child: LavaAnimation(
                    color: changeWeatherTheme(
                        context, context.read<WeatherApiService>()),
                    child: const SizedBox(
                      height: double.infinity,
                      width: 100,
                    )),
              ),
              GlassContainer(
                height: MediaQuery.of(context).size.height,
                blur: 10,
                width: MediaQuery.of(context).size.width,
                borderRadius: BorderRadius.circular(35),
                borderWidth: 0.0,
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
                color: Colors.white.withOpacity(0.05),
              ),
              Column(
                children: [
                  SizedBox(
                    height: _focusedIndex != 0 ? 0 : 20,
                  ),
                  Visibility(
                    visible: _focusedIndex != 0 ? false : true,
                    child: SizedBox(
                        height: 17,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            HapticFeedback.lightImpact();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 3),
                                child: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                              Text("Back",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                        )),
                  ),
                  Consumer<ReverseGeoCodingProvider>(
                      builder: (context, revGeoCode, child) {
                    if (revGeoCode.reverseGeoModel != null) {
                      //Details data
                      final detailsData = revGeoCode.reverseGeoModel!.address;

                      //Converting coordinates string to double to trim the decimal
                      String latitude = revGeoCode.reverseGeoModel!.lat!;
                      double latDouble = double.parse(latitude);
                      String longitude = revGeoCode.reverseGeoModel!.lon!;
                      double lonDouble = double.parse(longitude);

                      //Latitude and Longitude
                      final latNlong =
                          "${latDouble.toStringAsFixed(4)},${lonDouble.toStringAsFixed(4)}";

                      //Data for ListView
                      final List<Map<String, dynamic>> data = [
                        {
                          "data": detailsData!.postcode ?? 'Unavailable',
                          "title": 'Postcode'
                        },
                        {
                          "data": detailsData.stateDistrict ?? 'Unavailabe',
                          "title": 'State/District'
                        },
                        {
                          "data": detailsData.village ??
                              detailsData.county ??
                              detailsData.city ??
                              'Unavailabe',
                          "title": 'City/Village/County'
                        },
                        {
                          "data": detailsData.road ?? 'Road Unavailabe',
                          "title": 'Road'
                        },
                        {"data": latNlong, "title": "Lat/Long"}
                      ];

                      return Expanded(
                        child: ScrollSnapList(
                          listController:
                              RotaryScrollController(maxIncrement: 10),

                          updateOnScroll: true,
                          scrollDirection: Axis.vertical,
                          onItemFocus: _onItemFocus,
                          clipBehavior: Clip.hardEdge,
                          dynamicSizeEquation: (distance) {
                            return 1 - min(distance.abs() / 300, 0.2);
                          },
                          initialIndex: 0,
                          scrollPhysics: const BouncingScrollPhysics(),

                          itemSize: 80,
                          itemCount: data.length,
                          itemBuilder: (_, index) {
                            return Visibility(
                              visible: data[index]['data'] != 'Unavailabe',
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Container(
                                  height: 78,
                                  width:
                                      MediaQuery.of(context).size.width * 0.83,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(35),
                                      color: changeWeatherTheme(context,
                                              context.read<WeatherApiService>())
                                          .withOpacity(0.2)

                                      // const Color.fromARGB(255, 203, 113, 255)
                                      // .withOpacity(0.2),
                                      ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data[index]['title'],
                                            style: GoogleFonts.poppins(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            data[index]['data'],
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  // ),
                                ),
                              ),
                            );
                          },
                          selectedItemAnchor: SelectedItemAnchor.MIDDLE,
                          dynamicItemSize: true,
                          // dynamicSizeEquation: customEquation, //optional
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.purple,
                          strokeWidth: 2,
                        ),
                      );
                    }
                  }),
                ],
              ),
            ],
          ),
        ));
  }

  // @override
  // bool get wantKeepAlive => true;
}

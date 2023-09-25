import 'package:barometer_app/lava_lamp/lava_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../services/reverse_geocoding/geocodingapi.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int _focusedIndex = 0;

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Data
    final revGeoCode =
        Provider.of<ReverseGeoCodingProvider>(context, listen: true)
            .reverseGeoModel;

    //Details data
    final detailsData = revGeoCode!.address;

    //Converting coordinates string to double to trim the decimal
    String latitude = revGeoCode.lat!;
    double latDouble = double.parse(latitude);
    String longitude = revGeoCode.lon!;
    double lonDouble = double.parse(longitude);

    //Latitude and Longitude
    final latNlong =
        "${latDouble.toStringAsFixed(4)},${lonDouble.toStringAsFixed(4)}";

    //Data for ListView
    final List<Map<String, dynamic>> data = [
      {"data": detailsData!.postcode ?? 'Unavailable', "title": 'Postcode'},
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
      {"data": detailsData.road ?? 'Road Unavailabe', "title": 'Road'},
      {"data": latNlong, "title": "Lat/Long"}
    ];

    //View
    return Scaffold(
        backgroundColor: Colors.black,
        body: revGeoCode.lat == null
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                  strokeWidth: 2,
                ),
              )
            : SizedBox(
                height: double.infinity,
                width: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    const Center(
                      child: LavaAnimation(
                          child: SizedBox(
                        height: double.infinity,
                        width: 120,
                      )),
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
                        Expanded(
                          child: ScrollSnapList(
                            updateOnScroll: true,
                            scrollDirection: Axis.vertical,
                            onItemFocus: _onItemFocus,
                            initialIndex: 0,
                            scrollPhysics: const BouncingScrollPhysics(),

                            itemSize: 80,
                            itemCount: data.length,
                            itemBuilder: (p0, index) {
                              // print("----${data.length}");
                              return GlassContainer(
                                isFrostedGlass: true,
                                frostedOpacity: 0.05,
                                height: 80,
                                blur: 10,
                                width: MediaQuery.of(context).size.width * 0.95,
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
                                color: Colors.white.withOpacity(0.1),
                                child: Container(
                                  height: 78,
                                  width:
                                      MediaQuery.of(context).size.width * 0.83,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35),
                                    color: Colors.white.withOpacity(0.0),
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
                                ),
                              );
                            },

                            dynamicItemSize: true,
                            // dynamicSizeEquation: customEquation, //optional
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
  }

  // @override
  // bool get wantKeepAlive => true;
}

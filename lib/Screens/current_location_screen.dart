import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'package:hubcare/Constants/ColorCodes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

import '../Constants/AppConstants.dart';
import '../Constants/BackgroundShap.dart';
import '../Constants/BaseUrl.dart';
import '../Constants/HttpService.dart';
import '../Constants/SharedPreference.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  String locationTitle = 'Select Location';
  String fullAddress = '';
  Position? _currentPosition;
  var token = "";
  double latitude = 0.0;
  double longitude = 0.0;
  GoogleMapController? myController;
  late Marker marker;
  List<Marker> markers = <Marker>[];
  LatLng _center = const LatLng(22.7004041, 75.8738072);

  @override
  void initState() {
    SharedPreference.getString(AppConstants.loginToken).then((v) {
      setState(() {
        token = v;
        _getCurrentLocation();
      });
    });
    super.initState();
  }


  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
      Fluttertoast.showToast(msg: "Location permission denied", backgroundColor: Colors.red);
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks[0];

    setState(() {
      _currentPosition = position;
      locationTitle = "My Current Location";
      fullAddress = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    });

  }


  Future<void> _sendLocationToServer() async {
    if (_currentPosition == null) {
      Fluttertoast.showToast(
        msg: "Please select location first",
        backgroundColor: Colors.red,
      );
      return;
    }


     latitude = _currentPosition?.latitude ?? 0.0;
     longitude = _currentPosition?.longitude ?? 0.0;

    try {
      dynamic data = {
        'address': fullAddress,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      };
      print(data);
      HttpService.postWithHeader(BaseUrl.userLocation, data,token).then((response) {
        setState(() {
          Map<String, dynamic> responseJson = json.decode(response.body);
          if (responseJson['status']) {
            debugPrint(responseJson.toString());
            Get.back();

          } else {
            Fluttertoast.showToast(
                msg: responseJson['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: AppColors.themeColor,
                textColor: Colors.black,
                fontSize: 16.0);
          }
        });
      });
    } on Exception catch (_, e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            // onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 17.0,
            ),
            // markers: _markers,
            mapType: MapType.normal,
            compassEnabled: true,
            markers: Set<Marker>.of(markers),
            onMapCreated: (GoogleMapController controller) {
              myController = controller;
            },
          ),
          Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: SvgPicture.asset('assets/backArrow.svg',height: 28,)),
                      SizedBox(height: 20,),
                      const Text(
                        "Where do you want your service?",
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      GooglePlaceAutoCompleteTextField(
                        textEditingController: _searchController,
                        googleAPIKey: AppConstants.googleKey,
                        inputDecoration: InputDecoration(
                            hintText: 'Search for area',
                            hintStyle: TextStyle(
                                fontSize: 14,
                                color: AppColors.fontGrayColors),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: const BorderSide(
                                width: 0,
                                // color: AppColors.green_color.withOpacity(.3),
                                style: BorderStyle.none,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.whiteColor
                                      .withOpacity(.5),
                                  width: 1.0),
                              borderRadius:
                              BorderRadius.circular(7.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.whiteColor
                                      .withOpacity(.5),
                                  width: 1.0),
                              borderRadius:
                              BorderRadius.circular(7.0),
                            ),
                            filled: true,
                            fillColor:
                            AppColors.whiteColor.withOpacity(.5),
                            contentPadding: const EdgeInsets.all(7),
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 20,
                            )),
                        debounceTime: 800,
                        // default 600 ms,
                        countries: const ["in"],
                        // optional by default null is set
                        isLatLngRequired: true,
                        // if you required coordinates from place detail
                        boxDecoration: Shap()
                            .dynamicBackgroundDecoration(
                            AppColors.whiteColor,
                            AppColors.grayColor66,
                            8),

                        getPlaceDetailWithLatLng:
                            (Prediction prediction) {
                          // this method will return latlng with place detail
                          print("placeDetails  ${prediction.lng}");
                          setState(() {
                            latitude = double.parse(prediction.lat.toString());
                            longitude = double.parse(prediction.lng.toString());
                            markers.add(
                                Marker(
                                  markerId: const MarkerId('SomeId'),
                                  position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                                  // infoWindow: InfoWindow(title: 'The title of the marker')
                                )
                            );

                          });
                        },
                        // this callback is called when isLatLngRequired is true
                        itemClick: (Prediction prediction) {
                          setState(() {
                            fullAddress = prediction.description!;
                          });

                          _searchController.text =
                          prediction.description!;
                          _searchController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: prediction
                                      .description!.length));
                        },
                        // if we want to make custom list item builder
                        itemBuilder:
                            (context, index, Prediction prediction) {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on),
                                const SizedBox(
                                  width: 7,
                                ),
                                Expanded(
                                    child: Text(
                                        prediction.description ?? ""))
                              ],
                            ),
                          );
                        },
                        // if you want to add seperator between list items
                        seperatedBuilder: const Divider(),
                        // want to show close icon
                        isCrossBtnShown: true,
                        // optional container padding
                        containerHorizontalPadding: 10,
                      ),
                      // TextField(
                      //   controller: _searchController,
                      //   decoration: InputDecoration(
                      //     hintText: "Search address",
                      //     prefixIcon: const Icon(Icons.search),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     filled: true,
                      //     fillColor: Colors.grey[200],
                      //   ),
                      // ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: _getCurrentLocation,
                        child: Row(
                          children: const [
                            Icon(Icons.my_location, color: Colors.purple),
                            SizedBox(width: 8),
                            Text(
                              "Use my current location",
                              style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Bottom Location Card
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.location_on, color: Colors.purple),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  locationTitle,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  fullAddress.isNotEmpty ? fullAddress : "No address selected",
                                  style: const TextStyle(color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // TextButton(
                          //   onPressed: () {
                          //     // Change action: maybe reopen search?
                          //     _getCurrentLocation();
                          //   },
                          //   child: const Text(
                          //     "CHANGE",
                          //     style: TextStyle(color: Colors.purple),
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _sendLocationToServer,
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(child: Text("Save",style: TextStyle(color: AppColors.whiteColor,fontSize: 16,fontWeight: FontWeight.w500),)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

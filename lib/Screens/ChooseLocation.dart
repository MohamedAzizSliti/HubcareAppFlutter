import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import 'package:http/http.dart' as http;
import 'package:hubcare/Screens/HomeScreen.dart';

import '../Constants/AppConstants.dart';
import '../Constants/BackgroundShap.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/ConstImage.dart';
import '../Constants/SharedPreference.dart';
import '../Widgets/button_widget.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({Key? key}) : super(key: key);

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  TextStyle basicText = TextStyle(
      fontSize: 22.0, fontWeight: FontWeight.w700, color: AppColors.blackColor);

  TextStyle smallText = TextStyle(
      fontSize: 13.0, fontWeight: FontWeight.w500, color: AppColors.fontColors);

  TextStyle editText = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w600, color: AppColors.blackColor);

  TextStyle hintText = TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: AppColors.fontGrayColors);

  GoogleMapController? myController;
  late Marker marker;
  LatLng _center = const LatLng(22.7004041, 75.8738072);
  Position? _currentPosition;
  final String _currentAddress = "Address";
  String _currentFullAddress = "";
  String firstAddName = "";
  String token = "";
  List<LatLng> area = [];
  bool isWhiteListArea = false;
  List<Point> points = <Point>[];

  Future<void> _getCurrentPosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else {
      // throw Exception('Error');
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.medium)
          .then((Position position) {
        setState(() {
          _currentPosition = position;
          markers.add(
              Marker(
                  markerId: const MarkerId('SomeId'),
                  position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                 // infoWindow: InfoWindow(title: 'The title of the marker')
              )
          );
          debugPrint(_currentPosition!.longitude.toString());
          latitude = _currentPosition!.latitude.toString();
          longitude = _currentPosition!.longitude.toString();
          _center =
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
        });

        _getAddressFromLatLng(position);
        getAddressFromLatLng(_currentPosition!.latitude, _currentPosition!.longitude);
       // printAddress(_currentPosition!.latitude, _currentPosition!.longitude);
      }).catchError((e) {
        debugPrint(e.toString());
      });
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        //_currentAddress = place.subLocality!;

        _currentFullAddress =
            '${place.street}, ${place.subLocality},${place.administrativeArea}';


        // '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
        debugPrint('${place.name},${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}');
      //  debugPrint('second == ${place1.name},${place1.street}, ${place1.subLocality},${place1.subAdministrativeArea}, ${place1.postalCode}');
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  getAddressFromLatLng(double lat, double lng) async {
    String host = 'https://maps.google.com/maps/api/geocode/json';
    final url = '$host?key=${AppConstants.googleKey}&language=en&latlng=$lat,$lng';
    print("response URL ====>> $url");
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      Map data = jsonDecode(response.body);
     // print("response ====>> $data");
      String formattedAddress = data["results"][0]["formatted_address"];
      print("response ====> $formattedAddress");

      setState(() {

        // city = "${data["results"][0]["address_components"][6]['long_name']}";
        // state = "${data["results"][0]["address_components"][8]['long_name']}";
        // piCode = "${data["results"][0]["address_components"][10]['long_name']}";
      });
      return formattedAddress;
    } else {
      return null;
    }
    }

  String _address = "";
  printAddress(double lat, double lng) async {
    List<Placemark> newPlace = await placemarkFromCoordinates(lat, lng);
    Placemark placeMark  = newPlace[0];
    String? name = placeMark.name;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;
    String address = "$name, $subLocality, $locality, $administrativeArea $postalCode, $country";
   // print(address); // do what you want with it

    setState(() {
      _address = address;
      city = locality!;
      state = administrativeArea!;
      piCode = postalCode!;
    });

    print("response _address $locality ====> $address");
  }

  List<Marker> markers = <Marker>[];
  bool isLoading = false;
  var latitude = "";
  var longitude = "";
  TextEditingController searchController = TextEditingController();
  dynamic argumentData = Get.arguments;
  var city = "";
  var state = "";
  var piCode = "";
  var isPickupDrop = "";
  var stopData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print(argumentData[1]);
    print("argumentData[0] lo");
    isPickupDrop = argumentData[0];

    _getCurrentPosition();
    Timer(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
    SharedPreference.getString(AppConstants.loginToken).then((value) {
      setState(() {
        //token = value;
        //isLoading = true;

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.inputCornerColor,
          title: Row(
            children: [
              Expanded(
                child: InkWell(
                    onTap: () {
                        Get.back();
                    },
                    child: ConstImage().buildSvgImage('back_btn.svg', 40)),
              ),
              const SizedBox(width: 7,),
              const Spacer(),
              Text(
                'Where do you want your service?',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.fontColors),
              ),
              const Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: AppColors.themeColor,
              ))
            : SafeArea(
                child: Padding(
                    padding: const EdgeInsets.only(left: 1, right: 1),
                    child: Stack(
                      children: [
                        // ConstImage().buildImage('map.png', MediaQuery.of(context).size.width, 620),
                      /*  GoogleMap(
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
                        ),*/
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 25,
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: GooglePlaceAutoCompleteTextField(
                                  textEditingController: searchController,
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
                                      latitude = prediction.lat.toString();
                                      longitude = prediction.lng.toString();

                                      printAddress(double.parse(latitude), double.parse(longitude));
                                      //getAddressFromLatLng(double.parse(latitude), double.parse(longitude));
                                      print(("${LatLng(double.parse(latitude), double.parse(longitude))} == >"));
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
                                      printAddress(double.parse(latitude), double.parse(longitude));
                                      _currentFullAddress = prediction.description!;
                                      Timer(const Duration(milliseconds: 1500),(){

                                      Map<String, String> data;
                                      if(isPickupDrop == "pickup"){
                                        data = {
                                          'city': city,
                                          'state': state,
                                          'pinCode': piCode,
                                          'lat': latitude,
                                          'lng': longitude,
                                          'add': _currentFullAddress,
                                        };
                                        print(data);

                                      //  Get.to(() => const AddPickupAddress(), arguments: [data,argumentData[1]]);
                                      }



                                      });
                                    });

                                    searchController.text =
                                        prediction.description!;
                                    searchController.selection =
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
                              ),
                              const Expanded(
                                child: SizedBox(
                                  height: 5,
                                ),
                              ),
                             // if(isPickupDrop == "pickup" || isPickupDrop == "drop")
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 16, left: 8, right: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.whiteColor.withOpacity(0.2),
                                  ),
                                  color: AppColors.whiteColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0)),
                                ),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: AppColors.themeColor,
                                            size: 20,
                                          ),
                                          Text(
                                            _currentAddress,
                                            textAlign: TextAlign.center,
                                            style: editText,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        _currentFullAddress,
                                        textAlign: TextAlign.start,
                                        style: smallText,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      /*ButtonWidget(
                                        icon: Icons.my_location,
                                          text: 'Use current location',
                                          onPressed: () {
                                            Get.to(() => const HomeScreen());
                                            Map<String, String> data;
                                          *//*if(isPickupDrop == "pickup"){
                                            data = {
                                              'city': city,
                                              'state': state,
                                              'pinCode': piCode,
                                              'lat': latitude,
                                              'lng': longitude,
                                              'add': _currentFullAddress,
                                            };
                                           // print(data);
                                          }*//*


                                          }),
                                      const SizedBox(
                                        height: 15,
                                      ),*/
                                      ButtonWidget(

                                          text: 'Continue',
                                          onPressed: () {
                                            Get.to(() => const HomeScreen());
                                            Map<String, String> data;
                                          /*if(isPickupDrop == "pickup"){
                                            data = {
                                              'city': city,
                                              'state': state,
                                              'pinCode': piCode,
                                              'lat': latitude,
                                              'lng': longitude,
                                              'add': _currentFullAddress,
                                            };
                                           // print(data);
                                          }*/


                                          }),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ]),
                              ),
                            ]),
                      ],
                    ))));
  }

}

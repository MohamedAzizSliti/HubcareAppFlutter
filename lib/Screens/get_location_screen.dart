// location_list_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../Constants/AppConstants.dart';
import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/HttpService.dart';
import '../Constants/SharedPreference.dart';

class LocationGetScreen extends StatefulWidget {
  List<dynamic> locations;
   LocationGetScreen({Key? key,required this.locations}) : super(key: key);

  @override
  State<LocationGetScreen> createState() => _LocationGetScreenState();
}

class _LocationGetScreenState extends State<LocationGetScreen> {

  String? selectedLocationId;


  @override
  void initState() {
    super.initState();
  }



  void onLocationSelected(String locationId) {
    setState(() {
      selectedLocationId = locationId;
    });
    print('Selected location ID: $locationId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // Optional: Remove shadow
        title: Row(
          children: [
            InkWell(
                onTap: () {
                  Get.back();
                },
                child: SvgPicture.asset(
                  'assets/backArrow.svg',
                  height: 28,
                )),
            const SizedBox(
              width: 5,
            ),
            Text(
              'Select Location',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount:  widget.locations.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final location =  widget.locations[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selectedLocationId == location["id"] ? Colors.purple : Colors.grey.shade300,
                width: selectedLocationId ==  location["id"] ? 2 : 1,
              ),
            ),
            child: RadioListTile<String>(
              value: location['id'],
              groupValue: selectedLocationId,
              onChanged: (value) => onLocationSelected(value!),
              activeColor: Colors.purple,
              title: Text(
                location['address'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: selectedLocationId != null
              ? () {
            final selected =  widget.locations..asMap().forEach((index,loc) => loc['id'] == selectedLocationId);
            widget.locations..asMap().forEach((index,loc){
              if(loc['id'] == selectedLocationId){
                Navigator.pop(context, index);
              }
            });


          }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            'Confirm Location',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: AppColors.whiteColor),
          ),
        ),
      ),
    );
  }
}



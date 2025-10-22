import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:hubcare/Constants/ConstImage.dart';
import 'package:hubcare/Screens/BookingDone.dart';
import 'package:hubcare/Screens/PaymentSummary.dart';
import 'package:hubcare/Widgets/button_widget.dart';

import '../Constants/AppConstants.dart';
import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/HttpService.dart';
import '../Constants/SharedPreference.dart';
import 'current_location_screen.dart';
import 'get_location_screen.dart';

class Summary extends StatefulWidget {
  String serviceId;
  String servicePrice;
  String serviceName;
  bool promoCode;
   Summary({super.key,required this.serviceId,required this.serviceName,required this.servicePrice, this.promoCode = false});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  TextStyle smallText = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w500, color: AppColors.blackColor);

  String? _selectedValue = "1";
  List<String> listOfValue = ['1', '2', '3', '4', '5'];
  String? _selectedWorker = "1";
  List<String> listOfWorkers = ['1', '2', '3', '4', '5'];
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  bool isLoading = true;
  var token = "";
  List<dynamic> locations = [];
  int selectLocationIndex = 0;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  int isOpen = 0;
  @override
  void initState() {
    SharedPreference.getString(AppConstants.loginToken).then((value) {
      setState(() {
        token = value;
        fetchLocations();
      });
    });
    super.initState();
  }

  Future<void> fetchLocations() async {
    var url = BaseUrl.getLocation;
    HttpService.getDataWithHeader(url,token).then((response) {
      setState(() {
        // ignore: avoid_print
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['status'] == true) {
          setState(() {
            locations = responseJson['data']; // <- Use 'data' array
            isLoading = false;
          });
        } else {
          Fluttertoast.showToast(
              msg: responseJson['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: AppColors.themeColor,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    });
  }

  // Select Date
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Select Time
  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // String get formattedDate {
  //   if (selectedDate == null) return 'Select Date';
  //   return "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
  // }

  String get formattedDate {
    if (selectedDate == null) return 'Select Date';
    return DateFormat('yyyy-MM-dd').format(selectedDate!);
  }

  String get formattedTime {
    if (selectedTime == null) return 'Select Time';
    final hour = selectedTime!.hourOfPeriod.toString().padLeft(2, '0');
    final minute = selectedTime!.minute.toString().padLeft(2, '0');
    final period = selectedTime!.period == DayPeriod.am ? 'AM' : 'PM';
    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    if(formattedDate.isNotEmpty && formattedTime.isNotEmpty){
      dateController.text = formattedDate;
      timeController.text = formattedTime;
    }
    return Scaffold(
      // backgroundColor: AppColors.whiteColor,
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
              'Summary',
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
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 17, right: 17),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 7, bottom: 1),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.whiteColor.withOpacity(0.1),
                          ),
                          color: AppColors.whiteColor,
                          shape: BoxShape.rectangle,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 7, right: 7),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'SERVICE',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.themeColor),
                                      ),
                                      Text(
                                        widget.serviceName,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.blackColor),
                                      ),
                                    ],
                                  ),
                                  Expanded(child: SizedBox(width: 5)),
                                  Text(
                                    'QR ${widget.servicePrice}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'PER HR.',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.themeColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 7, right: 7, top: 5, bottom: 7),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.themeColor.withOpacity(0.1),
                                ),
                                color: AppColors.themeColor.withOpacity(0.3),
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Set Number of Worker you want!',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.themeColor),
                                        ),
                                        Text(
                                          'Charges depend on workers, time taken, and partial hours are included',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.blackColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  SizedBox(
                                    width: 60,
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          borderSide: BorderSide(
                                            width: 0,
                                            color: AppColors.blackColor
                                                .withOpacity(.9),
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.blackColor
                                                  .withOpacity(.9),
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.blackColor
                                                  .withOpacity(.9),
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(.2),
                                        contentPadding: const EdgeInsets.all(7),
                                      ),
                                      value: _selectedWorker,
                                      hint: Text(
                                        'choose one',
                                      ),
                                      isExpanded: true,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedWorker = value;
                                        });
                                      },
                                      onSaved: (value) {
                                        setState(() {
                                          _selectedWorker = value;
                                        });
                                      },
                                      items: listOfWorkers.map((String val) {
                                        return DropdownMenuItem(
                                          value: val,
                                          child: Text(
                                            val,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.grayColor66.withOpacity(0.3),
                              ),
                              color: AppColors.whiteColor,
                              shape: BoxShape.rectangle,
                              borderRadius: const BorderRadius.all(
                                   Radius.circular(17.0)),
                            ),
                            child: Row(

                              children: [
                                ConstImage().buildSvgImage('pinIcon.svg', 40),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //   'Preston Rd',
                                      //   textAlign: TextAlign.start,
                                      //   style: TextStyle(
                                      //       fontSize: 14.0,
                                      //       fontWeight: FontWeight.w600,
                                      //       color: AppColors.themeColor),
                                      // ),
                                      locations.isNotEmpty ?
                                      Text(
                                        locations[selectLocationIndex]['address'],
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.blackColor),
                                      ):Container(),
                                    ],
                                  ),
                                ),

                                locations.isNotEmpty ?
                                SizedBox(
                                  width: 75,
                                  height: 35,
                                  child: TextButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(
                                            AppColors.blue_light_color),
                                        shape:
                                        MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ))),
                                    onPressed: () {
                                      Get.to(LocationGetScreen(locations: locations,))?.then((onValue){
                                        if(onValue!=null){
                                          selectLocationIndex = onValue;
                                          setState(() {});
                                        }

                                      });

                                    },
                                    child: const Text('Change',
                                        style: TextStyle(color: Colors.blue)),
                                  ),
                                ):
                                SizedBox(
                                  width: 75,
                                  height: 35,
                                  child: TextButton(
                                    style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty.all(
                                            AppColors.blue_light_color),
                                        shape:
                                        WidgetStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ))),
                                    onPressed: () {
                                      Get.to(LocationScreen())?.then((onValue){
                                          fetchLocations();
                                          setState(() {});
                                      });

                                    },
                                    child: const Text('Add',
                                        style: TextStyle(color: Colors.blue)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            color: AppColors.inputColor.withOpacity(
                              .8,
                            ),
                            height: 1,
                            width: MediaQuery.of(context).size.width - 10,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'When do you want your service ?',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Select date for service',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blackColor),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            onTap: _pickDate,
                            controller: dateController,
                            style: smallText,
                            readOnly: true,
                            keyboardType: TextInputType.datetime,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: 'DD MM YYYY',
                              hintStyle: smallText,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                  width: 0,
                                  color: AppColors.blackColor,
                                  style: BorderStyle.none,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.blackColor, width: 1.0),
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.blackColor, width: 1.0),
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              filled: true,
                              fillColor: AppColors.whiteColor,
                              contentPadding: const EdgeInsets.all(7),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  // selectedDate = DateTime.now();
                                  // _selectDate(context);
                                },
                                icon: const Icon(Icons.date_range_sharp),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please select Birth Date';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Select start time of service',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Service will start according to time consumption and price added accordingly',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blackColor),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          TextFormField(
                            onTap: _pickTime,
                            controller: timeController,
                            style: smallText,
                            readOnly: true,
                            keyboardType: TextInputType.datetime,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: 'HH:MM PM',
                              hintStyle: smallText,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                  width: 0,
                                  color: AppColors.blackColor,
                                  style: BorderStyle.none,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.blackColor, width: 1.0),
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.blackColor, width: 1.0),
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              filled: true,
                              fillColor: AppColors.whiteColor,
                              contentPadding: const EdgeInsets.all(7),
                              suffixIcon: IconButton(
                                onPressed: () {

                                },
                                icon: const Icon(Icons.access_time),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please select Birth Date';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Select Work Hours',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            'Choose work hours to calculate service time and pricing automatically.',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blackColor),
                          ),
                          SizedBox(height: 5),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                  width: 0,
                                  color: AppColors.blackColor.withOpacity(.9),
                                  style: BorderStyle.none,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.blackColor.withOpacity(.9),
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.blackColor.withOpacity(.9),
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(.2),
                              contentPadding: const EdgeInsets.all(7),
                            ),
                            value: _selectedValue,
                            hint: Text(
                              'choose one',
                            ),
                            isExpanded: true,
                            onChanged: (value) {
                              setState(() {
                                _selectedValue = value;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                _selectedValue = value;
                              });
                            },
                            items: listOfValue.map((String val) {
                              return DropdownMenuItem(
                                value: val,
                                child: Text(
                                  val,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ButtonWidget(
                              text: 'Proceed to Book',
                              onPressed: () {
                                print(formattedDate);
                                if(formattedDate!="Select Date" &&
                                    formattedTime!="Select Time" && locations.isNotEmpty){
                                  Get.to(() => PaymentSummary(
                                    servicePrice: widget.servicePrice,
                                    serviceName: widget.serviceName,serviceId: widget.serviceId,
                                    serviceDate: formattedDate,
                                    serviceTime: formattedTime,
                                    numberOfWorker: _selectedWorker.toString(),
                                    workHours: _selectedValue.toString(),
                                    locationId: locations[selectLocationIndex]['id'],
                                    promoCode: widget.promoCode,
                                  ));
                                }

                                setState(() {
                                });
                              })
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ]),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:hubcare/Screens/HomeScreen.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

import '../Constants/AppConstants.dart';
import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/ConnectivityUtil.dart';
import '../Constants/HttpService.dart';
import '../Constants/InputField.dart';
import '../Constants/SharedPreference.dart';
import '../Widgets/button_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextStyle smallText = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w500, color: AppColors.blackColor);
  TextStyle editText = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w600, color: AppColors.blackColor);

  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  String? dropdownValue;

  String _selectedGender = "";
  String phone = '';
  String profile = '';
  String userId = '';
  String birthDate = '';
  File _pickedImage1 = File("");
  File _pickedImage = File("");
  PickedFile? imageFile;
  var countries = [];

  bool isLoading = false;
  var token = "";
  var argumentData = Get.arguments;

  // Add these variables for dynamic country code handling
  String country_code = "";
  String initialCountryCode = 'QA'; // default
  Key phoneFieldKey = UniqueKey(); // Key to force rebuild IntlPhoneField

  final Map<String, String> countryDialCodeToISO = {
    // --- A ---
    '+93': 'AF', // Afghanistan
    '+355': 'AL', // Albania
    '+213': 'DZ', // Algeria
    '+376': 'AD', // Andorra
    '+244': 'AO', // Angola
    '+1264': 'AI', // Anguilla (NANP)
    '+672': 'AQ', // Antarctica
    '+1268': 'AG', // Antigua & Barbuda (NANP)
    '+54': 'AR', // Argentina
    '+374': 'AM', // Armenia
    '+297': 'AW', // Aruba
    '+61': 'AU', // Australia
    '+43': 'AT', // Austria
    '+994': 'AZ', // Azerbaijan
    // --- B ---
    '+1242': 'BS', // Bahamas (NANP)
    '+973': 'BH', // Bahrain
    '+880': 'BD', // Bangladesh
    '+1246': 'BB', // Barbados (NANP)
    '+375': 'BY', // Belarus
    '+32': 'BE', // Belgium
    '+501': 'BZ', // Belize
    '+229': 'BJ', // Benin
    '+1441': 'BM', // Bermuda (NANP)
    '+975': 'BT', // Bhutan
    '+591': 'BO', // Bolivia
    '+387': 'BA', // Bosnia & Herzegovina
    '+267': 'BW', // Botswana
    '+55': 'BR', // Brazil
    '+1284': 'VG', // British Virgin Islands (NANP)
    '+673': 'BN', // Brunei
    '+359': 'BG', // Bulgaria
    '+226': 'BF', // Burkina Faso
    '+257': 'BI', // Burundi
    // --- C ---
    '+855': 'KH', // Cambodia
    '+237': 'CM', // Cameroon
    '+1': 'CA', // Canada (NANP) - General NANP entry, but often separated from US
    '+238': 'CV', // Cape Verde
    '+1345': 'KY', // Cayman Islands (NANP)
    '+236': 'CF', // Central African Republic
    '+235': 'TD', // Chad
    '+56': 'CL', // Chile
    '+86': 'CN', // China
    '+6189164': 'CX', // Christmas Island (part of AU +61)
    '+6189162': 'CC', // Cocos (Keeling) Islands (part of AU +61)
    '+57': 'CO', // Colombia
    '+269': 'KM', // Comoros
    '+242': 'CG', // Congo - Brazzaville
    '+243': 'CD', // Congo - Kinshasa (DRC)
    '+682': 'CK', // Cook Islands
    '+506': 'CR', // Costa Rica
    '+385': 'HR', // Croatia
    '+53': 'CU', // Cuba
    '+599': 'CW', // Curaçao (Used to be Netherlands Antilles)
    '+357': 'CY', // Cyprus
    '+420': 'CZ', // Czech Republic
    // --- D ---
    '+45': 'DK', // Denmark
    '+253': 'DJ', // Djibouti
    '+1767': 'DM', // Dominica (NANP)
    '+1809': 'DO', // Dominican Republic (NANP)
    '+1829': 'DO', // Dominican Republic (NANP)
    '+1849': 'DO', // Dominican Republic (NANP)
    // --- E ---
    '+593': 'EC', // Ecuador
    '+20': 'EG', // Egypt
    '+503': 'SV', // El Salvador
    '+240': 'GQ', // Equatorial Guinea
    '+291': 'ER', // Eritrea
    '+372': 'EE', // Estonia
    '+251': 'ET', // Ethiopia
    // --- F ---
    '+500': 'FK', // Falkland Islands
    '+298': 'FO', // Faroe Islands
    '+679': 'FJ', // Fiji
    '+358': 'FI', // Finland
    '+33': 'FR', // France
    '+594': 'GF', // French Guiana
    '+689': 'PF', // French Polynesia
    // --- G ---
    '+241': 'GA', // Gabon
    '+220': 'GM', // Gambia
    '+995': 'GE', // Georgia
    '+49': 'DE', // Germany
    '+233': 'GH', // Ghana
    '+350': 'GI', // Gibraltar
    '+30': 'GR', // Greece
    '+299': 'GL', // Greenland
    '+1473': 'GD', // Grenada (NANP)
    '+590': 'GP', // Guadeloupe (French Antilles)
    '+1671': 'GU', // Guam (NANP)
    '+502': 'GT', // Guatemala
    '+44': 'GG', // Guernsey (UK Crown Dependency)
    '+224': 'GN', // Guinea
    '+245': 'GW', // Guinea-Bissau
    '+592': 'GY', // Guyana
    // --- H ---
    '+509': 'HT', // Haiti
    '+504': 'HN', // Honduras
    '+852': 'HK', // Hong Kong
    '+36': 'HU', // Hungary
    // --- I ---
    '+354': 'IS', // Iceland
    '+91': 'IN', // India
    '+62': 'ID', // Indonesia
    '+98': 'IR', // Iran
    '+964': 'IQ', // Iraq
    '+353': 'IE', // Ireland
    '+44': 'IM', // Isle of Man (UK Crown Dependency)
    '+972': 'IL', // Israel
    '+39': 'IT', // Italy (official code)
    // --- J ---
    '+1876': 'JM', // Jamaica (NANP)
    '+81': 'JP', // Japan
    '+44': 'JE', // Jersey (UK Crown Dependency)
    '+962': 'JO', // Jordan
    // --- K ---
    '+7': 'KZ', // Kazakhstan (shares with RU)
    '+254': 'KE', // Kenya
    '+686': 'KI', // Kiribati
    '+965': 'KW', // Kuwait
    '+996': 'KG', // Kyrgyzstan
    // --- L ---
    '+856': 'LA', // Laos
    '+371': 'LV', // Latvia
    '+961': 'LB', // Lebanon
    '+266': 'LS', // Lesotho
    '+231': 'LR', // Liberia
    '+218': 'LY', // Libya
    '+423': 'LI', // Liechtenstein
    '+370': 'LT', // Lithuania
    '+352': 'LU', // Luxembourg
    // --- M ---
    '+853': 'MO', // Macao
    '+389': 'MK', // Macedonia (North Macedonia)
    '+261': 'MG', // Madagascar
    '+265': 'MW', // Malawi
    '+60': 'MY', // Malaysia
    '+960': 'MV', // Maldives
    '+223': 'ML', // Mali
    '+356': 'MT', // Malta
    '+692': 'MH', // Marshall Islands
    '+596': 'MQ', // Martinique (French Antilles)
    '+222': 'MR', // Mauritania
    '+230': 'MU', // Mauritius
    '+262': 'YT', // Mayotte
    '+52': 'MX', // Mexico
    '+691': 'FM', // Micronesia
    '+373': 'MD', // Moldova
    '+377': 'MC', // Monaco
    '+976': 'MN', // Mongolia
    '+382': 'ME', // Montenegro
    '+1664': 'MS', // Montserrat (NANP)
    '+212': 'MA', // Morocco
    '+258': 'MZ', // Mozambique
    '+95': 'MM', // Myanmar (Burma)
    // --- N ---
    '+264': 'NA', // Namibia
    '+674': 'NR', // Nauru
    '+977': 'NP', // Nepal
    '+31': 'NL', // Netherlands
    '+599': 'AN', // Netherlands Antilles (Legacy code for Curaçao/Sint Maarten)
    '+687': 'NC', // New Caledonia
    '+64': 'NZ', // New Zealand
    '+505': 'NI', // Nicaragua
    '+227': 'NE', // Niger
    '+234': 'NG', // Nigeria
    '+683': 'NU', // Niue
    '+672': 'NF', // Norfolk Island
    '+850': 'KP', // North Korea
    '+1670': 'MP', // Northern Mariana Islands (NANP)
    '+47': 'NO', // Norway
    // --- O ---
    '+968': 'OM', // Oman
    // --- P ---
    '+92': 'PK', // Pakistan
    '+680': 'PW', // Palau
    '+970': 'PS', // Palestine
    '+507': 'PA', // Panama
    '+675': 'PG', // Papua New Guinea
    '+595': 'PY', // Paraguay
    '+51': 'PE', // Peru
    '+63': 'PH', // Philippines
    '+48': 'PL', // Poland
    '+351': 'PT', // Portugal
    '+1787': 'PR', // Puerto Rico (NANP)
    '+1939': 'PR', // Puerto Rico (NANP)
    // --- Q ---
    '+974': 'QA', // Qatar
    // --- R ---
    '+40': 'RO', // Romania
    '+7': 'RU', // Russia (shares with KZ)
    '+250': 'RW', // Rwanda
    // --- S ---
    '+290': 'SH', // Saint Helena, Ascension and Tristan da Cunha
    '+1869': 'KN', // St. Kitts & Nevis (NANP)
    '+1758': 'LC', // St. Lucia (NANP)
    '+590': 'BL', // St. Barthélemy
    '+508': 'PM', // St. Pierre & Miquelon
    '+1784': 'VC', // St. Vincent & Grenadines (NANP)
    '+685': 'WS', // Samoa
    '+378': 'SM', // San Marino
    '+239': 'ST', // São Tomé & Príncipe
    '+966': 'SA', // Saudi Arabia
    '+221': 'SN', // Senegal
    '+381': 'RS', // Serbia
    '+248': 'SC', // Seychelles
    '+232': 'SL', // Sierra Leone
    '+65': 'SG', // Singapore
    '+1721': 'SX', // Sint Maarten (NANP)
    '+421': 'SK', // Slovakia
    '+386': 'SI', // Slovenia
    '+677': 'SB', // Solomon Islands
    '+252': 'SO', // Somalia
    '+27': 'ZA', // South Africa
    '+82': 'KR', // South Korea
    '+211': 'SS', // South Sudan
    '+34': 'ES', // Spain
    '+94': 'LK', // Sri Lanka
    '+249': 'SD', // Sudan
    '+597': 'SR', // Suriname
    '+47': 'SJ', // Svalbard & Jan Mayen (part of NO +47)
    '+268': 'SZ', // Eswatini (Swaziland)
    '+46': 'SE', // Sweden
    '+41': 'CH', // Switzerland
    '+963': 'SY', // Syria
    // --- T ---
    '+886': 'TW', // Taiwan
    '+992': 'TJ', // Tajikistan
    '+255': 'TZ', // Tanzania
    '+66': 'TH', // Thailand
    '+670': 'TL', // Timor-Leste
    '+228': 'TG', // Togo
    '+690': 'TK', // Tokelau
    '+676': 'TO', // Tonga
    '+1868': 'TT', // Trinidad & Tobago (NANP)
    '+216': 'TN', // Tunisia
    '+90': 'TR', // Turkey
    '+993': 'TM', // Turkmenistan
    '+1649': 'TC', // Turks & Caicos Islands (NANP)
    '+688': 'TV', // Tuvalu
    // --- U ---
    '+256': 'UG', // Uganda
    '+380': 'UA', // Ukraine
    '+971': 'AE', // United Arab Emirates
    '+44': 'GB', // United Kingdom
    '+1': 'US', // United States (NANP) - General NANP entry
    '+598': 'UY', // Uruguay
    '+998': 'UZ', // Uzbekistan
    // --- V ---
    '+678': 'VU', // Vanuatu
    '+379': 'VA', // Vatican City (more specific code, avoids +39 conflict)
    '+58': 'VE', // Venezuela
    '+84': 'VN', // Vietnam
    '+1340': 'VI', // U.S. Virgin Islands (NANP)
    // --- W ---
    '+681': 'WF', // Wallis & Futuna
    // --- Y ---
    '+967': 'YE', // Yemen
    // --- Z ---
    '+260': 'ZM', // Zambia
    '+263': 'ZW', // Zimbabwe
  };

  @override
  void initState() {
    super.initState();
    SharedPreference.getString(AppConstants.loginToken).then((value) {
      setState(() {
        token = value;
        print('token : $token');
        isLoading = true;
        getProfile();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              children: [
                if(argumentData[0] == "2")
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
                  'Update Profile',
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
          body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 17, right: 17),
                  child: Form(
                    key: formKey,
                    onChanged: () => formKey.currentState!.validate(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              // _showChoiceDialog(context);
                            },
                            child: Center(
                              child: SizedBox(
                                width: 90,
                                height: 99,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(55),
                                      child: _pickedImage.path.isNotEmpty
                                          ? Image.file(
                                        _pickedImage,
                                        fit: BoxFit.cover,
                                      )
                                          : profile.isNotEmpty
                                          ? Image.network(
                                          "${BaseUrl.imageUrl}${profile}",
                                          fit: BoxFit.cover,
                                          width: 90,
                                          height: 90,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(Icons.account_circle, color: Colors.grey, size: 65),
                                            );
                                          }
                                      )
                                          : Image.asset(
                                        'assets/image.png',
                                        height: 90,
                                        width: 90,
                                      ),
                                    ),
                                    Positioned(
                                        right: 1,
                                        bottom: 1,
                                        child: InkWell(
                                            onTap: () {
                                              _showChoiceDialog(context);
                                            },
                                            child: SvgPicture.asset(
                                                'assets/add_pic.svg'))),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Full Name',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          TextFormField(
                            controller: nameController,
                            style: smallText,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputField().inputDecoration(
                                'Name',
                                AppColors.whiteColor,
                                AppColors.blackColor.withOpacity(.5)),
                            validator: (value) {
                              if (value!.length < 3) {
                                return 'Name must be greater than 3 characters'
                                    .tr();
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          Text(
                            'Email',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor),
                          ),
                          const SizedBox(
                            height: 7,
                          ),

                          TextFormField(
                              controller: emailController,
                              style: smallText,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputField().inputDecoration(
                                  'Email',
                                  AppColors.whiteColor,
                                  AppColors.blackColor.withOpacity(.5)),
                              validator: _validateEmail
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Phone',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          IntlPhoneField(
                            key: phoneFieldKey, // Important for dynamic updates
                            controller: phoneController,
                            flagsButtonPadding: const EdgeInsets.all(4),
                            dropdownIconPosition: IconPosition.trailing,
                            initialCountryCode: initialCountryCode, // Dynamic initial country
                            decoration: InputDecoration(
                              hintText: 'Phone number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                  width: 0,
                                  color: AppColors.blackColor.withOpacity(.5),
                                  style: BorderStyle.none,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.blackColor.withOpacity(.5),
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.blackColor.withOpacity(.5),
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(.2),
                              counterText: "",
                              contentPadding: const EdgeInsets.all(7),
                            ),
                            validator: (value) {
                              if (value == null || value.number.isEmpty) {
                                return 'Please enter a phone number';
                              }
                              return null;
                            },
                            onChanged: (phone) {
                              setState(() {
                                // Update both country_code and initialCountryCode
                                country_code = phone.countryCode;
                                initialCountryCode = phone.countryISOCode;
                                SharedPreference.putString(AppConstants.country_code, ""+phone.countryCode);
                                print('Country Code: $country_code');
                                print('Complete Number: ${phone.completeNumber}');
                              });
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ButtonWidget(
                              text: 'Update',
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  _checkConnectivity();
                                }else{
                                  formKey.currentState!.validate();
                                }
                              }),
                          const SizedBox(
                            height: 15,
                          ),
                        ]),
                  ),
                ),
              )),
        ),
        if (isLoading)
          Center(
            child: CircularProgressIndicator(
              color: AppColors.themeColor,
            ),
          ),
      ],
    );
  }

  /// --------- Pick Image --------- ///

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    setState(() {
      try {
        _pickedImage1 = File(pickedFile!.path);
        _cropImage(_pickedImage1.path);
      } catch (err) {
        //print(err.runtimeType);
      }
    });

    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      try {
        _pickedImage1 = File(pickedFile!.path);
        _cropImage(_pickedImage1.path);
      } catch (err) {
        print(err.runtimeType);
      }
    });
    Navigator.pop(context);
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'choose_option'.tr(),
              style: TextStyle(color: AppColors.themeColor),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: AppColors.themeColor,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                    },
                    title: Text('gallery'.tr()),
                    leading: Icon(
                      Icons.account_box,
                      color: AppColors.themeColor,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: AppColors.themeColor,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: Text('camera'.tr()),
                    leading: Icon(
                      Icons.camera,
                      color: AppColors.themeColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  /// Crop Image
  _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedImage != null) {
      setState(() {
        final _pickedImage1 = croppedImage.path;
        _pickedImage = File(_pickedImage1);
        debugPrint(croppedImage.path);
      });
    }
  }

  /// ----------- getProfile -----------///
  getProfile() async {
    var url = BaseUrl.getProfile;
    print('Token $token');

    try {
      final response = await HttpService.getDataWithHeader(url, token);
      print(response.body.toString());

      Map<String, dynamic> responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseJson['status']) {
          // Set basic user info
          phoneController.text = responseJson['user']['phone'] ?? "";
          nameController.text = responseJson['user']['name'] ?? "";
          emailController.text = responseJson['user']['email'] ?? "";
          profile = responseJson['user']['profile_image'] ?? "";

          // Handle country code dynamically
          country_code = responseJson['user']['country_code'] ?? "+974";
          print('Received country_code: $country_code');
          SharedPreference.putString(AppConstants.country_code, ""+country_code);

          // Map country code to ISO code for IntlPhoneField
          initialCountryCode = countryDialCodeToISO[country_code] ?? 'QA';
          print('Mapped initialCountryCode: $initialCountryCode');

        } else {
          Fluttertoast.showToast(
            msg: responseJson['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.themeColor,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "Failed to load profile",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print("Error fetching profile: $e");
      Fluttertoast.showToast(
        msg: "Failed to load profile",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        isLoading = false;
        print('isLoading: $isLoading');
      });

      // Force rebuild IntlPhoneField after profile data is loaded
      setState(() {
        phoneFieldKey = UniqueKey();
      });
    }
  }

  /// ----------- Update profile ------------- ///
  updateProfile() async {
    var url = Uri.parse(BaseUrl.updateProfile);
    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer $token'
    };

    var request = http.MultipartRequest('PUT', url);
    request.headers.addAll(headers);
    request.fields['name'] = nameController.text.trim();
    request.fields['email'] = emailController.text.trim();
    request.fields['phone'] = phoneController.text.trim();
    request.fields['country_code'] = country_code; // Use the dynamic country code

    if (_pickedImage.path.isNotEmpty) {
      final mimeType = lookupMimeType(_pickedImage.path);
      final multipartFile = await http.MultipartFile.fromPath(
        'image',
        _pickedImage.path,
        contentType: MediaType.parse(mimeType!),
      );
      request.files.add(multipartFile);
    }
    debugPrint("request.statusCode =  ${request}");
    debugPrint("request.statusCode =  ${country_code}");

    try {
      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      debugPrint("response.statusCode =  ${response.statusCode}");
      debugPrint("response.statusCode =  ${responseString}");

      if (response.statusCode == 200) {
        debugPrint("response123$responseString");
        Map<String, dynamic> resposne1 = jsonDecode(responseString);

        if (resposne1["status"]) {
          setState(() {
            isLoading = false;
          });
          if(argumentData[0]=="2") {
            Get.back();
          }else{

            SharedPreference.putString(AppConstants.country_code, ""+country_code);
            SharedPreference.putBool(AppConstants.isLogin, true);
            Get.offAll(()=>HomeScreen());
          }

          debugPrint(resposne1.toString());
          Fluttertoast.showToast(
              msg: resposne1["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);

          debugPrint(resposne1["message"]);
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
              msg: resposne1["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Server error ${response.statusCode}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        debugPrint('Error updating profile.${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error updating profile.11');
      debugPrint('Exception: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  /// ------------ Check Internet Connection -------------- ///

  Future<void> _checkConnectivity() async {
    bool isConnected = await ConnectivityUtil.checkConnectivity(context);
    setState(() {
      if (isConnected) {
        setState(() {
          isLoading = true;
        });
        updateProfile();
      }
    });
  }

  String? _validateEmail(String? value) {
    const pattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
    final regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
}
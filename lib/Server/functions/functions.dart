import 'dart:convert';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_update/in_app_update.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trust_app_updated/Pages/main_categories/main_categories.dart';
import 'package:trust_app_updated/Pages/merchant_screen/driver_screen/driver_screen.dart';
import 'package:trust_app_updated/Pages/merchant_screen/merchant_screen.dart';
import '../../Components/button_widget/button_widget.dart';
import '../../Constants/constants.dart';
import '../../LocalDB/Models/CartItem.dart';
import '../../LocalDB/Provider/CartProvider.dart';
import '../../Pages/all_seasons/all_seasons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../Pages/merchant_screen/maintenance_department/maintenance_department.dart';
import '../../Pages/products_by_season/products_by_season.dart';
import '../../main.dart';
import '../../pages/home_screen/home_screen.dart';

import '../domains/domains.dart';

var headers = {'ContentType': 'application/json', "Connection": "Keep-Alive"};

NavigatorFunction(BuildContext context, Widget Widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Widget));
}

Future<bool> checkForUpdate() async {
  try {
    final updateInfo = await InAppUpdate.checkForUpdate();
    return updateInfo.updateAvailability == UpdateAvailability.updateAvailable;
  } catch (e) {
    // Handle errors or assume no update available
    return false;
  }
}

getHome() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? id = prefs.getInt('user_id');
  var response =
      await http.get(Uri.parse("$URL_HOME/${id.toString()}"), headers: headers);
  var res = jsonDecode(response.body);
  return res;
}

getNotifications(int page) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? id = prefs.getString('user_id');
  var response = await http.get(
      Uri.parse("$URL_NOTIFICATIONS/userId/$id?page=$page"),
      headers: headers);
  var res = jsonDecode(response.body);
  return res;
}

deleteAllNotifications(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? id = prefs.getString('user_id');
  final url = Uri.parse("$URL_NOTIFICATIONS/userId/$id");
  final response = await http.delete(url);
  var data = json.decode(response.body);
  if (data["success"] == true) {
    Fluttertoast.showToast(
        msg: "تم حذف جميع الاشعارات بنجاح",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(255, 28, 116, 31),
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pop(context);
  } else {
    Fluttertoast.showToast(
        msg: "فشلت عملية حذف الاشعارات , الرجاء المحاولة فيما بعد",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pop(context);
  }
}

getSeasons() async {
  var response = await http.get(Uri.parse(URL_SEASONS), headers: headers);
  var res = jsonDecode(response.body)["response"]["data"];
  return res;
}

getMerchants(int page, latt, long) async {
  var response = await http.get(
      Uri.parse("$URL_MERCHANTS?x=$latt&y=$long&page=$page"),
      headers: headers);
  var res = jsonDecode(response.body)["response"]["data"];
  return res;
}

getWarranties(int page) async {
  var response =
      await http.get(Uri.parse("$URL_WARRANTIES?page=$page"), headers: headers);
  var res = jsonDecode(response.body)["response"]["data"];
  return res;
}

getMaintenanceRequests(int page) async {
  var response = await http
      .get(Uri.parse("$URL_MAINTENANCE_REQUESTS?page=$page"), headers: headers);
  var res = jsonDecode(response.body)["response"];
  return res;
}

getMaintenanceRequestsByMerchantID(int page) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? merchantID = prefs.getString('merchant_id');
  print("$URL_MAINTENANCE_REQUESTS/merchantId/$merchantID?page=$page");
  var response = await http.get(
      Uri.parse("$URL_MAINTENANCE_REQUESTS/merchantId/$merchantID?page=$page"),
      headers: headers);
  var res = jsonDecode(response.body)["response"];
  return res;
}

getMaintenanceRequestsDriver(int page) async {
  print("$URL_MAINTENANCE_REQUESTS?page=$page&driver=true");
  var response = await http.get(
      Uri.parse("$URL_MAINTENANCE_REQUESTS?page=$page&driver=true"),
      headers: headers);
  var res = jsonDecode(response.body)["response"];
  return res;
}

getRequestsReports() async {
  print("URL_REPORTS");
  print(URL_REPORTS);
  var response = await http.get(Uri.parse(URL_REPORTS), headers: headers);
  var res = jsonDecode(response.body)["response"];
  return res;
}

getMaintenanceRequestsFilter(int page, String City) async {
  var response = await http.get(
      Uri.parse(
          "$URL_MAINTENANCE_REQUESTS/maintenanceDepartment/$City?page=$page"),
      headers: headers);
  var res = jsonDecode(response.body)["response"];
  return res;
}

getMaintenanceRequestsFilterDriver(int page,
    {String? fromDate,
    String? endDate,
    String? category,
    String? countryID,
    String? selectedStatus}) async {
  String url = "$URL_MAINTENANCE_REQUESTS?page=$page&driver=true";

  // Conditionally append parameters if they are not empty
  if (fromDate != null && fromDate.isNotEmpty) {
    url += "&fromDate=$fromDate";
  }
  if (endDate != null && endDate.isNotEmpty) {
    url += "&toDate=$endDate";
  }
  if (countryID != null && countryID.isNotEmpty) {
    url += "&countryId=$countryID";
  }
  if (category != null && category.isNotEmpty) {
    url += "&maintenanceDepartment=$category";
  }
  if (selectedStatus != null && selectedStatus.isNotEmpty) {
    url += "&statuses=$selectedStatus";
  }
  print("url");
  print(url);

  var response = await http.get(Uri.parse(url), headers: headers);
  var res = jsonDecode(response.body)["response"];
  return res;
}

getSliders() async {
  var response = await http.get(Uri.parse(URL_SLIDERS), headers: headers);
  var res = jsonDecode(response.body)["response"];
  return res;
}

getCategories() async {
  var response = await http.get(Uri.parse(URL_CATEGORIES), headers: headers);
  var res = jsonDecode(response.body)["response"]["data"];
  return res;
}

getSubCategories(sub_category_id) async {
  print("$URL_SUB_CATEGORIES/$sub_category_id");
  var response = await http
      .get(Uri.parse("$URL_SUB_CATEGORIES/$sub_category_id"), headers: headers);
  var res = jsonDecode(response.body)["response"]["data"];
  return res;
}

getSubCategoriesBySeasonID(sub_category_id, page) async {
  var response = await http.get(
      Uri.parse("${URL}cats/SubCat/$sub_category_id?page=$page"),
      headers: headers);
  var res = jsonDecode(response.body)["response"]["data"];
  return res;
}

getProductByID(id) async {
  print('$URL_SINGLE_PRODUCT/$id');
  var response = await http.get(Uri.parse('$URL_SINGLE_PRODUCT/$id'));
  var res = jsonDecode(response.body)["response"];
  return res;
}

getProductsBySeasonID(season_id, page) async {
  var response =
      await http.get(Uri.parse('${URL}products/season/$season_id?page=$page'));
  var res = jsonDecode(response.body)["response"]["data"];
  return res;
}

getProductsByCategorynID(category_id, int page) async {
  print("$URL_PRODUCTS_BY_CATEGORY/list/$category_id?page=$page");
  var response = await http
      .get(Uri.parse('$URL_PRODUCTS_BY_CATEGORY/list/$category_id?page=$page'));
  var res = jsonDecode(response.body)["response"]["data"];
  return res;
}

getOrders(int page) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? TOKEN = await prefs.getString('token');
  var response = await http.get(Uri.parse('$URL_ORDERS?page=$page'),
      headers: {"Authorization": "Bearer $TOKEN"});
  var res = jsonDecode(response.body)["response"]["data"];
  return res;
}

getSpeceficOrder(int orderID) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? TOKEN = await prefs.getString('token');
  var response = await http.get(Uri.parse('$URL_ORDERS/$orderID'),
      headers: {"Authorization": "Bearer $TOKEN"});
  var res = jsonDecode(response.body)["response"]["items"];
  return res;
}

getLatestProducts(int page) async {
  var response =
      await http.get(Uri.parse('$URL_PRODUCTS_BY_CATEGORY/latest?page=$page'));
  var res = jsonDecode(response.body)["response"]["data"];
  return res;
}

getOffers(int page) async {
  var response = await http.get(Uri.parse('$URL_OFFERS?page=$page'));
  var res = jsonDecode(response.body)["response"]["data"];
  return res;
}

getShareUrl(category_id) async {
  var response = await http.get(Uri.parse('$URL_SHARE_URL/$category_id'));
  var res = jsonDecode(response.body)["response"];
  return res;
}

sendLoginRequest(email, password, context) async {
  final _firebaseMessaging = FirebaseMessaging.instance;

  // Wait for the token to be available
  final token = await _firebaseMessaging.getToken();
  print('Token: $token');
  final url = Uri.parse(URL_LOGIN);
  final jsonData = {
    'password': password.toString(),
    'email': email.toString(),
    'userToken': token.toString(),
  };
  print("json.encode(jsonData)");
  print(json.encode(jsonData));
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(jsonData),
  );
  var data = json.decode(response.body);
  if (data["success"] == true) {
    Navigator.of(context, rootNavigator: true).pop();

    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.loginsuccess,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(255, 28, 116, 31),
        textColor: Colors.white,
        fontSize: 16.0);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String roleID = data["user"]["role_id"];
    await prefs.setBool('login', true);
    await prefs.setString('role_id', roleID);
    await prefs.setString('user_id', data["user"]["id"].toString());
    await prefs.setString('name', data["user"]["name"]);
    await prefs.setString('email', data["user"]["email"]);
    await prefs.setString('token', data["token"]);
    if (roleID == "6") {
      NavigatorFunction(context, MaintenanceDepartment());
    } else if (roleID == "5") {
      NavigatorFunction(context, DriverScreen());
    } else if (roleID == "4" || roleID == "3") {
      int merchantID = data["merchant"]["id"] ?? 0;
      await prefs.setString('merchant_id', merchantID.toString());
      NavigatorFunction(context, MerchantScreen());
    } else {
      NavigatorFunction(context, HomeScreen(currentIndex: 0));
    }
  } else {
    Navigator.of(context, rootNavigator: true).pop();
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.phoneorpassin,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

sendMassageRequest(message, productName, email, name, context) async {
  final url = Uri.parse(URL_CONTACT);

  final jsonData = {
    "message": "${message}",
    "email": "${email}",
    "name": "${name}",
    "subject": "${productName} استفسار عن منتج "
  };
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(jsonData),
  );
  var data = json.decode(response.body);
  if (data["success"] == true) {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.consuccess,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(255, 28, 116, 31),
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pop(context);
  } else {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.confailed,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pop(context);
  }
}

addWarranty(customerPhone, customerName, productSerialNumber, productId,
    id_number, merchantId, notes, context) async {
  final url = Uri.parse(URL_WARRANTIES);

  final jsonData = {
    "customerPhone": "${customerPhone}",
    "customerName": "${customerName}",
    "productSerialNumber": "${productSerialNumber}",
    "productId": "${productId}",
    "idNumber": "${id_number}",
    "merchantId": "${merchantId}",
    "notes": "${notes}"
  };
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(jsonData),
  );
  var data = json.decode(response.body);
  if (data["success"] == true) {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.consuccess,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(255, 28, 116, 31),
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pop(context);
  } else {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.confailed,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pop(context);
  }
}

editWarranty(
    warrantyID, idNumber, customerPhone, customerName, notes, context) async {
  final url = Uri.parse("$URL_WARRANTIES/edit");

  final jsonData = {
    "id": "${warrantyID}",
    "idNumber": "${idNumber}",
    "customerPhone": "${customerPhone}",
    "customerName": "${customerName}",
    "notes": "${notes}"
  };
  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(jsonData),
  );
  var data = json.decode(response.body);
  if (data["success"] == true) {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.edit_success,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(255, 28, 116, 31),
        textColor: Colors.white,
        fontSize: 16.0);
  } else {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.confailed,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

addMaintanenceRequest(
    customerPhone,
    customerName,
    productSerialNumber,
    productId,
    merchantId,
    notes,
    warrantyId,
    warrantyStatus,
    malfunctionDdescription,
    context) async {
  final url = Uri.parse(URL_MAINTENANCE_REQUESTS);

  final jsonData = {
    "customerPhone": "${customerPhone}",
    "warrantyId":
        warrantyId.toString() == "null" ? null : warrantyId.toString(),
    "customerName": "${customerName}",
    "productSerialNumber": "${productSerialNumber}",
    "productId": "${productId}",
    "merchantId": "${merchantId}",
    "malfunctionDdescription": "${malfunctionDdescription}",
    "warrantyStatus": warrantyId.toString() == "null" ? false : true,
    "notes": "${notes}"
  };
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(jsonData),
  );
  var data = json.decode(response.body);
  if (data["success"] == true) {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.consuccess,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(255, 28, 116, 31),
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pop(context);
  } else {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.confailed,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pop(context);
  }
}

editMaintanenceRequest(maintanenceRequestID, customerPhone, customerName, notes,
    malfunctionDdescription, context) async {
  final url = Uri.parse("$URL_MAINTENANCE_REQUESTS/edit");

  final jsonData = {
    "id": "${maintanenceRequestID}",
    "customerPhone": "${customerPhone}",
    "customerName": "${customerName}",
    "malfunctionDdescription": "${malfunctionDdescription}",
    "notes": "${notes}",
    "status": "pending"
  };
  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(jsonData),
  );
  var data = json.decode(response.body);
  if (data["success"] == true) {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.edit_success,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(255, 28, 116, 31),
        textColor: Colors.white,
        fontSize: 16.0);
  } else {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.confailed,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

editMaintanenceRequestStatus(maintanenceRequestID, status, context) async {
  final url = Uri.parse("$URL_MAINTENANCE_REQUESTS/edit");

  final jsonData = {
    "id": "${maintanenceRequestID}",
    "status": "${status}",
  };
  print("json.encode(jsonData)");
  print(json.encode(jsonData));
  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(jsonData),
  );
  var data = json.decode(response.body);
  if (data["success"] == true) {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.edit_success,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(255, 28, 116, 31),
        textColor: Colors.white,
        fontSize: 16.0);
  } else {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.confailed,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

editMaintanenceRequestStatusArray(var maintanenceRequests, context) async {
  final url = Uri.parse("$URL_MAINTENANCE_REQUESTS/edit");
  print("json.encode(maintanenceRequests)");
  print(json.encode(maintanenceRequests));
  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(maintanenceRequests),
  );
  var data = json.decode(response.body);
  if (data["success"] == true) {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.edit_success,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(255, 28, 116, 31),
        textColor: Colors.white,
        fontSize: 16.0);
  } else {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.confailed,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

sendContact(message, email, name, context) async {
  final url = Uri.parse(URL_CONTACT);
  final jsonData = {
    "message": "${message}",
    "email": "${email}",
    "name": "${name}",
  };
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(jsonData),
  );
  var data = json.decode(response.body);
  if (data["success"] == true) {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.consuccess,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(255, 28, 116, 31),
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pop(context);
    Navigator.pop(context);
  } else {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.confailed,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pop(context);
  }
}

deleteAccount(user_id, context) async {
  final url = Uri.parse(URL_DELETE_ACCOUNT);
  final jsonData = {"id": "${user_id}"};
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(jsonData),
  );
  var data = json.decode(response.body);
  if (data["success"] == true) {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.delete_account,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(255, 28, 116, 31),
        textColor: Colors.white,
        fontSize: 16.0);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pop(context);
    NavigatorFunction(context, HomeScreen(currentIndex: 0));
  } else {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.confailed,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pop(context);
  }
}

changeName(id, name, context) async {
  final url = Uri.parse(URL_EDIT_NAME);
  final jsonData = {
    "id": "${id}",
    "name": "${name}",
  };

  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(jsonData),
  );
  var data = json.decode(response.body);

  if (data["success"] == true) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', id);
    await prefs.setString('name', name);
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.editsuccess,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 28, 116, 31),
        textColor: Colors.white,
        fontSize: 16.0);

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  } else {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.editfailed,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pop(context);
  }
}

changePassword(id, password, new_password, context) async {
  final url = Uri.parse(URL_EDIT_PASSWORD);
  final jsonData = {
    "id": "${id}",
    "password": "${password}",
    "newPassword": "${new_password}",
  };

  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(jsonData),
  );
  var data = json.decode(response.body);

  if (data["success"] == true) {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.editsuccess,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 28, 116, 31),
        textColor: Colors.white,
        fontSize: 16.0);

    Navigator.pop(context);
    Navigator.pop(context);
  } else {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.editfailed,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pop(context);
  }
}

addOrder(context, notes) async {
  final url = Uri.parse(URL_ORDERS);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? user_id = await prefs.getString('user_id');
  String? TOKEN = await prefs.getString('token');
  final cartProvider =
      Provider.of<CartProvider>(context, listen: false).cartItems;
  final cartProviderCart = Provider.of<CartProvider>(context, listen: false);
  List<Map<String, dynamic>> products = [];
  for (var i = 0; i < cartProvider.length; i++) {
    products.add({
      "product_id": cartProvider[i].productId.toString(),
      "quantity": cartProvider[i].quantity.toString(),
      "color": cartProvider[i].color_id,
      "size": cartProvider[i].size_id,
      "notes": cartProvider[i].notes.toString(),
    });
  }
  final jsonData = {
    "userId": "${user_id.toString()}",
    "notes": notes,
    "products": products
  };
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $TOKEN',
      'Content-Type': 'application/json',
    },
    body: json.encode(jsonData),
  );
  var data = json.decode(response.body);
  if (data["success"] == true) {
    Navigator.of(context, rootNavigator: true).pop();
    cartProviderCart.clearCart();
    showSuccessOrder(context);
  } else {
    Navigator.of(context, rootNavigator: true).pop();

    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.confailed,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pop(context);
  }
}

getRelatedProducts(product_id, category_id) async {
  var response = await http.get(Uri.parse(
      'http://app.redtrust.ps:3003/products/$product_id/related/$category_id'));
  var res = jsonDecode(response.body)["response"];
  return res;
}

searchProductByKey(key) async {
  var response = await http.get(Uri.parse('$URL_SINGLE_PRODUCT/search/$key'));
  var res = jsonDecode(response.body)["response"]["data"];
  return res;
}

getAboutUs() async {
  var response = await http.get(Uri.parse(URL_ABOUT_US));
  var res = jsonDecode(response.body)["response"];
  return res;
}

getCatPage() async {
  var response = await http.get(Uri.parse(URL_CAT_PAGE));
  var res = jsonDecode(response.body)["response"];
  return res;
}

getRequest(API_URL) async {
  print("API_URL");
  print(API_URL);
  var response = await http.get(Uri.parse(API_URL), headers: headers);
  var res = jsonDecode(response.body);
  return res;
}

void showFilterDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Center(
        child: Container(
          height: 270,
          width: 200,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.view_by,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 25,
                        )),
                  ],
                ),
                InkWell(
                  onTap: () {
                    NavigatorFunction(context, MainCategories());
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.category,
                        color: Colors.white,
                        size: 25,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.parts,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.or_select_season,
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      )
                    ],
                  ),
                ),
                FutureBuilder(
                    future: getSeasons(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                            width: double.infinity,
                            height: 40,
                            child: Center(
                              child: SpinKitFadingCircle(
                                color: Colors.white,
                                size: 25.0,
                              ),
                            ));
                      } else {
                        if (snapshot.data != null) {
                          var seasons = snapshot.data;

                          return Container(
                            width: double.infinity,
                            height: 120,
                            child: ListView.builder(
                                itemCount: seasons.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      if (seasons[index]["id"] == 5) {
                                        NavigatorFunction(
                                            context,
                                            AllSeasons(
                                              id: seasons[index]["id"],
                                              image: URLIMAGE +
                                                  seasons[index]["cover"],
                                              name_ar: seasons[index]
                                                          ["translations"][0]
                                                      ["value"] ??
                                                  "",
                                              name_en:
                                                  seasons[index]["name"] ?? "",
                                            ));
                                      } else {
                                        NavigatorFunction(
                                            context,
                                            ProductsBySeason(
                                                name_ar: seasons[index]
                                                            ["translations"][0]
                                                        ["value"] ??
                                                    "",
                                                name_en: seasons[index]
                                                        ["name"] ??
                                                    "",
                                                image: SeasonsImages[index],
                                                season_image: URLIMAGE +
                                                    seasons[index]["cover"],
                                                season_id: seasons[index]
                                                    ["id"]));
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            SeasonsImages[index],
                                            color: Colors.white,
                                            fit: BoxFit.cover,
                                            width: 25,
                                            height: 25,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            locale.toString() == "ar"
                                                ? seasons[index]["translations"]
                                                    [0]["value"]
                                                : seasons[index]["name"] ?? "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          );
                        } else {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: double.infinity,
                            color: Colors.white,
                          );
                        }
                      }
                    }),
              ],
            ),
          ),
        ),
      );
    },
  );
}

showDialogToAddToCart(
    {context,
    List<String>? SIZES_EN,
    List<String>? SIZES_AR,
    List<int>? SIZESIDs,
    colors,
    selectedSize,
    selectedSizeIDs,
    product_id,
    category_id,
    cartProvider,
    name_ar,
    name_en,
    image}) async {
  bool emptySizes = false;
  int? selectedIndex;
  bool emptyColors = false;
  List<int> _Counters = [];
  List<String> _Names_en = [];
  List<String> _Names_ar = [];
  List<int> _ColorIDs = [];
  List<String> _Images = [];
  TextEditingController _countController = TextEditingController();
  _countController.text = "1";
  for (int i = 0; i < colors.length; i++) {
    _Counters.add(0);
    _Names_en.add(colors[i]["title"]);
    _Names_ar.add(colors[i]["translations"][0]["value"] ?? "-");
    _ColorIDs.add(colors[i]["id"]);
    _Images.add(colors[i]["image"] ?? "");
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          title: Container(
              decoration: BoxDecoration(
                  color: MAIN_COLOR,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              height: 50,
              width: double.infinity,
              child: Center(
                  child: Text(
                AppLocalizations.of(context)!.select_size,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ))),
          content: Container(
            color: Colors.white,
            width: isTablet ? MediaQuery.of(context).size.width : 300,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.size,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Visibility(
                        visible: emptySizes,
                        child: Text(
                          "(${AppLocalizations.of(context)!.select_size})",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                locale.toString() == "ar"
                    ? Column(
                        children: SIZES_AR!.asMap().entries.map((entry) {
                          final index = entry.key;
                          final size = entry.value;
                          return RadioListTile(
                            activeColor: MAIN_COLOR,
                            contentPadding: EdgeInsets.zero,
                            title: Text(size),
                            value: size,
                            groupValue: selectedSize,
                            onChanged: (value) {
                              setState(() {
                                selectedSize = value as String;
                                selectedIndex = index;
                              });
                            },
                          );
                        }).toList(),
                      )
                    : Column(
                        children: SIZES_EN!.asMap().entries.map((entry) {
                          final index = entry.key;
                          final size = entry.value;
                          return RadioListTile(
                            activeColor: MAIN_COLOR,
                            contentPadding: EdgeInsets.zero,
                            title: Text(size),
                            value: size,
                            groupValue: selectedSize,
                            onChanged: (value) {
                              setState(() {
                                selectedSize = value as String;
                                selectedIndex = index;
                              });
                            },
                          );
                        }).toList(),
                      ),
                Visibility(
                  visible: colors!.length == 0 ? true : false,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              var COUNT = int.parse(_countController.text);
                              COUNT++;
                              _countController.text = COUNT.toString();
                            });
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            child: Center(
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: locale.toString() == "ar"
                                        ? BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10))
                                        : BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)),
                                    color: MAIN_COLOR),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.plus,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              border: Border.all(color: MAIN_COLOR, width: 1)),
                          child: SizedBox(
                              width: 35,
                              height: 30,
                              child: Container(
                                height: 30,
                                width: 35,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 0, top: 0),
                                    child: Center(
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                        ),
                                        controller: _countController,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            var COUNT = int.parse(_countController.text);

                            if (COUNT > 1) {
                              setState(() {
                                if (COUNT != 1) COUNT--;

                                _countController.text = COUNT.toString();
                              });
                            }
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: locale.toString() == "en"
                                      ? BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10))
                                      : BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                  color: MAIN_COLOR),
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.minus,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: colors.length == 0 ? false : true,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.color,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Visibility(
                          visible: emptyColors,
                          child: Text(
                            "(${AppLocalizations.of(context)!.select_color})",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: colors.length == 0 ? false : true,
                  child: Expanded(
                    child: Container(
                      width: 300,
                      height: 400,
                      child: ListView.builder(
                          itemCount: colors.length,
                          itemBuilder: (BuildContext context, int index) {
                            TextEditingController colorCounterController =
                                TextEditingController();
                            colorCounterController.text =
                                _Counters[index].toString();
                            return Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      FancyShimmerImage(
                                          imageUrl:
                                              (colors[index]["image"] != null)
                                                  ? URLIMAGE +
                                                      colors[index]["image"]
                                                  : '',
                                          height: 30,
                                          width: 30,
                                          errorWidget: Image.asset(
                                            "assets/images/logo_well.png",
                                            fit: BoxFit.cover,
                                            height: 190,
                                            width: double.infinity,
                                          )),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        locale.toString() == "ar"
                                            ? colors[index]["translations"][0]
                                                ["value"]
                                            : colors[index]["title"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _Counters[index]++;
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          child: Center(
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius: locale
                                                              .toString() ==
                                                          "ar"
                                                      ? BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10))
                                                      : BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10)),
                                                  color: MAIN_COLOR),
                                              child: Center(
                                                child: FaIcon(
                                                  FontAwesomeIcons.plus,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 30,
                                        width: 35,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: MAIN_COLOR, width: 1)),
                                        child: SizedBox(
                                          width: 35,
                                          height: 30,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0, top: 0),
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                border: InputBorder.none,
                                              ),
                                              controller:
                                                  colorCounterController,
                                              onChanged: (value) {
                                                _Counters[index] =
                                                    int.parse(value.toString());
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (_Counters[index] > 0) {
                                            setState(() {
                                              if (_Counters[index] != 0)
                                                _Counters[index]--;
                                            });
                                          }
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                borderRadius: locale
                                                            .toString() ==
                                                        "en"
                                                    ? BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10))
                                                    : BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                10)),
                                                color: MAIN_COLOR),
                                            child: Center(
                                              child: FaIcon(
                                                FontAwesomeIcons.minus,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
                if (colors.length == 0) {
                  if (selectedSize == "") {
                    setState(() {
                      emptySizes = true;
                    });
                  } else {
                    final newItem = CartItem(
                      selectedSizeIndex: selectedIndex!,
                      sizesIDs:
                          SIZESIDs!.map((size) => SIZESIDs.toString()).toList(),
                      color_id: 0,
                      notes: "",
                      sizes_en:
                          SIZES_EN!.map((size) => size.toString()).toList(),
                      sizes_ar:
                          SIZES_AR!.map((size) => size.toString()).toList(),
                      size_id: SIZESIDs[selectedIndex!],
                      colorsNamesEN:
                          _Names_en.map((size) => size.toString()).toList(),
                      colorsNamesAR:
                          _Names_ar.map((size) => size.toString()).toList(),
                      colorsImages:
                          _Images.map((size) => size.toString()).toList(),
                      productId: product_id,
                      name_ar: name_ar,
                      name_en: name_en,
                      categoryID: category_id,
                      image: image,
                      size_ar: selectedSize.toString(),
                      size_en: selectedSize.toString(),
                      quantity: int.parse(_countController.text),
                      color_en: '',
                      color_ar: '',
                    );
                    cartProvider.addToCart(newItem);
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                        msg: AppLocalizations.of(context)!.cart_success,
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: const Color.fromARGB(255, 28, 116, 31),
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                } else {
                  bool allZeros = _Counters.every((element) => element == 0);
                  if (allZeros || selectedSize == "") {
                    setState(() {
                      emptyColors = true;
                      emptySizes = true;
                    });
                  } else {
                    for (int i = 0; i < _Counters.length; i++) {
                      if (_Counters[i] > 0) {
                        final newItem = CartItem(
                            selectedSizeIndex: selectedIndex!,
                            sizesIDs: SIZESIDs!
                                .map((size) => SIZESIDs.toString())
                                .toList(),
                            size_id: SIZESIDs[selectedIndex!],
                            notes: "",
                            sizes_en: SIZES_EN!
                                .map((size) => size.toString())
                                .toList(),
                            sizes_ar: SIZES_AR!
                                .map((size) => size.toString())
                                .toList(),
                            colorsNamesEN:
                                _Names_en.map((size) => size.toString())
                                    .toList(),
                            colorsNamesAR:
                                _Names_ar.map((size) => size.toString())
                                    .toList(),
                            colorsImages:
                                _Images.map((size) => size.toString()).toList(),
                            categoryID: category_id,
                            productId: product_id,
                            name_ar: name_ar,
                            name_en: name_en,
                            image: URLIMAGE + _Images[i],
                            size_ar: selectedSize.toString(),
                            size_en: selectedSize.toString(),
                            quantity: _Counters[i],
                            color_en: _Names_en[i],
                            color_ar: _Names_ar[i],
                            color_id: _ColorIDs[i]);
                        cartProvider.addToCart(newItem);
                      }
                    }

                    Navigator.pop(context);
                    Fluttertoast.showToast(
                        msg: AppLocalizations.of(context)!.cart_success,
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: const Color.fromARGB(255, 28, 116, 31),
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                }
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: MAIN_COLOR,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  height: 50,
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    AppLocalizations.of(context)!.sin_cart,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ))),
            ),
          ],
        );
      });
    },
  );
}

showSuccessOrder(context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset("assets/images/Animation - 1699454344848.json",
                    height: 300,
                    reverse: true,
                    repeat: true,
                    fit: BoxFit.cover),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    AppLocalizations.of(context)!.order_first,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    AppLocalizations.of(context)!.order_second,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 114, 114, 114),
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () {
                    NavigatorFunction(context, HomeScreen(currentIndex: 0));
                  },
                  child: Container(
                    width: 200,
                    height: 40,
                    child: Center(
                        child: Text(
                      AppLocalizations.of(context)!.navigator_home,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    )),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black),
                  ),
                )
              ],
            ),
          ));
    },
  );
}

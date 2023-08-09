/// api_service.dart
// ignore_for_file: depend_on_referenced_packages, import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/api_service/exceptions.dart';
import 'package:front/data/user_.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  final String baseUrl;
  String? token;

  ApiService({required this.baseUrl, this.token});

  Future<User_?> login(String userEmail, String password) async {
    try {
      Map<String, dynamic> responseBody = await _httpRequest('POST', '$baseUrl/auth/login', data: {
        'username': userEmail,
        'password': password,
      });
      if (responseBody['code'] != null && responseBody['code'] == 401) {
        throw const UnauthorizedException("Invalid username or password");
      }
      Map<String, dynamic> userData = responseBody['user_data'];
      return User_(
        id: userData['id'],
        name: "${userData['first_name'] as String} ${userData['last_name'] as String}",
        token: responseBody['token'],
        userType: UserType.admin,
        password: password,
        email: userData['email'],
      );
    } on UnauthorizedException {
      return null;
    }
  }

  Future<bool> checkUIDAuth() async {
    print(Data.user?.uid);
    dynamic responseBody = await _httpRequest('GET', '$baseUrl/auth/test');  
    return responseBody.runtimeType == String;
  }

  Future<bool> checkAuth() async {
    dynamic responseBody = await _httpRequest('GET', '$baseUrl/auth/testToken', data: {'token': token ?? ''});  
    return responseBody.runtimeType == String;
  }

  void logout() {
    Data.pageList = [
        ["DASHBOARD", Icons.dashboard], 
        ["DAILY SCHEDULE", Icons.schedule], 
        ["LOST AND FOUND", Icons.find_in_page], 
        ["FOOD MENU", Icons.fastfood], 
        ["HAWKS NEST", Icons.store], 
        ["SPORTS", Icons.sports]
    ];
    Data.user = null;
  }

  // daily schedule
  Future<Map<String, dynamic>> getDailySchedule() async {
    // dynamic result = await _httpRequest('GET', '$baseUrl/data/daily-schedule');
    // if (result is Map<String, dynamic>) {
    //   return [Map<String, dynamic>.from(result)];
    // }
    // return List<Map<String, dynamic>>.from(result);
    dynamic data = {
      "2023-04-19": [
        {
          "id": 31,
          "start": "2023-06-23T06:30",
          "end": "2023-06-23T07:10",
          "title": "Yoga",
          "description": "In Tiernan Room",
          "resource": [1, 2, 3, 4],
          "color": "#67B767",
          "isRequired": false,
          "location": "Tiernan Room"
        },
        {
          "id": 32,
          "start": "2023-06-23T07:30",
          "end": "2023-06-23T08:30",
          "title": "Breakfast",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#3232BF",
          "isRequired": false,
          "location": ""
        },
        {
          "id": 33,
          "start": "2023-06-23T08:45",
          "end": "2023-06-23T09:10",
          "title": "All School COMPASS for Freshman and Sophomore",
          "description": "Brown (Mr. Field), VESPERS DRESS",
          "resource": [1, 2],
          "color": "#ff0000",
          "isRequired": true,
          "location": ""
        },
        {
          "id": 34,
          "start": "2023-06-23T08:45",
          "end": "2023-06-23T09:10",
          "title": "All School COMPASS for Junior and Senior",
          "description": "Chaple, VESPERS DRESS",
          "resource": [3, 4],
          "color": "#ff0000",
          "isRequired": true,
          "location": ""
        },
        {
          "id": 35,
          "start": "2023-06-23T09:10",
          "end": "2023-06-23T10:10",
          "title": "Block C",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#67B767",
          "isRequired": true,
          "location": ""
        },
        {
          "id": 36,
          "start": "2023-06-23T10:20",
          "end": "2023-06-23T11:15",
          "title": "Block D",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#67B767",
          "isRequired": true,
          "location": ""
        },
        {
          "id": 37,
          "start": "2023-06-23T11:25",
          "end": "2023-06-23T12:20",
          "title": "Block E",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#67B767",
          "isRequired": true,
          "location": ""
        },
        {
          "id": 38,
          "start": "2023-06-23T11:45",
          "end": "2023-06-23T13:00",
          "title": "Buffet Lunch",
          "description": "Menu: Chicken. If you have E period free, please come early.",
          "resource": [1, 2, 3, 4],
          "color": "#3232BF",
          "isRequired": false,
          "location": ""
        },
        {
          "id": 39,
          "start": "2023-06-23T12:30",
          "end": "2023-06-23T17:30",
          "title": "Afternoon Activities",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#67B767",
          "isRequired": false,
          "location": ""
        },
        {
          "id": 40,
          "start": "2023-06-23T14:30",
          "end": "2023-06-23T15:30",
          "title": "Snack in Refactory",
          "description": "Please be neat.",
          "resource": [1, 2, 3, 4],
          "color": "#8000FF",
          "isRequired": false,
          "location": "Refactory"
        },
        {
          "id": 41,
          "start": "2023-06-23T14:15",
          "end": "2023-06-23T14:45",
          "title": "JV GOLF vs Salisbury",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#999928",
          "isRequired": false,
          "location": ""
        },
        {
          "id": 42,
          "start": "2023-06-23T15:00",
          "end": "2023-06-23T16:30",
          "title": "VARS Baseball vs Kingswood",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#999928",
          "isRequired": false,
          "location": ""
        },
        {
          "id": 43,
          "start": "2023-06-23T15:00",
          "end": "2023-06-23T16:30",
          "title": "VARS Lacrosse vs Berkshine",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#999928",
          "isRequired": false,
          "location": ""
        },
        {
          "id": 44,
          "start": "2023-06-23T17:00",
          "end": "2023-06-23T18:30",
          "title": "Buffet Dinner",
          "description": "Smart casual. Menu: Chicken.",
          "resource": [1, 2, 3, 4],
          "color": "#3232BF",
          "isRequired": false,
          "location": ""
        },
        {
          "id": 45,
          "start": "2023-06-23T18:00",
          "end": "2023-06-23T19:30",
          "title": "Special Olympics Soccer",
          "description": "JV Soccer field",
          "resource": [1, 2, 3, 4],
          "color": "#658FB9",
          "isRequired": false,
          "location": "JV Soccer field"
        },
        {
          "id": 46,
          "start": "2023-06-23T18:00",
          "end": "2023-06-23T18:45",
          "title": "Investment Club",
          "description": "Meets in the LC",
          "resource": [1, 2, 3, 4],
          "color": "#658FB9",
          "isRequired": false,
          "location": "LC"
        },
        {
          "id": 47,
          "start": "2023-06-23T18:45",
          "end": "2023-06-23T19:45",
          "title": "Network Club",
          "description": "Meets in the Office bla bla",
          "resource": [1, 2, 3, 4],
          "color": "#658FB9",
          "isRequired": false,
          "location": "Office"
        },
        {
          "id": 48,
          "start": "2023-06-23T18:45",
          "end": "2023-06-23T19:45",
          "title": "Applied Math Club",
          "description": "Ele 31",
          "resource": [1, 2, 3, 4],
          "color": "#658FB9",
          "isRequired": false,
          "location": "Ele 31"
        },
        {
          "id": 49,
          "start": "2023-06-23T18:45",
          "end": "2023-06-23T19:45",
          "title": "Community time",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#658FB9",
          "isRequired": true,
          "location": ""
        },
        {
          "id": 50,
          "start": "2023-06-23T19:45",
          "end": "2023-06-23T21:30",
          "title": "Study Hall",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#20C420",
          "isRequired": false,
          "location": ""
        },
        {
          "id": 51,
          "start": "2023-06-23T21:30",
          "end": "2023-06-23T22:30",
          "title": "McDonald's",
          "description": "For sale in the Hawk's Nest",
          "resource": [1, 2, 3, 4],
          "color": "#3232BF",
          "isRequired": false,
          "location": ""
        },
        {
          "id": 52,
          "start": "2023-06-23T22:30",
          "end": "2023-06-23T22:45",
          "title": "Dorm Check",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#FF5300",
          "isRequired": false,
          "location": ""
        }
      ],
      "2023-04-20": [
        {
          "id": 53,
          "start": "2023-06-23T06:30",
          "end": "2023-06-23T07:10",
          "title": "Yoga",
          "description": "In Tiernan Room",
          "resource": [1, 2, 3, 4],
          "color": "#67B767",
          "isRequired": false,
          "location": "Tiernan Room"
        },
        {
          "id": 54,
          "start": "2023-06-23T07:30",
          "end": "2023-06-23T08:30",
          "title": "Breakfast",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#3232BF",
          "isRequired": false,
          "location": ""
        },
        {
          "id": 55,
          "start": "2023-06-23T08:45",
          "end": "2023-06-23T09:10",
          "title": "All School COMPASS for Freshman and Sophomore",
          "description": "Brown (Mr. Field), VESPERS DRESS",
          "resource": [1, 2],
          "color": "#ff0000",
          "isRequired": true,
          "location": ""
        },
        {
          "id": 56,
          "start": "2023-06-23T08:45",
          "end": "2023-06-23T09:10",
          "title": "All School COMPASS for Junior and Senior",
          "description": "Chaple, VESPERS DRESS",
          "resource": [3, 4],
          "color": "#ff0000",
          "isRequired": true,
          "location": ""
        },
        {
          "id": 57,
          "start": "2023-06-23T09:10",
          "end": "2023-06-23T10:10",
          "title": "Block C",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#67B767",
          "isRequired": true,
          "location": ""
        },
        {
          "id": 59,
          "start": "2023-06-23T10:20",
          "end": "2023-06-23T11:15",
          "title": "Block D",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#67B767",
          "isRequired": true,
          "location": ""
        },
        {
          "id": 60,
          "start": "2023-06-23T11:25",
          "end": "2023-06-23T12:20",
          "title": "Block E",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#67B767",
          "isRequired": true,
          "location": ""
        },
        {
          "id": 61,
          "start": "2023-06-23T11:45",
          "end": "2023-06-23T13:00",
          "title": "Buffet Lunch",
          "description": "Menu: Chicken. If you have E period free, please come early.",
          "resource": [1, 2, 3, 4],
          "color": "#3232BF",
          "isRequired": false,
          "location": ""
        },
        {
          "id": 72,
          "start": "2023-06-23T12:30",
          "end": "2023-06-23T17:30",
          "title": "Afternoon Activities",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#67B767",
          "isRequired": false,
          "location": ""
        },
        {
          "id": 783,
          "start": "2023-06-23T14:30",
          "end": "2023-06-23T15:30",
          "title": "Snack in Refactory",
          "description": "Please be neat.",
          "resource": [1, 2, 3, 4],
          "color": "#8000FF",
          "isRequired": false,
          "location": "Refactory"
        },
        {
          "id": 722,
          "start": "2023-06-23T14:15",
          "end": "2023-06-23T14:45",
          "title": "JV GOLF vs Salisbury",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#999928",
          "isRequired": false,
          "location": ""
        },
        {
          "id": 733,
          "start": "2023-06-23T15:00",
          "end": "2023-06-23T16:30",
          "title": "VARS Baseball vs Kingswood",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#999928",
          "isRequired": false,
          "location": ""
        },
        {
          "id": 75,
          "start": "2023-06-23T15:00",
          "end": "2023-06-23T16:30",
          "title": "VARS Lacrosse vs Berkshine",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#999928",
          "isRequired": false,
          "location": ""
        },
        {
          "id": 78,
          "start": "2023-06-23T17:00",
          "end": "2023-06-23T18:30",
          "title": "Buffet Dinner",
          "description": "Smart casual. Menu: Chicken.",
          "resource": [1, 2, 3, 4],
          "color": "#3232BF",
          "isRequired": false,
          "location": ""
        },
        {
          "id": 80,
          "start": "2023-06-23T18:00",
          "end": "2023-06-23T19:30",
          "title": "Special Olympics Soccer",
          "description": "JV Soccer field",
          "resource": [1, 2, 3, 4],
          "color": "#658FB9",
          "isRequired": false,
          "location": "JV Soccer field"
        },
        {
          "id": 79,
          "start": "2023-06-23T18:00",
          "end": "2023-06-23T18:45",
          "title": "Investment Club",
          "description": "Meets in the LC",
          "resource": [1, 2, 3, 4],
          "color": "#658FB9",
          "isRequired": false,
          "location": "LC"
        },
        {
          "id": 81,
          "start": "2023-06-23T18:45",
          "end": "2023-06-23T19:45",
          "title": "Network Club",
          "description": "Meets in the Office bla bla",
          "resource": [1, 2, 3, 4],
          "color": "#658FB9",
          "isRequired": false,
          "location": "Office"
        },
        {
          "id": 82,
          "start": "2023-06-23T18:45",
          "end": "2023-06-23T19:45",
          "title": "Applied Math Club",
          "description": "Ele 31",
          "resource": [1, 2, 3, 4],
          "color": "#658FB9",
          "isRequired": false,
          "location": "Ele 31"
        },
        {
          "id": 83,
          "start": "2023-06-23T18:45",
          "end": "2023-06-23T19:45",
          "title": "Community time",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#658FB9",
          "isRequired": true,
          "location": ""
        },
        {
          "id": 84,
          "start": "2023-06-23T19:45",
          "end": "2023-06-23T21:30",
          "title": "Study Hall",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#20C420",
          "isRequired": false,
          "location": ""
        },
        {
          "id": 85,
          "start": "2023-06-23T21:30",
          "end": "2023-06-23T22:30",
          "title": "McDonald's",
          "description": "For sale in the Hawk's Nest",
          "resource": [1, 2, 3, 4],
          "color": "#3232BF",
          "isRequired": false,
          "location": ""
        },
        {
          "id": 86,
          "start": "2023-06-23T22:30",
          "end": "2023-06-23T22:45",
          "title": "Dorm Check",
          "description": "",
          "resource": [1, 2, 3, 4],
          "color": "#FF5300",
          "isRequired": false,
          "location": ""
        }
      ],
    };
    return data;
  }

  Future<dynamic> postDailySchedule(String date, String url) async {
    return await _httpRequest('POST', '$baseUrl/data/daily-schedule/', data: {date: url});
  }

  Future<dynamic> putDailySchedule(String date, Map<String, String> scheduleData) async {
    return await _httpRequest('PUT', '$baseUrl/data/daily-schedule/$date', data: scheduleData);
  }

  Future<dynamic> deleteDailySchedule(String date) async {
    return await _httpRequest('DELETE', '$baseUrl/data/daily-schedule/$date');
  }

  // food menu
  Future<List<Map<String, dynamic>>> getFoodMenu() async {
    dynamic data = await _httpRequest('GET', '$baseUrl/data/food-menu/all');

    if (data['list'] == null) {
      return [Map<String, dynamic>.from(data)];
    }
    List<Map<String, String>> listOfMaps = List<Map<String, String>>.from(data['list']);
    return listOfMaps;
  }

  Future<List<Map<String, dynamic>>> getGames() async {
    dynamic data = await _httpRequest('GET', '$baseUrl/data/games/');
    List<Map<String, dynamic>> listOfMaps = List<Map<String, dynamic>>.from(data['list']);
    return listOfMaps;
  }

  Future<List<Map<String, dynamic>>> getSports() async {
    dynamic data = await _httpRequest('GET', '$baseUrl/data/sports/');
    List<Map<String, dynamic>> listOfMaps = List<Map<String, dynamic>>.from(data['list']);
    return listOfMaps;
  }

  Future<List<Map<String, dynamic>>> getLostAndFound() async {
    dynamic data = await _httpRequest('GET', '$baseUrl/data/lost-and-found/');
    List<Map<String, dynamic>> listOfMaps = List<Map<String, dynamic>>.from(data['items']);
    return listOfMaps;
  }

  Future<dynamic> postLostAndFound(Map<String, String> lostAndFoundData, File imageFile) async {
    return await _httpRequest('POST', '$baseUrl/data/lost-and-found/', data: lostAndFoundData, imageFile: imageFile);
  }

  Future<dynamic> putLostAndFound(int id, Map<String, String> lostAndFoundData, File? imageFile) async {
    return await _httpRequest('PUT', '$baseUrl/data/lost-and-found/image/$id', data: lostAndFoundData, imageFile: imageFile, contentType: "multipart/form-data");
  }

  Future<dynamic> deleteLostAndFound(String id) async {
    return await _httpRequest('DELETE', '$baseUrl/data/lost-and-found/$id');
  }

  Future<dynamic> getLostAndFoundItemImage(String id) async {
    return await _httpRequest('GET', '$baseUrl/data/lost-and-found/image/$id');
  }

  Future<List<Map<String, dynamic>>> getSchoolStoreItems() async {
    dynamic data = await _httpRequest('GET', '$baseUrl/data/school-store/');
    List<Map<String, dynamic>> listOfMaps = List<Map<String, dynamic>>.from(data['list']);
    return listOfMaps;
  }

  Future<dynamic> postSchoolStoreItem(Map<String, String> schoolStoreItemData, File imageFile) async {
    return await _httpRequest('POST', '$baseUrl/data/school-store/', data: schoolStoreItemData, imageFile: imageFile);
  }

  Future<dynamic> putSchoolStoreItem(int id, Map<String, String> schoolStoreItemData, File? imageFile) async {
    return await _httpRequest('PUT', '$baseUrl/data/school-store/$id', data: schoolStoreItemData, imageFile: imageFile, contentType: "multipart/form-data");
  }

  Future<dynamic> getSchoolStoreItemImage(String id) async {
    return await _httpRequest('GET', '$baseUrl/data/school-store/image/$id');
  }

  Future<dynamic> deleteSchoolStoreItem(String id) async {
    return await _httpRequest('DELETE', '$baseUrl/data/school-store/$id');
  }

  Future<dynamic> _httpRequest(String method, String url, {Map<String, String>? data, File? imageFile, String? contentType}) async {
    if (contentType == "application/json" && imageFile != null) {
      throw BadRequestException('Error: Cannot upload image with application/json content type');
    }
    var request;
    if (method == 'PUT' || method == 'POST') {
      if (contentType == "multipart/form-data" || imageFile != null) {
        request = MultipartRequest(method, Uri.parse(url));
        data?.forEach((key, value) {
          request.fields[key] = value;
        });
        var multipartFile;
        if (imageFile != null) {
          multipartFile = await MultipartFile.fromPath(
            'image_file', imageFile.path,
            contentType: MediaType('image', 'jpeg')
          );
          request.files.add(multipartFile);
        }
      } else {
        request = Request(method, Uri.parse(url));
        request.headers['Content-Type'] = 'application/json';
        request.body = jsonEncode(data);
      }
    } else {
      request = Request(method, Uri.parse(url));
    }
    
    if (token != null) {
      request.headers["Authorization"] = "Bearer $token";
    }

    if (Data.user?.uid != null) {
      request.headers["uid"] = Data.user!.uid ?? '';
    }

    // Set the 'Origin' header
    // request.headers.set('Origin', 'https://your-origin.com');

    // Set the 'Referer-Policy' header
    // request.headers.set('Referer-Policy', 'strict-origin-when-cross-origin');

    // Set any other necessary headers for authentication or API access
    // request.headers.set('Client-data', 'your-session-token');
    final streamedResponse = await request.send();
    Response response = await Response.fromStream(streamedResponse);
    if (response.statusCode == ResponseType.UNAUTHORIZED) {
      throw UnauthorizedException('Error ${response.statusCode}: Failed to load data');
    } else if (response.statusCode == ResponseType.BAD_REQUEST) {
      throw BadRequestException('Error ${response.statusCode}: Failed to load data');
    } else if (response.statusCode == ResponseType.NOT_FOUND) {
      throw NotFoundException('Error ${response.statusCode}: Failed to load data');
    } else if (response.statusCode == ResponseType.INTERNAL_SERVER_ERROR) {
      throw InternalServerErrorException('Error ${response.statusCode}: Failed to load data');
    } else if (response.statusCode == ResponseType.SERVICE_UNAVAILABLE) {
      throw ServiceUnavailableException('Error ${response.statusCode}: Failed to load data');
    } else if (response.statusCode == ResponseType.GATEWAY_TIMEOUT) {
      throw GatewayTimeoutException('Error ${response.statusCode}: Failed to load data');
    } 

    if (response.statusCode == 200 || response.statusCode == 201) {
      dynamic data;
      String responseBody = response.body;
      try {
        data = jsonDecode(responseBody);
      } on FormatException {
        // responseBody is not valid JSON but string
        return responseBody;
      }
      return data;
    } 
    throw UnknownResponseException('Error ${response.statusCode}: Failed to load data');
  }
}
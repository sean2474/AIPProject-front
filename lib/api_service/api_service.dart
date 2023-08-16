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
  Future<List<dynamic>> getDailySchedule() async {
    // TODO: delete after testing
    List<String> dateList = ['2023-08-09', '2023-08-10', '2023-08-11', '2023-08-12'];
    // List<String> dateList = [];
    // String currentDate = DateTime.now().toString().substring(0, 10);
    // for (int i = -3; i <= 3; i++) {
    //   dateList.add(DateTime.parse(currentDate).add(Duration(days: i)).toString().substring(0, 10));
    // }
    List<dynamic> result = [];
    for (String date in dateList) {
      List<dynamic>? event = (await _httpRequest('GET', '$baseUrl/data/daily-schedule/events?date=$date'))["events"];
      if (event != null) result.addAll(event);
    }
    return result;
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
        return responseBody;
      }
      return data;
    } 
    throw UnknownResponseException('Error ${response.statusCode}: Failed to load data');
  }
}
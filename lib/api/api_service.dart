import 'dart:convert';
import 'package:billing_mobile/models/login_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


final String baseUrl = 'https://billing.sham360.com';

class ApiService {
  // Общая обработка ответа от сервера 401
  Future<http.Response> _handleResponse(http.Response response) async {
    if (response.statusCode == 401) {
      _redirectToLogin();
      throw Exception('Неавторизованный доступ!');
    }
    return response;
  }

  void _redirectToLogin() {
    final navigatorKey = GlobalKey<NavigatorState>();
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  }

// Добавьте эти методы в класс ApiService
Future<void> _saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<void> clearToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
}

  //_________________________________ START___API__METHOD__GET__POST__PATCH__DELETE____________________________________________//

  Future<http.Response> _getRequest(String path) async {
    final token = await getToken(); 
    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Device': 'mobile'
      },
    );

    // print('Статус ответа! ${response.statusCode}');
    // print('Тело ответа!${response.body}');

    return _handleResponse(response);
  }

  // Метод для выполнения POST-запросов
  Future<http.Response> _postRequest(
      String path, Map<String, dynamic> body) async {
    final token = await getToken(); 

    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null)
          'Authorization': 'Bearer $token',
        'Device': 'mobile'
      },
      body: json.encode(body),
    );

    print('Статус ответа! ${response.statusCode}');
    print('Тело ответа!${response.body}');

    return _handleResponse(response);
  }

// Метод для выполнения PATCH-запросов
  Future<http.Response> _patchRequest(
      String path, Map<String, dynamic> body) async {
    final token = await getToken();

    final response = await http.patch(
      Uri.parse('$baseUrl$path'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null)
          'Authorization': 'Bearer $token',
        'Device': 'mobile'
      },
      body: json.encode(body),
    );

    print('Статус ответа! ${response.statusCode}');
    print('Тело ответа!${response.body}');

    return _handleResponse(response);
  }

  // Метод для выполнения DELETE-запросов
  Future<http.Response> _deleteRequest(String path) async {
    final token = await getToken(); 

    final response = await http.delete(
      Uri.parse('$baseUrl$path'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Device': 'mobile'
      },
    );

    print('Статус ответа! ${response.statusCode}');
    print('Тело ответа!${response.body}');

    return _handleResponse(response);
  }

  //_________________________________ END___API__METHOD__GET__POST__PATCH__DELETE____________________________________________//

  //_________________________________ START___API__LOGIN____________________________________________//

  // // Метод для проверки логина и пароля
Future<LoginResponse> login(LoginModel loginModel) async {
  final response = await _postRequest('/login', loginModel.toJson());
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final loginResponse = LoginResponse.fromJson(data);
    await _saveToken(loginResponse.token);
    return loginResponse;
  } else {
    final errorData = json.decode(response.body);
    final errorMessage = errorData['message'] ?? 'Неправильный email или пароль!';
    throw Exception(errorMessage);
  }
}

   
  // //_________________________________ START_____API__SCREEN__LEAD____________________________________________//

  // //_________________________________ START_____API_SCREEN__CLIENTS____________________________________________//

  // Future<List<Goods>> getGoods({int page = 1, int perPage = 20}) async {
  //   final organizationId = await getSelectedOrganization();
  //   final String path =
  //       '/good?page=$page&per_page=$perPage&organization_id=$organizationId';

  //   final response = await _getRequest(path);

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = json.decode(response.body);
  //     if (data.containsKey('result') && data['result']['data'] is List) {
  //       return (data['result']['data'] as List)
  //           .map((item) => Goods.fromJson(item as Map<String, dynamic>))
  //           .toList();
  //     } else {
  //       throw Exception('Ошибка: Неверный формат данных');
  //     }
  //   } else {
  //     throw Exception('Ошибка загрузки товаров: ${response.statusCode}');
  //   }
  // }

  // Future<List<Goods>> getGoodsById(int goodsId) async {
  //   final organizationId = await getSelectedOrganization();
  //   final String path = '/good/$goodsId?organization_id=$organizationId';

  //   final response = await _getRequest(path);

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = json.decode(response.body);
  //     if (data.containsKey('result')) {
  //       return [Goods.fromJson(data['result'] as Map<String, dynamic>)];
  //     } else {
  //       throw Exception('Ошибка: Неверный формат данных');
  //     }
  //   } else {
  //     throw Exception(
  //         'Ошибка загрузки просмотра товаров: ${response.statusCode}');
  //   }
  // }

  // Future<List<SubCategoryAttributesData>> getSubCategoryAttributes() async {
  //   final organizationId = await getSelectedOrganization();
  //   final String path =
  //       '/category/get/subcategories?organization_id=$organizationId';

  //   final response = await _getRequest(path);

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = json.decode(response.body);
  //     if (data.containsKey('data')) {
  //       return (data['data'] as List)
  //           .map((item) => SubCategoryAttributesData.fromJson(
  //               item as Map<String, dynamic>))
  //           .toList();
  //     } else {
  //       throw Exception('Ошибка: Неверный формат данных');
  //     }
  //   } else {
  //     throw Exception(
  //         'Ошибка загрузки просмотра товаров: ${response.statusCode}');
  //   }
  // }

  // Future<Map<String, dynamic>> createGoods({
  //   required String name,
  //   required int parentId,
  //   required String description,
  //   required int quantity,
  //   required List<String> attributeNames,
  //   List<File>? images,
  //   required bool isActive,
  //   double? discountPrice, // Добавлено
  // }) async {
  //   try {
  //     final token = await getToken();
  //     final organizationId = await getSelectedOrganization();
  //     var uri = Uri.parse(
  //         '${baseUrl}/good${organizationId != null ? '?organization_id=$organizationId' : ''}');
  //     var request = http.MultipartRequest('POST', uri);
  //     request.headers.addAll({
  //       'Authorization': 'Bearer $token',
  //       'Accept': 'application/json',
  //       'Device': 'mobile'
  //     });

  //     request.fields['name'] = name;
  //     request.fields['category_id'] = parentId.toString();
  //     request.fields['description'] = description;
  //     request.fields['quantity'] = quantity.toString();
  //     request.fields['is_active'] = isActive.toString();
  //     if (discountPrice != null) {
  //       // Добавлено
  //       request.fields['discount_price'] = discountPrice.toString();
  //     }

  //     for (int i = 0; i < attributeNames.length; i++) {
  //       request.fields['attributes[$i][attribute_id]'] = (i + 1).toString();
  //       request.fields['attributes[$i][value]'] = attributeNames[i];
  //     }

  //     if (images != null && images.isNotEmpty) {
  //       for (var image in images) {
  //         final imageFile =
  //             await http.MultipartFile.fromPath('files[]', image.path);
  //         request.files.add(imageFile);
  //       }
  //     }

  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //     final responseBody = json.decode(response.body);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return {
  //         'success': true,
  //         'message': 'goods_created_successfully',
  //         'data': CategoryData.fromJson(responseBody),
  //       };
  //     } else {
  //       return {
  //         'success': false,
  //         'message': responseBody['message'] ?? 'Failed to create goods',
  //         'error': responseBody,
  //       };
  //     }
  //   } catch (e) {
  //     return {
  //       'success': false,
  //       'message': 'An error occurred: $e',
  //     };
  //   }
  // }

  // Future<Map<String, dynamic>> updateGoods({
  //   required int goodId,
  //   required String name,
  //   required int parentId,
  //   required String description,
  //   required int quantity,
  //   required List<String> attributeNames,
  //   List<File>? images,
  //   required bool isActive,
  //   double? discountPrice, // Добавлено
  // }) async {
  //   try {
  //     final token = await getToken();
  //     final organizationId = await getSelectedOrganization();
  //     var uri = Uri.parse(
  //         '$baseUrl/good/$goodId${organizationId != null ? '?organization_id=$organizationId' : ''}');
  //     var request = http.MultipartRequest('POST', uri);
  //     request.headers.addAll({
  //       'Authorization': 'Bearer $token',
  //       'Accept': 'application/json',
  //       'Device': 'mobile'
  //     });

  //     request.fields['name'] = name;
  //     request.fields['category_id'] = parentId.toString();
  //     request.fields['description'] = description;
  //     request.fields['quantity'] = quantity.toString();
  //     request.fields['is_active'] = isActive.toString();
  //     if (discountPrice != null) {
  //       // Добавлено
  //       request.fields['discount_price'] = discountPrice.toString();
  //     }

  //     for (int i = 0; i < attributeNames.length; i++) {
  //       request.fields['attributes[$i][attribute_id]'] = (i + 1).toString();
  //       request.fields['attributes[$i][value]'] = attributeNames[i];
  //     }

  //     if (images != null && images.isNotEmpty) {
  //       for (var image in images) {
  //         final imageFile =
  //             await http.MultipartFile.fromPath('files[]', image.path);
  //         request.files.add(imageFile);
  //       }
  //     }

  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //     final responseBody = json.decode(response.body);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return {
  //         'success': true,
  //         'message': 'goods_updated_successfully',
  //         'data': responseBody,
  //       };
  //     } else {
  //       return {
  //         'success': false,
  //         'message': responseBody['message'] ?? 'Failed to update goods',
  //         'error': responseBody,
  //       };
  //     }
  //   } catch (e) {
  //     return {
  //       'success': false,
  //       'message': 'An error occurred: $e',
  //     };
  //   }
  // }

  // Future<bool> deleteGoods(int goodId, {int? organizationId}) async {
  //   try {
  //     final token = await getToken();
  //     if (token == null) throw Exception('Токен не найден');

  //     final orgId = await getSelectedOrganization();
  //     final effectiveOrgId = organizationId ??
  //         orgId; // Используем переданный organizationId или из getSelectedOrganization
  //     var uri = Uri.parse(
  //       '$baseUrl/good/$goodId${effectiveOrgId != null ? '?organization_id=$effectiveOrgId' : ''}',
  //     );

  //     final response = await http.delete(
  //       uri,
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Accept': 'application/json',
  //         'Device': 'mobile',
  //       },
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 204) {
  //       return true;
  //     } else {
  //       final jsonResponse = jsonDecode(response.body);
  //       throw Exception(
  //           jsonResponse['message'] ?? 'Ошибка при удалении товара');
  //     }
  //   } catch (e) {
  //     print('Ошибка удаления товара: $e');
  //     return false;
  //   }
  // }

  //_________________________________ END____API_SCREEN__CLIENTS____________________________________________//

}

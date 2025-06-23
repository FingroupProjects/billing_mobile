import 'dart:convert';
import 'package:billing_mobile/models/Country_model.dart';
import 'package:billing_mobile/models/businessType_model.dart';
import 'package:billing_mobile/models/client_history_model.dart';
import 'package:billing_mobile/models/clientsById_model.dart';
import 'package:billing_mobile/models/clients_model.dart';
import 'package:billing_mobile/models/currency_model.dart';
import 'package:billing_mobile/models/login_model.dart';
import 'package:billing_mobile/models/organizations_model.dart';
import 'package:billing_mobile/models/partner_model.dart';
import 'package:billing_mobile/models/sale_model.dart';
import 'package:billing_mobile/models/tariff_model.dart';
import 'package:billing_mobile/models/transactions_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


// const String baseUrl = 'https://billing-back.sham360.com/api';
const String baseUrl = 'https://billing-back.shamcrm.com/api';

class ApiService {
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
// Сохранение роли
  Future<void> _saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
  }
  // Получение роли
  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }
  // Очистка роли
  Future<void> clearRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('role');
  }
Future<void> _saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

// Обновляем clearToken для очистки роли
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await clearRole(); // Очищаем роль при выходе
  }

  // Метод для проверки, является ли пользователь админом
  Future<bool> isAdmin() async {
    final role = await getRole();
    return role == 'admin';
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

    // print('Статус ответа! ${response.statusCode}');
    // print('Тело ответа!${response.body}');

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

    // print('Статус ответа! ${response.statusCode}');
    // print('Тело ответа!${response.body}');

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

    // print('Статус ответа! ${response.statusCode}');
    // print('Тело ответа!${response.body}');

    return _handleResponse(response);
  }

  //_________________________________ END___API__METHOD__GET__POST__PATCH__DELETE____________________________________________//

  //_________________________________ START___API__LOGIN____________________________________________//

Future<LoginResponse> login(LoginModel loginModel) async {
    final response = await _postRequest('/login', loginModel.toJson());
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final loginResponse = LoginResponse.fromJson(data);
      await _saveToken(loginResponse.token);
      await _saveRole(loginResponse.role); // Сохраняем роль
      return loginResponse;
    } else if (response.statusCode == 401) {
      throw ('Неправильный логин или пароль!');
    } else {
      final errorData = json.decode(response.body);
      final errorMessage = errorData['message'] ?? 'Неправильный логин или пароль!';
      throw (errorMessage);
    }
  }
   
  // //_________________________________ START_____API__SCREEN__LEAD____________________________________________//

  // //_________________________________ START_____API_SCREEN__CLIENTS____________________________________________//

// Future<ClientListResponse> getClients({
//   int page = 1,
//   String? search,
//   int? demo,
//   int? status,
//   int? tariff,
//   int? partner,
// }) async {
//   try {
//     final queryParameters = {
//       'page': page.toString(),
//       if (search != null && search.isNotEmpty) 'search': search,
//       if (demo != null) 'demo': demo.toString(),
//       if (status != null) 'status': status.toString(),
//       if (tariff != null) 'tariff': tariff.toString(),
//       if (partner != null) 'partner': partner.toString(),
//     };
    
//     final uri = Uri.parse('/clients').replace(queryParameters: queryParameters);
//     final response = await _getRequest(uri.toString());
    
//     switch (response.statusCode) {
//       case 200:
//         final jsonData = json.decode(response.body);
//         if (jsonData['clients'] != null) {
//           final adaptedJson = {
//             'view': '/clients',
//             'data': {
//               'clients': jsonData['clients'],
//               'partners': jsonData['partners'] ?? [],
//               'tariffs': jsonData['tariffs'] ?? [],
//             }
//           };
//           return ClientListResponse.fromJson(adaptedJson);
//         }
//         return ClientListResponse.fromJson(jsonData);
      
//       case 400:
//         throw ('Некорректный запрос: ${response.body}');
      
//       case 401:
//         throw ('Не авторизован: требуется аутентификация');
      
//       case 403:
//         throw ('Доступ запрещен');
      
//       case 404:
//         throw ('Ресурс не найден');
      
//       case 429:
//         throw ('Слишком много запросов. Пожалуйста, попробуйте позже');
      
//       case 500:
//         throw ('Внутренняя ошибка сервера. Пожалуйста, попробуйте позже');
      
//       default:
//         throw ('Ошибка загрузки клиентов!');
//     }
//   } catch (e) {
//     throw ('Ошибка загрузки клиентов!');
//   }
// }
Future<ClientListResponse> getClients({
  int page = 1,
  String? search,
  int? demo,
  int? status,
  int? tariff,
  int? partner,
  int? countryId, // Added countryId parameter
  int? currencyId, // Added currencyId parameter  
}) async {
  try {
    final queryParameters = {
      'page': page.toString(),
      if (search != null && search.isNotEmpty) 'search': search,
      'demo': (demo ?? 0).toString(),  
      'status': (status ?? 1).toString(),  
      if (tariff != null) 'tariff': tariff.toString(),
      if (partner != null) 'partner': partner.toString(),
      if (countryId != null) 'country_id': countryId.toString(), // Added country_id to query parameters
      if (currencyId != null) 'currency_id': currencyId.toString(), // Added currency_id to query parameters
    };
    
    final uri = Uri.parse('/clients').replace(queryParameters: queryParameters);
    final response = await _getRequest(uri.toString());
    
    switch (response.statusCode) {
      case 200:
        final jsonData = json.decode(response.body);
        if (jsonData['clients'] != null) {
          final adaptedJson = {
            'view': '/clients',
            'data': {
              'clients': jsonData['clients'],
              'partners': jsonData['partners'] ?? [],
              'tariffs': jsonData['tariffs'] ?? [],
            }
          };
          return ClientListResponse.fromJson(adaptedJson);
        }
        return ClientListResponse.fromJson(jsonData);
      
      case 400:
        throw ('Некорректный запрос: ${response.body}');
      
      case 401:
        throw ('Не авторизован: требуется аутентификация');
      
      case 403:
        throw ('Доступ запрещен');
      
      case 404:
        throw ('Ресурс не найден');
      
      case 429:
        throw ('Слишком много запросов. Пожалуйста, попробуйте позже');
      
      case 500:
        throw ('Внутренняя ошибка сервера. Пожалуйста, попробуйте позже');
      
      default:
        throw ('Ошибка загрузки клиентов!');
    }
  } catch (e) {
    throw ('Ошибка загрузки клиентов!');
  }
}

Future<ClientListResponse> getNfrClients({
  int page = 1,
  String? search,
  int? demo,
  int? status,
  int? tariff,
  int? partner,
  int? countryId, // Added countryId parameter
  int? currencyId, // Added currencyId parameter  
}) async {
  try {
    final queryParameters = {
      'page': page.toString(),
      if (search != null && search.isNotEmpty) 'search': search,
      'demo': (demo ?? 0).toString(),
      'status': (status ?? 1).toString(),
      if (tariff != null) 'tariff': tariff.toString(),
      if (partner != null) 'partner': partner.toString(),
       if (countryId != null) 'country_id': countryId.toString(), // Added country_id to query parameters
      if (currencyId != null) 'currency_id': currencyId.toString(), // Added currency_id to query parameters
    };

    final uri = Uri.parse('/clients/nfr').replace(queryParameters: queryParameters);
    final response = await _getRequest(uri.toString());

    switch (response.statusCode) {
      case 200:
        final jsonData = json.decode(response.body);
        if (jsonData['clients'] != null) {
          final adaptedJson = {
            'view': '/nfr-clients',
            'data': {
              'clients': jsonData['clients'],
              'partners': jsonData['partners'] ?? [],
              'tariffs': jsonData['tariffs'] ?? [],
            }
          };
          return ClientListResponse.fromJson(adaptedJson);
        }
        return ClientListResponse.fromJson(jsonData);

      case 400:
        throw ('Некорректный запрос: ${response.body}');
      case 401:
        throw ('Не авторизован: требуется аутентификация');
      case 403:
        throw ('Доступ запрещен');
      case 404:
        throw ('Ресурс не найден');
      case 429:
        throw ('Слишком много запросов. Пожалуйста, попробуйте позже');
      case 500:
        throw ('Внутренняя ошибка сервера. Пожалуйста, попробуйте позже');
      default:
        throw ('Ошибка загрузки NFR клиентов!');
    }
  } catch (e) {
    throw ('Ошибка загрузки NFR клиентов!');
  }
}
Future<ClientListResponse> getDemoClients({
  int page = 1,
  String? search,
  int? demo,  // Этот параметр будет игнорироваться
  int? status,
  int? tariff,
  int? partner,
  int? countryId,
  int? currencyId,
}) async {
  try {
    final queryParameters = {
      'page': page.toString(),
      'demo': '1',  // ВСЕГДА устанавливаем demo = 1
      'status': (status ?? 1).toString(),
      if (search != null && search.isNotEmpty) 'search': search,
      if (tariff != null) 'tariff': tariff.toString(),
      if (partner != null) 'partner': partner.toString(),
      if (countryId != null) 'country_id': countryId.toString(),
      if (currencyId != null) 'currency_id': currencyId.toString(),
    };
    
    final uri = Uri.parse('/clients').replace(queryParameters: queryParameters);
    final response = await _getRequest(uri.toString());
    
    switch (response.statusCode) {
      case 200:
        final jsonData = json.decode(response.body);
        if (jsonData['clients'] != null) {
          final adaptedJson = {
            'view': '/clients',
            'data': {
              'clients': jsonData['clients'],
              'partners': jsonData['partners'] ?? [],
              'tariffs': jsonData['tariffs'] ?? [],
            }
          };
          return ClientListResponse.fromJson(adaptedJson);
        }
        return ClientListResponse.fromJson(jsonData);
      
      case 400:
        throw ('Некорректный запрос: ${response.body}');
      
      case 401:
        throw ('Не авторизован: требуется аутентификация');
      
      case 403:
        throw ('Доступ запрещен');
      
      case 404:
        throw ('Ресурс не найден');
      
      case 429:
        throw ('Слишком много запросов. Пожалуйста, попробуйте позже');
      
      case 500:
        throw ('Внутренняя ошибка сервера. Пожалуйста, попробуйте позже');
      
      default:
        throw ('Ошибка загрузки клиентов!');
    }
  } catch (e) {
    throw ('Ошибка загрузки клиентов!');
  }
}
Future<ClientListResponse> getInActiveClients({
  int page = 1,
  String? search,
  int? demo,
  int? status,
  int? tariff,
  int? partner,
  int? countryId,
  int? currencyId,
}) async {
  try {
    final queryParameters = {
      'page': page.toString(),
      'demo': (demo ?? 0).toString(),  // Всегда добавляем demo (по умолчанию 0)
      'status': (status ?? 0).toString(),  // Всегда добавляем status (по умолчанию 0)
      if (search != null && search.isNotEmpty) 'search': search,
      if (tariff != null) 'tariff': tariff.toString(),
      if (partner != null) 'partner': partner.toString(),
      if (countryId != null) 'country_id': countryId.toString(),
      if (currencyId != null) 'currency_id': currencyId.toString(),
    };
    
    final uri = Uri.parse('/clients').replace(queryParameters: queryParameters);
    final response = await _getRequest(uri.toString());
    
    switch (response.statusCode) {
      case 200:
        final jsonData = json.decode(response.body);
        if (jsonData['clients'] != null) {
          final adaptedJson = {
            'view': '/clients',
            'data': {
              'clients': jsonData['clients'],
              'partners': jsonData['partners'] ?? [],
              'tariffs': jsonData['tariffs'] ?? [],
            }
          };
          return ClientListResponse.fromJson(adaptedJson);
        }
        return ClientListResponse.fromJson(jsonData);
      
      case 400:
        throw ('Некорректный запрос: ${response.body}');
      
      case 401:
        throw ('Не авторизован: требуется аутентификация');
      
      case 403:
        throw ('Доступ запрещен');
      
      case 404:
        throw ('Ресурс не найден');
      
      case 429:
        throw ('Слишком много запросов. Пожалуйста, попробуйте позже');
      
      case 500:
        throw ('Внутренняя ошибка сервера. Пожалуйста, попробуйте позже');
      
      default:
        throw ('Ошибка загрузки клиентов!');
    }
  } catch (e) {
    throw ('Ошибка загрузки клиентов!');
  }
}

Future<ClientByIdResponse> getClientById(String clientId) async {
  try {
    final response = await _getRequest('/clients/$clientId');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ClientByIdResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to load client: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load client: ');
  }
}

 Future<Map<String, dynamic>> createClients({
    required String fio,
    required String phone,
    required String email,
    String? contactPerson,
    required String subDomain,
    int? partnerId,
    String? clientType,
    int? tariffId,
    int? saleId,
    int? countryId,
    required bool isDemo,
  }) async {

    final response = await _postRequest( '/clients/store', 
        {
          'name': fio,
          'phone': phone,
          'email': email,
          'contact_person': contactPerson,
          'sub_domain': subDomain,
          'partner_id': partnerId,
          'client_type': clientType,
          'tariff_id': tariffId,
          'sale_id': saleId,
          'country_id': countryId,
          'is_demo': isDemo,
        });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'Клиент успещно создан!'};
      } else if (response.statusCode == 422) {
        if (response.body.contains('phone')) {
        return {'success': false, 'message': 'Телефон уже зарегистрирован.'};
      }
      if (response.body.contains('email')) {
        return {'success': false, 'message': 'Введите корректный адрес электронной почты.'};
      } else if (response.body.contains('sub_domain')) {
        return {'success': false, 'message': 'Поддомен уже зарегистрирован.'};
      } else {
        return {'success': false, 'message': 'Неизвестная ошибка!'};
      }
    } else {
      return {'success': false, 'message': 'Ошибка создания клиента!'};
    }
  }


  Future<List<Partner>> getPartners() async {
  try {
    final response = await _getRequest('/partners');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> partnersJson = jsonData['result']['data'];
      return partnersJson.map((orgJson) => Partner.fromJson(orgJson)).toList();
    } else {
      throw Exception('Failed to load partners: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load partners: ');
  }
}
  Future<List<SaleData>> getSales() async {
  try {
    final response = await _getRequest('/sale');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> saleJson = jsonData['result']['data'];
      return saleJson.map((orgJson) => SaleData.fromJson(orgJson)).toList();
    } else {
      throw Exception('Failed to load sales: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load sales: ');
  }
}

  Future<List<CountryData>> getCountries() async {
  try {
    final response = await _getRequest('/countries');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> countryJson = jsonData['result']['data'];
      return countryJson.map((orgJson) => CountryData.fromJson(orgJson)).toList();
    } else {
      throw Exception('Failed to load countries: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load countries: ');
  }
}

Future<List<CurrencyData>> getCurrencies() async {
  try {
    final response = await _getRequest('/currencies');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> currencyJson = jsonData['result']['data'];
      return currencyJson.map((curJson) => CurrencyData.fromJson(curJson)).toList();
    } else {
      throw Exception('Failed to load currencies: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load currencies: $e');
  }
}
/*************  ✨ Windsurf Command ⭐  *************/
/// Fetches a list of tariffs based on the provided code.
///
/// Sends a GET request to the server with the given code to retrieve a list of 
/// tariffs. The server's response is expected to be either a direct list of 
/// tariffs, or a map containing the tariffs under 'result.data' or 'data'. 
/// The function parses the JSON response into a list of `TariffData` objects.
///
/// Throws an exception if the server response is not successful or if the 
/// response format is unexpected.
///
/// [code] is the code used to filter the tariffs on the server.
///
/// Returns a `Future` that completes with a list of `TariffData`.

/*******  995fe2ee-9bcc-4cc6-bc25-91d2d0c69f56  *******/
Future<List<TariffData>> getTariffs(String code) async {
  try {
    final response = await _getRequest('/t/tariff?code=$code');
    print('Tariff request sent with code: $code');
    
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      
      // Проверяем структуру ответа
      List<dynamic> tariffJson;
      
      if (jsonData is List) {
        // Если сервер возвращает массив напрямую
        tariffJson = jsonData;
      } else if (jsonData is Map && jsonData.containsKey('result')) {
        // Если сервер возвращает в формате {result: {data: [...]}}
        tariffJson = jsonData['result']['data'];
      } else if (jsonData is Map && jsonData.containsKey('data')) {
        // Если сервер возвращает в формате {data: [...]}
        tariffJson = jsonData['data'];
      } else {
        throw Exception('Unexpected response format');
      }
      
      return tariffJson.map((tariffJson) => TariffData.fromJson(tariffJson)).toList();
    } else {
      throw Exception('Failed to load tariffs: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in getTariffs: $e'); // Добавим отладочную информацию
    throw Exception('Failed to load tariffs: $e');
  }
}

Future<List<History>> getClientHistory(int clientId) async {
    try {
      final response = await _getRequest( '/clients/getHistory/$clientId');

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body);
        final List<dynamic> jsonList = decodedJson['result']['history'];
        return jsonList.map((json) => History.fromJson(json)).toList();
      } else {
        print('Failed to load lead history!');
        throw Exception('Ошибка загрузки истории client!');
      }
    } catch (e) {
      print('Error occurred!');
      throw Exception('Ошибка загрузки истории client!');
    }
  }

  
  Future<void> ClientActiveDeactivate(int clientId, String rejectCause) async {
    final response = await _postRequest('/clients/activation/$clientId',
        {
          'reject_cause': rejectCause
        });

    if (response.statusCode != 200) {
      throw Exception('Статус клиента успешно изменен!');
    }
  }

  Future<void> OrganizationActiveDeactivate(int organizationId) async {
    final response = await _postRequest('/organizations/access/$organizationId',
        {
        });

    if (response.statusCode != 200) {
      throw Exception('Статус организации успешно изменен!');
    }
  }

  //_________________________________ END____API_SCREEN__CLIENTS____________________________________________//


  
  //_________________________________ START____API_SCREEN__ORGANIZATIONS____________________________________________//

  Future<List<BusinessTypeData>> getBusinessType() async {
  try {
    final response = await _getRequest('/businessType');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> businessTypeJson = jsonData['result']['data'];
      return businessTypeJson.map((orgJson) => BusinessTypeData.fromJson(orgJson)).toList();
    } else {
      throw Exception('Failed to load businessType: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load businessType: ');
  }
}


Future<List<Organization>> getClientByIdOrganizations(String clientId) async {
  try {
    final response = await _getRequest('/clients/getOrganizations/$clientId');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> organizationsJson = jsonData['result']['data'];
      return organizationsJson.map((orgJson) => Organization.fromJson(orgJson)).toList();
    } else {
      throw Exception('Failed to load organizations: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load organizations: ');
  }
}

Future<List<Organization>> getOrganizationsById(String organizationId) async {
  try {
    final response = await _getRequest('/organizations/$organizationId');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['organization'] != null) {
        return [Organization.fromJson(jsonData['organization'])];
      } else {
        return []; 
      }
    } else {
      throw Exception('Failed to load organizationsById: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load organizationsById: ');
  }
}


Future<Map<String, dynamic>> createOrganizations({
  required int clientId,
  required String name,
  required String phone,
  required String inn,
  required String businessTypeId,
  required String address,
}) async {
  final response = await _postRequest('/organizations/$clientId',
    {
      'name': name,
      'phone': phone,
      'INN': inn,
      'business_type_id': businessTypeId,
      'address': address,
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    return {'success': true, 'message': 'Организация успешно создана!'};
  } else if (response.statusCode == 422) {
    if (response.body.contains('phone')) {
      return {'success': false, 'message': 'Телефон уже зарегистрирован.'};
    }
    if (response.body.contains('INN')) {
      return {'success': false, 'message': 'ИНН уже зарегистрирован.'};
    }
    return {'success': false, 'message': 'Ошибка валидации. Проверьте введённые данные.'};
  } else if (response.statusCode >= 500) {
    return {'success': false, 'message': 'Ошибка сервера. Попробуйте позже.'};
  } else {
    return {
      'success': false,
      'message': 'Ошибка создания организации! Код: ${response.statusCode}'
    };
  }
}


  //_________________________________ END____API_SCREEN__ORGANIZATIONS____________________________________________//


  //_________________________________ START____API_SCREEN__TRANSACTION____________________________________________//


Future<TransactionListResponse> getClientByIdTransactions(String clientId, {int page = 1}) async {
    try {
      final response = await _getRequest('/clients/getTransactions/$clientId?page=$page');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final adaptedJson = {
          'view': '/clients/getTransactions/$clientId',
          'data': jsonData['result'],
        };
        return TransactionListResponse.fromJson(adaptedJson);
      } else {
        throw Exception('Ошибка загрузки транзакций: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('CATCH ERROR Ошибка загрузки транзакций: ');
    }
  }

Future<List<Transaction>> getTransactionsById(String transactionId) async {
  try {
    final response = await _getRequest('/transactions/$transactionId');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['transaction'] != null) {
        return [Transaction.fromJson(jsonData['transaction'])];
      } else {
        return []; 
      }
    } else {
      throw Exception('Failed to load TransactionById: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load TransactionById: ');
  }
}

Future<Map<String, dynamic>> createTransactions({
  required int clientId,
  required String date,
  required String sum,
}) async {
  final response = await _postRequest('/clients/create-transaction/$clientId',
    {
      'date': date,
      'sum': sum,
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    return {'success': true, 'message': 'Транзакция успешно создана!'};
  } else if (response.statusCode >= 500) {
    return {'success': false, 'message': 'Ошибка сервера. Попробуйте позже.'};
  } else {
    return {
      'success': false,
      'message': 'Ошибка создания Транзакции! Код: ${response.statusCode}'
    };
  }
}


  //_________________________________ END____API_SCREEN__TRANSACTION____________________________________________//


}

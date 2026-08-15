import 'dart:convert';
import 'package:billing_mobile/models/Country_model.dart';
import 'package:billing_mobile/models/ai_subscription_model.dart';
import 'package:billing_mobile/models/businessType_model.dart';
import 'package:billing_mobile/models/client_history_model.dart';
import 'package:billing_mobile/models/clientsById_model.dart';
import 'package:billing_mobile/models/clients_model.dart';
import 'package:billing_mobile/models/commercial_offer_model.dart';
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

  ClientListResponse _clientListResponseFromJson(
    Map<String, dynamic> jsonData, {
    required String view,
    bool? forceDemo,
  }) {
    if (jsonData['organizations'] != null) {
      final organizations = jsonData['organizations'];
      final organizationList = organizations is Map<String, dynamic>
          ? organizations['data'] ?? []
          : organizations;
      final normalizedOrganizationList = organizationList is List
          ? organizationList.map((organization) {
              if (forceDemo == null || organization is! Map<String, dynamic>) {
                return organization;
              }

              final client = organization['client'];
              if (client is! Map<String, dynamic>) {
                return {
                  ...organization,
                  'is_demo': forceDemo,
                };
              }

              return {
                ...organization,
                'client': {
                  ...client,
                  'is_demo': client['is_demo'] ?? forceDemo,
                },
              };
            }).toList()
          : [];
      final adaptedJson = {
        'view': view,
        'data': {
          'clients': {
            'current_page': organizations is Map<String, dynamic>
                ? organizations['current_page'] ?? 1
                : 1,
            'data': normalizedOrganizationList,
            'total': jsonData['total'] ??
                (organizations is Map<String, dynamic>
                    ? organizations['total'] ??
                        normalizedOrganizationList.length
                    : normalizedOrganizationList.length),
          },
          'partners': jsonData['partners'] ?? [],
          'tariffs': jsonData['tariffs'] ?? [],
        }
      };
      return ClientListResponse.fromJson(adaptedJson);
    }

    if (jsonData['clients'] != null) {
      final adaptedJson = {
        'view': view,
        'data': {
          'clients': jsonData['clients'],
          'partners': jsonData['partners'] ?? [],
          'tariffs': jsonData['tariffs'] ?? [],
        }
      };
      return ClientListResponse.fromJson(adaptedJson);
    }

    return ClientListResponse.fromJson(jsonData);
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
        if (token != null) 'Authorization': 'Bearer $token',
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
        if (token != null) 'Authorization': 'Bearer $token',
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
      final errorMessage =
          errorData['message'] ?? 'Неправильный логин или пароль!';
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
        if (demo != null) 'demo': demo.toString(),
        if (status != null) 'status': status.toString(),
        if (tariff != null) 'tariff': tariff.toString(),
        if (partner != null) 'partner': partner.toString(),
        if (countryId != null)
          'country_id':
              countryId.toString(), // Added country_id to query parameters
        if (currencyId != null)
          'currency_id':
              currencyId.toString(), // Added currency_id to query parameters
      };

      final uri = Uri.parse('/organizations-active-v2')
          .replace(queryParameters: queryParameters);
      final response = await _getRequest(uri.toString());

      switch (response.statusCode) {
        case 200:
          final jsonData = json.decode(response.body);
          return _clientListResponseFromJson(jsonData,
              view: '/organizations-active-v2');

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
        if (demo != null) 'demo': demo.toString(),
        if (status != null) 'status': status.toString(),
        if (tariff != null) 'tariff': tariff.toString(),
        if (partner != null) 'partner': partner.toString(),
        if (countryId != null)
          'country_id':
              countryId.toString(), // Added country_id to query parameters
        if (currencyId != null)
          'currency_id':
              currencyId.toString(), // Added currency_id to query parameters
      };

      final uri = Uri.parse('/organizations-nfr-v2')
          .replace(queryParameters: queryParameters);
      final response = await _getRequest(uri.toString());

      switch (response.statusCode) {
        case 200:
          final jsonData = json.decode(response.body);
          return _clientListResponseFromJson(jsonData,
              view: '/organizations-nfr-v2');

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
    int? demo,
    int? status,
    int? tariff,
    int? partner,
    int? countryId, // Added countryId parameter
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
        if (demo != null) 'demo': demo.toString(),
        if (status != null) 'status': status.toString(),
        if (tariff != null) 'tariff': tariff.toString(),
        if (partner != null) 'partner': partner.toString(),
        if (countryId != null) 'country': countryId.toString(),
      };

      final uri = Uri.parse('/organizations-demo-v2')
          .replace(queryParameters: queryParameters);
      final response = await _getRequest(uri.toString());

      switch (response.statusCode) {
        case 200:
          final jsonData = json.decode(response.body);
          return _clientListResponseFromJson(jsonData,
              view: '/organizations-demo-v2', forceDemo: true);

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
    int? countryId, // Added countryId parameter
    int? currencyId, // Added currencyId parameter
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
        if (demo != null) 'demo': demo.toString(),
        if (status != null) 'status': status.toString(),
        if (tariff != null) 'tariff': tariff.toString(),
        if (partner != null) 'partner': partner.toString(),
        if (countryId != null)
          'country_id':
              countryId.toString(), // Added country_id to query parameters
        if (currencyId != null)
          'currency_id':
              currencyId.toString(), // Added currency_id to query parameters
      };

      final uri = Uri.parse('/organizations-inActive-v2')
          .replace(queryParameters: queryParameters);
      final response = await _getRequest(uri.toString());

      switch (response.statusCode) {
        case 200:
          final jsonData = json.decode(response.body);
          return _clientListResponseFromJson(jsonData,
              view: '/organizations-inActive-v2');

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

  Future<CommercialOfferListResponse> getCommercialOffers({
    int page = 1,
    String? search,
    int? partnerId,
    String? requestType,
    int? tariffId,
    int? periodMonths,
    String? operationStatus,
    String? dateFrom,
    String? dateTo,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
        if (partnerId != null) 'partner_id': partnerId.toString(),
        if (requestType != null && requestType.isNotEmpty)
          'request_type': requestType,
        if (tariffId != null) 'tariff_id': tariffId.toString(),
        if (periodMonths != null) 'period_months': periodMonths.toString(),
        if (operationStatus != null && operationStatus.isNotEmpty)
          'operation_status': operationStatus,
        if (dateFrom != null && dateFrom.isNotEmpty) 'date_from': dateFrom,
        if (dateTo != null && dateTo.isNotEmpty) 'date_to': dateTo,
      };

      final uri = Uri.parse('/commercial-foofers')
          .replace(queryParameters: queryParameters);
      final response = await _getRequest(uri.toString());

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final map = jsonData is Map<String, dynamic>
            ? jsonData
            : jsonData is Map
                ? jsonData.cast<String, dynamic>()
                : null;
        if (map == null) {
          return CommercialOfferListResponse(
            currentPage: page,
            data: const [],
            total: 0,
            lastPage: 1,
          );
        }
        return CommercialOfferListResponse.fromJson(map);
      }

      throw ('Ошибка загрузки подключений!');
    } catch (_) {
      throw ('Ошибка загрузки подключений!');
    }
  }

  Future<List<CommercialOfferStatus>> getCommercialOfferStatuses(
      int offerId) async {
    try {
      final response =
          await _getRequest('/commercial-foofers/$offerId/statuses');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final statuses = jsonData is Map ? jsonData['statuses'] : null;
        if (statuses is! List) return const [];
        return statuses
            .whereType<Map>()
            .map((statusJson) => CommercialOfferStatus.fromJson(
                  statusJson.cast<String, dynamic>(),
                ))
            .toList();
      }

      throw ('Ошибка загрузки статусов подключения!');
    } catch (e) {
      throw ('Ошибка загрузки статусов подключения!');
    }
  }

  Future<List<CommercialOfferAccount>> getAccounts() async {
    try {
      final response = await _getRequest('/accounts');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final accounts = jsonData is Map ? jsonData['accounts'] : null;
        if (accounts is! List) return const [];
        return accounts
            .whereType<Map>()
            .map((accountJson) => CommercialOfferAccount.fromJson(
                  accountJson.cast<String, dynamic>(),
                ))
            .toList();
      }

      throw ('Ошибка загрузки счетов!');
    } catch (e) {
      throw ('Ошибка загрузки счетов!');
    }
  }

  Future<void> createCommercialOfferStatus({
    required int offerId,
    required String status,
    required String statusDate,
    required String paymentMethod,
    int? accountId,
    String? paymentOrderNumber,
  }) async {
    final response = await _postRequest(
      '/commercial-foofers/$offerId/statuses',
      {
        'status': status,
        'status_date': statusDate,
        'payment_method': paymentMethod,
        if (accountId != null) 'account_id': accountId,
        if (paymentOrderNumber != null && paymentOrderNumber.isNotEmpty)
          'payment_order_number': paymentOrderNumber,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ('Ошибка сохранения статуса подключения!');
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
    final response = await _postRequest('/clients/store', {
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
        return {
          'success': false,
          'message': 'Введите корректный адрес электронной почты.'
        };
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
        final result = jsonData['result'];
        final partnersJson = result is Map<String, dynamic>
            ? (result['data'] as List? ?? const [])
            : const [];
        return partnersJson
            .whereType<Map<String, dynamic>>()
            .map(Partner.fromJson)
            .toList();
      } else {
        throw Exception('Failed to load partners: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load partners: $e');
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
        return countryJson
            .map((orgJson) => CountryData.fromJson(orgJson))
            .toList();
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
        return currencyJson
            .map((curJson) => CurrencyData.fromJson(curJson))
            .toList();
      } else {
        throw Exception('Failed to load currencies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load currencies: $e');
    }
  }

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

        return tariffJson
            .map((tariffJson) => TariffData.fromJson(tariffJson))
            .toList();
      } else {
        throw Exception('Failed to load tariffs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getTariffs: $e'); // Добавим отладочную информацию
      throw Exception('Failed to load tariffs: $e');
    }
  }

  Future<List<TariffCatalogItem>> getTariffCatalog() async {
    try {
      final response = await _getRequest('/tariff');
      if (response.statusCode == 200) {
        final catalog = _parseTariffCatalog(json.decode(response.body));
        if (catalog.isNotEmpty) return catalog;
      }
    } catch (_) {}

    final fallback = await getTariffs('998');
    return fallback
        .map((item) => TariffCatalogItem(
              id: item.tariff.id,
              name: item.tariff.name,
            ))
        .where((item) => item.id != 0 && item.name.isNotEmpty)
        .toList();
  }

  List<TariffCatalogItem> _parseTariffCatalog(dynamic jsonData) {
    final items = <int, TariffCatalogItem>{};

    void addItems(dynamic source) {
      for (final item in _extractCollection(source)) {
        if (item is! Map) continue;
        final map = item.cast<String, dynamic>();
        final nestedTariff = map['tariff'];
        final catalogItem = nestedTariff is Map
            ? TariffCatalogItem.fromJson(nestedTariff.cast<String, dynamic>())
            : TariffCatalogItem.fromJson(map);
        if (catalogItem.id == 0 || catalogItem.name.isEmpty) continue;
        items[catalogItem.id] = catalogItem;
      }
    }

    if (jsonData is List) {
      addItems(jsonData);
      return items.values.toList();
    }

    if (jsonData is! Map) return const [];

    final roots = <dynamic>[
      jsonData,
      jsonData['data'],
      jsonData['result'],
      jsonData['result'] is Map ? jsonData['result']['data'] : null,
    ];

    for (final root in roots) {
      if (root == null) continue;
      addItems(root);
      if (root is Map) {
        addItems(root['tariffs']);
        addItems(root['services']);
        addItems(root['baseTariffs']);
      }
    }

    final catalog = items.values.toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return catalog;
  }

  List<dynamic> _extractCollection(dynamic source) {
    if (source is List) return source;
    if (source is Map && source['properties'] is List) {
      return source['properties'] as List;
    }
    if (source is Map && source['data'] is List) {
      return source['data'] as List;
    }
    return const [];
  }

  Future<List<History>> getClientHistory(int clientId) async {
    try {
      final response = await _getRequest('/clients/getHistory/$clientId');

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
    final response = await _postRequest(
        '/clients/activation/$clientId', {'reject_cause': rejectCause});

    if (response.statusCode != 200) {
      throw Exception('Статус клиента успешно изменен!');
    }
  }

  Future<void> OrganizationActiveDeactivate(int organizationId) async {
    final response =
        await _postRequest('/organizations/access/$organizationId', {});

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
        return businessTypeJson
            .map((orgJson) => BusinessTypeData.fromJson(orgJson))
            .toList();
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
        return organizationsJson
            .map((orgJson) => Organization.fromJson(orgJson))
            .toList();
      } else {
        throw Exception('Failed to load organizations: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load organizations: ');
    }
  }

  Future<OrganizationDetails> getOrganizationsById(
      String organizationId) async {
    try {
      final response = await _getRequest('/organizations-v2/$organizationId');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['organization'] != null) {
          return OrganizationDetails.fromJson(jsonData);
        } else {
          throw Exception('Organization not found');
        }
      } else {
        throw Exception(
            'Failed to load organizationsById: ${response.statusCode}');
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
    final response = await _postRequest(
      '/organizations/$clientId',
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
      return {
        'success': false,
        'message': 'Ошибка валидации. Проверьте введённые данные.'
      };
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

  Future<TransactionListResponse> getClientByIdTransactions(String clientId,
      {int page = 1}) async {
    try {
      final response =
          await _getRequest('/clients/getTransactions/$clientId?page=$page');
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
        throw Exception(
            'Failed to load TransactionById: ${response.statusCode}');
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
    final response = await _postRequest(
      '/clients/create-transaction/$clientId',
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

  //_________________________________ START____API_SCREEN__AI_CLIENTS____________________________________________//

  Future<AiSubscriptionListResponse> getAiSubscriptions({
    int page = 1,
    String? search,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final uri = Uri.parse('/ai-subscription')
          .replace(queryParameters: queryParameters);
      final response = await _getRequest(uri.toString());

      if (response.statusCode == 200) {
        return AiSubscriptionListResponse.fromJson(json.decode(response.body));
      }

      throw ('Ошибка загрузки ИИ-клиентов!');
    } catch (_) {
      throw ('Ошибка загрузки ИИ-клиентов!');
    }
  }

  Future<AiSubscription?> getAiSubscriptionById(
    int id, {
    AiSubscription? fallback,
  }) async {
    try {
      final response = await _getRequest('/ai-subscription/$id');
      if (response.statusCode == 200) {
        return parseAiSubscriptionDetails(
          json.decode(response.body),
          fallback: fallback,
        );
      }
      return fallback;
    } catch (_) {
      return fallback;
    }
  }

  //_________________________________ END____API_SCREEN__AI_CLIENTS____________________________________________//
}

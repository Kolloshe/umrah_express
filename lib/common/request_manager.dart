// // ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'network_static.dart';
import 'static_var.dart';
import 'utility_var.dart';

class ApiAdapter {
  static const _timeout = Duration(seconds: 240);

  static final _headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  static void _setAuthHeader() {
    if (UtilityVar.userToken.isNotEmpty) {
      _headers['Authorization'] = 'Bearer ${UtilityVar.userToken}';
    }
  }

  static Future sendRequest({
    required String method,
    required String url,
    Map<String, dynamic>? data,
    String? version,
    bool withOutLoader = false,
  }) async {
    try {
      _setAuthHeader();
      final apiUrl = _buildUrl(url, version);
      final request = http.Request(method, Uri.parse(apiUrl));

      _setRequestData(request, data);

      if (!withOutLoader) StaticVar.showIndicator();

      final response = await request.send().timeout(_timeout);

      if (!withOutLoader) StaticVar.hideIndicator();

      return await _handleResponse(response);
    } catch (e) {
      log('Error in $method request: $e');
      StaticVar().showToastMessage(message: 'حدث خطأ في الاتصال', isError: true);
      return null;
    }
  }

  // ... (باقي الأساليب المساعدة هنا)

  static Future postRequest(
      {required String url, Map<String, dynamic>? data, String? version}) async {
    return sendRequest(method: 'POST', url: url, data: data, version: version);
  }

  static Future getRequest(
      {required String url,
      Map<String, dynamic>? data,
      String? version,
      bool? withOutLoader}) async {
    return sendRequest(
        method: 'GET',
        url: url,
        data: data,
        version: version,
        withOutLoader: withOutLoader ?? false);
  }

  static Future putRequest(
      {required String url, Map<String, dynamic>? data, String? version}) async {
    return sendRequest(method: 'PUT', url: url, data: data, version: version);
  }

  static Future deleteRequest(
      {required String url, Map<String, dynamic>? data, String? version}) async {
    return sendRequest(method: 'DELETE', url: url, data: data, version: version);
  }

  static String _buildUrl(String url, String? version) {
    if (version != null) {
      return '$base${verion.replaceFirst('1', version)}$url';
    }
    return baseUrl + url;
  }

  static void _setRequestData(http.Request request, Map<String, dynamic>? data) {
    if (data != null) {
      if (request.method == 'GET') {
        final newUri = request.url
            .replace(queryParameters: data.map((key, value) => MapEntry(key, value.toString())));
        request = http.Request(request.method, newUri);
      } else {
        request.body = json.encode(data);
      }
    }
    request.headers.addAll(_headers);
  }

  static Future _handleResponse(http.StreamedResponse response) async {
    final String responseBody = await response.stream.bytesToString();
    log('Response for ${response.request?.url}:>>> $responseBody');

    print(responseBody);

    if (response.statusCode == 200) {
      return responseBody;
    } else {
      final error = json.decode(responseBody);
      _showErrorMessage(error['message'] ?? 'حدث خطأ غير معروف');
      return {
        'statusCode': response.statusCode,
        'data': error,
      };
    }
  }

  static void _showErrorMessage(String? message) {
    if (message != null && message.isNotEmpty) {
      StaticVar().showToastMessage(message: message, isError: true);
    }
  }
}

// import 'network_static.dart';
// import 'static_var.dart';
// import 'utility_var.dart';

// class ApiAdapter {
//   static final header = {
//     'Accept': 'application/json',
//     'Content-Type': 'application/json',
//   };

//   static Future postRequest({required String url, data, String? v}) async {
//     try {
//       String apiUrl = baseUrl + url;
//       if (v != null) {
//         apiUrl = base + verion.replaceFirst('1', v) + url;
//       }
//       var request = http.Request('POST', Uri.parse(apiUrl));
//       request.body = json.encode(data);
//       header['Authorization'] = 'Bearer ${UtilityVar.userToken}';
//       request.headers.addAll(header);
//       print(apiUrl);
//       log(request.body.toString());

//       StaticVar.showIndicator();
//       http.StreamedResponse response = await request.send();
//       StaticVar.hideIndicator();
//       final jsonString = await response.stream.bytesToString();
//       log(jsonString.toString());
//       if (response.statusCode == 200) {
//         final data = jsonDecode(jsonString);
//         //print(data);

//         if (data is Map) {
//           if ((data.containsKey('code') && data['code'].toString() == "200") ||
//               response.statusCode == 200) {
//             return jsonString;
//           } else {
//             StaticVar().showTostMessage(message: data['message'], isError: true);
//             return null;
//           }
//         }
//       } else {
//         // final json = await response.stream.bytesToString();
//         final error = jsonDecode(jsonString);
//         if (error.containsKey('message')) {
//           StaticVar().showTostMessage(message: error['message'], isError: true);
//         }
//         return {"statusCode": response.statusCode, "data": jsonDecode(jsonString)};
//       }
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }

//   static Future getRequest({required String url, data, String? v, bool? withOutLoader}) async {
//     //  print(v);
//     String apiUrl = baseUrl + url;

//     if (v != null) {
//       apiUrl = apiUrl.replaceFirst('1', v);
//     }
//     print(apiUrl);
//     try {
//       var request = http.Request('GET', Uri.parse(apiUrl));

//       if (data != null) {
//         request.body = json.encode(data);
//       }

//       header['Authorization'] = 'Bearer ${UtilityVar.userToken}';
//       request.headers.addAll(header);
//       if ((withOutLoader ?? false) == false) {
//         StaticVar.showIndicator();
//       }

//       http.StreamedResponse response = await request.send();
//       // .timeout(
//       //   const Duration(seconds: 10),
//       //   onTimeout: () {
//       //     StaticVar.showToast(message: 'Timeout ');
//       //     return http.StreamedResponse(Stream.value([]), 405);
//       //   },
//       // );

//       if ((withOutLoader ?? false) == false) {
//         StaticVar.hideIndicator();
//       }

//       if (response.statusCode == 200) {
//         final jsonString = await response.stream.bytesToString();
//         return jsonString;
//       } else {
//         final error = await response.stream.bytesToString();

//         log(url);

//         log(">>>>>>>>>>>>>");
//         log(error.toString());
//         log(">>>>>>>>>>>>>");
//         return {"statusCode": response.statusCode, "data": jsonDecode(error)};
//       }
//     } catch (e) {
//       return null;
//     }
//   }

//   static Future putRequest({required String url, data, String? v}) async {
//     print(baseUrl + url);

//     String apiUrl = baseUrl + url;
//     if (v != null) {
//       apiUrl.replaceFirst('1', v);
//     }
//     try {
//       var request = http.Request('PUT', Uri.parse(apiUrl));

//       if (data != null) {
//         request.body = json.encode(data);
//       }

//       header['Authorization'] = 'Bearer ${UtilityVar.userToken}';
//       request.headers.addAll(header);
//       StaticVar.showIndicator();

//       http.StreamedResponse response = await request.send();
//       // .timeout(
//       //   const Duration(seconds: 10),
//       //   onTimeout: () {
//       //     StaticVar.showToast(message: 'Timeout ');
//       //     return http.StreamedResponse(Stream.value([]), 405);
//       //   },
//       // );
//       StaticVar.hideIndicator();
//       if (response.statusCode == 200) {
//         final jsonString = await response.stream.bytesToString();
//         return jsonString;
//       } else {
//         final error = await response.stream.bytesToString();
//         log(error.toString());

//         return {"statusCode": response.statusCode, "data": jsonDecode(error)};
//       }
//     } catch (e) {
//       return null;
//     }
//   }

//   static Future deleteRequest({required String url, data, String? v}) async {
//     print(baseUrl + url);

//     String apiUrl = baseUrl + url;
//     if (v != null) {
//       apiUrl.replaceFirst('1', v);
//     }
//     try {
//       var request = http.Request('DELETE', Uri.parse(apiUrl));

//       if (data != null) {
//         request.body = json.encode(data);
//       }

//       header['Authorization'] = 'Bearer ${UtilityVar.userToken}';
//       request.headers.addAll(header);
//       StaticVar.showIndicator();

//       http.StreamedResponse response = await request.send();
//       // .timeout(
//       //   const Duration(seconds: 10),
//       //   onTimeout: () {
//       //     StaticVar.showToast(message: 'Timeout ');
//       //     return http.StreamedResponse(Stream.value([]), 405);
//       //   },
//       // );
//       StaticVar.hideIndicator();
//       if (response.statusCode == 200) {
//         final jsonString = await response.stream.bytesToString();
//         return jsonString;
//       } else {
//         final error = await response.stream.bytesToString();
//         log(error.toString());

//         return {"statusCode": response.statusCode, "data": jsonDecode(error)};
//       }
//     } catch (e) {
//       return null;
//     }
//   }
// }

import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class AuthClient {
  final Dio _dio;
  final CookieJar _cookieJar;

  final String internalErrorMessage = "Προέκυψε σφάλμα κατά την σύνδεση σας, παρακαλώ δοκιμάστε αργότερα";

  AuthClient()
      : _cookieJar = CookieJar(),
        _dio = Dio(BaseOptions(followRedirects: false)) {
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  String _generateState() {
    final rand = Random.secure();
    final str = List.generate(64, (_) => String.fromCharCode(97 + rand.nextInt(26))).join();
    return sha256.convert(utf8.encode(str)).toString();
  }

  Future<Response> _followRedirects(Response response, {int max = 5}) async {
    while (_isRedirect(response.statusCode) && max-- > 0) {
      final location = response.headers.value('location');
      if (location == null) break;
      response = await _dio.get(location, options: _requestOptions());
    }
    return response;
  }

  bool _isRedirect(int? status) =>
      [301, 302, 303, 307, 308].contains(status);

  Options _requestOptions({Map<String, String>? headers}) => Options(
        headers: {
          'User-Agent': 'unistudents',
          ...?headers,
        },
        followRedirects: false,
        validateStatus: (s) => s != null && s < 500,
      );

  Map<String, String> _extractFormFields(Document doc, List<String> names) {
    final result = <String, String>{};
    for (var name in names) {
      final el = doc.querySelector('input[name=$name]');
      if (el != null) result[name] = el.attributes['value'] ?? '';
    }
    return result;
  }

  Future<String> login(String username, String password) async {
    final state = _generateState();

    final initialUrl = 'https://unilogin.uop.gr/auth/realms/universis/protocol/openid-connect/auth?redirect_uri=https%3A%2F%2Funistudent.uop.gr%2Fauth%2Fcallback%2Findex.html&response_type=token&client_id=universis-student&scope=students&state=$state';

    var resp = await _dio.get(initialUrl, options: _requestOptions());
    resp = await _followRedirects(resp);

    final doc1 = parse(resp.data.toString());
    final form1 = doc1.querySelector('form');
    final formUrl1 = form1?.attributes['action'] ?? '';
    final samlData = _extractFormFields(doc1, ['SAMLRequest', 'RelayState']);

    if (formUrl1.isEmpty || samlData.length < 2) {
      throw Exception(internalErrorMessage);
    }

    resp = await _dio.post(formUrl1, data: samlData, options: _requestOptions(headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    }));
    resp = await _followRedirects(resp);

    final doc2 = parse(resp.data.toString());
    final loginForm = doc2.getElementById('fm1');
    if (loginForm == null) throw Exception(internalErrorMessage);

    final loginData = {
      'username': username,
      'password': password,
      ..._extractFormFields(doc2, ['execution', '_eventId']),
    };

    final postFormUrl = 'https://sso.uop.gr/login?service=https%3A%2F%2Fidp.uop.gr%2Fcasauth%2Ffacade%2Fnorenew%3Fidp%3Dhttps%3A%2F%2Fidp.uop.gr%2Fidp%2FexternalAuthnCallback';

    resp = await _dio.post(postFormUrl, data: loginData, options: _requestOptions(headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    }));
    resp = await _followRedirects(resp);

    final doc3 = parse(resp.data.toString());
    final bodyText = doc3.body?.text ?? '';
    if (bodyText.contains('not recognized') || bodyText.contains('failed')) {
      throw Exception("Invalid Credentials");
    }

    // Confirm step
    if (bodyText.contains('Digital ID Card')) {
      final confirmUrl = resp.requestOptions.uri.toString();
      resp = await _dio.post(confirmUrl, data: {'confirm': 'Confirm'}, options: _requestOptions(headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      }));
      resp = await _followRedirects(resp);
    }

    final finalDoc = parse(resp.data.toString());
    final formFinal = finalDoc.querySelector('form');
    final finalUrl = formFinal?.attributes['action'] ?? '';
    final samlFinalData = _extractFormFields(finalDoc, ['SAMLResponse', 'RelayState']);

    if (finalUrl.isEmpty || samlFinalData.length < 2) {
      throw Exception(internalErrorMessage);
    }

    resp = await _dio.post(finalUrl, data: samlFinalData, options: _requestOptions(headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    }));

    if (resp.statusCode == 302 || resp.statusCode == 301) { final location = resp.headers.value('location') ?? ''; if (location.contains('access_token=') && location.contains('&token_type')) { 
      // Extract token 
        final start = location.indexOf('access_token=') + 'access_token='.length; 
        final end = location.indexOf('&token_type'); 
        final token = location.substring(start, end); 
        return token; 
    }else  throw Exception(internalErrorMessage);  } 
  else  throw Exception(internalErrorMessage);   
  } 
}

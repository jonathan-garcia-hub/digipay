import 'dart:async';
import 'dart:convert';
import 'package:digipay/models/ResponseAfiliations.dart';
import 'package:digipay/models/ResponseIndicators.dart';
import 'package:digipay/models/ResponseLoteDetails.dart';
import 'package:http/http.dart' as http;
import 'package:digipay/models/ResponseLogin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ResponseError.dart';
import '../models/ResponseTransactions.dart';
import '../screens/home_screen.dart';
import '../util/biometric_util.dart';


class TransactionsProvider extends ChangeNotifier {

  final _auth = BiometricAuthUtil();
  String _baseUrl = 'http://thannajo.ddns.net:8090';

  Future<void> storeApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_key', apiKey);
  }

  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_key');
  }

  Future<void> login1(BuildContext context, String username,
      String password) async {
    notifyListeners();

    try {
      final response = await http.post(

        Uri.parse(
            'http://thannajo.ddns.net:8090/api-echo/v1/users/login?quickResponse=true'),
        body: jsonEncode({
          'email': username,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final userJson = json.decode(response.body);
        final user = ResponseLogin.fromJson(userJson);

      } else {
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Error'),
                content: Text('Credenciales inválidas, intente nuevamente.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );
      }
    } catch (e) {
      print('Error al conectarse con API servicio de login: $e');
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Ha ocurrido un error inesperado, intente de nuevo más tarde.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }

    notifyListeners();
  }

  Future<void> login2(BuildContext context, String username,
      String password) async {
    notifyListeners();

    print('$username $password');

    try {
      final response = await http.post(

        Uri.parse('$_baseUrl/api-echo/v1/login'),
        body: jsonEncode({
          'email': username,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final userJson = json.decode(response.body);
        final user = ResponseLogin.fromJson(userJson);

        print(user);

        //Guardo credenciales cifradas en almacenamiento del tlf para habilitar biometria
        if (await _auth.hasEnabledBiometricAuth()){
          //Ya tiene credenciales guardadas las actualizo ?
          print('NO guardadas');

        }else{
          //No tiene entonces las guardo
          // _auth.enableBiometricAuth(username, password);
          print('guardadas');
        }

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) => HomeScreen(usuario: user.data.user)), (
            route) => false);
      } else {
        print(response.statusCode);

        final errorJson = json.decode(response.body);
        final error = ResponseError.fromJson(errorJson);

        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: const Text('Error'),
                content: Text(error.message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );
      }
    } catch (e) {
      print('Error al conectarse con API servicio de login: $e');
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Ha ocurrido un error inesperado, intente de nuevo más tarde.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }

    notifyListeners();
  }

  //
  Future<ResponseAfiliados> getAffiliations(BuildContext context,
      String apiKey) async {

    print(apiKey);
    storeApiKey(apiKey);

    try {
      final response = await http.get(
        Uri.parse(
        '$_baseUrl/api-echo/v1/resumen/affiliations?object=false'),
            headers: {
              'Content-Type': 'application/json',
              'api-key': apiKey
            },
      );

      if (response.statusCode == 200) {
        final afiliationsJson = json.decode(response.body);
        final afiliations = ResponseAfiliados.fromJson(afiliationsJson);

        print(afiliationsJson);

        return afiliations;
      } else {
        print(response.statusCode);

        final errorJson = json.decode(response.body);
        final error = ResponseError.fromJson(errorJson);

        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: const Text('Error'),
                content: Text(error.message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );

        return ResponseAfiliados.empty();
      }
    } catch (e) {
      print('Error al conectarse con API servicio de resumen afiliados: $e');
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Ha ocurrido un error inesperado, intente de nuevo más tarde.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }

    return ResponseAfiliados.empty();
  }


  //
  Future<List<ResponseTransactions>> getTransactions(
      BuildContext context,
      String merchant,
      String terminal
      ) async {

    try {

      final response = await http.get(
        Uri.parse(
            '$_baseUrl/api-echo/v1/transactions/$merchant/$terminal'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final transactionsJson = json.decode(response.body);
        print(transactionsJson);

        List<ResponseTransactions> transacciones = [];
        for (var transactionJson in transactionsJson) {
          transacciones.add(ResponseTransactions.fromJson(transactionJson));
        }

        return transacciones;
      } else {
        print(response.statusCode);

        final errorJson = json.decode(response.body);
        final error = ResponseError.fromJson(errorJson);

        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: const Text('Error'),
                content: Text(error.message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );

        return [];
      }
    } catch (e) {
      print('Error al conectarse con API servicio de listado de transacciones del lote: $e');
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Ha ocurrido un error inesperado, intente de nuevo más tarde.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }

    return [];
  }

  //Lista de transacciones de lote cerrado
  Future<List<ResponseTransactions>> getTransactionsClosetLot(
      BuildContext context,
      String merchant,
      String terminal,
      int lotNumber
      ) async {

    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/api-echo/v1/transactions/$merchant/$terminal?lotNumber=$lotNumber'),
          // '$_baseUrl/api-echo/v1/transactions/123456789AAAAAC/12341113?lotNumber=15'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final transactionsJson = json.decode(response.body);
        print(transactionsJson);

        List<ResponseTransactions> transacciones = [];
        for (var transactionJson in transactionsJson) {
          transacciones.add(ResponseTransactions.fromJson(transactionJson));
        }

        return transacciones;
      } else {
        print(response.statusCode);

        final errorJson = json.decode(response.body);
        final error = ResponseError.fromJson(errorJson);

        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: const Text('Error'),
                content: Text(error.message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );

        return [];
      }
    } catch (e) {
      print('Error al conectarse con API servicio de listado de transacciones del lote: $e');
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Ha ocurrido un error inesperado, intente de nuevo más tarde.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }

    return [];
  }

  //Indicadores para lote abierto
  Future<ResponseIndicators> getIndicators(
      BuildContext context,
      int idAfiliation
      ) async {

    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/api-echo/v1/transactions?affiliationId=$idAfiliation'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final indicatorsJson = json.decode(response.body);
        final indicators = ResponseIndicators.fromJson(indicatorsJson);

        return indicators;
      } else {

        final errorJson = json.decode(response.body);
        final error = ResponseError.fromJson(errorJson);

        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: const Text('Error'),
                content: Text(error.message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );

        return ResponseIndicators.empty();
      }
    } catch (e) {
      print('Error al conectarse con API servicio de resumen de ventas lote abierto: $e');
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Ha ocurrido un error inesperado, intente de nuevo más tarde.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }

    return ResponseIndicators.empty();
  }

  //Indicadores para lote cerrado
  Future<ResponseIndicators> getIndicatorsClose(
      BuildContext context,
      int lotNumber
      ) async {

    final apiKey = await getApiKey();
    print("prefffffff"+apiKey!);

    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/api-echo/v1/batch/2?lotNumber=$lotNumber'),
        headers: {
          'Content-Type': 'application/json',
          'api-key': apiKey!
          // 'api-key': 'bm9uY2U9MTcwMTcxOTA3NjkwOSwgZW1haWw9ZXJuZXN0b0BnbWFpbC5jb20sIHJvbGU9VVNFUkFETUlO'

        },
      );

      if (response.statusCode == 200) {
        final indicatorsJson = json.decode(response.body);
        final indicators = ResponseIndicators.fromJson2(indicatorsJson);

        return indicators;
      } else {

        final errorJson = json.decode(response.body);
        final error = ResponseError.fromJson(errorJson);

        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: const Text('Error'),
                content: Text(error.message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );

        return ResponseIndicators.empty();
      }
    } catch (e) {
      print('Error al conectarse con API servicio de resumen de ventas lote cerrado: $e');
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Ha ocurrido un error inesperado, intente de nuevo más tarde.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }

    return ResponseIndicators.empty();
  }

  //Indicadores para lote cerrado
  Future<List<ResponseIndicators>> getClosedLotList(
      BuildContext context,
      int idAfiliation
      ) async {

    final apiKey = await getApiKey();

    print('lote cerrado: '+ apiKey!);

    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/api-echo/v1/batch/$idAfiliation'),
        headers: {
          'Content-Type': 'application/json',
          'api-key': apiKey!
          // 'api-key': 'bm9uY2U9MTcwMTcxOTA3NjkwOSwgZW1haWw9ZXJuZXN0b0BnbWFpbC5jb20sIHJvbGU9VVNFUkFETUlO'
        },
      );

      if (response.statusCode == 200) {
        final indicatorsJson = json.decode(response.body);

        List<ResponseIndicators> indicators = [];
        for (var indicatorJson in indicatorsJson) {
          indicators.add(ResponseIndicators.fromJson(indicatorJson));
        }

        return indicators;
      } else {

        final errorJson = json.decode(response.body);
        final error = ResponseError.fromJson(errorJson);

        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: const Text('Error'),
                content: Text(error.message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );

        return [];
      }
    } catch (e) {
      print('Error al conectarse con API servicio de resumen de ventas lote cerrado: $e');
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Ha ocurrido un error inesperado, intente de nuevo más tarde.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }

    return [];
  }

  //Recibo de lote cerrado
  Future<ResponseLoteDetails> getLotCloseDetails(
      BuildContext context,
      String merchant,
      String terminal,
      int lotNumber
      ) async {

    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/api-echo/v1/transactions/$merchant/$terminal?batches=true&lotNumber=$lotNumber'),
            // '$_baseUrl/api-echo/v1/transactions/123456789AAAAAC/12341113?batches=true&lotNumber=15'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final loteJson = json.decode(response.body);
        final lote = ResponseLoteDetails.fromJsonList(loteJson);

        return lote;
      } else {

        final errorJson = json.decode(response.body);
        final error = ResponseError.fromJson(errorJson);

        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: const Text('Error'),
                content: Text(error.message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );

        return ResponseLoteDetails.empty();
      }
    } catch (e) {
      print('Error al conectarse con API servicio de ResponseLoteDetails: $e');
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Ha ocurrido un error inesperado, intente de nuevo más tarde.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }

    return ResponseLoteDetails.empty();
  }


}

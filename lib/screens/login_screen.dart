import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import '../providers/transactions_provider.dart';
import '../themes/digipay_theme.dart';
import '../util/biometric_util.dart';
import '../util/local_auth_util.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = BiometricAuthUtil();
  bool _hasBiometric = false;
  bool _hasCredentians = false;
  bool _showFingerButtom = false;
  bool _obscureText = true;
  bool _isLoading = false;
  late LocalAuthUtil _biometricAuthUtil;

  @override
  void initState() {
    // TODO: implement initState
    _auth.isBiometricSupported().then((value) {
      _auth.hasEnabledBiometricAuth().then((value2) {
        setState(() {
          setState(() {
            _showFingerButtom = value && value2;
            print(value);
            print(value2);
            print(_showFingerButtom);
          });
        });
      });
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(

      create: (context) => TransactionsProvider(),
      child: Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          // Formas curvas en la parte superior
          Positioned(
            top: -200,
            left: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ThemeConfig.secondaryColor.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ThemeConfig.tertiaryColor.withOpacity(0.2),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ThemeConfig.primaryColor.withOpacity(0.2),
              ),
            ),
          ),
          SafeArea(
            child: Consumer<TransactionsProvider>(
              builder: (context, viewModel, child) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Expanded(child: SizedBox()),
                      // Logo
                      Image(
                        image: AssetImage(ThemeConfig.fullLogo),
                        width: 280.0,
                      ),

                      SizedBox(height: 20.0),

                      // Texto "Inicio de sesión"
                      Text(
                        'Inicio de sesión',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 20.0),

                      // TextField para el email
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),

                      SizedBox(height: 15.0),

                      // TextField para la contraseña
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        // Variable que controla la visibilidad del texto
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility : Icons
                                  .visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText =
                                !_obscureText; // Cambia la visibilidad del texto
                              });
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 20.0),

                      // Botón para iniciar sesión
                      _isLoading
                          ? SpinKitCircle(
                        color: ThemeConfig.primaryColor,
                        size: 60.0,
                      )
                          : Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _isLoading = true;
                              final loginProvider = Provider.of<
                                  TransactionsProvider>(context, listen: false);
                              loginProvider.login2(context, _emailController.text,
                                  _passwordController.text).then((value) =>
                              _isLoading = false);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              backgroundColor: ThemeConfig.primaryColor,
                            ),
                            child: const Text(
                              'Iniciar sesión',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ),
                          // Expanded(child: SizedBox()),
                          SizedBox(height: 15,),

                          _showFingerButtom
                              ? FloatingActionButton(
                            onPressed: () {
                              _auth.biometricAuthenticate().then((value) async {
                                if (value) {
                                  print('exitoso, inicia sesión con biometria');

                                  String? user = await _auth.getValueFromSecureStorage(_auth.usernameKey);
                                  String? password = await _auth.getValueFromSecureStorage(_auth.passwordKey);

                                  _isLoading = true;
                                  final loginProvider = Provider.of<
                                      TransactionsProvider>(context, listen: false);
                                  loginProvider.login2(context, user!,
                                      password!).then((value) =>
                                  _isLoading = false);

                                } else {
                                  print('no exitoso');
                                }
                              });
                            },
                            backgroundColor: ThemeConfig.primaryColor,
                            child: const Icon(
                              Icons.fingerprint,
                              color: Colors.white,
                              size: 35.0,
                            ),
                            shape: const StadiumBorder(), // For a rounded button
                          )
                              : SizedBox(),
                        ],
                      ),





                      Expanded(child: SizedBox()),

                      // Separador horizontal con gradiente
                      Container(
                        height: 3.0,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ThemeConfig.primaryColor,
                              ThemeConfig.secondaryColor,
                              ThemeConfig.tertiaryColor,
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 15.0),

                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Powered by ',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'Digipay',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: ThemeConfig.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    ),
    );
  }
}


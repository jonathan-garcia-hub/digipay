import 'package:digipay/models/ResponseLogin.dart';
import 'package:digipay/providers/transactions_provider.dart';
import 'package:digipay/screens/transactions_closed_lot_screen_.dart';
import 'package:digipay/screens/transactions_closet_screen.dart';
import 'package:digipay/screens/transactions_detai_closet_screen_.dart';
import 'package:digipay/screens/transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:digipay/models/ResponseAfiliations.dart';

import '../themes/digipay_theme.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final User usuario;

  const HomeScreen({Key? key, required this.usuario}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {

    String nombre = widget.usuario.name;
    List<String> palabras = nombre.split(' ');
    String iniciales = '';

    if (palabras.length >= 2) {
      iniciales += palabras[0].substring(0, 1) + palabras[1].substring(0, 1);
    } else if (palabras.length > 0) {
      iniciales += palabras[0].substring(0, 1);
    }

    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => TransactionsProvider(),
        child: Consumer<TransactionsProvider>(
          builder: (context, transactions, _) {
            return Column(
              children: [
                AppBar(
                  backgroundColor: ThemeConfig.secondaryColor.withOpacity(0.3),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 50,),
                      Image.asset(ThemeConfig.fullLogo, width: 140, height: 100),
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                      },
                    ),
                  ],
                  elevation: 0,
                ),
                const Divider(
                    color: ThemeConfig.secondaryColor,
                    height: 1,
                    thickness: 1.5
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ThemeConfig.secondaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: ThemeConfig.secondaryColor,
                                  radius: 16,
                                  child: Text(
                                    iniciales,
                                    style: TextStyle(fontSize: 14, color: Color(0xff4bca00)),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bienvenido,',
                                      style: TextStyle(fontSize: 14, color: Colors.black),
                                    ),
                                    Text(
                                      widget.usuario.name,
                                      style: TextStyle(fontSize: 16, color: Color(0xff0045ab)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          height: 40,
                          width: 1,
                          color: ThemeConfig.secondaryColor,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tipo de usuario:',
                              style: TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            Text(
                              widget.usuario.rol,
                              style: TextStyle(fontSize: 16, color: Color(0xff0045ab)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 5),

                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10), // Ajusta el espacio aquí
                  child: Text(
                    'Comercios afiliados:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                Expanded(
                  child: FutureBuilder(
                    future: transactions.getAffiliations(context, widget.usuario.apiKey),
                    builder: (context, AsyncSnapshot<ResponseAfiliados> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 150),
                            height: 180,
                            child: SpinKitCircle(
                              color: ThemeConfig.primaryColor,
                              size: 60.0,
                            ),
                          ),
                        );
                      }

                      final afiliations = snapshot.data!;

                      return
                        afiliations.commerces.isEmpty ?
                        Center(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 150),
                            height: 180,
                            child: Text("No hay comercios para mostrar"),
                        ),):
                        ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          itemCount: afiliations.commerces.length,
                          itemBuilder: (context, index) {
                            return MerchantExpansionTile(
                              commerce: afiliations.commerces[index],
                            );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


class MerchantExpansionTile extends StatefulWidget {
  final Commerce commerce;

  MerchantExpansionTile({required this.commerce});

  @override
  _MerchantExpansionTileState createState() => _MerchantExpansionTileState();
}

class _MerchantExpansionTileState extends State<MerchantExpansionTile> {
  bool _isExpanded = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeConfig.secondaryColor.withOpacity(0.3), // Cambio de color de fondo
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),

            child: ListTile(
              title: Text(widget.commerce.name, style: TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
              subtitle: Text(widget.commerce.taxId, style: TextStyle(fontSize:16)),
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Column(
              children: widget.commerce.affiliations.asMap().entries.map((entry) {
                final afiliation = entry.value;
                final isLastAfiliation = entry.key == widget.commerce.affiliations.length - 1;
                final statusColor = afiliation.description == 'Activa' ? Colors.green : Colors.amber;

                return Column(
                  children: [
                    SizedBox(height: 10,),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Dispositivo: ',
                            style: TextStyle(
                              fontSize:16,
                              color: ThemeConfig.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: afiliation.serial,
                            style: TextStyle(
                              fontSize:16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Merchant: ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: afiliation.merchant,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5,),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Terminal: ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${afiliation.terminal} - Lote: ${afiliation.lotNumber}',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5,),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // llamar a transaction Screen

                                      //Consultar servicio y si trae ventas pasa a la pantalla sino modal

                                      // Cargar el listado de transacciones
                                      _isLoading = true;
                                      TransactionsProvider().getIndicators(context,afiliation.id)
                                          .then((indicators) {

                                            print(indicators.amountSalesDebitApproved);

                                            if (indicators.quantitySales > 0){
                                              Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) => TransactionsScreen(
                                                      comercio: widget.commerce.name,
                                                      rif: widget.commerce.taxId,
                                                      merchant: afiliation.merchant,
                                                      terminal: afiliation.terminal,
                                                      lote: afiliation.lotNumber,
                                                      indicators: indicators
                                                  )));
                                            }else{
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: const Text('Información'),
                                                      content: Text('Aún no hay ventas en el lote abierto: ${afiliation.lotNumber.toString().padLeft(3, '0')}'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          child: Text('OK'),
                                                        ),
                                                      ],
                                                    ),
                                              );
                                            }
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      });

                                    },
                                    child: const Icon(Icons.account_balance),
                                  ),
                                  SizedBox(width: 50,),
                                  ElevatedButton(
                                    onPressed: () {
                                      // llamar a transaction Screen
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => TransactionsClosedLotScreen(
                                            comercio: widget.commerce.name,
                                            rif: widget.commerce.taxId,
                                            merchant: afiliation.merchant,
                                            terminal: afiliation.terminal,
                                            idAfiliation: afiliation.id,
                                          )));

                                    },
                                    child: const Icon(Icons.receipt),
                                  ),
                                ],
                              ),

                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              afiliation.description,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     // llamar a transaction Screen
                          //     Navigator.push(context, MaterialPageRoute(
                          //         builder: (context) => TransactionsScreen(
                          //             comercio: widget.commerce.name,
                          //             rif: widget.commerce.taxId,
                          //             merchant: afiliation.merchant,
                          //             terminal: afiliation.terminal,
                          //         )));
                          //
                          //   },
                          //   child: const Icon(Icons.search),
                          // ),
                        ],
                      ),
                    ),
                    if (!isLastAfiliation) Divider(), // Línea separadora condicional
                  ],
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
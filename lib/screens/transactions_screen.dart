import 'package:digipay/models/ResponseIndicators.dart';
import 'package:digipay/providers/transactions_provider.dart';
import 'package:digipay/screens/transactions_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/ResponseTransactions.dart';
import '../themes/digipay_theme.dart';
import '../widgets/sales_indicators.dart';

class TransactionsScreen extends StatefulWidget {
  final String comercio;
  final String rif;
  final String merchant;
  final String terminal;
  final String lote;
  final ResponseIndicators indicators;

  const TransactionsScreen({
    Key? key,
    required this.comercio,
    required this.rif,
    required this.merchant,
    required this.terminal,
    required this.lote,
    required this.indicators,
  }) : super(key: key);

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  bool _showListBtm = false;

  @override
  Widget build(BuildContext context) {

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

                      Image.asset(ThemeConfig.fullLogo, width: 140, height: 100),
                      SizedBox(width: 50,),
                    ],
                  ),

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
                    child: Column(
                      children: [
                        Text(
                          'Lote abierto: ${widget.lote.toString().padLeft(3, '0')}',
                          style: TextStyle(fontSize: 20, color: ThemeConfig.secondaryColor, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'MID: ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: ThemeConfig.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: widget.merchant,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: ThemeConfig.secondaryColor,
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'TID: ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: ThemeConfig.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: widget.terminal,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'RIF: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: ThemeConfig.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: widget.rif,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Nombre Comercio: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: ThemeConfig.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: widget.comercio,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        Container(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => TransactionsDetailScreen(
                                    comercio: widget.comercio,
                                    rif: widget.rif,
                                    merchant: widget.merchant,
                                    terminal: widget.terminal,
                                    lote: widget.lote,
                                  )));
                            },
                            icon: Icon(Icons.list, color: Color(0xff0045ab)), // Icono del botón
                            label: Text('Listado de transacciones',
                                style: TextStyle(fontSize:16,color: Colors.black,)), // Texto del botón
                            style: ElevatedButton.styleFrom(
                              primary: ThemeConfig.tertiaryColor, // Color de fondo del botón
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20), // Bordes redondeados del botón
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10),


                      ],
                    ),
                  ),
                ),


                Expanded(
                  child: SalesIndicators(
                  indicators: widget.indicators,
                  ),
                ),

                // FutureBuilder(
                //   future: transactions.getIndicators(context, widget.idAfiliation),
                //   builder: (context, AsyncSnapshot<ResponseIndicators> snapshot) {
                //     if (!snapshot.hasData) {
                //       return Center(
                //         child: Container(
                //           constraints: BoxConstraints(maxWidth: 150),
                //           height: 180,
                //           child: SpinKitCircle(
                //             color: ThemeConfig.primaryColor,
                //             size: 60.0,
                //           ),
                //         ),
                //       );
                //     }
                //
                //     final indicators = snapshot.data!;
                //
                //     if (indicators.quantitySales > 0 ){
                //       WidgetsBinding.instance.addPostFrameCallback((_) {
                //         setState(() {
                //           _showListBtm = true;
                //         });
                //       });
                //     }
                //
                //
                //     return
                //       indicators.lotNumber == 0 ?
                //       Center(
                //         child: Container(
                //           constraints: BoxConstraints(maxWidth: 150),
                //           height: 180,
                //           child: Text("No hay indicadores para mostrar"),
                //         ),):
                //       //Puede cambiar de tamano en tiempo de ejecucion
                //       Expanded(
                //         child: SalesIndicators(
                //           indicators: indicators,
                //         ),
                //       );
                //   },
                // ),
                SizedBox(height: 10),


              ],
            );
          },
        ),
      ),
    );
  }
}












class TransactionsExpansionTile extends StatefulWidget {
  final ResponseTransactions transaction;

  TransactionsExpansionTile({required this.transaction});

  @override
  _TransactionsExpansionTileState createState() => _TransactionsExpansionTileState();
}

class _TransactionsExpansionTileState extends State<TransactionsExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final statusColor = widget.transaction.d039 == '00' ? Colors.green : Colors.amber;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeConfig.secondaryColor.withOpacity(0.3),// Cambio de color de fondo
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),

            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.transaction.applicationLabel == 'MASTERCARD' ?
                    Image.asset('assets/master.png', width: 60):
                    widget.transaction.applicationLabel == 'MAESTRO' ?
                      Image.asset('assets/maestro.png', width: 60):
                      widget.transaction.applicationLabel == 'VISA' ?
                        Image.asset('assets/visa.png', width: 60):
                        widget.transaction.applicationLabel == 'AMEX' ?
                          Image.asset('assets/amex.png', width: 60):
                        Image.asset('assets/generic_card.png', width: 60),
                  Text('${widget.transaction.d004} Bs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),



              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5,),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Fecha: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: widget.transaction.tranDate.toString(),
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
                          text: 'Tarjeta: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: widget.transaction.d002,
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
                          text: 'Referencia: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: widget.transaction.d037,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Recibo: ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: widget.transaction.d011,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: widget.transaction.d039 == '00' ?
                          Text(
                            "Aprobada",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                            ),
                          ):
                        Text(
                          "Declinada",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  )

                ],
              ),
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Column(

              children: [
                    SizedBox(height: 10,),
                    Text('RECIBO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ListTile(
                      subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(widget.transaction.receipt),
                              ElevatedButton(
                                onPressed: () {
                                  Share.share(widget.transaction.receipt);
                                },
                                child: const Icon(Icons.share),
                              ),
                            ],
                          ),
                    ),
                  ],
            ),
        ],
      ),
    );
  }
}
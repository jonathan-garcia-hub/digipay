import 'package:digipay/providers/transactions_provider.dart';
import 'package:digipay/screens/transactions_detai_closet_screen_.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/ResponseIndicators.dart';
import '../models/ResponseTransactions.dart';
import '../themes/digipay_theme.dart';
import 'lote_receipt_screen.dart';

class TransactionsClosedLotScreen extends StatefulWidget {
  final String comercio;
  final String rif;
  final String merchant;
  final String terminal;
  final int idAfiliation;

  const TransactionsClosedLotScreen({
    Key? key,
    required this.comercio,
    required this.rif,
    required this.merchant,
    required this.terminal,
    required this.idAfiliation,
  }) : super(key: key);

  @override
  _TransactionsClosedLotScreenState createState() => _TransactionsClosedLotScreenState();
}

class _TransactionsClosedLotScreenState extends State<TransactionsClosedLotScreen> {

  bool _isLoading = false;
  bool _isFiltered = false;
  List<ResponseIndicators> _filteredList = [];
  List<ResponseIndicators> _lotsList = [];
  final _Parameters = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    // Cargar el listado de transacciones
    TransactionsProvider().getClosedLotList(context, widget.idAfiliation)
        .then((lots) {
      setState(() {
        _lotsList = lots;
        _isLoading = false;
      });
    })
        .catchError((error) {
      setState(() {
        _isLoading = false;
      });
      print('Error al cargar los lotes cerrados: $error');
    });
  }


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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Detalle lote cerrado',
                          style: TextStyle(fontSize: 22, color: ThemeConfig.primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                  ),
                ),
                SizedBox(height: 10),

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

                        _lotsList.length > 3 ?
                          Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 8.0, top: 10, bottom: 10), // Espacio entre el TextField y el botón
                                child: TextField(
                                  controller: _Parameters,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(30), // Máximo de 3 caracteres
                                  ],
                                  textAlign: TextAlign.start, // Centrar los dígitos
                                  decoration: InputDecoration(
                                    labelText: 'Indique un parametro',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_Parameters.text.isNotEmpty && _lotsList.isNotEmpty){
                                  setState(() {
                                    _isFiltered = true;
                                    _filteredList = [];
                                    _filteredList = filterLots(_lotsList, _Parameters.text);
                                  });
                                }else if(_Parameters.text.isEmpty) {
                                  setState(() {
                                    _isFiltered = false;
                                  });
                                }
                              },
                              child: const Icon(Icons.search),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0), // Mismo radio de borde que el TextField
                                  ),
                                ),
                                elevation: MaterialStateProperty.all<double>(0), // Sin elevación para que coincida con el TextField
                                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(16.0)), // Ajustar el espacio interior
                              ),
                            ),
                          ],
                        ): const SizedBox()
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: _isLoading ?
                  Center(
                  child: SpinKitCircle(
                    color: ThemeConfig.primaryColor,
                    size: 60.0,
                  ),): _lotsList.isEmpty ?
                        Center(
                          child: Text("No hay transacciones para mostrar"),
                        ): _filteredList.isEmpty ?
                              _isFiltered ?
                                Center(
                                  child: Text("No hay coincidencias"),
                                ):
                                ListView.builder(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  itemCount: _lotsList.length,
                                  itemBuilder: (context, index) {
                                    return ClosedLotsExpansionTile(
                                      closedLot: _lotsList[index],
                                      merchant: widget.merchant,
                                      terminal: widget.terminal,
                                      comercio: widget.comercio,
                                      rif: widget.rif
                                    );
                                  },
                                ):
                          ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            itemCount: _filteredList.length,
                            itemBuilder: (context, index) {
                              return ClosedLotsExpansionTile(
                                closedLot: _filteredList[index],
                                merchant: widget.merchant,
                                terminal: widget.terminal,
                                comercio: widget.comercio,
                                rif: widget.rif
                              );
                            },
                          )
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ClosedLotsExpansionTile extends StatefulWidget {
  final ResponseIndicators closedLot;
  final String merchant;
  final String terminal;
  final String comercio;
  final String rif;


  ClosedLotsExpansionTile({
    required this.closedLot,
    required this.merchant,
    required this.terminal,
    required this.comercio,
    required this.rif

  });

  @override
  ClosedLotsExpansionTileState createState() => ClosedLotsExpansionTileState();
}

class ClosedLotsExpansionTileState extends State<ClosedLotsExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {

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
              title: Text('Número del lote: ${widget.closedLot.lotNumber}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('General', style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                          const SizedBox(width: 50,),
                          Text('${widget.closedLot.quantitySales.toString()} Venta(s)'),
                        ],
                      ),
                      Text('${widget.closedLot.amountSales} Bs')
                    ],
                  ),
                  Divider(color:ThemeConfig.secondaryColor),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('Débito  ', style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                          const SizedBox(width: 50,),
                          Text('${widget.closedLot.quantitySalesDebitApproved.toString()} Venta(s)'),
                        ],
                      ),

                      Text('${widget.closedLot.amountSalesDebitApproved} Bs')
                    ],
                  ),
                  Divider(color:ThemeConfig.secondaryColor),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('Crédito ', style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                          const SizedBox(width: 50,),
                          Text('${widget.closedLot.quantitySalesCreditApproved.toString()} Venta(s)'),
                        ],
                      ),

                      Text('${widget.closedLot.amountSalesCreditApproved} Bs')
                    ],
                  ),
                  Divider(color:ThemeConfig.secondaryColor),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('Anulación  ', style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                          const SizedBox(width: 30,),
                          Text('${widget.closedLot.quantityRefund.toString()} Venta(s)'),
                        ],
                      ),

                      Text('${widget.closedLot.quantityRefund} Bs')
                    ],
                  ),
                  // Divider(color:ThemeConfig.secondaryColor),

                  // RichText(
                  //   text: TextSpan(
                  //     children: [
                  //       TextSpan(
                  //         text: 'Cant. ventas generales: ',
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       TextSpan(
                  //         text: widget.closedLot.quantitySales.toString(),
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 5,),
                  // RichText(
                  //   text: TextSpan(
                  //     children: [
                  //       TextSpan(
                  //         text: 'Monto ventas generales: ',
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       TextSpan(
                  //         text: widget.closedLot.amountSales,
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 5,),
                  // RichText(
                  //   text: TextSpan(
                  //     children: [
                  //       TextSpan(
                  //         text: 'Cant. ventas débito: ',
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       TextSpan(
                  //         text: widget.closedLot.quantitySalesDebitApproved.toString(),
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 5,),
                  // RichText(
                  //   text: TextSpan(
                  //     children: [
                  //       TextSpan(
                  //         text: 'Monto ventas débito: ',
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       TextSpan(
                  //         text: widget.closedLot.amountSalesDebitApproved,
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 5,),
                  // RichText(
                  //   text: TextSpan(
                  //     children: [
                  //       TextSpan(
                  //         text: 'Cant. ventas crédito: ',
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       TextSpan(
                  //         text: widget.closedLot.quantitySalesCreditApproved.toString(),
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 5,),
                  // RichText(
                  //   text: TextSpan(
                  //     children: [
                  //       TextSpan(
                  //         text: 'Monto ventas crédito: ',
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       TextSpan(
                  //         text: widget.closedLot.amountSalesCreditApproved,
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 5,),
                  // RichText(
                  //   text: TextSpan(
                  //     children: [
                  //       TextSpan(
                  //         text: 'Cant. anulaciones: ',
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       TextSpan(
                  //         text: widget.closedLot.quantityRefund.toString(),
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 5,),
                  // RichText(
                  //   text: TextSpan(
                  //     children: [
                  //       TextSpan(
                  //         text: 'Monto anulaciones: ',
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       TextSpan(
                  //         text: widget.closedLot.amountRefund,
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 5,),
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
                ListTile(
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => TransactionsDetailClosetScreen(
                                    comercio: widget.comercio,
                                    rif: widget.rif,
                                    merchant: widget.merchant,
                                    terminal: widget.terminal,
                                    lote: widget.closedLot.lotNumber,
                                  )));
                            },
                            child: const Icon(Icons.list_sharp),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => LoteReceiptScreen(
                                    merchant: widget.merchant,
                                    terminal: widget.terminal,
                                    lote: widget.closedLot.lotNumber,
                                  )));
                            },
                            child: const Icon(Icons.receipt_long),
                          ),
                        ],
                      )

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


List<ResponseIndicators> filterLots(List<ResponseIndicators> lots, String filterString) {
  // Filtrar las transacciones que coincidan con el string pasado por parámetro en los primeros 5 campos
  return lots.where((lot) {
    // Filtrar por los primeros 5 campos
    return lot.lotNumber.toString().contains(filterString);
  }).toList();
}
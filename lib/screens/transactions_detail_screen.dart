import 'package:digipay/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/ResponseTransactions.dart';
import '../themes/digipay_theme.dart';

class TransactionsDetailScreen extends StatefulWidget {
  final String comercio;
  final String rif;
  final String merchant;
  final String terminal;
  final String lote;

  const TransactionsDetailScreen({
    Key? key,
    required this.comercio,
    required this.rif,
    required this.merchant,
    required this.terminal,
    required this.lote,
  }) : super(key: key);

  @override
  _TransactionsDetailScreenState createState() => _TransactionsDetailScreenState();
}

class _TransactionsDetailScreenState extends State<TransactionsDetailScreen> {
  bool _isLoading = false;
  bool _isFiltered = false;
  List<ResponseTransactions> _filteredList = [];
  List<ResponseTransactions> _transactionsList = [];
  final _Parameters = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    // Cargar el listado de transacciones
    TransactionsProvider().getTransactions(context, widget.merchant, widget.terminal)
        .then((transactions) {
      setState(() {
        _transactionsList = transactions;
        _isLoading = false;
      });
    })
        .catchError((error) {
      setState(() {
        _isLoading = false;
      });
      print('Error al cargar las transacciones: $error');
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
                      children: [
                        Text(
                          'Lote ${widget.lote}',
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

                        _transactionsList.length > 3 ?
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 8.0, top: 15, bottom: 10), // Espacio entre el TextField y el botón
                                child: TextField(
                                  controller: _Parameters,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(30), // Máximo de 3 caracteres
                                  ],
                                  textAlign: TextAlign.start, // Centrar los dígitos
                                  decoration: InputDecoration(
                                    labelText: 'Indique un parámetro',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_Parameters.text.isNotEmpty && _transactionsList.isNotEmpty){
                                  setState(() {
                                    _isFiltered = true;
                                    _filteredList = [];
                                    _filteredList = filterTransactions(_transactionsList, _Parameters.text);
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
                      ),): _transactionsList.isEmpty ?
                    Center(
                      child: Text("No hay transacciones para mostrar"),
                    ): _filteredList.isEmpty ?
                    _isFiltered ?
                    Center(
                      child: Text("No hay coincidencias"),
                    ):
                    ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      itemCount: _transactionsList.length,
                      itemBuilder: (context, index) {
                        return TransactionsExpansionTile(
                          transaction: _transactionsList[index],
                        );
                      },
                    ):
                    ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      itemCount: _filteredList.length,
                      itemBuilder: (context, index) {
                        return TransactionsExpansionTile(
                          transaction: _filteredList[index],
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
                  Image.asset('assets/generic_card2.png', width: 60),
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

List<ResponseTransactions> filterTransactions(List<ResponseTransactions> transactions, String filterString) {
  // Filtrar las transacciones que coincidan con el string pasado por parámetro en los primeros 5 campos
  return transactions.where((transaction) {
    // Filtrar por los primeros 5 campos
    return transaction.tranDate.toString().contains(filterString) ||
        transaction.applicationLabel.toString().contains(filterString) ||
        transaction.d002.contains(filterString) ||
        transaction.d037.contains(filterString) ||
        transaction.d004.contains(filterString) ||
        transaction.d011.contains(filterString);
  }).toList();
}
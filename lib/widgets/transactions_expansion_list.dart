import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/ResponseTransactions.dart';
import '../themes/digipay_theme.dart';

class TransactionsExpansionList extends StatefulWidget {
  final ResponseTransactions transaction;

  TransactionsExpansionList({required this.transaction});

  @override
  _TransactionsExpansionListState createState() => _TransactionsExpansionListState();
}

class _TransactionsExpansionListState extends State<TransactionsExpansionList> {
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


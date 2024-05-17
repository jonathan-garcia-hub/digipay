import 'package:digipay/models/ResponseLoteDetails.dart';
import 'package:digipay/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/ResponseTransactions.dart';
import '../themes/digipay_theme.dart';

class LoteReceiptScreen extends StatefulWidget {
  final String merchant;
  final String terminal;
  final int lote;

  const LoteReceiptScreen({
    Key? key,
    required this.merchant,
    required this.terminal,
    required this.lote,
  }) : super(key: key);

  @override
  _LoteReceiptScreenState createState() => _LoteReceiptScreenState();
}

class _LoteReceiptScreenState extends State<LoteReceiptScreen> {

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
                          'Lote cerrado: ${widget.lote.toString().padLeft(3, '0')}',
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

                Expanded(
                  child: FutureBuilder(
                    future: transactions.getLotCloseDetails(context, widget.merchant, widget.terminal, widget.lote),
                    builder: (context, AsyncSnapshot<ResponseLoteDetails> snapshot) {
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

                      final lote = snapshot.data!;


                      return
                        lote.id == 0 ?
                        Center(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 150),
                            height: 180,
                            child: Text("No hay recibo de cierre de lote para mostrar"),
                          ),):
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("RECIBO DE CIERRE",
                                    style: TextStyle(fontSize:18,color: Colors.black,fontWeight: FontWeight.bold)),
                                SizedBox(height: 20,),
                                Text(lote.receipt),
                                ElevatedButton(
                                  onPressed: () {
                                    Share.share(lote.receipt);
                                  },
                                  child: const Icon(Icons.share),
                                ),
                              ],
                            ),
                          ),
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
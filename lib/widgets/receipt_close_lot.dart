import 'package:digipay/models/ResponseIndicators.dart';
import 'package:digipay/models/ResponseLoteDetails.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../themes/digipay_theme.dart';

class ReceiptCloseLot extends StatefulWidget {
  final ResponseLoteDetails lote;

  ReceiptCloseLot({
    required this.lote,
  });

  @override
  _ReceiptCloseLotState createState() => _ReceiptCloseLotState();
}


class _ReceiptCloseLotState extends State<ReceiptCloseLot> {
  bool _isExpanded1 = true;


  @override
  Widget build(BuildContext context) {
    return ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(_isExpanded1 ? 10 : 10),
              child: ExpansionTile(
                initiallyExpanded: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.receipt_long),
                    Text(
                      'Recibo de cierre',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                collapsedBackgroundColor: Colors.grey[200],
                backgroundColor: ThemeConfig.secondaryColor.withOpacity(0.3),
                onExpansionChanged: (value) {
                  setState(() {
                    _isExpanded1 = value;
                  });
                },
                children: [
                  Divider(color: ThemeConfig.primaryColor,),
                  _isExpanded1
                      ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(widget.lote.receipt),
                        ElevatedButton(
                          onPressed: () {
                            Share.share(widget.lote.receipt);
                          },
                          child: const Icon(Icons.share),
                        ),
                      ],
                    ),
                  )
                      : Container(),
                ],
              ),
            )
          ]
      );
  }

}




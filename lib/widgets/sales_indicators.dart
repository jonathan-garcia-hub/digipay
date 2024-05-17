import 'package:digipay/models/ResponseIndicators.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../themes/digipay_theme.dart';

class SalesIndicators extends StatefulWidget {
  final ResponseIndicators indicators;

  SalesIndicators({
    required this.indicators,
  });

  @override
  _SalesIndicatorsState createState() => _SalesIndicatorsState();
}


class _SalesIndicatorsState extends State<SalesIndicators> {
  bool _isExpanded1 = true;
  // bool _isExpanded2 = false;
  // bool _isExpanded3 = false;
  // bool _isExpanded4 = false;


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
                    Icon(Icons.point_of_sale_sharp),
                    Text(
                      'Indicadores de ventas',
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                                Text('${widget.indicators.quantitySales.toString()} Venta(s)'),
                              ],
                            ),
                            Text('${widget.indicators.amountSales} Bs')
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
                                Text('${widget.indicators.quantitySalesDebitApproved.toString()} Venta(s)'),
                              ],
                            ),

                            Text('${widget.indicators.amountSalesDebitApproved} Bs')
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
                                Text('${widget.indicators.quantitySalesCreditApproved.toString()} Venta(s)'),
                              ],
                            ),

                            Text('${widget.indicators.amountSalesCreditApproved} Bs')
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
                                Text('${widget.indicators.quantityRefund.toString()} Venta(s)'),
                              ],
                            ),

                            Text('${widget.indicators.quantityRefund} Bs')
                          ],
                        ),
                        SizedBox(height: 10,),
                        // _buildIndicatorRow('Cantidad', widget.indicators.quantitySales, ""),
                        // Divider(color: ThemeConfig.secondaryColor,),
                        // _buildIndicatorRow('Monto Total', widget.indicators.amountSales, " Bs"),
                      ],
                    ),
                  )
                      : Container(),
                ],
              ),
            ),
            // SizedBox(height: 10,),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(_isExpanded2 ? 10 : 10),
            //   child: ExpansionTile(
            //     title: const Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       children: [
            //         Icon(Icons.account_balance),
            //         Text(
            //           'Ventas por débito',
            //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //         ),
            //
            //       ],
            //     ),
            //     collapsedBackgroundColor: Colors.grey[200],
            //     backgroundColor: ThemeConfig.secondaryColor.withOpacity(0.3),
            //     onExpansionChanged: (value) {
            //       setState(() {
            //         _isExpanded2 = value;
            //       });
            //     },
            //     children: [
            //       Divider(color: ThemeConfig.primaryColor,),
            //       _isExpanded2
            //           ? Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.stretch,
            //           children: [
            //             _buildIndicatorRow('Cantidad', widget.indicators.quantitySalesDebitApproved, ""),
            //             Divider(color: ThemeConfig.secondaryColor,),
            //             _buildIndicatorRow('Monto', widget.indicators.amountSalesDebitApproved, " Bs"),
            //           ],
            //         ),
            //       )
            //           : Container(),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 10,),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(_isExpanded3 ? 10 : 10),
            //   child: ExpansionTile(
            //     title: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       children: [
            //         Icon(Icons.credit_card),
            //         Text(
            //           'Ventas por crédito',
            //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //         ),
            //
            //       ],
            //     ),
            //     collapsedBackgroundColor: Colors.grey[200],
            //     backgroundColor: ThemeConfig.secondaryColor.withOpacity(0.3),
            //     onExpansionChanged: (value) {
            //       setState(() {
            //         _isExpanded3 = value;
            //       });
            //     },
            //     children: [
            //       Divider(color: ThemeConfig.primaryColor,),
            //       _isExpanded3
            //           ? Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.stretch,
            //           children: [
            //             _buildIndicatorRow('Cantidad', widget.indicators.quantitySalesCreditApproved, ""),
            //             Divider(color: ThemeConfig.secondaryColor,),
            //             _buildIndicatorRow('Monto', widget.indicators.amountSalesCreditApproved, " Bs"),
            //           ],
            //         ),
            //       )
            //           : Container(),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 10,),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(_isExpanded4 ? 10 : 10),
            //   child: ExpansionTile(
            //     title: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       children: [
            //         Icon(Icons.change_circle_outlined),
            //         Text(
            //           'Anulaciones',
            //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //         ),
            //         SizedBox(height: 15,)
            //
            //       ],
            //     ),
            //     collapsedBackgroundColor: Colors.grey[200],
            //     backgroundColor: ThemeConfig.secondaryColor.withOpacity(0.3),
            //     onExpansionChanged: (value) {
            //       setState(() {
            //         _isExpanded4 = value;
            //       });
            //     },
            //     children: [
            //       Divider(color: ThemeConfig.primaryColor,),
            //       _isExpanded4
            //           ? Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.stretch,
            //           children: [
            //             _buildIndicatorRow('Cantidad', widget.indicators.quantityRefund, ""),
            //             Divider(color: ThemeConfig.secondaryColor,),
            //             _buildIndicatorRow('Monto', widget.indicators.amountRefund, " Bs"),
            //           ],
            //         ),
            //       )
            //           : Container(),
            //     ],
            //   ),
            // ),
          ]
      );
  }

  Widget _buildIndicatorRow(String label, dynamic value, String currency) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14),
          ),
          Text(
            value.toString()+currency,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}




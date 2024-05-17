import 'package:digipay/providers/transactions_provider.dart';
import 'package:digipay/screens/transactions_detai_closet_screen_.dart';
import 'package:digipay/screens/transactions_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/ResponseIndicators.dart';
import '../models/ResponseTransactions.dart';
import '../themes/digipay_theme.dart';
import '../widgets/sales_indicators.dart';
import 'lote_receipt_screen.dart';

class TransactionsClosetScreen extends StatefulWidget {
  final String comercio;
  final String rif;
  final String merchant;
  final String terminal;

  const TransactionsClosetScreen({
    Key? key,
    required this.comercio,
    required this.rif,
    required this.merchant,
    required this.terminal,
  }) : super(key: key);

  @override
  _TransactionsClosetScreenState createState() => _TransactionsClosetScreenState();
}

class _TransactionsClosetScreenState extends State<TransactionsClosetScreen> {

  bool _isLoading = false;
  bool _HasLot = false;
  final _lotNumberController = TextEditingController();
  int _lotNumber = -1;

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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                              const TextSpan(
                                text: 'Nombre Comercio: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: ThemeConfig.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: widget.comercio,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15,),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 8.0), // Espacio entre el TextField y el botón
                                child: TextField(
                                  controller: _lotNumberController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3), // Máximo de 3 caracteres
                                  ],
                                  textAlign: TextAlign.center, // Centrar los dígitos
                                  decoration: InputDecoration(
                                    labelText: 'Indique el lote',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {

                                //Se llama al metodo con el numero del lote
                                if (_lotNumberController.text.isEmpty){

                                  setState(() {
                                    _HasLot = false;
                                    _lotNumber = -1;
                                  });

                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        AlertDialog(
                                          title: Text('Aviso'),
                                          content: Text(
                                              'Indique un lote para continuar.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text('OK'),
                                            ),
                                          ],
                                        ),
                                  );
                                }else{

                                  //Se activa el loading
                                  setState(() {
                                    _isLoading = true;

                                    // _lotNumber = int.parse();

                                    if (int.parse(_lotNumberController.text) != _lotNumber){
                                      _HasLot = false;
                                      _lotNumber = int.parse(_lotNumberController.text);
                                    }

                                    _isLoading = false;
                                    _HasLot = true;
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
                        ),

                        _HasLot ?
                          Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => TransactionsDetailClosetScreen(
                                    comercio: widget.comercio,
                                    rif: widget.rif,
                                    merchant: widget.merchant,
                                    terminal: widget.terminal,
                                    lote: _lotNumber,
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
                        )
                            : SizedBox(),

                        _HasLot ?
                        Container(
                          padding: EdgeInsets.fromLTRB(0,0,0,10),
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => LoteReceiptScreen(
                                    merchant: widget.merchant,
                                    terminal: widget.terminal,
                                    lote: _lotNumber,
                                  )));
                            },
                            icon: Icon(Icons.receipt_long, color: Color(0xff0045ab)), // Icono del botón
                            label: Text('Recibo del lote',
                                style: TextStyle(fontSize:16,color: Colors.black,)), // Texto del botón
                            style: ElevatedButton.styleFrom(
                              primary: ThemeConfig.tertiaryColor, // Color de fondo del botón
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20), // Bordes redondeados del botón
                              ),
                            ),
                          ),
                        )
                            : SizedBox()
                      ],
                    ),
                  ),
                ),

                _isLoading?
                  const Expanded(
                  child: SpinKitCircle(
                    color: ThemeConfig.primaryColor,
                    size: 60.0,
                  ),
                ) :
                    _HasLot ?
                      FutureBuilder(
                        future: transactions.getIndicatorsClose(context, _lotNumber),
                        builder: (context, AsyncSnapshot<ResponseIndicators> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Expanded(
                                child: SpinKitCircle(
                                  color: ThemeConfig.primaryColor,
                                  size: 60.0,
                                ),
                              ),
                            );
                          }

                          final indicators = snapshot.data!;


                          return
                            indicators.lotNumber == 0 ?
                            Center(
                              child: Expanded(
                                child: Text("No hay indicadores para mostrar"),
                              ),):
                            //Puede cambiar de tamano en tiempo de ejecucion
                            Expanded(
                              child: SalesIndicators(
                                indicators: indicators,
                              ),
                            );
                        },
                      ):
                      const SizedBox(),

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


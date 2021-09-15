import 'package:flutter/material.dart';
import 'package:practica2/src/utils/color_settings.dart';

class Opcion1Screen extends StatefulWidget {
  Opcion1Screen({Key? key}) : super(key: key);

  @override
  _Opcion1ScreenState createState() => _Opcion1ScreenState();
}

class _Opcion1ScreenState extends State<Opcion1Screen> {

  TextEditingController txtMontoCon = TextEditingController();
  var monto = 0.0;
  var total = 0.0;

  @override
  Widget build(BuildContext context) {
    TextFormField txtMonto = TextFormField(
      controller: txtMontoCon,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Escriba el monto',
        prefixIcon: Icon(Icons.monetization_on),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical:5)
      ),
    );

    ElevatedButton btnCalcular = ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: ColorsSettings.colorButton
      ),
      onPressed: (){
        if (txtMontoCon.text.isNotEmpty) {
          setState(() {});
          monto = double.parse(txtMontoCon.text);
          total = (monto*0.16)+monto;
          //print(monto); 
          //print(total);
          showDialog(
            context: context, 
            builder: (context) => AlertDialog(
              title: const Text('Monto total con propina :'),
              content: Text(""+total.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            )
          );
        }else{
          showDialog(
            context: context, 
            builder: (context) => AlertDialog(
              titleTextStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              title: const Text('ERROR: Ingrese el monto.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            )
          );
        }
        //print(txtMontoCon.text);     
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('CALCULAR')
        ],
      )
    );
    return Container(
      decoration: BoxDecoration(
        color: ColorsSettings.colorPrimary
      ),
      child: Card(
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              txtMonto,
              SizedBox(height: 5,),
              btnCalcular
            ],
          ),
        ),
      )
    );
  }
}
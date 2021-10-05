import 'package:flutter/material.dart';
import 'package:practica2/src/utils/color_settings.dart';

class DaashBoardScreen extends StatelessWidget {
  const DaashBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DASHBOARD'),
        backgroundColor: ColorsSettings.colorPrimary,  
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('LUISA MEDINA'), 
              accountEmail: Text('luisaestm@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes.png'),
                //child: Icon(Icons.verified_user)
              ),
              otherAccountsPictures: [
                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/perfil');
                  }, 
                  icon: Icon(Icons.settings)
                ),
              ],
              decoration: BoxDecoration(
                color: ColorsSettings.colorPrimary
              ),
            ),
            ListTile(
              title: Text('Propinas'),
              subtitle: Text('Calculadora de propinas'),
              leading: Icon(Icons.monetization_on),
              trailing: Icon(Icons.chevron_right),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/propinas');
              },
            ),
            ListTile(
              title: Text('Intenciones'),
              subtitle: Text('Intenciones implicitas'),
              leading: Icon(Icons.phone_android),
              trailing: Icon(Icons.chevron_right),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/intenciones');
              },
            ),
            ListTile(
              title: Text('Notas'),
              subtitle: Text('CRUD notas'),
              leading: Icon(Icons.phone_android),
              trailing: Icon(Icons.chevron_right),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/notas');
              },
            ),
            ListTile(
              title: Text('Movies'),
              subtitle: Text('Prueba API REST'),
              leading: Icon(Icons.phone_android),
              trailing: Icon(Icons.chevron_right),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/movie');
              },
            )
          ], 
        )
      ),
    );
  }
}
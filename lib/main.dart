import 'package:flutter/material.dart';
import 'package:practica2/src/screens/agregar_nota_screen.dart';
import 'package:practica2/src/screens/agregar_task_screen.dart';
import 'package:practica2/src/screens/intenciones_screen.dart';
import 'package:practica2/src/screens/movies_screens/detail_screen.dart';
import 'package:practica2/src/screens/movies_screens/popular_screen.dart';
import 'package:practica2/src/screens/notas_screen.dart';
import 'package:practica2/src/screens/opcion1_screen.dart';
import 'package:practica2/src/screens/splash_screen.dart';
import 'package:practica2/src/screens/profile_screen.dart';
import 'package:practica2/src/screens/task_list_entrega_screen.dart';
import 'package:practica2/src/screens/tasks_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/propinas' : (BuildContext context) => Opcion1Screen(),
        '/intenciones' : (BuildContext context) => IntencionesScreen(),
        '/notas' : (BuildContext context) => NotasScreen(),
        '/agregar' : (BuildContext context) => AgregarNotaScreen(),
        '/perfil' : (BuildContext context) => ProfileScreen(),
        '/movie' : (BuildContext context) => PopularScreen(),
        '/task' : (BuildContext context) => TasksScreen(),
        '/agregartask' : (BuildContext context) => AgregarTaskScreen(),
        '/taskentregadas' : (BuildContext context) => TaskEntregadas(),
        '/detail' : (BuildContext context) => DetailScreen(),
      },
      debugShowCheckedModeBanner: false,
      //home: LoginScreen(),
      home: SplashScreen(),
    );
  }
}
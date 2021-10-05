import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:practica2/src/models/notas_model.dart';
import 'package:practica2/src/models/perfil_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _nombreBD = "NOTASBD";
  static final _versionBD = 4;
  static final _nombreTBL = "tblNotas";
  static final _nombreTBLP = "tblPerfil";
  static Database? _database;

  Future<Database?> get database async {
    if( _database != null ) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async{
    Directory carpeta = await getApplicationDocumentsDirectory();
    String rutaBD = join(carpeta.path, _nombreBD);
    return openDatabase(
      rutaBD,
      version: _versionBD,
      onCreate: _crearTabla,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldversion, int newversion) async{
    db.execute("DROP TABLE $_nombreTBLP");
    db.execute("Create table $_nombreTBLP (id INTEGER PRIMARY KEY, nombre VARCHAR(50), apaterno VARCHAR(50), amaterno VARCHAR(50), tel VARCHAR(15), correo VARCHAR(60), avatar TEXT)");
  }

  Future<void> _crearTabla(Database db, int version) async{
    await db.execute("CREATE TABLE $_nombreTBL (id INTEGER PRIMARY KEY, titulo VARCHAR(50), detalle VARCHAR(100))");
    await db.execute("Create table $_nombreTBLP (id INTEGER PRIMARY KEY, nombre VARCHAR(50), apaterno VARCHAR(50), amaterno VARCHAR(50), tel VARCHAR(15), correo VARCHAR(60), avatar TEXT)");
   
  }
  //VER TAMAÑO Y TIPO IMAGEN----------------------------------------
  
  

  insert(Map<String,dynamic> row) async{
    var conexion = await database; //DEBEMOS PONER AWAIT PARA NO TENER ERRORES
    return conexion!.insert(_nombreTBL, row); //! indica que no debe ser nulo el insert
  }

  Future<int> update(Map<String,dynamic> row) async{
    var conexion = await database;
    return conexion!.update(_nombreTBL, row, where: 'id = ?', whereArgs: [row['id']]);
  }

  Future<int> delete(int id) async{
    var conexion = await database;
    return await conexion!.delete(_nombreTBL, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<NotasModel>> getAllNotes() async {
    var conexion = await database;
    var result = await conexion!.query(_nombreTBL); //query es un select
    return result.map((notaMap) => NotasModel.fromMap(notaMap)).toList();
  }

  Future<NotasModel> getNote(int id) async{
    var conexion = await database;
    var result = await conexion!.query(_nombreTBL, where: 'id = ?', whereArgs: [id]);
    //result.map((notaMap) => NotasModel.fromMap(notaMap)).first;
    return NotasModel.fromMap(result.first);
  }

  //perfil
  insertPerfil(Map<String,dynamic> row) async{
    var conexion = await database; //DEBEMOS PONER AWAIT PARA NO TENER ERRORES
    return conexion!.insert(_nombreTBLP, row); //! indica que no debe ser nulo el insert
  }
  Future<List<PerfilModel>> getPerfil() async {
    var conexion = await database;
    var result = await conexion!.query(_nombreTBLP); //query es un select
    return result.map((perfilMap) => PerfilModel.fromMap(perfilMap)).toList();
  }

  Future<int> updatePerfil(Map<String,dynamic> row) async{
    var conexion = await database;
    return conexion!.update(_nombreTBLP, row, where: 'id = ?', whereArgs: [row['id']]);
  }

}
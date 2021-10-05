import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:practica2/database/database_helper.dart';
import 'package:practica2/src/models/perfil_model.dart';
import 'package:practica2/src/utils/color_settings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practica2/src/utils/utility.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late DatabaseHelper _databaseHelper;
  TextEditingController _controllerNombre = TextEditingController();
  TextEditingController _controllerAPaterno = TextEditingController();
  TextEditingController _controllerAMaterno = TextEditingController();
  TextEditingController _controllerTel = TextEditingController();
  TextEditingController _controllerCorreo = TextEditingController();
  bool _validateNombre = false;
  bool _validateAPaterno = false;
  bool _validateAMaterno = false;
  bool _validateTel = false;
  bool _validateCorreo = false;
  //bool isvalidCo = false;
  String? _imgn=null;
  

  Future getImage(ImageSource source) async{
    final img = await ImagePicker().pickImage(
      source: source,
      maxHeight: 800,
      maxWidth: 800
    );
    setState(() {
      if (img == null) return;
      final imgt = File(img.path);
      _imgn = Utility.base64String(imgt.readAsBytesSync());
    });
  }

  @override
  void initState(){
    _databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsSettings.colorPrimary,
        title: Text('Editar Perfil')
      ),
      body: FutureBuilder(
        future: _databaseHelper.getPerfil(),
        builder: (BuildContext context, AsyncSnapshot<List<PerfilModel>> snapshot){
          //validar si hubo error al momento de recuperar datos
          if(snapshot.hasError){
            return Center(child: Text('Ocurrio un error en la petición'),);
          }else{ //revisar si se hizo bien la conexion
            if(snapshot.connectionState == ConnectionState.done){
              return _listadPerfil(snapshot.data!);
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          }
        },
      ),
    );
  }

  Widget _listadPerfil(List<PerfilModel> perfiles){
    print(perfiles);
    return RefreshIndicator(
      onRefresh: (){
        return Future.delayed(
        Duration(seconds: 2),
        (){setState(() {});}
        );
      },
      child: ListView.builder(
        itemBuilder: (BuildContext context, index){ //llamada implicita
          PerfilModel perfil = perfiles[0];
          _controllerNombre.text = perfil.nombre!;
          _controllerAPaterno.text = perfil.apaterno!;
          _controllerAMaterno.text = perfil.amaterno!;
          _controllerTel.text = perfil.tel!;
          _controllerCorreo.text = perfil.correo!;
          String imgen;
          if(_imgn == null){
            imgen = perfil.avatar!;
          }else{
            imgen = _imgn!;
          }
          return Card(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    child: imgen == null ? Text('Aún no ha cargado imagen') : Image.memory(base64Decode(imgen), fit: BoxFit.fill,)
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                        shape: CircleBorder()
                      ),
                        onPressed: (){
                          getImage(ImageSource.camera);
                        },
                        child: Icon(Icons.camera_alt_outlined)
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                        shape: CircleBorder()
                      ),
                        onPressed: (){
                          getImage(ImageSource.gallery);
                        },
                        child: Icon(Icons.image_outlined)
                      )
                    ],
                  ),
                  SizedBox(height: 5,),
                  _crearTextFieldNombre(),
                  SizedBox(height: 5,),
                  _crearTextFieldAPaterno(),
                  SizedBox(height: 5,),
                  _crearTextFieldAMaterno(),
                  SizedBox(height: 5,),
                  _crearTextFieldTel(),
                  SizedBox(height: 5,),
                  _crearTextFieldCorreo(),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        _controllerNombre.text.isEmpty ? _validateNombre = true : _validateNombre = false;
                        _controllerAPaterno.text.isEmpty ? _validateAPaterno = true : _validateAPaterno = false;
                        _controllerAMaterno.text.isEmpty ? _validateAMaterno = true : _validateAMaterno = false;
                        _controllerTel.text.isEmpty ? _validateTel = true : _validateTel = false;
                        _controllerCorreo.text.isEmpty ? _validateCorreo = true : _validateCorreo = false;

                        if(_validateNombre == false && _validateAPaterno == false && _validateAMaterno == false && _validateTel == false && _validateCorreo == false)
                        {
                              PerfilModel obj = PerfilModel(
                                id: perfil.id,
                                nombre: _controllerNombre.text,
                                apaterno: _controllerAPaterno.text,
                                amaterno: _controllerAMaterno.text,
                                tel: _controllerTel.text,
                                correo: _controllerCorreo.text,
                                avatar: imgen
                              );
                              _databaseHelper.updatePerfil(obj.toMap()).then(
                                (value){
                                  if(value > 0){
                                    Navigator.of(this.context).pop();
                                  }else{
                                    ScaffoldMessenger.of(this.context).showSnackBar(
                                      SnackBar(content: Text('La solicitud no se ha realizado'))
                                    );
                                  }
                                }
                              );
                            }else{
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(content: Text('No se realizo'))
                              );
                            }
                        
                      });
                    },
                    child: Text('Guardar')
                  )
                ],
              ),
            ),
          );
        },
        itemCount: perfiles.length,
      )
    );
  }

  Widget _crearTextFieldNombre(){
    return TextField(
      controller:  _controllerNombre,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Nombre",
        errorText: _validateNombre ? 'Este campo es obligatorio' : null,
      ),
      onChanged: (value){

      },
    );
  }
  Widget _crearTextFieldAPaterno(){
    return TextField(
      controller:  _controllerAPaterno,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Apellido paterno",
        errorText: _validateAPaterno ? 'Este campo es obligatorio' : null,
      ),
      onChanged: (value){

      },
    );
  }
  Widget _crearTextFieldAMaterno(){
    return TextField(
      controller:  _controllerAMaterno,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Apellido materno",
        errorText: _validateAMaterno ? 'Este campo es obligatorio' : null,
      ),
      onChanged: (value){

      },
    );

  }
  Widget _crearTextFieldTel(){
    return TextField(
      controller:  _controllerTel,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Teléfono",
        errorText: _validateTel ? 'Este campo es obligatorio' : null,
      ),
      onChanged: (value){

      },
    );

  }
  Widget _crearTextFieldCorreo(){
    return TextField(
      controller:  _controllerCorreo,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Correo",
        errorText: _validateCorreo ? 'Este campo es obligatorio' : null,
      ),
      onChanged: (value){
      },
    );
  }
}
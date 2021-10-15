import 'package:flutter/material.dart';
import 'package:practica2/database/database_helper.dart';
import 'package:practica2/src/models/tasks_model.dart';
import 'package:practica2/src/utils/color_settings.dart';

class AgregarTaskScreen extends StatefulWidget {
  TaskModel? tarea; 
  AgregarTaskScreen({Key? key, this.tarea}) : super(key: key);

  @override
  _AgregarTaskScreenState createState() => _AgregarTaskScreenState();
}

class _AgregarTaskScreenState extends State<AgregarTaskScreen> {
  late DatabaseHelper _databaseHelper;
  TextEditingController _controllerNombre = TextEditingController();
  TextEditingController _controllerDesc = TextEditingController();
  TextEditingController _controllerDate = TextEditingController();
  String _fecha = '';
  String _fechaUpdate = '';
  bool _validateNombre = false;
  bool _validateDesc = false;
  bool _validateDate = false;

  @override
  void initState(){
    if(widget.tarea != null){
      _controllerNombre.text = widget.tarea!.nomTarea!;
      _controllerDesc.text = widget.tarea!.dscTarea!;
      _controllerDate.text = widget.tarea!.fechaEntrega!;
    }
    _databaseHelper = DatabaseHelper();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: ColorsSettings.colorPrimary,
      title: widget.tarea == null ? Text('Agregar Tarea') : Text('Editar Tarea'),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              _crearTextFieldNombre(),
              SizedBox(height: 10,),  //tener espaciado entre widgets
              _crearTextFieldDesc(),
              SizedBox(height: 10,),
              _crearTextFieldDate(context),
              SizedBox(height: 5,),
              ElevatedButton(
                onPressed: (){
                  setState(() {
                    //VALIDAR VACIO
                    _controllerNombre.text.isEmpty ? _validateNombre = true : _validateNombre = false;
                    _controllerDesc.text.isEmpty ? _validateDesc = true : _validateDesc = false;
                    _controllerDate.text.isEmpty ? _validateDate = true : _validateDate = false;
        
                    if(_validateNombre == false && _validateDesc == false && _validateDate == false && _controllerNombre.text.length<=48 && _controllerDesc.text.length<=98)
                    {
                      if(widget.tarea == null){           
                        TaskModel task = TaskModel(
                          nomTarea: _controllerNombre.text,
                          dscTarea: _controllerDesc.text,
                          fechaEntrega: _controllerDate.text
                        );
                        _databaseHelper.insertTask(task.toMap()).then(
                          (value){
                            if(value > 0){
                              Navigator.pop(context);
                              /*ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Registro insertado correctamente'))
                              );*/
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('La solicitud no se completo'))
                              );
                            }
                          }
                        );
                      }else{ //UPDATE
                        TaskModel task = TaskModel(
                          id: widget.tarea!.id, //no debe ser nulo
                          nomTarea: _controllerNombre.text,
                          dscTarea: _controllerDesc.text,
                          fechaEntrega: _controllerDate.text
                        );
                        _databaseHelper.updateTask(task.toMap()).then(
                          (value){
                            if(value > 0){
                              Navigator.pushNamed(context, '/task').whenComplete((){ //refresh automatica
                                setState(() {});
                              });
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('ERROR: La solicitud no se ha realizado.'))
                              );
                            }
                          }
                        );
                      }
                    }else{
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        SnackBar(content: Text('ERROR: No se pudo realizar la solicitud.'))
                      );
                    }
                  });
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _crearTextFieldNombre(){
    return TextField(
      controller:  _controllerNombre,
      keyboardType: TextInputType.text,
      maxLength: 48,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Nombre de la tarea",
        errorText: _validateNombre ? 'Este campo es obligatorio' : null,
        icon: Icon(Icons.person_sharp)
      ),
      onChanged: (value){

      },
    );
  }
  Widget _crearTextFieldDesc(){
    return TextField(
      controller: _controllerDesc,
      keyboardType: TextInputType.text,
      maxLines: 8,
      maxLength: 98,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Descripción",
        errorText: _validateDesc ? 'Este campo es obligatorio' : null,
        icon: Icon(Icons.notes_outlined)
      ),
      onChanged: (value){

      },
    );
  }

  Widget _crearTextFieldDate(BuildContext context){
    return TextField(
      controller:  _controllerDate,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Fecha de entrega",
        errorText: _validateDate ? 'Este campo es obligatorio' : null,
        icon: Icon(Icons.calendar_today_sharp)
      ),
      onChanged: (value){

      },
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
        _date(context);
      },
    );
  }

  _date(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if(picked != null){
      setState(() {
        _fecha = picked.toString();
        _controllerDate.text = _fecha;
      });
    }
  }


}
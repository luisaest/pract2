import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:practica2/database/database_helper.dart';
import 'package:practica2/src/models/tasks_model.dart';
import 'package:practica2/src/utils/color_settings.dart';

class TaskEntregadas extends StatefulWidget {
  TaskEntregadas({Key? key}) : super(key: key);

  @override
  _TaskEntregadasState createState() => _TaskEntregadasState();
}

class _TaskEntregadasState extends State<TaskEntregadas> {
  late DatabaseHelper _databaseHelper;

  @override
  void initState(){
    super.initState();
    _databaseHelper = DatabaseHelper();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsSettings.colorPrimary,
        title: Text('Lista de tareas entregadas')
      ),
      body: FutureBuilder(
        future: _databaseHelper.getAllTask(),
        builder: (BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot){
          //validar si hubo error al momento de recuperar datos
          if(snapshot.hasError){
            return Center(child: Text('Ocurrio un error en la petición'),);
          }else{ //revisar si se hizo bien la conexion
            if(snapshot.connectionState == ConnectionState.done){
              return _listadoTareas(snapshot.data!);
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          }
        },
      )
    );
  }

  Widget _listadoTareas(List<TaskModel> tareas){
    return RefreshIndicator(
      onRefresh: (){
        return Future.delayed(
        Duration(seconds: 2),
        (){setState(() {});}
        );
      },
      child: ListView.builder(
        itemBuilder: (BuildContext context, index){
          TaskModel tarea = tareas[index];
          if(tarea.entregada == 1){
            print(tarea.id);
            print(tarea.nomTarea);
            return Slidable(
              actionPane: SlidableDrawerActionPane(),
              child: Card(
                  child: Column(
                  children: [
                    Text(tarea.nomTarea!,style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(tarea.dscTarea!),
                    Text(tarea.fechaEntrega!.substring(0, 10))
                  ],
                ),
              ),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context){
                      return AlertDialog(
                        title: Text('Confirmación'),
                        content: Text('¿Estas seguro de eliminar esta tarea?'),
                        actions: [
                          TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                              _databaseHelper.deleteTask(tarea.id!).then(
                                (noRows){
                                  if(noRows > 0){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('El registro se ha eliminado'))
                                    );
                                    setState(() {  //para que haga la actualizacion
                                              
                                    });
                                  }
                                }
                              ); //es nun valor forzoso
                            },
                            child: Text('si')
                          ),
                          TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text('No')
                          )
                        ],
                      );
                    }
                  ),
                ),
              ],
            );
          }else{
            return SizedBox(height: 0);
          }
        },
        itemCount: tareas.length,
      )
    );
  }

}
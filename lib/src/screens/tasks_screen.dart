import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:practica2/database/database_helper.dart';
import 'package:practica2/src/models/tasks_model.dart';
import 'package:practica2/src/screens/agregar_task_screen.dart';
import 'package:practica2/src/utils/color_settings.dart';


class TasksScreen extends StatefulWidget {
  TasksScreen({Key? key}) : super(key: key);

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
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
        title: Text('Lista de tareas'),
        actions: [
          IconButton(
            onPressed: (){ 
              Navigator.pushNamed(context, '/taskentregadas').whenComplete((){ //refresh automatica
                setState(() {});
              });
            },
            icon: Icon(Icons.task_outlined)
          )
        ],
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/agregartask').whenComplete((){ //refresh automatica
            setState(() {});
          });
        },
        child: const Icon(Icons.add_task),
        backgroundColor: Colors.blueGrey,
      ),
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
          DateTime compfecha = DateTime.parse(tarea.fechaEntrega!);
          if(tarea.entregada == null){
            return Slidable(
              actionPane: SlidableDrawerActionPane(),
              child: Card(
                  child: Column(
                  children: [
                    Text(tarea.nomTarea!,style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(tarea.dscTarea!),
                    Text(tarea.fechaEntrega!.substring(0, 10)),
                    DateTime.now().isAfter(compfecha) ? Text('No ha entregado la tarea', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)) : Text('')
                  ],
                ),
              ),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Editar',
                  color: Colors.black45,
                  icon: Icons.edit,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AgregarTaskScreen(tarea: tarea)
                    )
                  )
                ),
                IconSlideAction(
                  caption: 'Entregar',
                  color: Colors.green,
                  icon: Icons.note_alt_rounded,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context){
                      return AlertDialog(
                        title: Text('Confirmación'),
                        content: Text('¿Estas seguro de entregar esta tarea?'),
                        actions: [
                          TextButton(
                            onPressed: (){
                              TaskModel task = TaskModel(
                                id: tarea.id,
                                nomTarea: tarea.nomTarea,
                                dscTarea: tarea.dscTarea,
                                fechaEntrega: tarea.fechaEntrega,
                                entregada: tarea.entregada = 1,
                              );
                              _databaseHelper.updateTask(task.toMap()).then(
                                (value){
                                  if(value > 0){
                                    Navigator.pop(context);
                                    setState(() {  //para que haga la actualizacion
                                              
                                    });
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('ERROR: La solicitud no se ha realizado.'))
                                    );
                                  }
                                }
                            );
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
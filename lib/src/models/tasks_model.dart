class TaskModel {
  int? id;
  String? nomTarea;
  String? dscTarea;
  String? fechaEntrega;
  int? entregada; //en sqlite representar un booleano es con 1 o 0 por lo tanto debe ser int

  TaskModel({this.id, this.nomTarea, this.dscTarea,this.fechaEntrega, this.entregada});

  //Map -> Object
  factory TaskModel.fromMap(Map<String,dynamic>map){
    return TaskModel(
      id : map['id'],
      nomTarea : map['nomTarea'],
      dscTarea : map['dscTarea'],
      fechaEntrega : map['fechaEntrega'],
      entregada : map['entregada'],
    );
  }

  //Object->Map
  Map<String, dynamic> toMap(){
    return {
      'id' :id,
      'nomTarea' :nomTarea,
      'dscTarea' :dscTarea,
      'fechaEntrega' :fechaEntrega,
      'entregada' :entregada
    };
  }
}
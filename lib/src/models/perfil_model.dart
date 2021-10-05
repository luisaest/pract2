class PerfilModel{
  int? id;
  String? nombre;
  String? apaterno;
  String? amaterno;
  String? tel;
  String? correo;
  String? avatar;

  PerfilModel({this.id,this.nombre, this.apaterno, this.amaterno, this.tel, this.correo, this.avatar});

  //Map -> Object
  factory PerfilModel.fromMap(Map<String,dynamic>map){
    return PerfilModel(
      id : map['id'],
      nombre : map['nombre'],
      apaterno : map['apaterno'],
      amaterno : map['amaterno'],
      tel: map['tel'],
      correo: map['correo'],
      avatar: map['avatar'],
    );
  }

  //Object->Map
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'nombre' :nombre,
      'apaterno' :apaterno,
      'amaterno' :amaterno,
      'tel': tel,
      'correo': correo,
      'avatar' : avatar
    };
  }
}
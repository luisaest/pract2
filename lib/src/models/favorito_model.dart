class FavoritoModel {
  int? id;
  String? title;
  String? backdrop_path;

  FavoritoModel({this.id, this.title, this.backdrop_path});

  //Map -> Object
  factory FavoritoModel.fromMap(Map<String,dynamic>map){
    return FavoritoModel(
      id : map['id'],
      title : map['title'],
      backdrop_path : map['backdrop_path'],
    );
  }

  //Object->Map
  Map<String, dynamic> toMap(){
    return {
      'id' :id,
      'title' :title,
      'backdrop_path' :backdrop_path
    };
  }
}
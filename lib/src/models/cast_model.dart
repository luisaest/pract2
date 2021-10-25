class ListC {
  final List<Cast> cast;

  ListC(this.cast);
}

class Cast{
  String? name;
  String? profilePath;

  Cast({
    this.name, 
    this.profilePath
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    if(json == null){
      return Cast();
    }
    return Cast(
      name: json['name'],
      profilePath: json['profile_path']
    );
  }
}


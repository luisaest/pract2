import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:practica2/src/models/popular_movies_model.dart';

class ApiPopular{
  //ENDPOINT
  var URL = Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=eb5875f8c00b9aabd203e075a0e4b25f&language=en-MX&page=1');
  //CONSUMIR
  Future<List<PopularMoviesModel>?> getAllPopular() async{  //puede ser un valor falso
    //definir la ejecucion
    final response = await http.get(URL); //respuesta
    if(response.statusCode == 200){ //se ejecuto correctamente
      var popular = jsonDecode(response.body)['results'] as List;
      List<PopularMoviesModel> listPopular =  popular.map((movie) => PopularMoviesModel.fromMap(movie)).toList();  //convertir mapa a objeto
      return listPopular;
    }else{
      return null;
    }
  }
}
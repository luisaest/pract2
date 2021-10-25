import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:practica2/src/models/cast_model.dart';
import 'package:practica2/src/models/popular_movies_model.dart';

class ApiPopular{
  //ENDPOINT
  var URL = Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=eb5875f8c00b9aabd203e075a0e4b25f&language=en-MX&page=1');
  final Dio _dio = Dio();
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

  Future<PopularMoviesModel> getMovieDetalle(int id) async {
    try {
      final response = await _dio.get(
          'https://api.themoviedb.org/3/movie/$id?api_key=eb5875f8c00b9aabd203e075a0e4b25f&language=en-MX&page=1');
      PopularMoviesModel detalle =
          PopularMoviesModel.fromJson(response.data);
      
      detalle.trailerId = await getYoutubeId(id);
      detalle.castList = await getCast(id);

      return detalle;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Cast>> getCast(int id) async {
    try {
      final response = await _dio.get(
          'https://api.themoviedb.org/3/movie/$id/credits?api_key=eb5875f8c00b9aabd203e075a0e4b25f&language=en-MX&page=1');
      var list = response.data['cast'] as List;
      List<Cast> castList = list
          .map((c) => Cast(
              name: c['name'],
              profilePath: c['profile_path']))
          .toList();

      return castList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  Future<String> getYoutubeId(int id) async {
    try {
      final response = await _dio.get(
          'https://api.themoviedb.org/3/movie/${id}/videos?api_key=eb5875f8c00b9aabd203e075a0e4b25f&language=en-MX&page=1');
      var youtubeId = response.data['results'][0]['key'];
      return youtubeId;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }
}
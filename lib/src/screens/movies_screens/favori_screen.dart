import 'package:flutter/material.dart';
import 'package:practica2/database/database_helper.dart';
import 'package:practica2/src/models/favorito_model.dart';
import 'package:practica2/src/network/api_popular.dart';
import 'package:practica2/src/views/card_popular.dart';

class FavoriteScreen extends StatefulWidget {
  FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
ApiPopular? apiPopular;
late DatabaseHelper _databaseHelper;

  @override
  void initState(){
    super.initState();
    apiPopular = ApiPopular();
    _databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: FutureBuilder(
        future: _databaseHelper.getAllFavs(),
        builder: (BuildContext context, AsyncSnapshot<List<FavoritoModel>?> snapshot){
          if(snapshot.hasError){
            return Center(child: Text('Hay un error en la petición'),);
          }else{
            if(snapshot.connectionState == ConnectionState.done){
              return _listFavsMovies(snapshot.data);
            }else{
              return Center(child: CircularProgressIndicator());
            }
          }
        }
      )
    );
  }

   Widget _listFavsMovies(List<FavoritoModel>?favs){
    return ListView.separated(
      itemBuilder: (BuildContext context, index){
        FavoritoModel popular = favs![index];
        //return Card();
        //return CardPopularView(popular: popular);
        return Text(popular.title!);
      }, 
      separatorBuilder: (_, __) => Divider(height: 10,), 
      itemCount: favs!.length
    );
  }
}
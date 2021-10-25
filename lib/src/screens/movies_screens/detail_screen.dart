import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:practica2/src/models/popular_movies_model.dart';
import 'package:practica2/src/network/api_popular.dart';
import 'package:practica2/src/utils/color_settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:practica2/src/models/cast_model.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  ApiPopular? apiPopular;
  
  @override
  void initState(){
    super.initState();
    apiPopular = ApiPopular();
  }

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: apiPopular!.getMovieDetalle(movie['id']),
        builder: (BuildContext context, AsyncSnapshot<PopularMoviesModel?> snapshot){
          if(snapshot.hasError){
            return Center(child: Text('Hay un error en la petición'),);
          }else{
            if(snapshot.connectionState == ConnectionState.done){
              return _detalles(snapshot.data);
            }else{
              return Center(child: CircularProgressIndicator());
            }
          }
        }
      ),
    );
  }

  Widget _detalles(PopularMoviesModel? movies){
    
    return CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: MediaQuery.of(context).size.height * .6,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://image.tmdb.org/t/p/w500/${movies!.posterPath}',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${movies.title}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async{
                            final url = 'https://www.youtube.com/embed/${movies.trailerId}';
                            if(await canLaunch(url)){
                              await launch(url);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white
                          ),
                          child: Row(
                            children: [
                              Text('Ver', style: TextStyle(color: Colors.black),),
                              Icon(Icons.play_arrow, color: Colors.black,)
                            ],
                          )
                        ),
                        IconButton(
                          onPressed: (){}, 
                          icon: Icon(Icons.favorite),
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${movies.overview}',
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.3,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Cast',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 150,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movies.castList!.length,
                      itemBuilder: (context, index){
                        Cast cast = movies.castList![index];
                        return Container(
                          height: double.infinity,
                          width: 100,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            children: <Widget>[
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)
                                )
                              ),
                              ClipRRect(
                                child: CachedNetworkImage(
                                  imageUrl: cast.profilePath == null? 'https://static.vecteezy.com/system/resources/previews/000/566/937/non_2x/vector-person-icon.jpg' : 'https://image.tmdb.org/t/p/w200${cast.profilePath}',
                                  imageBuilder: (context, imageBuilder){
                                    return Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(100)),
                                        image: DecorationImage(image: imageBuilder, fit: BoxFit.cover),
                                      ),
                                    );
                                  }
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                left: 5,
                                child: Text(
                                  '${cast.name}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    ),
                  )
                ],
              ),
            ),
          )
        ],
    );
  }
}
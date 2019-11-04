import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:achernyak_app/api/api.dart';
import 'package:achernyak_app/models/movie_card.dart';
import 'package:achernyak_app/pages/movie-detail-page.dart';

class MovieListWidget extends StatelessWidget {
  const MovieListWidget({
    Key key,
    this.listName,
    @required this.stream,
  }) : super(key: key);

  final Stream<List<dynamic>> stream;
  final String listName;

  @override
  Widget build(BuildContext context) {
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: StreamBuilder<List<MovieCard>>(
              stream: stream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<MovieCard>> snapshot) {

                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemBuilder: (BuildContext context, int index) {

                        return _buildMovieCard(context, index, snapshot.data);
                      },
                      itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                    );
                  }
              ),
          ),
        ],
      );
  }

  Widget _buildMovieCard(
    BuildContext context,
    int index,
    List<MovieCard> movieCards) {

    final MovieCard movieCard =
        (movieCards != null && movieCards.length > index)
          ? movieCards[index]
          : null;

    if (movieCard == null) {

      return Center(
        child: const CircularProgressIndicator(),
      );
    }

  void goToMoviesDetailPage(MovieCard movieCardData) {
    Navigator
      .of(context)
      .push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        return MovieDetailsPage(
          movieCard: movieCardData,
          listName: listName,
        );
      }));
  }

    return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0)
          ),
          child: InkResponse(
            splashColor: Colors.red,
            enableFeedback: true,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Image(
                        image: CachedNetworkImageProvider(api.imageBaseUrl + movieCards[index].posterPath),
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                 ),
                 Container(
                  alignment: Alignment.bottomLeft,
                  child: Text('${movieCards[index].title }' ' ${movieCards[index].voteAverage.toString()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.white)))
               ],
            ),
            onTap: () => goToMoviesDetailPage(movieCards[index]),
          ),
        );
  }
}

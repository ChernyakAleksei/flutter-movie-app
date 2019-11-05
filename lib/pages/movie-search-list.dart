import 'package:achernyak_app/blocs/bloc_provider.dart';
import 'package:achernyak_app/blocs/search_bloc.dart';
import 'package:achernyak_app/models/movie_card.dart';
import 'package:achernyak_app/pages/movie-detail-page.dart';
import 'package:achernyak_app/pages/watch-list-page.dart';
import 'package:flutter/material.dart';

class MovieSearchListPage extends StatefulWidget {

  @override
  _MovieSearchListPageState createState() => _MovieSearchListPageState();
}

class _MovieSearchListPageState extends State<MovieSearchListPage> {
  @override
  Widget build(BuildContext context) {
    final MovieSearchBloc movieBloc = BlocProvider.of<MovieSearchBloc>(context);
    final TextEditingController _editingController = TextEditingController();

    void initState() {
      _editingController.addListener(() {
        final String text = _editingController.text.toLowerCase();
        _editingController.value = _editingController.value.copyWith(
          text: text,
          selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
          composing: TextRange.empty,
        );
      });
      super.initState();
    }

    void dispose() {
      _editingController.dispose();
      super.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (String value) {
                movieBloc.inMovieIndex.add(value);
              },
              controller: _editingController,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
          Expanded(
            child: StreamBuilder<List<MovieCard>>(
              stream: movieBloc.outSearchMoviesList,
              builder: (BuildContext context, AsyncSnapshot<List<MovieCard>> snapshot) {
              
                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {

                    return _buildMovieCard(context, index, snapshot.data);
                  },
              );
              }),
            ),
          ],
        ),
      );
  }

  Widget _buildMovieCard(
    BuildContext context,
    int index,
    List<MovieCard> movieCards) {

              
  void goToMoviesDetailPage(MovieCard movieCardData) {
    Navigator
      .of(context)
      .push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        return MovieDetailsPage(
          movieCard: movieCardData,
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
      child: ListTile(
        title: Text('${movieCards[index].title} (${movieCards[index].releaseDate.substring(0, 4)})'),
      ),
      onTap: () => goToMoviesDetailPage(movieCards[index]),
    ),
  );
  }

  void goToWatchListPage(BuildContext context) {
    Navigator
      .of(context)
      .push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        return WatchListPage();
      }));
  }
}

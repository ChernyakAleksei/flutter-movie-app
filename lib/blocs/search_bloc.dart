import 'dart:async';
import 'dart:collection';
import 'package:achernyak_app/api/api.dart';
import 'package:achernyak_app/blocs/bloc_provider.dart';
import 'package:achernyak_app/models/movie_card.dart';
import 'package:achernyak_app/models/movie_page_result.dart';
import 'package:rxdart/rxdart.dart';



class MovieSearchBloc implements BlocBase {
    MovieSearchBloc() {
    _serchController.stream.listen(_handleResp);
  }
  
  final PublishSubject<List<MovieCard>> _moviesSearchController = PublishSubject<List<MovieCard>>();
  Sink<List<MovieCard>> get _inSearchMoviesList => _moviesSearchController.sink;
  Stream<List<MovieCard>> get outSearchMoviesList => _moviesSearchController.stream;

  final PublishSubject<String> _serchController = PublishSubject<String>();
  Sink<String> get inMovieIndex => _serchController.sink;

  @override
  void dispose(){
    _moviesSearchController.close();
  }

  void _handleResp(String query){
    if (query.isNotEmpty && query.length > 3) {
      api.getSerachList(query: query)
        .then((MoviePageResult fetchedPage) => _handleFetchedPage(fetchedPage));
    }
  }

  void _handleFetchedPage(MoviePageResult page){
    final List<MovieCard> movies = <MovieCard>[];
    movies.addAll(page.movies);

    if (movies.isNotEmpty){
      _inSearchMoviesList.add(UnmodifiableListView<MovieCard>(movies));
    }
  }

}
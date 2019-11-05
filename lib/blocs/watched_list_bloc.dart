import 'dart:async';
import 'dart:collection';
import 'package:achernyak_app/blocs/bloc_provider.dart';
import 'package:achernyak_app/db/watch-mivie_db.dart';
import 'package:achernyak_app/models/movie_card.dart';
import 'package:rxdart/rxdart.dart';


class WatchedListBloc implements BlocBase {
  WatchedListBloc(){
    _watchListAddController.listen(_handleAddWatch);
    _watchListRemoveController.listen(_handleRemoveWatch);
    DBProvider.db.getAll('moviesWatched').then((List<MovieCard> list) => _inWatch.add(UnmodifiableListView<MovieCard>(list)));
  }

  final Set<MovieCard> _watchList = Set<MovieCard>();

  final BehaviorSubject<MovieCard> _watchListAddController = BehaviorSubject<MovieCard>();
  Sink<MovieCard> get inAddWatch => _watchListAddController.sink;

  final BehaviorSubject<MovieCard> _watchListRemoveController = BehaviorSubject<MovieCard>();
  Sink<MovieCard> get inRemoveWatch => _watchListRemoveController.sink;

  final BehaviorSubject<List<MovieCard>> _watchListController = BehaviorSubject<List<MovieCard>>.seeded([]);
  Sink<List<MovieCard>> get _inWatch =>_watchListController.sink;
  Stream<List<MovieCard>> get outWatch =>_watchListController.stream;

  @override
  void dispose(){
    _watchListAddController.close();
    _watchListRemoveController.close();
    _watchListController.close();
  }

  void _handleAddWatch(MovieCard movieCard){
    _watchList.add(movieCard);
    DBProvider.db.insert(movieCard, 'moviesWatched');

    _notify();
  }

  void _handleRemoveWatch(MovieCard movieCard){
    _watchList.removeWhere((MovieCard item) => item.id == movieCard.id);
    DBProvider.db.delete(movieCard.id, 'moviesWatched');


    _notify();
  }

  void _notify(){

    _inWatch.add(UnmodifiableListView<MovieCard>(_watchList));
  }
}
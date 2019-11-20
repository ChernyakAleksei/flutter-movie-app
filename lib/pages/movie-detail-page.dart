import 'package:achernyak_app/api/api.dart';
import 'package:achernyak_app/blocs/bloc_provider.dart';
import 'package:achernyak_app/blocs/watch_list_bloc.dart';
import 'package:achernyak_app/blocs/watched_list_bloc.dart';
import 'package:achernyak_app/models/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class MovieDetailsPage extends StatefulWidget {
  const MovieDetailsPage({
    Key key,
    this.movieCard
  }) : super(key: key);

  final MovieCard movieCard;

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  final List<String> genresList = <String>[];
  WatchListBloc _bloc;
  WatchedListBloc _blocWatched;

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<WatchListBloc>(context);
    _blocWatched = BlocProvider.of<WatchedListBloc>(context);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Stream<List<List<MovieCard>>> getMergetStream() {

    return Observable.combineLatest2(_bloc.outWatch, _blocWatched.outWatch, (List<MovieCard> a, List<MovieCard> b) => [a, b]);
  }

  @override
  Widget build(BuildContext context) {

    Widget _buttonBuilder (String label, dynamic action) {
      return FlatButton(
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        padding: const EdgeInsets.all(8.0),
        splashColor: Colors.orangeAccent,
        onPressed: action,
        child: Text(
          label,
          style: TextStyle(fontSize: 14.0),
        )
      );
    }

    List<Widget> _buildButtons(List<List<MovieCard>> snapshot) {
      final List<Widget> list = [];
      if(snapshot == null) {
        return [];
      }

      final bool inWatch = snapshot[0].indexWhere((MovieCard item) => item.id == widget.movieCard.id) > -1;
      final bool inWatched = snapshot[1].indexWhere((MovieCard item) => item.id == widget.movieCard.id) > -1;

      if (!inWatch) {
        list.add(_buttonBuilder('Add to WatchList', () {
          _bloc.inAddWatch.add(widget.movieCard);
          _blocWatched.inRemoveWatch.add(widget.movieCard);
        }));
      }

      if(!inWatched) {
        list.add(_buttonBuilder('Already Watched', () {
          _blocWatched.inAddWatch.add(widget.movieCard);
          _bloc.inRemoveWatch.add(widget.movieCard);
        }));
      }

      if(inWatch) {
        list.add(_buttonBuilder('Remove Watch', () {
            _bloc.inRemoveWatch.add(widget.movieCard);
        }));
      }

      if(inWatched) {
        list.add(_buttonBuilder('Remove Watched', () {
          _blocWatched.inRemoveWatch.add(widget.movieCard);
        }));
      }

      return list.toList();
    }

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                centerTitle: true,
                title: Text(widget.movieCard.title),
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                elevation: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    api.imageBaseUrl + widget.movieCard.posterPath,
                    fit: BoxFit.cover,
                )),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 50.0,
                  alignment: WrapAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        widget.movieCard.title,
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                Container(margin: const EdgeInsets.only(top: 8.0, bottom: 8.0)),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 1.0, right: 1.0),
                    ),
                    Text(
                      widget.movieCard.voteAverage.toString(),
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    ),
                    Text(
                      widget.movieCard.releaseDate,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
                Container(margin: const EdgeInsets.only(top: 8.0, bottom: 8.0)),
                StreamBuilder<List<List<MovieCard>>>(
                  stream: getMergetStream(),
                  builder: (BuildContext context, AsyncSnapshot<List<List<MovieCard>>> snapshot) {
              
                return Column(
                  children: <Widget>[
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: _buildButtons(snapshot.data),
                    )
                  ],
                );
              }),
                Text(widget.movieCard.overview),
                Container(margin: const EdgeInsets.only(top: 8.0, bottom: 8.0)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
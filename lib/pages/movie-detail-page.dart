import 'package:achernyak_app/api/api.dart';
import 'package:achernyak_app/blocs/bloc_provider.dart';
import 'package:achernyak_app/blocs/watch_list_bloc.dart';
import 'package:achernyak_app/blocs/watched_list_bloc.dart';
import 'package:achernyak_app/models/movie_card.dart';
import 'package:flutter/material.dart';

class MovieDetailsPage extends StatefulWidget {
  const MovieDetailsPage({
    Key key,
    this.movieCard,
    this.listName,
  }) : super(key: key);

  final MovieCard movieCard;
  final String listName;

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  final List<String> genresList = <String>[];
  dynamic _bloc;
  dynamic _blocWatched;


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

    List<Widget> _buildButtons(String name) {
      List<Widget> list = [];
      if(name == 'watch') {
        list.add(_buttonBuilder('Already Watched', () {
          _blocWatched.inAddWatch.add(widget.movieCard);
        }));

        list.add(_buttonBuilder('Remove', () {
          _bloc.inRemoveWatch.add(widget.movieCard);
        }));
      } else if (name == 'watched') {
        list.add(_buttonBuilder('Add to WatchList', () {
          _bloc.inAddWatch.add(widget.movieCard);
        }));

        list.add(_buttonBuilder('Remove', () {
          _blocWatched.inRemoveWatch.add(widget.movieCard);
        }));
      } else {
        list.add(_buttonBuilder('Add to WatchList', () {
          _bloc.inAddWatch.add(widget.movieCard);
        }));
        list.add(_buttonBuilder('Already Watched', () {
          _blocWatched.inAddWatch.add(widget.movieCard);
          
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
                Column(
                  children: <Widget>[
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: _buildButtons(widget.listName),
                    )
                  ],
                ),
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
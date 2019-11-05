import 'package:achernyak_app/blocs/bloc_provider.dart';
import 'package:achernyak_app/blocs/search_bloc.dart';
import 'package:achernyak_app/pages/movie-search-list.dart';
import 'package:achernyak_app/pages/watch-list-page.dart';
import 'package:achernyak_app/pages/watched-list-page.dart';
import 'package:flutter/material.dart';

class MovieListWrapperPage extends StatelessWidget {

  void goToSearchPage(BuildContext context) {
    Navigator
      .of(context)
      .push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        return BlocProvider<MovieSearchBloc>(
          bloc: MovieSearchBloc(),
          child: MovieSearchListPage(),
        );
      }));
  }

  @override
  Widget build(BuildContext context) {

    return  DefaultTabController(
      length: 2,
      child: Scaffold(
      appBar: AppBar(
        title: const Text('What to Watch'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Serch movies',
            onPressed: () {
              goToSearchPage(context);
            },
          ),
        ],
        bottom: TabBar(
          tabs: const <Widget>[
            Tab(text: 'Watch Later'),
            Tab(text: 'Watched'),
          ],
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          WatchListPage(),
          WatchedListPage(),
        ],
      )
    ),
    );
  }
}



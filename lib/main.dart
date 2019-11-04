import 'package:flutter/material.dart';
import 'package:achernyak_app/blocs/watch_list_bloc.dart';
import 'package:achernyak_app/blocs/watched_list_bloc.dart';
import 'package:achernyak_app/pages/movie-list-wrapper.dart';
import 'package:achernyak_app/blocs/bloc_provider.dart';

void main() => runApp(
  BlocProvider<WatchListBloc>(
    bloc: WatchListBloc(),
    child: BlocProvider<WatchedListBloc>(
      bloc: WatchedListBloc(),
      child: MyApp(),
    ),
  )
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.grey[600],
        ),
        primaryColor: Colors.red[500],
        textSelectionHandleColor: Colors.green[500],
      ),
      home: MovieListWrapperPage(),
    );
  }
}

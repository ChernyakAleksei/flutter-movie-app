import 'package:achernyak_app/blocs/watched_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:achernyak_app/blocs/bloc_provider.dart';
import 'package:achernyak_app/widgets/movie-list-widget.dart';


class WatchedListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WatchedListBloc bloc = BlocProvider.of<WatchedListBloc>(context);

    return Scaffold(

      body: MovieListWidget(stream: bloc.outWatch)
    );
  }
}
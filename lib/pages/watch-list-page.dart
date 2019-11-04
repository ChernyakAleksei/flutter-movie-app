import 'package:achernyak_app/blocs/watch_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:achernyak_app/blocs/bloc_provider.dart';
import 'package:achernyak_app/widgets/movie-list-widget.dart';


class WatchListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WatchListBloc bloc = BlocProvider.of<WatchListBloc>(context);

    return Scaffold(

      body: MovieListWidget(stream: bloc.outWatch, listName: 'watch')
    );
  }
}



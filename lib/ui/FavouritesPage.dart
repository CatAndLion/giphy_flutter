
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_flutter/bloc/GifListBloc.dart';
import 'package:giphy_flutter/loaders/DBLoader.dart';
import 'package:giphy_flutter/util/UiUtils.dart';

import 'GifGrid.dart';

class FavouritePage extends StatefulWidget {

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {

  GifListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = GifListBloc(DBLoader());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(UiUtils.titleLogoPath)
          ),

      body: BlocProvider<GifListBloc>(
        builder: (context) => bloc,
        child: Container(
          child: const GifGrid(),
          decoration: BoxDecoration(color: UiUtils.pageBackground),
        ),
      ),

    );
  }
}

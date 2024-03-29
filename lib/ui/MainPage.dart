import 'package:flutter/material.dart';
import 'package:giphy_flutter/bloc/GifListBloc.dart';
import 'package:giphy_flutter/bloc/ListEvent.dart';
import 'package:giphy_flutter/loaders/ApiLoader.dart';
import 'package:giphy_flutter/ui/GifGrid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_flutter/util/UiUtils.dart';

import 'FavouritesPage.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);
  
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {

  GifListBloc bloc;

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance.addObserver(this);
    _controller.addListener(onSearch);

    bloc = GifListBloc(ApiLoader());
  }

  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(UiUtils.titleLogoPath),
          actions: <Widget>[
            StreamBuilder(
              stream: bloc.countStream,
              builder: (context, snapshot) {
                int count = snapshot.hasData ? snapshot.data : bloc.ids?.length ?? 0;
                return Row(
                  children: <Widget>[
                    Text(count.toString(), style: UiUtils.textStyle),
                    IconButton(icon: Icon(Icons.star, color: Colors.white,),
                      iconSize: 35,
                      onPressed: navigateToFavouritesPage,
                    )
                  ],
                );
              }
            )
          ],
        ),
        body: BlocProvider<GifListBloc>(
          builder: (context) => bloc,
          child: Container(
              child: Column(
                children: <Widget>[
                  //search field
                  TextField(autofocus: false, controller: _controller,
                    keyboardType: TextInputType.text,
                    style: UiUtils.searchTextStyle,
                    decoration: InputDecoration(
                      hintMaxLines: 1,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(10),
                      hintText: "gif search",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: UiUtils.textSize),
                    ),
                  ),

                  //grid
                  Expanded(child: const GifGrid())
                ],
              ),
              decoration: BoxDecoration(color: UiUtils.pageBackground),
          ),
        ),
    );
  }

  void onSearch() {
    bloc.dispatch(ListEvent(query: _controller.text));
  }

  void navigateToFavouritesPage() async {

    await Navigator.push(context, MaterialPageRoute(builder: (_) => FavouritePage()));

    //magic
    bloc.updateIds();
  }
}
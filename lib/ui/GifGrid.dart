import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_flutter/bloc/GifListBloc.dart';
import 'package:giphy_flutter/bloc/ListEvent.dart';
import 'package:giphy_flutter/bloc/ListState.dart';
import 'package:giphy_flutter/model/GifObject.dart';
import 'package:giphy_flutter/ui/GifItem.dart';
import 'package:giphy_flutter/ui/LoadingWidget.dart';
import 'package:giphy_flutter/util/UiUtils.dart';

// Widget class
class GifGrid extends StatefulWidget {

  const GifGrid();

  @override
  _GifGridState createState() => _GifGridState();
}

// State class
class _GifGridState extends State<GifGrid> with TickerProviderStateMixin {

  GifListBloc bloc;

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(onScroll);

    print("${this.runtimeType.toString()} initState");
  }

  @override
  void dispose() {
    print("${this.runtimeType.toString()} dispose");
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print("${this.runtimeType.toString()} build");

    bloc = BlocProvider.of<GifListBloc>(context);
    if(bloc.currentState.isEmpty) {
      bloc.dispatch(ListEvent(query: bloc.currentState.query));
    }

    return StreamBuilder(
      stream: bloc.idsStream,
      builder: (context, snapshot)  {

        bool idsReceived = snapshot.hasData && snapshot.data != null;

        return !idsReceived ? LoadingWidget() : BlocBuilder(bloc: bloc,
            builder: (_, ListState<GifObject> state) {

              if(state.isEmpty && state.isLoading) {
                return Center(child: LoadingWidget(),);
              }

              return CustomScrollView(
                controller: _scrollController,

                slivers: <Widget>[

                  // grid items
                  SliverPadding(
                    padding: EdgeInsets.all(UiUtils.marginDefault),
                    sliver: SliverGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: UiUtils.marginDefault,
                      crossAxisSpacing: UiUtils.marginDefault,
                      children: List.generate(state.size, (pos) {
                        return GifItem(state.data[pos]);
                      }),
                    ),
                  ),

                  //loading item
                  SliverList(
                    delegate: SliverChildListDelegate(
                        <Widget>[
                          buildBottom()
                        ]),
                  )
                ],
              );
            });
      },
    );
  }

  void onScroll() {
    if(bloc.currentError == null && !bloc.isLoading && bloc.canLoad &&
        _scrollController.offset >= _scrollController.position.maxScrollExtent) {
      // load next page
      bloc.dispatch(ListEvent(page: bloc.nextPage, query: bloc.currentState.query));
    }
  }

  Widget buildBottom() {
    if(bloc.currentError != null) {
      //error widget
      return Center(
        child: Column(
          children: <Widget>[
            FlatButton(
              child: Text("Try again"),
              onPressed: () {
                if(!bloc.isLoading) {
                  bloc.dispatch(ListEvent(page: bloc.currentState.page,
                      query: bloc.currentState.query));
                }
              },
            ),
          ],
        ),
      );
    }
    if(bloc.canLoad) {
      return Center(
        heightFactor: 2,
        child: LoadingWidget(),
      );
    } else if(!bloc.hasData) {
      return Center(
        heightFactor: 2,
        child: Text('not found', style: UiUtils.textStyle,),
      );
    } else {
      return Container();
    }
  }
}

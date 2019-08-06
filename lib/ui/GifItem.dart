
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_flutter/bloc/GifListBloc.dart';
import 'package:giphy_flutter/model/GifObject.dart';
import 'package:giphy_flutter/util/UiUtils.dart';

class GifItem extends StatefulWidget {

  final GifObject item;

  GifItem(this.item);

  @override
  _GifItemState createState() => _GifItemState();
}

class _GifItemState extends State<GifItem> {

  bool addedToFavourites = false;
  GifListBloc bloc;
  StreamSubscription s;

  void onItemTap() {
    s = bloc.itemStream.listen((data) {
      setState(() {
        s.cancel();
      });
    });

    if(!bloc.isFavourite(widget.item.id)) {
      bloc.addToFavourites(widget.item);
    } else {
      bloc.removeFromFavourites(widget.item.id);
    }
  }

  @override
  Widget build(BuildContext context) {

    bloc = BlocProvider.of<GifListBloc>(context);
    addedToFavourites = bloc.isFavourite(widget.item.id);

    return GestureDetector(
      onTap: onItemTap,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: _getGifPanel(widget.item.images.fixedWidth.url),

              child: Align(
                alignment: Alignment.topRight,
                child: Icon(bloc.isFavourite(widget.item.id) ? Icons.star : Icons.star_border,
                  color: bloc.isFavourite(widget.item.id) ? Colors.yellow : Colors.white, size: 40,),
              )
            ),
          ),

          Opacity(
            opacity: 0.8,
            child: Container(
              height: 3,
              color: UiUtils.itemBorderColor,
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: Container(
              height: 6,
              margin: EdgeInsets.symmetric(horizontal: 6),
              color: UiUtils.itemBorderColor,
            ),
          ),
          Opacity(
            opacity: 0.4,
            child: Container(
              height: 6,
              margin: EdgeInsets.symmetric(horizontal: 12),
              color: UiUtils.itemBorderColor,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _getGifPanel(String url) {

    return BoxDecoration(
      image: url.isNotEmpty ? DecorationImage(
          image: CachedNetworkImageProvider(url),
          fit: BoxFit.cover
      ) : null,
    );
  }
}

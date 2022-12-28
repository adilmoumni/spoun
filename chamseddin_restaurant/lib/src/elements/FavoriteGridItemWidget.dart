import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/l10n.dart';
import 'package:food_delivery_app/src/controllers/restaurant_controller.dart';

import '../models/get_favorites_response.dart';

class FavoriteGridItemWidget extends StatelessWidget {
  final String meal_id;
  final String heroTag;
  final Favourite favorite;
  final FavoritesClickListener favoritesClickListener;
  RestaurantController _con;
  GetFavoritesResponse getFavoritesResponse;

  FavoriteGridItemWidget(
      {Key key,
      this.meal_id,
      this.heroTag,
      this.favorite,
      this.favoritesClickListener})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    onButtonClick(String meal_id) {
      favoritesClickListener.onFavoritesBtnClicked(meal_id);
      Navigator.of(context).pushNamed('/Pages', arguments: 2);
    }

    Future<bool> _onFavPressed() {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text(
                S.of(context).areYouSure + '?',
                style: TextStyle(color: Colors.deepPurpleAccent),
              ),
              content: new Text(S.of(context).doYouWantTo + '?'),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () => onButtonClick(meal_id),
                      child: Text(
                        S.of(context).yes,
                        style: TextStyle(
                            color: Colors.deepPurpleAccent, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                SizedBox(),
                //SizedBox( width: 50,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
                      child: Text(
                        S.of(context).no,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                //SizedBox(),
              ],
            ),
          ) ??
          false;
    }

    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {},
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Hero(
                  tag: heroTag + favorite.id.toString(),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(this.favorite.imageName),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                favorite.name,
                style: Theme.of(context).textTheme.bodyText1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
//              Text(
//                favorite.restaurantId.toString(),
//                style: Theme.of(context).textTheme.caption,
//                overflow: TextOverflow.ellipsis,
//              )
            ],
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: 40,
            height: 40,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                _onFavPressed();
              },
              child: Icon(
                Icons.favorite,
                color: Colors.deepPurpleAccent,
                size: 24,
              ),
              color: Colors.white.withOpacity(0.9),
              shape: StadiumBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

abstract class FavoritesClickListener {
  onFavoritesBtnClicked(String meal_id);
}

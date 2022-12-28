import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import '../pages/filters.dart';
import '../pages/pages.dart';

import 'NotificationListWidget.dart';

class FavSearchBarWidget extends StatelessWidget {
  final ValueChanged onClickFilter;
  final int notificationsCount;

  const FavSearchBarWidget(
      {Key key, this.onClickFilter, this.notificationsCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 40, left: 12, right: 12, bottom: 12),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 0),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.black26,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PagesWidget(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FiltersWidget(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12, left: 0),
                  child: IconButton(
                      icon: Image.asset("assets/img/filters.png"), color: null),
                ),
              ),
            ),
            Expanded(
              child: Text(""),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 0),
              child: Icon(Icons.search, color: Colors.black26),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 0, left: 0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationListingWidget()),
                  );
                },
                child: Padding(
                    padding: const EdgeInsets.only(right: 12, left: 0),
                    child: IconButton(
                      icon: notificationsCount != null && notificationsCount > 0
                          ? Badge(
                              badgeContent: Text(
                                notificationsCount.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              child: Icon(Icons.notifications,
                                  color: Colors.deepPurpleAccent, size: 28),
                        badgeColor: Colors.deepPurpleAccent,
                            )
                          : Icon(Icons.notifications,
                              color: Colors.deepPurpleAccent, size: 28),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

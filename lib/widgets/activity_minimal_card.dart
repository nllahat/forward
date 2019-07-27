import 'package:flutter/material.dart';
import 'package:forward/models/activity_model.dart';
import 'package:forward/widgets/activity_card_parts.dart';
import 'package:provider/provider.dart';

class ActivityMinimalCard extends StatelessWidget {
  const ActivityMinimalCard({Key key, @required this.activity})
      : assert(activity != null),
        super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    /* if (address == null || address.coordinates == null) {
      return Container();
    } */

    Card _card = Card(
        color: Colors.white70,
        child: Row(
          children: <Widget>[
            Container(
              height: 120.0,
              width: 75.0,
              color: Colors.pink,
              child: Center(
                child: Icon(Icons.av_timer, color: Colors.white,),
              ),
            )
          ],
        ));

    return Container(
        child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/activity', arguments: activity);
            },
            child: Provider<Activity>.value(
              value: activity,
              child: _card,
            )));
  }
}

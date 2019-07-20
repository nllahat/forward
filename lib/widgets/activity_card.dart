import 'package:flutter/material.dart';
import 'package:forward/models/activity_model.dart';
import 'package:forward/widgets/activity_card_parts.dart';
import 'package:provider/provider.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({Key key, @required this.activity})
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ActivityCardImage(),
            ActivityCardInfo()
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

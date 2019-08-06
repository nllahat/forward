import 'package:flutter/material.dart';
import 'package:forward/models/activity_model.dart';
import 'package:forward/widgets/activity_card_parts.dart';
import 'package:provider/provider.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({Key key, @required this.activity, this.isUserInActivity})
      : assert(activity != null),
        super(key: key);

  final Activity activity;
  final bool isUserInActivity;

  @override
  Widget build(BuildContext context) {
    /* if (address == null || address.coordinates == null) {
      return Container();
    } */

    Card _card = Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        color: Colors.white70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[ActivityCardTop(), ActivityCardInfo()],
        ));

    return Container(
        decoration: BoxDecoration(boxShadow: [
          new BoxShadow(
            offset: Offset(0, 7),
            color: Colors.grey.shade400,
            blurRadius: 30.0,
          ),
        ], borderRadius: BorderRadius.all(Radius.circular(20))),
        child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/activity', arguments: activity);
            },
            child: MultiProvider(
              providers: [
                Provider<Activity>.value(value: activity),
                Provider<bool>.value(value: isUserInActivity)
              ],
              child: _card,
            )));
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:forward/models/activity_model.dart';
import 'package:forward/models/user_activity_model.dart';
import 'package:forward/repositories/auth_repository.dart';
import 'package:forward/repositories/user_activity_repository.dart';
import 'package:forward/widgets/activity_card_parts.dart';
import 'package:provider/provider.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key key}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ActivityCardImage(),
              ActivityCardInfo(),
              Registration()
            ],
          )),
    );
  }
}

class Registration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text('Privacy issues'),
          Text('We will show the details after your confirmation'),
          RaisedButton(
            onPressed: () async {
              String userId =
                  Provider.of<AuthRepository>(context).appUser.user.id;
              String activityId = Provider.of<Activity>(context).id;

              UserActivity userActivity =
                  UserActivity(userId: userId, activityId: activityId);

              await UserActivityRepository.addUserActivity(userActivity);

              this._showDialog(context);
            },
            child: Text('Register', style: TextStyle(fontSize: 20)),
          )
        ],
      ),
    );
  }

  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Alert Dialog title"),
          content: Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

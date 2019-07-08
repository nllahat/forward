import 'package:flutter/material.dart';
import 'package:forward/models/activity_model.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    List<Activity> activities = Provider.of<List<Activity>>(context);
    if (activities == null || activities.length == 0) {
      return Container();
    }
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        shrinkWrap: true,
        itemCount: activities?.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Text(activities[index].name);
        });
  }
}

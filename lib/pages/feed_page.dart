import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forward/models/activity_model.dart';
import 'package:forward/models/organisation_model.dart';
import 'package:forward/models/user_activity_model.dart';
import 'package:forward/repositories/auth_repository.dart';
import 'package:forward/repositories/organisation_repository.dart';
import 'package:forward/repositories/user_activity_repository.dart';
import 'package:forward/utils/location_util.dart';
import 'package:forward/widgets/activity_card.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    List<Activity> activities = Provider.of<List<Activity>>(context);
    String userId = Provider.of<AuthRepository>(context).appUser.user.id;

    if (activities == null || activities.length == 0) {
      return Container();
    }

    return Scrollbar(
        child: StreamProvider<Map<String, UserActivity>>.value(
            value: UserActivityRepository.streamUserUserActivitesMap(userId),
            child: Consumer<Map<String, UserActivity>>(
              builder: (context, userActivities, child) => ListView(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                children: activities.map<Widget>((Activity activity) {
                  bool isUserInActivity = userActivities.containsKey(activity.id);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: StreamProvider<Organisation>.value(
                      value: OrganisationRepository.streamOrganisation(
                          activity.organisation),
                      child: Consumer<Organisation>(
                        builder: (context, value, child) {
                          if (value == null) {
                            return Container();
                          }

                          return Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(value?.name,
                                      style: TextStyle(fontSize: 20.0)),
                                  isUserInActivity ? Text("I'm registered!!!!!!!") : Container()
                                ],
                              ),
                              FutureProvider<Address>.value(
                                value: LocationUtil.getAddressByGeoPoint(
                                    activity.location),
                                catchError: (context, object) {
                                  return Address();
                                },
                                child: ActivityCard(activity: activity),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            )));
  }
}

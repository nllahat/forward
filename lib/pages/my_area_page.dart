import 'package:flutter/material.dart';
import 'package:forward/models/activity_model.dart';
import 'package:forward/models/organisation_model.dart';
import 'package:forward/models/user_activity_model.dart';
import 'package:forward/repositories/auth_repository.dart';
import 'package:forward/repositories/organisation_repository.dart';
import 'package:forward/repositories/user_activity_repository.dart';
import 'package:forward/utils/location_util.dart';
import 'package:forward/widgets/activity_card.dart';
import 'package:forward/widgets/activity_minimal_card.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:provider/provider.dart';

class MyAreaPage extends StatefulWidget {
  @override
  _MyAreaPageState createState() => _MyAreaPageState();
}

class _MyAreaPageState extends State<MyAreaPage> {
  @override
  Widget build(BuildContext context) {
    List<Activity> activities = Provider.of<List<Activity>>(context);
    String userId = Provider.of<AuthRepository>(context).appUser.user.id;

    if (activities == null || activities.length == 0) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text('My Area'),
      ),
      body: Scrollbar(
          child: StreamProvider<Map<String, UserActivity>>.value(
              value: UserActivityRepository.streamUserActivitesMap(userId),
              child: Consumer<Map<String, UserActivity>>(
                builder: (context, userActivities, child) => ListView(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  children: activities.map<Widget>((Activity activity) {
                    bool isUserInActivity = userActivities != null
                        ? userActivities.containsKey(activity.id)
                        : false;
                    return !isUserInActivity ? Container() : Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: StreamProvider<Organisation>.value(
                        value: OrganisationRepository.streamOrganisation(
                            activity.organisation),
                        child: Consumer<Organisation>(
                          builder: (context, value, child) {
                            if (value == null) {
                              return Container();
                            }

                            return FutureProvider<Address>.value(
                                  value: LocationUtil.getAddressByGeoPoint(
                                      activity.location),
                                  catchError: (context, object) {
                                    return Address();
                                  },
                                  child: ActivityMinimalCard(activity: activity),
                                );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ))),
    );
  }
}

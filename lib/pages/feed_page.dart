import 'package:flutter/material.dart';
import 'package:forward/core/models/activity_model.dart';
import 'package:forward/core/models/organisation_model.dart';
import 'package:forward/core/models/user_activity_model.dart';
import 'package:forward/repositories/auth_repository.dart';
import 'package:forward/repositories/organisation_repository.dart';
import 'package:forward/repositories/user_activity_repository.dart';
import 'package:forward/utils/location_util.dart';
import 'package:forward/widgets/activity_card.dart';
import 'package:forward/widgets/radio_buttons.dart';
import 'package:forward/widgets/week_days_checkboxes.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  void _settingModalBottomSheet(context) {
    String dropdownValue = 'One';
    List<GroupModel> buttons = [
      GroupModel(text: "Day", index: 0, value: 0),
      GroupModel(text: "Night", index: 1, value: 1)
    ];

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Wrap(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Type",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      DropdownButton<String>(
                        value: dropdownValue,
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>['One', 'Two', 'Free', 'Four']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "City",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      DropdownButton<String>(
                        value: dropdownValue,
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>['One', 'Two', 'Free', 'Four']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: RadioButtons(
                      buttons: buttons,
                      onChangeButton: (int selectedIndex) {},
                    ),
                  ),
                  WeekDaysCheckboxes()
                  /*TextField(
                      decoration: InputDecoration(
                          labelText: "Activity type", hintText: "all")) */
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Activity> activities = Provider.of<List<Activity>>(context);
    String userId = Provider.of<AuthRepository>(context).appUser.user.id;
    Map<String, UserActivity> userActivities =
        Provider.of<Map<String, UserActivity>>(context);

    if (userActivities == null ||
        activities == null ||
        activities.length == 0) {
      return Container();
    }

    return Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _settingModalBottomSheet(context);
        },
        child: new Icon(Icons.tune),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text(
          "${activities.length} Activities",
        ),
      ),
      body: StreamProvider<Map<String, UserActivity>>.value(
          value: UserActivityRepository.streamUserActivitesMap(userId),
          child: Consumer<Map<String, UserActivity>>(
              builder: (context, userActivities, child) => ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.transparent,
                        height: 10.0,
                      ),
                  itemCount: activities.length,
                  itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: StreamProvider<Organisation>.value(
                            value: OrganisationRepository.streamOrganisation(
                                activities[index].organisation),
                            child: Consumer<Organisation>(
                              builder: (context, organisation, child) {
                                if (organisation == null) {
                                  return Container();
                                }

                                List<String> parts =
                                    organisation.name.split(' ');
                                List<String> initials = parts.map((part) {
                                  if (part.isNotEmpty) {
                                    return part[0];
                                  }

                                  return "";
                                }).toList();

                                return Column(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 10.0),
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.grey.shade800,
                                              child: Text(initials
                                                  .join('')
                                                  .toUpperCase()),
                                            ),
                                          ),
                                          Text(organisation?.name,
                                              style: TextStyle(fontSize: 20.0)),
                                        ],
                                      ),
                                    ),
                                    FutureProvider<Address>.value(
                                      value: LocationUtil.getAddressByGeoPoint(
                                          activities[index].location),
                                      catchError: (context, object) {
                                        return Address();
                                      },
                                      child: ActivityCard(
                                          activity: activities[index],
                                          isUserInActivity:
                                              userActivities.containsKey(
                                                  activities[index].id)),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      )))),
    );
  }
}

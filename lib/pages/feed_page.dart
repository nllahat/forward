import 'package:flutter/material.dart';
import 'package:forward/models/activity_model.dart';
import 'package:forward/models/organisation_model.dart';
import 'package:forward/models/user_activity_model.dart';
import 'package:forward/repositories/auth_repository.dart';
import 'package:forward/repositories/organisation_repository.dart';
import 'package:forward/repositories/user_activity_repository.dart';
import 'package:forward/utils/location_util.dart';
import 'package:forward/widgets/activity_card.dart';
import 'package:forward/widgets/popup_layout.dart';
import 'package:forward/widgets/popup_content.dart';
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
    Map<String, UserActivity> userActivities =
        Provider.of<Map<String, UserActivity>>(context);

    if (userActivities == null ||
        activities == null ||
        activities.length == 0) {
      return Container();
    }

    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  backgroundColor: Colors.grey.shade400,
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  title: Text("${activities.length} Activities"),
                  actions: <Widget>[
                    Container(
                      child: IconButton(
                        iconSize: 35.0,
                        icon: Icon(Icons.filter_list),
                        onPressed: () {
                          /* Navigator.push(
                            context,
                            PopupLayout(child: PopupContent(
                                content: Scaffold(
                                  appBar: AppBar(
                                    backgroundColor: Colors.grey.shade400,
                                    title: Text('Filters'),
                                    leading: new Builder(builder: (context) {
                                      return IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          try {
                                            Navigator.pop(
                                                context); //close the popup
                                          } catch (e) {}
                                        },
                                      );
                                    }),
                                    brightness: Brightness.light,
                                  ),
                                  resizeToAvoidBottomPadding: false,
                                  body: Container()
                                ),
                              ),),
                          ); */
                        },
                      ),
                    )
                  ]),
                  /* flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text('dsfsdfsfsdfsdfsd')
                  )) */
            ];
          },
          body: StreamProvider<Map<String, UserActivity>>.value(
              value: UserActivityRepository.streamUserActivitesMap(userId),
              child: Consumer<Map<String, UserActivity>>(
                  builder: (context, userActivities, child) =>
                      ListView.separated(
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
                                    value: OrganisationRepository
                                        .streamOrganisation(
                                            activities[index].organisation),
                                    child: Consumer<Organisation>(
                                      builder: (context, organisation, child) {
                                        if (organisation == null) {
                                          return Container();
                                        }

                                        List<String> parts =
                                            organisation.name.split(' ');
                                        List<String> initials =
                                            parts.map((part) {
                                          if (part.isNotEmpty) {
                                            return part[0];
                                          }

                                          return "";
                                        }).toList();

                                        return Column(
                                          children: <Widget>[
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
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
                                                      style: TextStyle(
                                                          fontSize: 20.0)),
                                                ],
                                              ),
                                            ),
                                            FutureProvider<Address>.value(
                                              value: LocationUtil
                                                  .getAddressByGeoPoint(
                                                      activities[index]
                                                          .location),
                                              catchError: (context, object) {
                                                return Address();
                                              },
                                              child: ActivityCard(
                                                  activity: activities[index],
                                                  isUserInActivity:
                                                      userActivities
                                                          .containsKey(
                                                              activities[index]
                                                                  .id)),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ))))),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:forward/core/models/activity_model.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:forward/utils/colors_util.dart';

class ActivityCardImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Activity activity = Provider.of<Activity>(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        image: DecorationImage(
            image: NetworkImage(activity.image), fit: BoxFit.cover),
      ),
      height: 260.0,
    );
  }
}

class ActivityCardTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isUserInActivity = Provider.of<bool>(context);

    return Stack(
      children: <Widget>[
        ActivityCardImage(),
        Positioned(bottom: 10, child: ActivityCardText()),
        isUserInActivity == null || isUserInActivity == false
            ? Container()
            : Positioned(
                top: 0,
                right: 20,
                child: Transform.rotate(
                  angle: pi / 2,
                  child: Chip(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    label: Transform.rotate(
                        angle: pi * 2 + 300, child: Icon(Icons.check)),
                    backgroundColor: Colors.pink,
                  ),
                )),
      ],
    );
  }
}

class ActivityCardText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Activity activity = Provider.of<Activity>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            activity.name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: Colors.black),
          ),
          /* FutureProvider<Color>.value(
              value: ColorsUtil().getTextColor(activity.image),
              catchError: (context, object) {
                return Colors.white;
              },
              child: Consumer<Color>(
                  builder: (context, textColor, child) => Text(
                        'More details',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                            color: textColor ),
                      ))) */
        ],
      ),
    );
  }
}

class ActivityCardInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25.0, bottom: 25.0, right: 5.0, left: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ActivityCardDetailsDay(false),
          VerticalDivider(
            color: Colors.pink,
            width: 1.0,
          ),
          ActivityCardDetailsTime(),
          VerticalDivider(
            color: Colors.pink,
            width: 1.0,
          ),
          ActivityCardDetailsLocation(),
        ],
      ),
    );
  }
}

class ActivityCardInfoSmall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ActivityCardDetailsDay(true),
          VerticalDivider(
            color: Colors.pink,
            width: 1.0,
          ),
          ActivityCardDetailsTime(),
          VerticalDivider(
            color: Colors.pink,
            width: 1.0,
          ),
          ActivityCardDetailsLocation(),
        ],
      ),
    );
  }
}

class ActivityCardDetailsDay extends StatelessWidget {
  final bool isSmall;
  ActivityCardDetailsDay(this.isSmall);

  @override
  Widget build(BuildContext context) {
    Activity activity = Provider.of<Activity>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            margin: const EdgeInsets.only(right: 5.0), child: Icon(Icons.info)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              DateFormat('EEEE').format(activity.startDate),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: this.isSmall ? 10.0 : 16.0),
            ),
            Text(
              DateFormat('LLLL d').format(activity.startDate),
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ],
    );
  }
}


class ActivityCardDetailsTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Activity activity = Provider.of<Activity>(context);

    return Row(
      children: <Widget>[
        Container(
            margin: const EdgeInsets.only(right: 5.0),
            child: Icon(Icons.access_time)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '${DateFormat('Hm').format(activity.startDate)} - ${DateFormat('Hm').format(activity.endDate)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "bla bla lba",
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ],
    );
  }
}

class ActivityCardDetailsLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Address address = Provider.of<Address>(context);

    return Row(
      children: <Widget>[
        Container(
            margin: const EdgeInsets.only(right: 5.0),
            child: Icon(Icons.location_on)),
        Column(
          children: <Widget>[
            Text(
              address == null || address.thoroughfare == null
                  ? 'Unknow'
                  : address.thoroughfare,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              address == null || address.adminArea == null
                  ? 'Unknow'
                  : address.adminArea,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ],
    );
  }
}

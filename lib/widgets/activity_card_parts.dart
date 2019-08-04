import 'dart:math';

import 'package:flutter/material.dart';
import 'package:forward/models/activity_model.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActivityCardImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Activity activity = Provider.of<Activity>(context);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(activity.image), fit: BoxFit.cover),
      ),
      height: 180.0,
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
        isUserInActivity == null || isUserInActivity == false ? Container() : Positioned(
            top: 0,
            right: 0,
            child: Transform.rotate(
              angle: pi / 2,
              child: Chip(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20))),
                label: Transform.rotate(
                    angle: pi * 2 + 300,
                    child: Icon(Icons.check)
                    ),
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
                fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.black),
          ),
          Text(
            'More details',
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.normal,
                fontSize: 16.0,
                color: Colors.black),
          )
        ],
      ),
    );
  }
}

class ActivityCardInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ActivityCardDetailsDay(),
          ActivityCardDetailsTime(),
          ActivityCardDetailsLocation(),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
    );
  }
}

class ActivityCardInfoSmall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ActivityCardDetailsDay(),
          ActivityCardDetailsTime(),
          ActivityCardDetailsLocation(),
        ],
      ),
    );
  }
}

class ActivityCardDetailsDay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Activity activity = Provider.of<Activity>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(Icons.info),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              DateFormat('EEEE').format(activity.startDate),
              style: TextStyle(fontWeight: FontWeight.bold),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Icon(Icons.access_time),
        ),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Icon(Icons.location_on),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              address == null || address.thoroughfare == null
                  ? 'Unknow'
                  : address.thoroughfare,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
            ),
            Text(
              address == null || address.adminArea == null
                  ? 'Unknow'
                  : address.adminArea,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10.0),
            ),
          ],
        ),
      ],
    );
  }
}

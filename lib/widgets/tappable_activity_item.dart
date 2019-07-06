import 'package:flutter/material.dart';
import 'package:forward/models/activity_model.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 12.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: Theme.of(context).textTheme.subhead),
      ),
    );
  }
}

class ActivityContent extends StatelessWidget {
  const ActivityContent({ Key key, @required this.activity })
    : assert(activity != null),
      super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle = theme.textTheme.headline.copyWith(color: Colors.white);
    final TextStyle descriptionStyle = theme.textTheme.subhead;

    final List<Widget> children = <Widget>[
      // Photo and title.
      SizedBox(
        height: 184.0,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              // In order to have the ink splash appear above the image, you
              // must use Ink.image. This allows the image to be painted as part
              // of the Material and display ink effects above it. Using a
              // standard Image will obscure the ink splash.
              child: Ink.image(
                // image: AssetImage(activity.assetName, package: activity.assetPackage),
                image: NetworkImage(activity.image),
                fit: BoxFit.cover,
                child: Container(),
              ),
            ),
            Positioned(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  activity.name,
                  style: titleStyle,
                ),
              ),
            ),
          ],
        ),
      ),
      // Description and share/explore buttons.
      Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: DefaultTextStyle(
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: descriptionStyle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // three line description
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  activity.generalDescription,
                  style: descriptionStyle.copyWith(color: Colors.black54),
                ),
              ),
              // Text(activity.city),
              Text(activity.location.toString()),
            ],
          ),
        ),
      ),
    ];

    children.add(
        // share, explore buttons
        ButtonTheme.bar(
          child: ButtonBar(
            alignment: MainAxisAlignment.start,
            children: <Widget>[
              FlatButton(
                child: Text('SHARE', semanticsLabel: 'Share ${activity.name}'),
                textColor: Colors.amber.shade500,
                onPressed: () { print('pressed'); },
              ),
              FlatButton(
                child: Text('EXPLORE', semanticsLabel: 'Explore ${activity.name}'),
                textColor: Colors.amber.shade500,
                onPressed: () { print('pressed'); },
              ),
            ],
          ),
        ),
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class TappableActivityItem extends StatelessWidget {
  const TappableActivityItem(
      {Key key, @required this.activity, this.shape})
      : assert(activity != null),
        super(key: key);

  // This height will allow for all the Card's content to fit comfortably within the card.
  static const double height = 298.0;
  final Activity activity;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const SectionTitle(title: 'Tappable'),
            SizedBox(
              height: height,
              child: Card(
                // This ensures that the Card's children (including the ink splash) are clipped correctly.
                clipBehavior: Clip.antiAlias,
                shape: shape,
                child: InkWell(
                  onTap: () {
                    print('Card was tapped');
                  },
                  // Generally, material cards use onSurface with 12% opacity for the pressed state.
                  splashColor:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                  // Generally, material cards do not have a highlight overlay.
                  highlightColor: Colors.transparent,
                  child: ActivityContent(activity: activity),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:my_social_app/widgets/indicators.dart';

typedef ItemBuilder =
    Widget Function(BuildContext context, Map<String, dynamic> data);

class StreamGridWrapper extends StatelessWidget {
  final Stream<List<Map<String, dynamic>>>? stream;
  final ItemBuilder itemBuilder;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final ScrollPhysics physics;
  final EdgeInsets padding;

  const StreamGridWrapper({
    super.key,
    required this.stream,
    required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.physics = const ClampingScrollPhysics(),
    this.padding = const EdgeInsets.only(bottom: 2.0, left: 2.0),
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var list = snapshot.data!;
          return list.isEmpty
              ? Container(child: Center(child: Text('No Posts')))
              : GridView.builder(
                padding: padding,
                scrollDirection: scrollDirection,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3 / 3,
                ),
                itemCount: list.length,
                shrinkWrap: shrinkWrap,
                physics: physics,
                itemBuilder: (BuildContext context, int index) {
                  return itemBuilder(context, list[index]);
                },
              );
        } else {
          return circularProgress(context);
        }
      },
    );
  }
}

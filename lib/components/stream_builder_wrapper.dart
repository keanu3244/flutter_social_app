import 'package:flutter/material.dart';
import 'package:my_social_app/widgets/indicators.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext context, T item);

class StreamBuilderWrapper<T> extends StatelessWidget {
  final Stream<List<T>>? stream;
  final ItemBuilder<T> itemBuilder;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final ScrollPhysics physics;
  final EdgeInsets padding;

  const StreamBuilderWrapper({
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
    return StreamBuilder<List<T>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var list = snapshot.data!;
          return list.isEmpty
              ? Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: SizedBox(
                  height: 60.0,
                  width: 100.0,
                  child: Center(child: Text('No Items')),
                ),
              )
              : ListView.builder(
                padding: padding,
                scrollDirection: scrollDirection,
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

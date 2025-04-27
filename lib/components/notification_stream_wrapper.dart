import 'package:flutter/material.dart';
import 'package:my_social_app/widgets/indicators.dart';

typedef ItemBuilder<T> =
    Widget Function(BuildContext context, Map<String, dynamic> data);

class ActivityStreamWrapper extends StatelessWidget {
  final Stream<List<Map<String, dynamic>>> stream;
  final ItemBuilder<Map<String, dynamic>> itemBuilder;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final ScrollPhysics physics;
  final EdgeInsets padding;

  const ActivityStreamWrapper({
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
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          var list = snapshot.data!;
          return list.isEmpty
              ? const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 250.0),
                  child: Text('暂无近期活动'),
                ),
              )
              : ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 0.5,
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: const Divider(),
                    ),
                  );
                },
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

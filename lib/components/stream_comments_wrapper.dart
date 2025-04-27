import 'package:flutter/material.dart';

class CommentsStreamWrapper extends StatelessWidget {
  final bool shrinkWrap;
  final EdgeInsets padding;
  final Stream<List<Map<String, dynamic>>> stream;
  final Widget Function(BuildContext, Map<String, dynamic>) itemBuilder;
  final ScrollPhysics physics;

  const CommentsStreamWrapper({
    super.key,
    this.shrinkWrap = false,
    this.padding = EdgeInsets.zero,
    required this.stream,
    required this.itemBuilder,
    this.physics = const AlwaysScrollableScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          shrinkWrap: shrinkWrap,
          padding: padding,
          physics: physics,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) =>
              itemBuilder(context, snapshot.data![index]),
        );
      },
    );
  }
}

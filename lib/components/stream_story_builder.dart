import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_social_app/widgets/indicators.dart';

typedef ItemBuilder<T> =
    Widget Function(BuildContext context, Map<String, dynamic> story);

class StreamStoriesWrapper extends StatelessWidget {
  final ItemBuilder<Map<String, dynamic>> itemBuilder;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final bool? reverse;
  final ScrollPhysics physics;
  final EdgeInsets padding;

  const StreamStoriesWrapper({
    super.key,
    required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.reverse,
    this.physics = const ClampingScrollPhysics(),
    this.padding = const EdgeInsets.only(bottom: 2.0, left: 2.0),
  });

  // 硬编码的故事数据
  static final List<Map<String, dynamic>> mockStories = [
    {
      'id': 'story1',
      'userId': 'user1',
      'content': 'assets/images/story1.jpg',
      'timestamp': '2025-04-25T10:00:00Z',
    },
    {
      'id': 'story2',
      'userId': 'user2',
      'content': 'assets/images/story2.jpg',
      'timestamp': '2025-04-25T09:00:00Z',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final controller = StreamController<List<Map<String, dynamic>>>.broadcast();
    controller.add(mockStories); // 初始化数据

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: controller.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var list = snapshot.data!;
          return list.isEmpty
              ? SizedBox()
              : ListView.builder(
                padding: padding,
                scrollDirection: scrollDirection,
                itemCount: list.length + 1,
                shrinkWrap: shrinkWrap,
                reverse: reverse ?? false,
                physics: physics,
                itemBuilder: (BuildContext context, int index) {
                  if (index == list.length) {
                    return buildUploadButton();
                  }
                  return itemBuilder(context, list[index]);
                },
              );
        } else {
          return circularProgress(context);
        }
      },
    );
  }

  Widget buildUploadButton() {
    return Padding(
      padding: EdgeInsets.all(7.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              offset: Offset(0.0, 0.0),
              blurRadius: 2.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(0.5),
          child: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.grey[300],
            child: Center(child: Icon(Icons.add, color: Colors.blue)),
          ),
        ),
      ),
    );
  }
}

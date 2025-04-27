import 'package:flutter/material.dart';

class IconBadge extends StatefulWidget {
  final IconData icon;
  final double? size;
  final Color? color;

  const IconBadge({super.key, required this.icon, this.size, this.color});

  @override
  _IconBadgeState createState() => _IconBadgeState();
}

class _IconBadgeState extends State<IconBadge> {
  // 模拟通知数据
  final List<Map<String, dynamic>> mockNotifications = [
    {
      'id': 'notif1',
      'userId': 'user1',
      'postId': 'post1',
      'type': 'like',
      'username': 'demo2',
      'userDp': 'https://img.qianshengclub.com/MTc0MDQ1MDA2OTkxNiMyMjYjcG5n.png',
      'mediaUrl': 'https://fake-post1.jpg',
      'timestamp': DateTime.now().subtract(Duration(hours: 1)),
    },
    {
      'id': 'notif2',
      'userId': 'user1',
      'postId': 'post1',
      'type': 'comment',
      'username': 'demo3',
      'userDp': 'https://img.qianshengclub.com/MTc0MDQ1MDA2OTkxNiMyMjYjcG5n.png',
      'mediaUrl': 'https://fake-post1.jpg',
      'timestamp': DateTime.now().subtract(Duration(minutes: 30)),
    },
  ];

  // 当前用户 ID
  String currentUserId() => 'user1';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Icon(
          widget.icon,
          size: widget.size,
          color: widget.color,
        ),
        Positioned(
          right: 0.0,
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(
              minWidth: 11,
              minHeight: 11,
            ),
            child:
                Padding(padding: EdgeInsets.only(top: 1), child: buildCount()),
          ),
        ),
      ],
    );
  }

  Widget buildCount() {
    // 过滤当前用户的通知
    int notificationCount = mockNotifications
        .where((notif) => notif['userId'] == currentUserId())
        .length;

    return buildTextWidget(notificationCount.toString());
  }

  Widget buildTextWidget(String counter) {
    return Text(
      counter,
      style: TextStyle(
        color: Colors.white,
        fontSize: 9,
      ),
      textAlign: TextAlign.center,
    );
  }
}

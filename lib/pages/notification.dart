import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_social_app/components/notification_stream_wrapper.dart';
import 'package:my_social_app/models/notification.dart';
import 'package:my_social_app/services/notification_service.dart';
import 'package:my_social_app/services/user_service.dart';
import 'package:my_social_app/widgets/notification_items.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  String currentUserId() {
    return Provider.of<UserService>(context, listen: false).currentUid();
  }

  @override
  Widget build(BuildContext context) {
    final notificationService = Provider.of<NotificationService>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('通知'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap:
                  () => notificationService.deleteAllNotifications(
                    currentUserId(),
                  ),
              child: Text(
                '清空',
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(children: [getActivities()]),
    );
  }

  Widget getActivities() {
    return ActivityStreamWrapper(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      stream: Provider.of<NotificationService>(
        context,
      ).getNotificationsStream(currentUserId()),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, Map<String, dynamic> notificationData) {
        ActivityModel activities = ActivityModel.fromJson(notificationData);
        return ActivityItems(activity: activities);
      },
    );
  }
}

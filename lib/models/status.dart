import 'package:my_social_app/models/enum/message_type.dart';

class StatusModel {
  final String? url;
  final String? caption;
  final MessageType? type;
  final DateTime? time;
  final String? statusId;
  final List<dynamic>? viewers;

  StatusModel({
    this.url,
    this.caption,
    this.type,
    this.time,
    this.statusId,
    this.viewers,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      url: json['url'] as String?,
      caption: json['caption'] as String?,
      type: json['type'] == 'IMAGE' ? MessageType.IMAGE : null,
      time:
          json['time'] is DateTime
              ? json['time']
              : json['time'] != null
              ? DateTime.fromMillisecondsSinceEpoch(json['time'] as int)
              : null,
      statusId: json['statusId'] as String?,
      viewers: json['viewers'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'caption': caption,
      'type': type.toString().split('.').last,
      'time': time?.millisecondsSinceEpoch,
      'statusId': statusId,
      'viewers': viewers,
    };
  }
}

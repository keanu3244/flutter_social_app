import 'package:my_social_app/models/enum/message_type.dart';

class Message {
  final String? content;
  final String? senderUid;
  final MessageType? type;
  final DateTime? time;

  Message({this.content, this.senderUid, this.type, this.time});

  factory Message.fromJson(Map<dynamic, dynamic> json) {
    return Message(
      content: json['content'] as String?,
      senderUid: json['senderUid'] as String?,
      type: json['type'] == 'text' ? MessageType.TEXT : MessageType.IMAGE,
      time:
          json['time'] is DateTime
              ? json['time']
              : DateTime.fromMillisecondsSinceEpoch(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'senderUid': senderUid,
      'type': type == MessageType.TEXT ? 'text' : 'image',
      'time': time?.millisecondsSinceEpoch,
    };
  }
}

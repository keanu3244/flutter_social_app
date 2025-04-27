class CommentModel {
  String? username;
  String? comment;
  DateTime? timestamp;
  String? userDp;
  String? userId;
  String? postId;

  CommentModel({
    this.username,
    this.comment,
    this.timestamp,
    this.userDp,
    this.userId,
    this.postId,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    username = json['username'] as String?;
    comment = json['comment'] as String?;
    timestamp = json['timestamp'] is DateTime
        ? json['timestamp']
        : json['timestamp'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int)
            : null;
    userDp = json['userDp'] as String?;
    userId = json['userId'] as String?;
    postId = json['postId'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['username'] = username;
    data['comment'] = comment;
    data['timestamp'] = timestamp?.millisecondsSinceEpoch;
    data['userDp'] = userDp;
    data['userId'] = userId;
    data['postId'] = postId;
    return data;
  }
}

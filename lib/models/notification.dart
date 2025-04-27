class ActivityModel {
  String? type;
  String? username;
  String? userId;
  String? userDp;
  String? postId;
  String? mediaUrl;
  String? commentData;
  DateTime? timestamp;
  ActivityModel(this.type, this.username, this.userId, this.userDp, this.postId,
      this.commentData, this.mediaUrl, this.timestamp);

  ActivityModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    username = json['username'];
    userId = json['userId'];
    userDp = json['userDp'];
    postId = json['postId'];
    mediaUrl = json['mediaUrl'];
    commentData = json['commentData'];
    timestamp = json['timestamp'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['username'] = username;
    data['userId'] = userId;
    data['userDp'] = userDp;
    data['postId'] = postId;
    data['mediaUrl'] = mediaUrl;
    data['commentData'] = commentData;
    data['timestamp'] = timestamp;
    return data;
  }
}

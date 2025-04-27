import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:like_button/like_button.dart';
import 'package:my_social_app/components/stream_comments_wrapper.dart';
import 'package:my_social_app/models/comments.dart';
import 'package:my_social_app/models/post.dart';
import 'package:my_social_app/models/user.dart';
import 'package:my_social_app/widgets/cached_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class Comments extends StatefulWidget {
  final PostModel? post;

  const Comments({super.key, this.post});

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final DateTime timestamp = DateTime.now();
  TextEditingController commentsTEC = TextEditingController();

  // 模拟数据
  List<Map<String, dynamic>> mockLikes = [
    {
      'id': 'like1',
      'userId': 'user1',
      'postId': 'post1',
      'dateCreated': DateTime.now().subtract(Duration(days: 1)),
    },
    {
      'id': 'like2',
      'userId': 'user2',
      'postId': 'post1',
      'dateCreated': DateTime.now().subtract(Duration(hours: 2)),
    },
  ];

  List<Map<String, dynamic>> mockComments = [
    {
      'postId': 'post1',
      'userId': 'user2',
      'username': 'demo2',
      'userDp': 'https://img.qianshengclub.com/MTc0MDQ1MDA2OTkxNiMyMjYjcG5n.png',
      'comment': 'Great post!',
      'timestamp': DateTime.now().subtract(Duration(hours: 1)),
    },
    {
      'postId': 'post1',
      'userId': 'user3',
      'username': 'demo3',
      'userDp': 'https://img.qianshengclub.com/MTc0MDQ1MDA2OTkxNiMyMjYjcG5n.png',
      'comment': 'Love this!',
      'timestamp': DateTime.now().subtract(Duration(minutes: 30)),
    },
  ];

  List<Map<String, dynamic>> mockUsers = [
    {
      'id': 'user1',
      'username': 'demo1',
      'email': 'user1@example.com',
      'photoUrl': 'https://img.qianshengclub.com/MTc0MjE4MzAwMzUyNyM3MDcjcG5n.png',
      'bio': '热爱生活',
      'country': '中国',
    },
    {
      'id': 'user2',
      'username': 'demo2',
      'email': 'user2@example.com',
      'photoUrl': 'https://img.qianshengclub.com/MTc0MDQ1MDA2OTkxNiMyMjYjcG5n.png',
      'bio': '探索世界',
      'country': '加拿大',
    },
    {
      'id': 'user3',
      'username': 'demo3',
      'email': 'user3@example.com',
      'photoUrl': 'https://img.qianshengclub.com/MTc0MDQ1MDA2OTkxNiMyMjYjcG5n.png',
      'bio': '追逐梦想',
      'country': '美国',
    },
  ];

  String currentUserId() {
    return 'user1';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(CupertinoIcons.xmark_circle_fill),
        ),
        centerTitle: true,
        title: Text('Comments'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Flexible(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: buildFullPost(),
                  ),
                  Divider(thickness: 1.5),
                  Flexible(child: buildComments()),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  constraints: BoxConstraints(maxHeight: 190.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: commentsTEC,
                            style: TextStyle(
                              fontSize: 15.0,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintText: "Write your comment...",
                              hintStyle: TextStyle(
                                fontSize: 15.0,
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodyLarge!.color,
                              ),
                            ),
                            maxLines: null,
                          ),
                          trailing: GestureDetector(
                            onTap: () async {
                              // await services.uploadComment(
                              //   currentUserId(),
                              //   commentsTEC.text,
                              //   widget.post!.postId!,
                              //   widget.post!.ownerId!,
                              //   widget.post!.mediaUrl!,
                              // );
                              commentsTEC.clear();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Icon(
                                Icons.send,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildFullPost() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 350.0,
          width: MediaQuery.of(context).size.width - 20.0,
          child: cachedNetworkImage(widget.post!.mediaUrl!),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post!.description!,
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text('2025-4-25', style: TextStyle()),
                      SizedBox(width: 3.0),
                      buildLikesCount(
                        context,
                        mockLikes
                            .where(
                              (like) => like['postId'] == widget.post!.postId,
                            )
                            .length,
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              buildLikeButton(),
            ],
          ),
        ),
      ],
    );
  }

  buildComments() {
    return CommentsStreamWrapper(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      stream: Stream.value(
        mockComments
            .where((comment) => comment['postId'] == widget.post!.postId)
            .toList(),
      ),
      itemBuilder: (_, Map<String, dynamic> data) {
        CommentModel comments = CommentModel.fromJson(data);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: CachedNetworkImageProvider(
                      comments.userDp!,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comments.username!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        timeago.format(comments.timestamp!),
                        style: TextStyle(fontSize: 10.0),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Text(comments.comment!.trim()),
              ),
              SizedBox(height: 10.0),
            ],
          ),
        );
      },
    );
  }

  buildLikeButton() {
    bool isLiked = mockLikes.any(
      (like) =>
          like['postId'] == widget.post!.postId &&
          like['userId'] == currentUserId(),
    );

    Future<bool> onLikeButtonTapped(bool isCurrentlyLiked) async {
      // if (!isCurrentlyLiked) {
      //   likesRef.add({
      //     'userId': currentUserId(),
      //     'postId': widget.post!.postId,
      //     'dateCreated': Timestamp.now(),
      //   });
      //   addLikesToNotification();
      // } else {
      //   likesRef.doc(docs[0].id).delete();
      //   removeLikeFromNotification();
      // }
      return isCurrentlyLiked;
    }

    return LikeButton(
      onTap: onLikeButtonTapped,
      size: 25.0,
      circleColor: CircleColor(
        start: Color(0xffFFC0CB),
        end: Color(0xffff0000),
      ),
      bubblesColor: BubblesColor(
        dotPrimaryColor: Color(0xffFFA500),
        dotSecondaryColor: Color(0xffd8392b),
        dotThirdColor: Color(0xffFF69B4),
        dotLastColor: Color(0xffff8c00),
      ),
      likeBuilder: (bool isLiked) {
        return Icon(
          isLiked ? Ionicons.heart : Ionicons.heart_outline,
          color: isLiked ? Colors.red : Colors.grey,
          size: 25,
        );
      },
    );
  }

  buildLikesCount(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0),
      child: Text(
        '$count likes',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
      ),
    );
  }

  addLikesToNotification() async {
    // bool isNotMe = currentUserId() != widget.post!.ownerId;
    // if (isNotMe) {
    //   DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
    //   user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
    //   notificationRef
    //       .doc(widget.post!.ownerId)
    //       .collection('notifications')
    //       .doc(widget.post!.postId)
    //       .set({
    //     "type": "like",
    //     "username": user!.username!,
    //     "userId": currentUserId(),
    //     "userDp": user!.photoUrl!,
    //     "postId": widget.post!.postId,
    //     "mediaUrl": widget.post!.mediaUrl,
    //     "timestamp": timestamp,
    //   });
    // }
  }

  removeLikeFromNotification() async {
    // bool isNotMe = currentUserId() != widget.post!.ownerId;
    // if (isNotMe) {
    //   DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
    //   user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
    //   notificationRef
    //       .doc(widget.post!.ownerId)
    //       .collection('notifications')
    //       .doc(widget.post!.postId)
    //       .get()
    //       .then((doc) => {
    //             if (doc.exists) {doc.reference.delete()}
    //           });
    // }
  }
}

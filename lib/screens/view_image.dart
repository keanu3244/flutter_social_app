import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:like_button/like_button.dart';
import 'package:my_social_app/models/post.dart';
import 'package:my_social_app/widgets/indicators.dart';
import 'package:timeago/timeago.dart' as timeago;

class ViewImage extends StatefulWidget {
  final PostModel? post;

  const ViewImage({super.key, this.post});

  @override
  _ViewImageState createState() => _ViewImageState();
}

final DateTime timestamp = DateTime.now();

String currentUserId() {
  return 'user1';
}

class _ViewImageState extends State<ViewImage> {
  // 模拟点赞数据
  final List<Map<String, dynamic>> mockLikes = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: buildImage(context)),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 50.0,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post!.username!,
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 3.0),
                    Row(
                      children: [
                        Icon(Ionicons.alarm_outline, size: 13.0),
                        SizedBox(width: 3.0),
                        Text('2025-4-25'),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                buildLikeButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: CachedNetworkImage(
          imageUrl: widget.post!.mediaUrl!,
          placeholder: (context, url) {
            return circularProgress(context);
          },
          errorWidget: (context, url, error) {
            return Icon(Icons.error);
          },
          height: 400.0,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
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
    //     "userDp": user!.photoUrl,
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
      //   return true;
      // } else {
      //   likesRef.doc(docs[0].id).delete();
      //   removeLikeFromNotification();
      //   return false;
      // }
      return isCurrentlyLiked; // 保持原状态，禁用实际点赞
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
}

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:like_button/like_button.dart';
import 'package:my_social_app/components/custom_card.dart';
import 'package:my_social_app/components/custom_image.dart';
import 'package:my_social_app/models/post.dart';
import 'package:my_social_app/models/user.dart';
import 'package:my_social_app/pages/profile.dart';
import 'package:my_social_app/screens/comment.dart';
import 'package:my_social_app/screens/view_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserPost extends StatefulWidget {
  final PostModel? post;

  const UserPost({super.key, this.post});

  @override
  _UserPostState createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
  // 当前用户 ID
  String currentUserId() => 'user1';

  // 模拟点赞数据
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

  // 模拟评论数据
  final List<Map<String, dynamic>> mockComments = [
    {
      'postId': 'post1',
      'userId': 'user2',
      'username': 'demo2',
      'userDp': 'https://img.qianshengclub.com/MTc0MDQ1MDA2OTkxNiMyMjYjcG5n.png',
      'comment': 'Great post!',
      'timestamp': DateTime.now().subtract(Duration(hours: 1)),
    },
  ];

  // 模拟用户数据
  final List<Map<String, dynamic>> mockUsers = [
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
  ];

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: () {},
      borderRadius: BorderRadius.circular(10.0),
      child: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        openBuilder: (BuildContext context, VoidCallback _) {
          return ViewImage(post: widget.post);
        },
        closedElevation: 0.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        onClosed: (v) {},
        closedColor: Theme.of(context).cardColor,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return Stack(
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    child: CustomImage(
                      imageUrl: widget.post?.mediaUrl ?? '',
                      height: 350.0,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.0,
                      vertical: 5.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Row(
                            children: [
                              buildLikeButton(),
                              SizedBox(width: 5.0),
                              InkWell(
                                borderRadius: BorderRadius.circular(10.0),
                                onTap: () {
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder:
                                          (_) => Comments(post: widget.post),
                                    ),
                                  );
                                },
                                child: Icon(
                                  CupertinoIcons.chat_bubble,
                                  size: 25.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child:
                                    StreamBuilder<List<Map<String, dynamic>>>(
                                      stream: Stream.value(
                                        mockLikes
                                            .where(
                                              (like) =>
                                                  like['postId'] ==
                                                  widget.post!.postId,
                                            )
                                            .toList(),
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          List<Map<String, dynamic>> likes =
                                              snapshot.data!;
                                          return buildLikesCount(
                                            context,
                                            likes.length,
                                          );
                                        } else {
                                          return buildLikesCount(context, 0);
                                        }
                                      },
                                    ),
                              ),
                            ),
                            SizedBox(width: 5.0),
                            StreamBuilder<List<Map<String, dynamic>>>(
                              stream: Stream.value(
                                mockComments
                                    .where(
                                      (comment) =>
                                          comment['postId'] ==
                                          widget.post!.postId,
                                    )
                                    .toList(),
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<Map<String, dynamic>> comments =
                                      snapshot.data!;
                                  return buildCommentsCount(
                                    context,
                                    comments.length,
                                  );
                                } else {
                                  return buildCommentsCount(context, 0);
                                }
                              },
                            ),
                          ],
                        ),
                        Visibility(
                          visible:
                              widget.post!.description != null &&
                              widget.post!.description!.isNotEmpty,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0, top: 3.0),
                            child: Text(
                              widget.post?.description ?? "",
                              style: TextStyle(
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodySmall!.color,
                                fontSize: 15.0,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ),
                        SizedBox(height: 3.0),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            '2025-4-25',
                            style: TextStyle(fontSize: 10.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              buildUser(context),
            ],
          );
        },
      ),
    );
  }

  Widget buildLikeButton() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: Stream.value(
        mockLikes
            .where(
              (like) =>
                  like['postId'] == widget.post!.postId &&
                  like['userId'] == currentUserId(),
            )
            .toList(),
      ),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          List<Map<String, dynamic>> docs = snapshot.data!;

          Future<bool> onLikeButtonTapped(bool isLiked) async {
            setState(() {
              if (docs.isEmpty) {
                // 模拟添加点赞（本地状态）
                mockLikes.add({
                  'id': 'like${mockLikes.length + 1}',
                  'userId': currentUserId(),
                  'postId': widget.post!.postId,
                  'dateCreated': DateTime.now(),
                });
                // 注释上传操作
                // addLikesToNotification();
              } else {
                // 模拟删除点赞（本地状态）
                mockLikes.removeWhere(
                  (like) =>
                      like['postId'] == widget.post!.postId &&
                      like['userId'] == currentUserId(),
                );
                // 注释上传操作
                // services.removeLikeFromNotification(
                //     widget.post!.ownerId!, widget.post!.postId!, currentUserId());
              }
            });
            return !isLiked;
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
                docs.isEmpty ? Ionicons.heart_outline : Ionicons.heart,
                color:
                    docs.isEmpty
                        ? Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black
                        : Colors.red,
                size: 25,
              );
            },
          );
        }
        return Container();
      },
    );
  }

  // 注释上传操作
  // addLikesToNotification() async {
  //   bool isNotMe = currentUserId() != widget.post!.ownerId;
  //
  //   if (isNotMe) {
  //     DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
  //     user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
  //     services.addLikesToNotification(
  //       "like",
  //       user!.username!,
  //       currentUserId(),
  //       widget.post!.postId!,
  //       widget.post!.mediaUrl!,
  //       widget.post!.ownerId!,
  //       user!.photoUrl!,
  //     );
  //   }
  // }

  Widget buildLikesCount(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0),
      child: Text(
        '$count likes',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
      ),
    );
  }

  Widget buildCommentsCount(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.5),
      child: Text(
        '-   $count comments',
        style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildUser(BuildContext context) {
    bool isMe = currentUserId() == widget.post!.ownerId;
    // 从 mockUsers 获取用户信息
    Map<String, dynamic>? userData = mockUsers.firstWhere(
      (user) => user['id'] == widget.post!.ownerId,
      orElse: () => {},
    );
    if (userData.isEmpty) {
      return Container();
    }
    UserModel user = UserModel.fromJson(userData);

    return Visibility(
      visible: !isMe,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: GestureDetector(
            onTap: () => showProfile(context, profileId: user.id!),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  user.photoUrl!.isEmpty
                      ? CircleAvatar(
                        radius: 20.0,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        child: Center(
                          child: Text(
                            user.username![0].toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      )
                      : CircleAvatar(
                        radius: 20.0,
                        backgroundImage: CachedNetworkImageProvider(
                          user.photoUrl!,
                        ),
                      ),
                  SizedBox(width: 5.0),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post?.username ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.post?.location ?? 'Wooble',
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Color(0xff4D4D4D),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showProfile(BuildContext context, {String? profileId}) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => Profile(profileId: profileId)),
    );
  }
}

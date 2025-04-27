import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:my_social_app/auth/register/register.dart';
import 'package:my_social_app/components/stream_grid_wrapper.dart';
import 'package:my_social_app/models/post.dart';
import 'package:my_social_app/models/user.dart';
import 'package:my_social_app/screens/edit_profile.dart';
import 'package:my_social_app/screens/list_posts.dart';
import 'package:my_social_app/screens/settings.dart';
import 'package:my_social_app/widgets/post_tiles.dart';

class Profile extends StatefulWidget {
  final String? profileId;

  const Profile({super.key, required this.profileId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;
  int postCount = 2; // 写死动态计数
  int followersCount = 0; // 写死粉丝计数
  int followingCount = 0; // 写死关注计数
  bool isFollowing = false; // 写死初始关注状态
  UserModel? user;
  final DateTime timestamp = DateTime.now();
  ScrollController controller = ScrollController();

  // 写死当前用户 ID
  String currentUserId() {
    return 'user1';
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // 写死用户数据
  Future<void> fetchUserData() async {
    setState(() {
      user = UserModel(
        id: widget.profileId,
        username: widget.profileId == 'user1' ? 'demo1' : 'demo2',
        email: '${widget.profileId}@example.com',
        country: widget.profileId == 'user1' ? '中国' : '加拿大',
        bio: '热爱生活',
        photoUrl: 'https://img.qianshengclub.com/MTc0MjE4MzAwMzUyNyM3MDcjcG5n.png',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('WOOBLE'),
        actions: [
          widget.profileId == currentUserId()
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 25.0),
                  child: GestureDetector(
                    onTap: () {
                      // 忽略退出登录操作，仅跳转
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(builder: (_) => Register()),
                      );
                    },
                    child: const Text(
                      '退出登录',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              )
              : const SizedBox(),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            floating: false,
            toolbarHeight: 5.0,
            collapsedHeight: 6.0,
            expandedHeight: 225.0,
            flexibleSpace: FlexibleSpaceBar(
              background:
                  user == null
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child:
                                    user!.photoUrl == null ||
                                            user!.photoUrl!.isEmpty
                                        ? CircleAvatar(
                                          radius: 40.0,
                                          backgroundColor:
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                          child: Center(
                                            child: Text(
                                              user!.username != null
                                                  ? user!.username![0]
                                                      .toUpperCase()
                                                  : '',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        )
                                        : CircleAvatar(
                                          radius: 40.0,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                user!.photoUrl!,
                                              ),
                                        ),
                              ),
                              const SizedBox(width: 20.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 32.0),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 130.0,
                                            child: Text(
                                              user!.username ?? '',
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w900,
                                              ),
                                              maxLines: null,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 130.0,
                                            child: Text(
                                              user!.country ?? '',
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 130.0,
                                            child: Text(
                                              user!.email ?? '',
                                              style: const TextStyle(
                                                fontSize: 10.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      widget.profileId == currentUserId()
                                          ? InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                CupertinoPageRoute(
                                                  builder:
                                                      (_) => const Setting(),
                                                ),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Ionicons.settings_outline,
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.secondary,
                                                ),
                                                const Text(
                                                  '设置',
                                                  style: TextStyle(
                                                    fontSize: 11.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                          : const Text(''),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              left: 20.0,
                            ),
                            child:
                                user!.bio == null || user!.bio!.isEmpty
                                    ? Container()
                                    : SizedBox(
                                      width: 200,
                                      child: Text(
                                        user!.bio!,
                                        style: const TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: null,
                                      ),
                                    ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            height: 50.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  buildCount("动态", postCount),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 15.0),
                                    child: SizedBox(
                                      height: 50.0,
                                      width: 0.3,
                                      child: VerticalDivider(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  buildCount("粉丝", followersCount),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 15.0),
                                    child: SizedBox(
                                      height: 50.0,
                                      width: 0.3,
                                      child: VerticalDivider(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  buildCount("关注", followingCount),
                                ],
                              ),
                            ),
                          ),
                          buildProfileButton(user!),
                        ],
                      ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              if (index > 0) return null;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        const Text(
                          '所有动态',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   CupertinoPageRoute(
                            //     builder: (_) => ListPosts(
                            //       userId: widget.profileId,
                            //       username: user?.username,
                            //     ),
                            //   ),
                            // );
                          },
                          icon: const Icon(Ionicons.grid_outline),
                        ),
                      ],
                    ),
                  ),
                  buildPostView(),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildCount(String label, int count) {
    return Column(
      children: <Widget>[
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w900,
            fontFamily: 'Ubuntu-Regular',
          ),
        ),
        const SizedBox(height: 3.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            fontFamily: 'Ubuntu-Regular',
          ),
        ),
      ],
    );
  }

  Widget buildProfileButton(UserModel user) {
    bool isMe = widget.profileId == currentUserId();
    if (isMe) {
      return buildButton(
        text: "编辑个人资料",
        function: () {
          Navigator.of(
            context,
          ).push(CupertinoPageRoute(builder: (_) => EditProfile(user: user)));
        },
      );
    } else if (isFollowing) {
      return buildButton(text: "取消关注", function: handleUnfollow);
    } else {
      return buildButton(text: "关注", function: handleFollow);
    }
  }

  Widget buildButton({required String text, required Function() function}) {
    return Center(
      child: GestureDetector(
        onTap: function,
        child: Container(
          height: 40.0,
          width: 200.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Theme.of(context).colorScheme.secondary,
                const Color(0xff597FDB),
              ],
            ),
          ),
          child: Center(
            child: Text(text, style: const TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }

  Future<void> handleUnfollow() async {
    // 忽略上传操作，仅更新本地 UI
    setState(() {
      isFollowing = false;
      followersCount = followersCount > 0 ? followersCount - 1 : 0;
    });
  }

  Future<void> handleFollow() async {
    // 忽略上传操作，仅更新本地 UI
    setState(() {
      isFollowing = true;
      followersCount++;
    });
  }

  Widget buildPostView() {
    return buildGridPost();
  }

  Widget buildGridPost() {
    // 写死动态数据
    final List<Map<String, dynamic>> mockPosts = [
      {
        'id': 'post1',
        'userId': widget.profileId,
        'imageUrl': 'https://fake-post1.jpg',
        'caption': '这是我的第一条动态！',
        'timestamp':
            DateTime.now()
                .subtract(const Duration(days: 1))
                .millisecondsSinceEpoch,
        'likes': 10,
        'comments': 5,
      },
      {
        'id': 'post2',
        'userId': widget.profileId,
        'imageUrl': 'https://fake-post2.jpg',
        'caption': '又一个精彩时刻！',
        'timestamp':
            DateTime.now()
                .subtract(const Duration(days: 3))
                .millisecondsSinceEpoch,
        'likes': 20,
        'comments': 8,
      },
    ];

    return StreamGridWrapper(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      stream: Stream.value(mockPosts), // 写死数据流
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, Map<String, dynamic> snapshot) {
        PostModel posts = PostModel.fromJson(snapshot);
        return PostTile(post: posts);
      },
    );
  }
}

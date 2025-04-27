import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:my_social_app/chats/conversation.dart';
import 'package:my_social_app/models/user.dart';
import 'package:my_social_app/pages/profile.dart';
import 'package:my_social_app/utils/constants.dart';
import 'package:my_social_app/widgets/indicators.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  bool loading = true;

  // 写死当前用户 ID，与 Profile 一致
  String currentUserId() {
    return 'user1';
  }

  // 写死用户数据
  Future<void> getUsers() async {
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
      {
        'id': 'user3',
        'username': 'demo3',
        'email': 'user3@example.com',
        'photoUrl': 'https://img.qianshengclub.com/MTc0MDQ1MDA2OTkxNiMyMjYjcG5n.png',
        'bio': '追逐梦想',
        'country': '美国',
      },
    ];
    setState(() {
      users = mockUsers;
      filteredUsers = mockUsers;
      loading = false;
    });
  }

  // 搜索逻辑，基于写死数据
  void search(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredUsers = users;
      });
    } else {
      setState(() {
        filteredUsers =
            users.where((user) {
              String userName = user['username'] as String;
              return userName.toLowerCase().contains(query.toLowerCase());
            }).toList();
      });
    }
  }

  // 移除列表项（当前用户）
  void removeFromList(int index) {
    setState(() {
      filteredUsers.removeAt(index);
    });
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          Constants.appName,
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        onRefresh: getUsers,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: buildSearch(),
            ),
            buildUsers(),
          ],
        ),
      ),
    );
  }

  Widget buildSearch() {
    return Row(
      children: [
        Container(
          height: 30.0,
          width: MediaQuery.of(context).size.width - 50,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: TextFormField(
              controller: searchController,
              textAlignVertical: TextAlignVertical.center,
              maxLength: 10,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              inputFormatters: [LengthLimitingTextInputFormatter(20)],
              textCapitalization: TextCapitalization.sentences,
              onChanged: (query) {
                search(query);
              },
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () {
                    searchController.clear();
                    search('');
                  },
                  child: Icon(
                    Ionicons.close_outline,
                    size: 12.0,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                border: InputBorder.none,
                counterText: '',
                hintText: 'Search...',
                hintStyle: TextStyle(fontSize: 13.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildUsers() {
    if (!loading) {
      if (filteredUsers.isEmpty) {
        return Center(
          child: Text(
            "No User Found",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      } else {
        return Expanded(
          child: Container(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> userData = filteredUsers[index];
                UserModel user = UserModel.fromJson(userData);
                if (user.id == currentUserId()) {
                  Timer(Duration(milliseconds: 500), () {
                    removeFromList(index);
                  });
                }
                return ListTile(
                  onTap: () => showProfile(context, profileId: user.id!),
                  leading:
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
                  title: Text(
                    user.username!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(user.email!),
                  trailing: GestureDetector(
                    onTap: () {
                      // 模拟聊天跳转，忽略 Firestore 查询
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder:
                              (_) => Conversation(
                                userId: user.id!,
                                chatId: getUser(currentUserId(), user.id!),
                              ),
                        ),
                      );
                    },
                    child: Container(
                      height: 30.0,
                      width: 62.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'Message',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
    } else {
      return Center(child: circularProgress(context));
    }
  }

  void showProfile(BuildContext context, {String? profileId}) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => Profile(profileId: profileId)),
    );
  }

  // 生成 chatId，与原逻辑一致
  String getUser(String user1, String user2) {
    user1 = user1.substring(0, 5);
    user2 = user2.substring(0, 5);
    List<String> list = [user1, user2];
    list.sort();
    return "${list[0]}-${list[1]}";
  }

  @override
  bool get wantKeepAlive => true;
}

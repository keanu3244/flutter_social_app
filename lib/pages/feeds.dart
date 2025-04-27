import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';
import 'package:my_social_app/chats/recent_chats.dart';
import 'package:my_social_app/models/post.dart';
import 'package:my_social_app/services/post_service.dart';
import 'package:my_social_app/widgets/indicators.dart';
import 'package:my_social_app/widgets/story_widget.dart';
import 'package:my_social_app/widgets/userpost.dart';

class Feeds extends StatefulWidget {
  const Feeds({super.key});

  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int page = 5;
  bool loadingMore = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          page = page + 5;
          loadingMore = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final postService = PostService();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'SocialApp', // Replace Constants.appName
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Ionicons.chatbubble_ellipses, size: 30.0),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => const Chats()),
              );
            },
          ),
          const SizedBox(width: 20.0),
        ],
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        onRefresh: () async {
          setState(() {
            page = 5; // Reset to initial page
          });
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StoryWidget(),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: postService.getPosts(page),
                  builder: (
                    context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
                  ) {
                    if (snapshot.hasData) {
                      final posts = snapshot.data!;
                      if (posts.isEmpty) {
                        return const Center(
                          child: Text(
                            'No Feeds',
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: posts.length + (loadingMore ? 1 : 0),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (index == posts.length && loadingMore) {
                            return circularProgress(context);
                          }
                          PostModel post = PostModel.fromJson(posts[index]);
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: UserPost(post: post),
                          );
                        },
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return circularProgress(context);
                    } else {
                      return const Center(
                        child: Text(
                          'No Feeds',
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_social_app/models/status.dart';
import 'package:my_social_app/models/user.dart';
import 'package:my_social_app/view_models/status/status_view_model.dart';
import 'package:my_social_app/widgets/indicators.dart';
import 'package:story/story.dart';
import 'package:timeago/timeago.dart' as timeago;

class StatusScreen extends StatefulWidget {
  final int initPage;
  final String statusId;
  final String storyId;
  final String userId;

  const StatusScreen({
    super.key,
    required this.initPage,
    required this.storyId,
    required this.statusId,
    required this.userId,
  });

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    StatusViewModel viewModel = Provider.of<StatusViewModel>(context);
    // 获取 mock 数据
    List<Map<String, dynamic>> statuses =
        viewModel.mockStatuses
            .where((status) => status['id'] == widget.statusId)
            .toList();
    List<Map<String, dynamic>> statusList =
        statuses.isNotEmpty
            ? statuses.first['statuses'] as List<Map<String, dynamic>>
            : [];
    Map<String, dynamic>? user = viewModel.mockUsers;

    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (value) {
          Navigator.pop(context);
        },
        child:
            statusList.isEmpty
                ? circularProgress(context)
                : StoryPageView(
                  indicatorPadding: EdgeInsets.symmetric(
                    vertical: 50.0,
                    horizontal: 20.0,
                  ),
                  indicatorHeight: 15.0,
                  initialPage: widget.initPage,
                  onPageLimitReached: () {
                    Navigator.pop(context);
                  },
                  indicatorVisitedColor:
                      Theme.of(context).colorScheme.secondary,
                  indicatorDuration: Duration(seconds: 30),
                  itemBuilder: (context, pageIndex, storyIndex) {
                    StatusModel stats = StatusModel.fromJson(
                      statusList[storyIndex],
                    );
                    // 模拟添加 viewers
                    List<dynamic> allViewers = List.from(stats.viewers ?? []);
                    if (allViewers.contains('user1')) {
                      print('ID ALREADY EXIST');
                    } else {
                      allViewers.add('user1');
                      // 更新 mockStatuses
                      // viewModel.updateStatusViewers(
                      //     widget.statusId, stats.statusId!, allViewers);
                    }
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 50.0),
                            child: getImage(stats.url!),
                          ),
                          Positioned(
                            top: 65.0,
                            left: 10.0,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.transparent,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 2.0,
                                          spreadRadius: 0.0,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: CircleAvatar(
                                        radius: 15.0,
                                        backgroundColor: Colors.grey,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                              '123' ?? '',
                                            ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Column(
                                    children: [
                                      Text(
                                        '123' ?? '',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        timeago.format(stats.time!),
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: widget.userId == 'user1' ? 10.0 : 30.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  color: Colors.grey.withOpacity(0.2),
                                  width: MediaQuery.of(context).size.width,
                                  constraints: BoxConstraints(maxHeight: 50.0),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0,
                                          ),
                                          child: Text(
                                            stats.caption ?? '',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (widget.userId == 'user1')
                                  TextButton.icon(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.remove_red_eye_outlined,
                                      size: 20.0,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    label: Text(
                                      stats.viewers?.length.toString() ?? '0',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  storyLength: (int pageIndex) {
                    return statusList.length;
                  },
                  pageLength: 1,
                ),
      ),
    );
  }

  Widget getImage(String url) {
    return AspectRatio(aspectRatio: 9 / 16, child: Image.network(url));
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:my_social_app/components/chat_bubble.dart';
import 'package:my_social_app/models/enum/message_type.dart';
import 'package:my_social_app/models/message.dart';
import 'package:my_social_app/models/user.dart';
import 'package:my_social_app/pages/profile.dart';
import 'package:my_social_app/services/chat_service.dart';
import 'package:my_social_app/services/user_service.dart';
import 'package:my_social_app/view_models/conversation/conversation_view_model.dart';
import 'package:my_social_app/view_models/user/user_view_model.dart';
import 'package:my_social_app/widgets/indicators.dart';
import 'package:timeago/timeago.dart' as timeago;

class Conversation extends StatefulWidget {
  final String userId;
  final String chatId;

  const Conversation({super.key, required this.userId, required this.chatId});

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  FocusNode focusNode = FocusNode();
  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();
  bool isFirst = false;
  String? chatId;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      focusNode.unfocus();
    });
    if (widget.chatId == 'newChat') {
      isFirst = true;
    }
    chatId = widget.chatId;

    messageController.addListener(() {
      if (focusNode.hasFocus && messageController.text.isNotEmpty) {
        setTyping(true);
      } else if (!focusNode.hasFocus ||
          (focusNode.hasFocus && messageController.text.isEmpty)) {
        setTyping(false);
      }
    });
  }

  setTyping(typing) {
    var user = Provider.of<UserViewModel>(context, listen: false).user;
    if (user != null) {
      Provider.of<ConversationViewModel>(
        context,
        listen: false,
      ).setUserTyping(widget.chatId, {'id': user.id}, typing);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConversationViewModel>(
      builder: (BuildContext context, viewModel, Widget? child) {
        return Scaffold(
          key: viewModel.scaffoldKey,
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.keyboard_backspace),
            ),
            elevation: 0.0,
            titleSpacing: 0,
            title: buildUserName(),
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Flexible(
                  child: Consumer<ChatService>(
                    builder: (context, chatService, _) {
                      List messages = chatService.getMessages(widget.chatId);
                      viewModel.setReadCount(widget.chatId, {
                        'id': chatService.getCurrentUserId(),
                      }, messages.length);
                      return messages.isEmpty
                          ? Center(child: circularProgress(context))
                          : ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            itemCount: messages.length,
                            reverse: true,
                            itemBuilder: (BuildContext context, int index) {
                              Message message = Message.fromJson(
                                messages.reversed.toList()[index],
                              );
                              return ChatBubbleWidget(
                                message: '${message.content}',
                                time: message.time!,
                                isMe:
                                    message.senderUid ==
                                    chatService.getCurrentUserId(),
                                type: message.type!,
                              );
                            },
                          );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomAppBar(
                    elevation: 10.0,
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 100.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              CupertinoIcons.photo_on_rectangle,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            onPressed:
                                () => showPhotoOptions(viewModel, {
                                  'id':
                                      Provider.of<ChatService>(
                                        context,
                                        listen: false,
                                      ).getCurrentUserId(),
                                }),
                          ),
                          Flexible(
                            child: TextField(
                              controller: messageController,
                              focusNode: focusNode,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10.0),
                                enabledBorder: InputBorder.none,
                                border: InputBorder.none,
                                hintText: "Type your message",
                                hintStyle: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                              maxLines: null,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Ionicons.send,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            onPressed: () {
                              if (messageController.text.isNotEmpty) {
                                sendMessage(viewModel, {
                                  'id':
                                      Provider.of<ChatService>(
                                        context,
                                        listen: false,
                                      ).getCurrentUserId(),
                                });
                              }
                            },
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
      },
    );
  }

  _buildOnlineText(UserModel user, bool typing) {
    if (user.isOnline ?? false) {
      return typing ? "typing..." : "online";
    } else {
      return 'last seen ${timeago.format(user.lastSeen!)}';
    }
  }

  Widget buildUserName() {
    UserService userService = Provider.of<UserService>(context, listen: false);
    UserModel? user = userService.getUser(widget.userId);
    if (user == null) {
      return Center(child: circularProgress(context));
    }
    return InkWell(
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Hero(
              tag: user.email ?? '',
              child:
                  user.photoUrl!.isEmpty
                      ? CircleAvatar(
                        radius: 25.0,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        child: Center(
                          child: Text(
                            user.username![0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      )
                      : CircleAvatar(
                        radius: 25.0,
                        backgroundImage: CachedNetworkImageProvider(
                          '${user.photoUrl}',
                        ),
                      ),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${user.username}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox(height: 5.0),
                Consumer<ChatService>(
                  builder: (context, chatService, _) {
                    bool typing = chatService.getTyping(
                      widget.chatId,
                      widget.userId,
                    );
                    return Text(
                      _buildOnlineText(user, typing),
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(
          context,
        ).push(CupertinoPageRoute(builder: (_) => Profile(profileId: user.id)));
      },
    );
  }

  showPhotoOptions(ConversationViewModel viewModel, Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text("Camera"),
              onTap: () {
                sendMessage(viewModel, user, imageType: 0, isImage: true);
              },
            ),
            ListTile(
              title: const Text("Gallery"),
              onTap: () {
                sendMessage(viewModel, user, imageType: 1, isImage: true);
              },
            ),
          ],
        );
      },
    );
  }

  sendMessage(
    ConversationViewModel viewModel,
    Map<String, dynamic> user, {
    bool isImage = false,
    int? imageType,
  }) async {
    String msg;
    if (isImage) {
      msg = await viewModel.pickImage(
        source: imageType!,
        context: context,
        chatId: widget.chatId,
      );
    } else {
      msg = messageController.text.trim();
      messageController.clear();
    }

    Message message = Message(
      content: msg,
      senderUid: user['id'],
      type: isImage ? MessageType.IMAGE : MessageType.TEXT,
      time: DateTime.now(),
    );

    if (msg.isNotEmpty) {
      if (isFirst) {
        String id = await viewModel.sendFirstMessage(widget.userId, message);
        setState(() {
          isFirst = false;
          chatId = id;
        });
        Provider.of<ChatService>(context, listen: false).initChat(id);
      } else {
        viewModel.sendMessage(widget.chatId, message);
      }
    }
  }

  String getUser(String user1, String user2) {
    user1 = user1.substring(0, 5);
    user2 = user2.substring(0, 5);
    List<String> list = [user1, user2];
    list.sort();
    return "${list[0]}-${list[1]}";
  }
}

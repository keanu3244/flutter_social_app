import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_social_app/components/chat_item.dart';
import 'package:my_social_app/models/enum/message_type.dart';
import 'package:my_social_app/models/message.dart';
import 'package:my_social_app/services/chat_service.dart';
import 'package:my_social_app/view_models/user/user_view_model.dart';
import 'package:my_social_app/widgets/indicators.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    UserViewModel viewModel = Provider.of<UserViewModel>(
      context,
      listen: false,
    );
    viewModel.setUser();
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.keyboard_backspace),
        ),
        title: const Text("Chats"),
      ),
      body: Consumer<ChatService>(
        builder: (context, chatService, _) {
          // 获取当前用户的所有聊天
          final chatList = chatService.getUserChats(viewModel.user?.id ?? '');
          if (chatList.isEmpty) {
            return const Center(child: Text('No Chats'));
          }
          return ListView.separated(
            itemCount: chatList.length,
            itemBuilder: (BuildContext context, int index) {
              final chat = chatList[index];
              final chatId = chat['chatId'];
              final messages = chatService.getMessages(chatId);
              if (messages.isEmpty) {
                return const SizedBox();
              }
              final message = Message.fromJson(messages.first);
              final users = chat['users'] as List<dynamic>;
              // 移除当前用户 ID，获取对方 ID
              final recipient = users.firstWhere(
                (userId) => userId != viewModel.user?.id,
                orElse: () => '',
              );
              return ChatItem(
                userId: recipient,
                messageCount: messages.length,
                msg: message.content!,
                time: message.time!,
                chatId: chatId,
                type: message.type!,
                currentUserId: viewModel.user?.id ?? '',
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 0.5,
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: const Divider(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

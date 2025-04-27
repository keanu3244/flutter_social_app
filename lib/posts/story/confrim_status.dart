import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:my_social_app/models/enum/message_type.dart';
import 'package:my_social_app/models/status.dart';
import 'package:my_social_app/view_models/status/status_view_model.dart';
import 'package:my_social_app/widgets/indicators.dart';
import 'package:uuid/uuid.dart';

class ConfirmStatus extends StatefulWidget {
  const ConfirmStatus({super.key});

  @override
  State<ConfirmStatus> createState() => _ConfirmStatusState();
}

class _ConfirmStatusState extends State<ConfirmStatus> {
  bool loading = false;
  final uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    StatusViewModel viewModel = Provider.of<StatusViewModel>(context);
    return Scaffold(
      body: LoadingOverlay(
        isLoading: loading,
        progressIndicator: circularProgress(context),
        child: Center(
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Image.file(viewModel.mediaUrl!),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10.0,
        child: Container(
          constraints: BoxConstraints(maxHeight: 100.0),
          child: Flexible(
            child: TextFormField(
              style: TextStyle(
                fontSize: 15.0,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
                hintText: "Type your caption",
                hintStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              onSaved: (val) {
                viewModel.setDescription(val!);
              },
              onChanged: (val) {
                viewModel.setDescription(val);
              },
              maxLines: null,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.done, color: Colors.white),
        onPressed: () async {
          setState(() {
            loading = true;
          });
          // 模拟图片 URL
          String url = 'https://fake-status-${uuid.v1()}.jpg';
          StatusModel message = StatusModel(
            url: url,
            caption: viewModel.description,
            type: MessageType.IMAGE,
            time: DateTime.now(),
            statusId: uuid.v1(),
            viewers: [],
          );
          // 模拟状态保存
          bool hasStatus = viewModel.mockStatuses.any(
            (status) => status['userId'] == 'user1',
          );
          if (hasStatus) {
            viewModel.sendStatus('mockChatId', message);
          } else {
            String id = await viewModel.sendFirstStatus(message);
            viewModel.sendStatus(id, message);
          }
          setState(() {
            loading = false;
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}

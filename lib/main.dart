import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:my_social_app/components/life_cycle_event_handler.dart';
import 'package:my_social_app/screens/mainscreen.dart';
import 'package:my_social_app/services/user_service.dart';
import 'package:my_social_app/services/chat_service.dart';
import 'package:my_social_app/utils/constants.dart';
import 'package:my_social_app/view_models/theme/theme_view_model.dart';
import 'package:my_social_app/view_models/user/user_view_model.dart';
import 'package:my_social_app/view_models/conversation/conversation_view_model.dart';
import 'services/notification_service.dart';
import 'package:my_social_app/view_models/status/status_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 模拟当前用户 ID
  String currentUserId() => 'user1';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        detachedCallBack:
            () => Provider.of<UserService>(
              context,
              listen: false,
            ).setUserStatus(false),
        resumeCallBack:
            () => Provider.of<UserService>(
              context,
              listen: false,
            ).setUserStatus(true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotificationService>(
          create: (_) => NotificationService(),
        ),
        ChangeNotifierProvider<ChatService>(create: (_) => ChatService()),
        ChangeNotifierProvider<UserService>(create: (_) => UserService()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<UserViewModel>(create: (_) => UserViewModel()),
        ChangeNotifierProvider<ConversationViewModel>(
          create: (_) => ConversationViewModel(),
        ),
        ChangeNotifierProvider<StatusViewModel>(
          create: (_) => StatusViewModel(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, Widget? child) {
          return MaterialApp(
            title: Constants.appName,
            debugShowCheckedModeBanner: false,
            theme: themeData(
              notifier.dark ? Constants.darkTheme : Constants.lightTheme,
            ),
            home: const TabScreen(),
          );
        },
      ),
    );
  }

  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(theme.textTheme),
    );
  }
}

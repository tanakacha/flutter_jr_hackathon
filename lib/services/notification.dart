import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

class Notifications {
  Notifications() {
    init();
  }

  static const _iosCategoryId = 'sample_category';
  static final _log = Logger('Notifications');

  final _plugin = FlutterLocalNotificationsPlugin();
  final _initCompleter = Completer<void>();

  // 途中
  Future<void> init() async {
    tz.initializeTimeZones();
    setLocalLocation(getLocation('Asia/Tokyo'));

    final success = await _plugin.initialize(
      InitializationSettings(
        iOS: DarwinInitializationSettings(
          notificationCategories: [
            DarwinNotificationCategory(
              _iosCategoryId,
              actions: [
                DarwinNotificationAction.plain(
                  'sample_action',
                  'Sample Action',
                  options: {DarwinNotificationActionOption.foreground},
                ),
              ],
              options: {
                DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
                DarwinNotificationCategoryOption.hiddenPreviewShowSubtitle,
                DarwinNotificationCategoryOption.allowAnnouncement,
              },
            )
          ],
        ),
        android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: notificationTapForeground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    if (success ?? false) {
      _log.info('Notifications initialized');
    } else {
      _log.severe('Failed to initialize notifications');
    }
    _initCompleter.complete();
  }

  // 途中
  // Future<void> showNotification()

  // 途中
  // Future<void> scheduleNotification()

  // 途中
  // int get _randomId

  // 途中
    @pragma('vm:entry-point')
  static void notificationTapForeground(
    NotificationResponse notificationResponse,
  ) {
    _log.info('notificationTapForeground: $notificationResponse');
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(
    NotificationResponse notificationResponse,
  ) {
    _log.info('notificationTapBackground: $notificationResponse');
  }
}

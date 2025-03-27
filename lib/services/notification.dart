import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

class Notifications {
  Notifications() {
    init();
  }

  // まだ使ってない
  // static const _iosCategoryId = 'sample_category';
  // static final _log = Logger('Notifications');

  // final _plugin = FlutterLocalNotificationsPlugin();
  // final _initCompleter = Completer<void>();

  // 途中
  Future<void> init() async {
    tz.initializeTimeZones();
    setLocalLocation(getLocation('Asia/Tokyo'));

  }
}

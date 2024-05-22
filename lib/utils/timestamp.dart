import 'package:timeago/timeago.dart' as timeago;

mixin MixinTimeStamp {
  abstract DateTime datetime;
  Map<String, dynamic> toJson();

  String displayTime() {
    return timeago.format(datetime.toLocal());
  }
}

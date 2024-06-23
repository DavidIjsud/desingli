import 'package:flutter/services.dart';

abstract class ChannelNative {
  static const platform = MethodChannel("signli.app/channel");
}

import 'dart:io';
import 'dart:convert';

import 'package:argear_flutter_plugin/argear_flutter_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

typedef ARGearControllerCallback = void Function(
    String method, dynamic arguments);

class ARGearController {
  ARGearController({
    required int id,
    this.apiUrl,
    this.apiKey,
    this.secretKey,
    this.authKey,
    this.onCallback,
    this.onPre,
    this.onComplete,
  }) {
    _channel = MethodChannel('argear_flutter_plugin_$id');
    _channel.setMethodCallHandler(_handleMethodCalls);
    init();
  }

  late MethodChannel _channel;

  final String? apiUrl;
  final String? apiKey;
  final String? secretKey;
  final String? authKey;
  final ARGearControllerCallback? onCallback;
  final ARGearControllerCallback? onPre;
  final ARGearControllerCallback? onComplete;

  init() async {
    try {
      await _channel.invokeMethod<void>('init', {
        'apiUrl': apiUrl,
        'apiKey': apiKey,
        'secretKey': secretKey,
        'authKey': authKey,
      });
    } on PlatformException catch (e) {
      debugPrint('${e.code}: ${e.message}');
    }
  }

  changeCameraFacing() async {
    try {
      var result = await _channel.invokeMethod<dynamic>('changeCameraFacing');
    } on PlatformException catch (e) {
      debugPrint('${e.code}: ${e.message}');
    }
  }

  changeCameraRatio(ARGCameraRatio ratio) async {
    try {
      await _channel
          .invokeMethod<dynamic>('changeCameraRatio', {'ratio': ratio.index});
    } on PlatformException catch (e) {
      debugPrint('${e.code}: ${e.message}');
    }
  }

  setVideoBitrate(ARGVideoBitrate bitrate) async {
    try {
      await _channel
          .invokeMethod<dynamic>('setVideoBitrate', {'bitrate': bitrate.index});
    } on PlatformException catch (e) {
      debugPrint('${e.code}: ${e.message}');
    }
  }

  setSticker(ItemModel itemModel) async {
    onPre?.call('preCallback', 'setSticker');
    try {
      var result = await _channel.invokeMethod<dynamic>(
          'setSticker', {'itemModel': jsonEncode(itemModel).toString()});
      if (result != null) {
        onComplete?.call('completeCallback', result.toString());
      }
    } on PlatformException catch (e) {
      debugPrint('${e.code}: ${e.message}');
      onComplete?.call('completeCallback', e.message.toString());
    }
  }

  clearSticker() async {
    try {
      await _channel.invokeMethod<dynamic>('clearSticker');
    } on PlatformException catch (e) {
      debugPrint('${e.code}: ${e.message}');
    }
  }

  setFilter(ItemModel itemModel) async {
    onPre?.call('preCallback', 'setFilter');
    try {
      var result = await _channel.invokeMethod<dynamic>(
          'setFilter', {'itemModel': jsonEncode(itemModel).toString()});
      if (result != null) {
        onComplete?.call('completeCallback', result.toString());
      }
    } on PlatformException catch (e) {
      debugPrint('${e.code}: ${e.message}');
      onComplete?.call('completeCallback', e.message.toString());
    }
  }

  setFilterLevel(double level) async {
    try {
      await _channel.invokeMethod<dynamic>('setFilterLevel', {'level': level});
    } on PlatformException catch (e) {
      debugPrint('${e.code}: ${e.message}');
    }
  }

  clearFilter() async {
    try {
      await _channel.invokeMethod<dynamic>('clearFilter');
    } on PlatformException catch (e) {
      debugPrint('${e.code}: ${e.message}');
    }
  }

  setBeauty(ARGBeauty type, double value) async {
    try {
      await _channel.invokeMethod<dynamic>(
          'setBeauty', {'type': type.index, 'value': value});
    } on PlatformException catch (e) {
      debugPrint('${e.code}: ${e.message}');
    }
  }

  setBeautyValues(List<double> values) async {
    try {
      await _channel.invokeMethod<dynamic>('setBeautyValues', {
        'values': Platform.isIOS ? values.toString() : values,
      });
    } on PlatformException catch (e) {
      debugPrint('${e.code}: ${e.message}');
    }
  }

  setDefaultBeauty() async {
    try {
      await _channel.invokeMethod<dynamic>('setDefaultBeauty');
    } on PlatformException catch (e) {
      debugPrint('${e.code}: ${e.message}');
    }
  }

  getDefaultBeauty() async {
    try {
      return await _channel.invokeMethod<dynamic>('getDefaultBeauty');
    } on PlatformException catch (e) {
      debugPrint('${e.code}: ${e.message}');
    }
  }

  setBulge(ARGBulge type) async {
    try {
      await _channel.invokeMethod<dynamic>('setBulge', {'type': type.index});
    } on PlatformException catch (e) {
      debugPrint('${e.code}: ${e.message}');
    }
  }

  clearBulge() async {
    try {
      await _channel.invokeMethod<dynamic>('clearBulge');
    } on PlatformException catch (e) {
      debugPrint('${e.code}: ${e.message}');
    }
  }

  takePicture() async {
    try {
      await _channel.invokeMethod<dynamic>('takePicture');
    } on PlatformException catch (e) {
      debugPrint('${e.code}: ${e.message}');
    }
  }

  Future<String> startRecording() async {
    try {
      return await _channel.invokeMethod<dynamic>('startRecording');
    } on PlatformException catch (e) {
      debugPrint('${e.code}: ${e.message}');
      return '';
    }
  }

  Future stopRecording() async {
    onPre?.call('preCallback', 'stopRecording');
    try {
      await _channel.invokeMethod<dynamic>('stopRecording');
    } on PlatformException catch (e) {
      debugPrint('${e.code}: ${e.message}');
    }
  }

  toggleRecording() async {
    try {
      await _channel.invokeMethod<dynamic>('toggleRecording');
    } on PlatformException catch (e) {
      debugPrint('${e.code}: ${e.message}');
    }
  }

  exitApp() async {
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod<dynamic>('exitApp');
      } on PlatformException catch (e) {
        debugPrint('${e.code}: ${e.message}');
      }
    }
  }

  // flutter -> android / ios callback handle
  Future<dynamic> _handleMethodCalls(MethodCall call) async {
    // print('_platformCallHandler call ${call.method} ${call.arguments}');
    switch (call.method) {
      case 'changeRatio':
        break;
      case 'takePictureCallback':
        onCallback?.call('takePictureCallback', call.arguments);
        break;
      case 'recordingCallback':
        onComplete?.call('completeCallback', call.arguments);
        onCallback?.call('recordingCallback', call.arguments);
        break;
      default:
        debugPrint('Unknown method ${call.method} ');
        break;
    }
    return Future.value();
  }

  void dispose() {
    _channel.invokeMethod<void>('dispose');
  }
}

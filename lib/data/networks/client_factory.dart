import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cronet_http/cronet_http.dart';
import 'package:cupertino_http/cupertino_http.dart';

class ClientFactory {
  static http.Client create() {
    if (Platform.isAndroid) {
      print("🚀 Using Cronet (Native Android Stack)");
      final engine = CronetEngine.build(
        cacheMode: CacheMode.memory,
        cacheMaxSize: 1024 * 1024,
      );
      return CronetClient.fromCronetEngine(engine);
    }

    if (Platform.isIOS || Platform.isMacOS) {
      final config = URLSessionConfiguration.defaultSessionConfiguration();
      return CupertinoClient.fromSessionConfiguration(config);
    }

    return http.Client(); // Fallback for Web/Desktop
  }
}
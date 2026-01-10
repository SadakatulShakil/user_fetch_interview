import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';

class NetworkExceptions {
  static String getErrorMessage(dynamic error) {
    if (error is SocketException) {
      return "no_internet".tr;
    } else if (error is TimeoutException) {
      return "connection_timeout".tr;
    } else if (error is HttpException) {
      return "server_error".tr;
    } else if (error is FormatException) {
      return "invalid_format".tr; // JSON parsing error
    } else {
      return "unexpected_error".tr;
    }
  }

  static String handleResponseError(int statusCode) {
    switch (statusCode) {
      case 400:
        return "bad_request".tr;
      case 401:
        return "unauthorized".tr;
      case 403:
        return "forbidden".tr;
      case 404:
        return "not_found".tr;
      case 500:
        return "server_error".tr;
      case 502:
        return "bad_gateway".tr;
      default:
        return "something_went_wrong".tr;
    }
  }
}
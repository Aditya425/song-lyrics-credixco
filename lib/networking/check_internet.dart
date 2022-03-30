import 'dart:io';

class CheckInternet {
  Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on Exception catch (_) {
      return false;
    }
    return false;
  }
}
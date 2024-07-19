import 'package:nyalcf_core/utils/logger.dart';

class TextEncrypt {
  static String obscure(String origin) {
    Logger.debug('Input: $origin');
    final length = origin.length;
    String output = '';
    output += origin.substring(0, 3);
    var i = 0;
    while (i != length - 6) {
      output += '*';
      i++;
    }
    output += origin.substring(length - 3, length);
    Logger.debug('Output: $output');
    return output;
  }
}

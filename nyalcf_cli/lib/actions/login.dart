import 'package:nyalcf/utils/template/command_implement.dart';
import 'package:nyalcf_core/utils/logger.dart';

class Login implements CommandImplement {

  @override
  bool result = false;

  @override
  bool end() {
    return result;
  }

  @override
  void main(List<String> args) {

    // Logger.info(args);
  }
}
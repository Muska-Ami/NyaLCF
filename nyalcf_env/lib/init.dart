// Package imports:
import 'package:dotenv/dotenv.dart';

void initEnv() {
  DotEnv(includePlatformEnvironment: true).load();
}

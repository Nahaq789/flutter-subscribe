import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscribe/adapter/aws_config.dart';

final awsConfigProvider = Provider<IAwsConfig>((ref) {
  return AwsConfig();
});

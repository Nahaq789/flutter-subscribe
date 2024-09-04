import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscribe/adapter/firebase/crashlytics_i_service.dart';
import 'package:subscribe/adapter/firebase/crashlytics_service.dart';

final carshlyticsProvider = Provider<ICrashlyticsService>((ref) {
  return CrashlyticsService();
});

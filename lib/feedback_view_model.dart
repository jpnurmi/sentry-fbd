import 'package:flutter/foundation.dart';
import 'package:platform/platform.dart';
import 'package:sentry/sentry.dart';

class FeedbackViewModel with ChangeNotifier {
  FeedbackViewModel([Platform platform = const LocalPlatform()])
    : _platform = platform;

  final Platform _platform;

  late final String? _dsn = _platform.environment['SENTRY_DSN'];
  late final String? _eventId = _platform.environment['SENTRY_EVENT_ID'];

  late String _name = _platform.environment['SENTRY_USER'] ?? '';
  late String _email = _platform.environment['SENTRY_EMAIL'] ?? '';
  late String _feedback = '';

  String? get dsn => _dsn;
  String? get eventId => _eventId;

  String get name => _name;
  String get email => _email;
  String get feedback => _feedback;

  bool get isValid =>
      _dsn != null && _eventId != null && _feedback.trim().isNotEmpty;

  void setName(String name) {
    if (name == _name) return;
    _name = name;
    notifyListeners();
  }

  void setEmail(String email) {
    if (email == _email) return;
    _email = email;
    notifyListeners();
  }

  void setFeedback(String feedback) {
    if (feedback == _feedback) return;
    _feedback = feedback;
    notifyListeners();
  }

  Future<void> init() {
    return Sentry.init((options) {
      options.dsn = dsn;
      options.debug = true;
    });
  }

  Future<void> submit() {
    return Sentry.captureFeedback(
      SentryFeedback(
        message: _feedback,
        name: _name,
        contactEmail: _email,
        associatedEventId: SentryId.fromId(_eventId!),
      ),
    );
  }
}

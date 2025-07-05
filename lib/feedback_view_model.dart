import 'package:flutter/widgets.dart';
import 'package:sentry/sentry.dart';

import 'envelope_model.dart';

class FeedbackViewModel with ChangeNotifier {
  Envelope? _envelope;
  String? get dsn => _envelope?.header['dsn'];
  String? get eventId => _envelope?.header['event_id'];

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _feedback = TextEditingController();

  TextEditingController get name => _name;
  TextEditingController get email => _email;
  TextEditingController get feedback => _feedback;

  bool get isValid =>
      dsn != null && eventId != null && _feedback.text.trim().isNotEmpty;

  Future<void> init(Envelope? envelope) async {
    final event = envelope?.getEvent();
    _name.text = event?['user']?['username'] ?? '';
    _email.text = event?['user']?['email'] ?? '';
    _envelope = envelope;
    notifyListeners();

    if (dsn != null) {
      await Sentry.init((options) {
        options.dsn = dsn;
        options.debug = true;
      });
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _feedback.dispose();
    super.dispose();
  }

  Future<void> submit() {
    return Sentry.captureFeedback(
      SentryFeedback(
        message: _feedback.text.trim(),
        name: _name.text.trim(),
        contactEmail: _email.text.trim(),
        associatedEventId: SentryId.fromId(eventId!),
      ),
    );
  }
}

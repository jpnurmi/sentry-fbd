import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentry_fbd/envelope_view_model.dart';
import 'package:sentry_fbd/feedback_view_model.dart';

import 'envelope.dart';
import 'feedback_view.dart';
import 'envelope_view.dart';
import 'routes.dart';

void main(List<String> args) {
  final envelope = Envelope.fromFile(args.singleOrNull);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EnvelopeViewModel(envelope)),
        ChangeNotifierProvider(create: (_) => FeedbackViewModel(envelope)),
      ],
      child: MaterialApp(
        title: 'Sentry FBD',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: FeedbackView(),
        routes: {
          Routes.envelope: (context) => EnvelopeView(),
          Routes.feedback: (context) => FeedbackView(),
        },
      ),
    ),
  );
}

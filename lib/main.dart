import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentry_fbd/envelope_view_model.dart';
import 'package:sentry_fbd/environment_view_model.dart';
import 'package:sentry_fbd/feedback_view_model.dart';

import 'environment_view.dart';
import 'feedback_view.dart';
import 'envelope_view.dart';
import 'routes.dart';

void main(List<String> args) {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EnvironmentViewModel()),
        ChangeNotifierProvider(create: (_) => EnvelopeViewModel()),
        ChangeNotifierProvider(create: (_) => FeedbackViewModel()),
      ],
      child: MaterialApp(
        title: 'Sentry FBD',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: FeedbackView(),
        routes: {
          Routes.envelope: (context) => EnvelopeView(args.singleOrNull),
          Routes.environment: (context) => EnvironmentView(),
          Routes.feedback: (context) => FeedbackView(),
        },
      ),
    ),
  );
}

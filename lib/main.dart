import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentry_fbd/argument_view_model.dart';
import 'package:sentry_fbd/envelope_view_model.dart';
import 'package:sentry_fbd/environment_view_model.dart';
import 'package:sentry_fbd/feedback_view_model.dart';

import 'argument_view.dart';
import 'environment_view.dart';
import 'feedback_view.dart';
import 'envelope_view.dart';
import 'routes.dart';

void main(List<String> args) {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ArgumentViewModel(args)),
        ChangeNotifierProvider(create: (_) => EnvironmentViewModel()),
        ChangeNotifierProvider(create: (_) => EnvelopeViewModel()),
        ChangeNotifierProvider(create: (_) => FeedbackViewModel()),
      ],
      child: MaterialApp(
        title: 'Sentry FBD',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: HomePage(),
        routes: {
          Routes.envelope: (context) =>
              EnvelopeView(Arguments.of(context).single),
          Routes.feedback: (context) => FeedbackView(),
        },
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Sentry FBD'),
            centerTitle: false,
            pinned: true,
          ),
          ArgumentView(),
          EnvironmentView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, Routes.feedback),
        child: const Icon(Icons.feedback),
      ),
    );
  }
}

class Arguments {
  static List<String> of(BuildContext context) {
    return ModalRoute.of(context)?.settings.arguments as List<String>;
  }
}

import 'package:flutter/material.dart';

import 'argument_view.dart';
import 'environment_view.dart';
import 'feedback_view.dart';
import 'file_view.dart';
import 'routes.dart';

void main(List<String> args) {
  runApp(
    MaterialApp(
      title: 'Sentry FBD',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: HomePage(args: args),
      routes: {
        Routes.file: (context) => FileView.create(Arguments.of(context).single),
        Routes.feedback: (context) => FeedbackView.create(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.args});

  final List<String> args;

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
          ArgumentView.create(args),
          EnvironmentView.create(),
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

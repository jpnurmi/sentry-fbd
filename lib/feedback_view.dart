import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'feedback_view_model.dart';
import 'routes.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FeedbackViewModel>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Sentry FBD'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Environment',
            onPressed: () => Navigator.pushNamed(context, Routes.environment),
          ),
          IconButton(
            icon: const Icon(Icons.mail),
            tooltip: 'Envelope',
            onPressed: () => Navigator.pushNamed(context, Routes.envelope),
          ),
        ],
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: viewModel.name,
            decoration: InputDecoration(label: Text('Name')),
          ),
          TextFormField(
            controller: viewModel.email,
            decoration: InputDecoration(label: Text('Email')),
          ),
          TextFormField(
            controller: viewModel.feedback,
            decoration: InputDecoration(label: Text('Feedback')),
            maxLines: 5,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) =>
                value?.trim().isNotEmpty == true ? null : 'Required',
          ),
        ].separated(const SizedBox(height: 16)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.isValid ? viewModel.submit : null,
        child: const Icon(Icons.send),
      ),
    );
  }
}

extension on Iterable<Widget> {
  List<Widget> separated(Widget separator) {
    return expand((item) sync* {
      yield separator;
      yield item;
    }).skip(1).toList();
  }
}

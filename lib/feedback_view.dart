import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'feedback_view_model.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => FeedbackViewModel(),
      child: const FeedbackView(),
    );
  }

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  @override
  void initState() {
    super.initState();
    context.read<FeedbackViewModel>().init();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FeedbackViewModel>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Feedback (${viewModel.eventId ?? '\$SENTRY_EVENT_ID'})'),
            Text(
              viewModel.dsn ?? '\$SENTRY_DSN',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            initialValue: viewModel.name,
            decoration: InputDecoration(label: Text('Name')),
            onChanged: viewModel.setName,
          ),
          TextFormField(
            initialValue: viewModel.email,
            decoration: InputDecoration(label: Text('Email')),
            onChanged: viewModel.setEmail,
          ),
          TextFormField(
            initialValue: viewModel.feedback,
            decoration: InputDecoration(label: Text('Feedback')),
            onChanged: viewModel.setFeedback,
            maxLines: 5,
            autovalidateMode: AutovalidateMode.always,
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

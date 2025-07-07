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
  void initState() {
    super.initState();
    final vm = context.read<FeedbackViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FeedbackViewModel>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Sentry FBD'),
        actions: [
          if (vm.envelope != null)
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
            controller: vm.name,
            decoration: InputDecoration(label: Text('Name')),
          ),
          TextFormField(
            controller: vm.email,
            decoration: InputDecoration(label: Text('Email')),
          ),
          TextFormField(
            controller: vm.feedback,
            decoration: InputDecoration(label: Text('Feedback')),
            maxLines: 5,
            autovalidateMode: AutovalidateMode.always,
            validator: (value) =>
                value?.trim().isNotEmpty == true ? null : 'Required',
          ),
        ].separated(const SizedBox(height: 16)),
      ),
      floatingActionButton: vm.isAvailable
          ? FloatingActionButton(
              onPressed: vm.isValid ? vm.submit : null,
              tooltip: vm.isValid ? 'Submit' : null,
              child: const Icon(Icons.send),
            )
          : null,
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

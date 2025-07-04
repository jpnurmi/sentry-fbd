import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'environment_view_model.dart';

class EnvironmentView extends StatefulWidget {
  const EnvironmentView({super.key});

  @override
  State<EnvironmentView> createState() => _EnvironmentViewState();
}

class _EnvironmentViewState extends State<EnvironmentView> {
  final _controller = TextEditingController(text: 'SENTRY');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EnvironmentViewModel>();
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: TextField(
            controller: _controller,
            onChanged: viewModel.filter,
            decoration: InputDecoration(
              labelText: 'Environment',
              suffixIcon: _controller.text.isEmpty
                  ? Icon(Icons.search)
                  : IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        viewModel.filter('');
                      },
                    ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            ),
          ),
        ),
        SliverList.separated(
          itemCount: viewModel.length,
          itemBuilder: (context, index) {
            return ListTile(
              dense: true,
              title: SelectableText(
                viewModel.key(index),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: SelectableText(viewModel.value(index) ?? ''),
            );
          },
          separatorBuilder: (_, _) => const Divider(height: 1, thickness: 1),
        ),
      ],
    );
  }
}

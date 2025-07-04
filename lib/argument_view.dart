import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'argument_view_model.dart';
import 'routes.dart';

class ArgumentView extends StatefulWidget {
  const ArgumentView({super.key});

  static Widget create(List<String> args) {
    return ChangeNotifierProvider(
      create: (_) => ArgumentViewModel(args),
      child: const ArgumentView(),
    );
  }

  @override
  State<ArgumentView> createState() => _ArgumentViewState();
}

class _ArgumentViewState extends State<ArgumentView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ArgumentViewModel>();
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: TextField(
            controller: _controller,
            onChanged: viewModel.filter,
            decoration: InputDecoration(
              labelText: 'Arguments',
              suffixIcon: _controller.text.isEmpty
                  ? const Icon(Icons.search)
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        viewModel.filter('');
                      },
                    ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: viewModel.args.map((arg) {
                return Chip(
                  label: SelectableText('$arg'),
                  deleteIcon: const Icon(Icons.chevron_right),
                  deleteButtonTooltipMessage: '',
                  onDeleted: arg.isFile
                      ? () => Navigator.pushNamed(
                          context,
                          Routes.envelope,
                          arguments: [arg.value],
                        )
                      : null,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

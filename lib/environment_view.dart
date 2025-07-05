import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'environment_view_model.dart';

class EnvironmentView extends StatefulWidget {
  const EnvironmentView({super.key});

  @override
  State<EnvironmentView> createState() => _EnvironmentViewState();
}

class _EnvironmentViewState extends State<EnvironmentView> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = context.read<EnvironmentViewModel>().init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EnvironmentViewModel>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: TextField(
          controller: _controller,
          onChanged: vm.filter,
          decoration: InputDecoration(
            labelText: 'Environment',
            suffixIcon: _controller.text.isEmpty
                ? Icon(Icons.search)
                : IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      vm.filter('');
                    },
                  ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: vm.length,
        itemBuilder: (context, index) {
          return ListTile(
            dense: true,
            title: SelectableText(
              vm.key(index),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: SelectableText(vm.value(index) ?? ''),
          );
        },
        separatorBuilder: (_, _) => const Divider(height: 1, thickness: 1),
      ),
    );
  }
}

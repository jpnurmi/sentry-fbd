import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:highlight/languages/json.dart' as highlight;
import 'package:provider/provider.dart';

import 'envelope_view_model.dart';

class EnvelopeView extends StatefulWidget {
  const EnvelopeView({super.key});

  @override
  State<EnvelopeView> createState() => _EnvelopeViewState();
}

class _EnvelopeViewState extends State<EnvelopeView> {
  final _controller = CodeController(language: highlight.json);

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<EnvelopeViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.init().then((content) {
        _controller.text = content.toString();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EnvelopeViewModel>();
    final styles = CodeStyles.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(viewModel.basename, overflow: TextOverflow.ellipsis),
            Text(
              viewModel.dirname,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      backgroundColor: styles['root']?.backgroundColor,
      body: SingleChildScrollView(
        child: CodeTheme(
          data: CodeThemeData(styles: styles),
          child: CodeField(
            controller: _controller,
            readOnly: true,
            wrap: true,
          ),
        ),
      ),
    );
  }
}

class CodeStyles {
  static Map<String, TextStyle> of(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return atomOneDarkTheme;
    } else {
      return atomOneLightTheme;
    }
  }
}

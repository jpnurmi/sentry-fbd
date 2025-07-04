import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:highlight/languages/json.dart' as highlight;
import 'package:provider/provider.dart';

import 'envelope_view_model.dart';

class EnvelopeView extends StatefulWidget {
  const EnvelopeView(this.path, {super.key});

  final String path;

  @override
  State<EnvelopeView> createState() => _EnvelopeViewState();
}

class _EnvelopeViewState extends State<EnvelopeView> {
  final _controller = CodeController(language: highlight.json);

  @override
  void initState() {
    super.initState();
    final model = context.read<EnvelopeViewModel>();
    model
        .load(widget.path)
        .then((_) => _controller.text = model.envelope.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EnvelopeViewModel>();
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
      body: SingleChildScrollView(
        child: CodeTheme(
          data: CodeThemeData(
            styles: CodeStyles.of(context),
          ),
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

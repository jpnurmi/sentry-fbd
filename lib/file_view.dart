import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:provider/provider.dart';

import 'file_view_model.dart';

class FileView extends StatefulWidget {
  const FileView({super.key});

  static Widget create(String filePath) {
    return ChangeNotifierProvider(
      create: (_) => FileViewModel(filePath),
      child: FileView(),
    );
  }

  @override
  State<FileView> createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {
  final _controller = CodeController();

  @override
  void initState() {
    super.initState();
    final model = context.read<FileViewModel>();
    model.init().then(
      (_) {
        _controller.text = model.content;
        _controller.language = model.language;
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FileViewModel>();
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

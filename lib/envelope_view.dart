import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlight/languages/json.dart' as highlight;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'envelope.dart';
import 'envelope_view_model.dart';

class EnvelopeView extends StatefulWidget {
  const EnvelopeView({super.key});

  @override
  State<EnvelopeView> createState() => _EnvelopeViewState();
}

class _EnvelopeViewState extends State<EnvelopeView> {
  Future<void> _copyFilePath() async {
    final messenger = ScaffoldMessenger.of(context);
    final vm = context.read<EnvelopeViewModel>();
    await Clipboard.setData(ClipboardData(text: vm.filePath));
    messenger.showSnackBar(
      SnackBar(
        content: Text('Copied "${vm.filePath}"'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<bool> _launchFilePath() async {
    final vm = context.read<EnvelopeViewModel>();
    return launchUrl(Uri.file(vm.filePath));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EnvelopeViewModel>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(vm.basename, overflow: TextOverflow.ellipsis),
            Text(
              vm.dirname,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
        actions: [
          IconButton(
            tooltip: 'Copy',
            onPressed: vm.filePath.isNotEmpty ? _copyFilePath : null,
            icon: Icon(Icons.copy),
          ),
        ],
      ),
      body: EnvelopeListView(envelope: vm.envelope),
      floatingActionButton: FloatingActionButton(
        onPressed: vm.filePath.isNotEmpty ? _launchFilePath : null,
        tooltip: 'Open',
        child: const Icon(Icons.open_in_new),
      ),
    );
  }
}

class EnvelopeListView extends StatefulWidget {
  const EnvelopeListView({super.key, required this.envelope});

  final Envelope? envelope;

  @override
  State<EnvelopeListView> createState() => _EnvelopeListViewState();
}

class _EnvelopeListViewState extends State<EnvelopeListView> {
  late final _expanded = List.generate(
    widget.envelope?.items.length ?? 0,
    (index) => false,
  );

  @override
  Widget build(BuildContext context) {
    final styles = CodeStyles.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          EnvelopeCodeView(code: widget.envelope!.formatHeader()),
          Divider(thickness: 1, height: 1),
          ExpansionPanelList(
            expandedHeaderPadding: EdgeInsets.zero,
            expansionCallback: (index, isExpanded) {
              setState(() => _expanded[index] = isExpanded);
            },
            children: [
              for (var i = 0; i < (widget.envelope?.items.length ?? 0); ++i)
                ExpansionPanel(
                  isExpanded: _expanded[i],
                  backgroundColor: styles['root']?.backgroundColor,
                  headerBuilder: (context, isExpanded) {
                    return EnvelopeCodeView(
                      code: widget.envelope!.formatItem(i),
                    );
                  },
                  body: _expanded[i]
                      ? EnvelopeCodeView(
                          code: widget.envelope!.formatPayload(i),
                        )
                      : SizedBox.shrink(),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class EnvelopeCodeView extends StatefulWidget {
  const EnvelopeCodeView({
    super.key,
    required this.code,
  });

  final String code;

  @override
  State<EnvelopeCodeView> createState() => _EnvelopeCodeViewState();
}

class _EnvelopeCodeViewState extends State<EnvelopeCodeView> {
  late final _controller = CodeController(
    language: widget.code.startsWith('{') ? highlight.json : null,
    text: widget.code,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CodeTheme(
      data: CodeThemeData(styles: CodeStyles.of(context)),
      child: CodeField(
        controller: _controller,
        lineNumbers: false,
        readOnly: true,
        textStyle: GoogleFonts.sourceCodePro(),
        wrap: true,
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

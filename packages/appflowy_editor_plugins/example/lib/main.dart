import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:appflowy_editor_plugins/appflowy_editor_plugins.dart';

void main() {
  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plugins',
      theme: ThemeData.light(),
      home: const Editor(),
    );
  }
}

class Editor extends StatefulWidget {
  const Editor({super.key});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  late final EditorState editorState;
  late final List<CharacterShortcutEvent>? shortcutEvents;
  late final List<CommandShortcutEvent>? commandEvents;
  late final Map<String, BlockComponentBuilder>? blockComponentBuilders;

  @override
  void initState() {
    super.initState();
    editorState = EditorState(
      document: Document.fromJson(jsonDecode(_initialDocumentData)),
    );

    shortcutEvents = [
      ...codeBlockCharacterEvents,
      ...standardCharacterShortcutEvents,
    ];

    commandEvents = [
      ...codeBlockCommands(),
      ...standardCommandShortcutEvents.where(
        (event) => event != pasteCommand, // Remove standard paste command
      ),
      linkPreviewCustomPasteCommand, // Add link preview paste command
      convertUrlToLinkPreviewBlockCommand,
    ];

    blockComponentBuilders = {
      ...standardBlockComponentBuilderMap,
      CodeBlockKeys.type: CodeBlockComponentBuilder(
        editorState: editorState,
        configuration: BlockComponentConfiguration(
          textStyle: (_) => const TextStyle(
            fontFamily: 'RobotoMono',
            fontSize: 14,
            height: 1.5,
          ),
        ),
        style: CodeBlockStyle(
          backgroundColor: Colors.grey[200]!,
          foregroundColor: Colors.blue,
        ),
        actions: CodeBlockActions(
          onCopy: (code) => Clipboard.setData(ClipboardData(text: code)),
        ),
      ),
      LinkPreviewBlockKeys.type: LinkPreviewBlockComponentBuilder(
        showMenu: true,
        menuBuilder: (context, node, state) => Positioned(
          top: 8,
          right: 4,
          child: SizedBox(
            height: 32.0,
            child: InkWell(
              borderRadius: BorderRadius.circular(4.0),
              onTap: () => Clipboard.setData(ClipboardData(
                  text: node.attributes[LinkPreviewBlockKeys.url])),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.copy, size: 18.0),
              ),
            ),
          ),
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppFlowyEditor(
        editorState: editorState,
        characterShortcutEvents: shortcutEvents,
        commandShortcutEvents: commandEvents,
        blockComponentBuilders: blockComponentBuilders,
      ),
    );
  }
}

const _initialDocumentData = """{
  "document": {
    "type": "page",
    "children": [
      {
        "type": "paragraph",
        "data": {"delta": []}
      },
      {
        "type": "code",
        "data": {"delta": []}
      },
      {
        "type": "paragraph",
        "data": {"delta": []}
      }
    ]
  }
}""";

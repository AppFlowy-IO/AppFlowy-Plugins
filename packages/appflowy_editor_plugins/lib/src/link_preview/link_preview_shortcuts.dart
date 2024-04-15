import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:appflowy_editor_plugins/appflowy_editor_plugins.dart';
import 'package:string_validator/string_validator.dart';

/// try to convert the pasted url to a link preview block, only works
///   if the selected block is a paragraph block and the url is valid
///
/// - support
///   - desktop
///   - mobile
///   - web
///
final CommandShortcutEvent convertUrlToLinkPreviewBlockCommand =
    CommandShortcutEvent(
  key: 'convert url to link preview block',
  getDescription: () => 'Convert the pasted url to a link preview block',
  command: 'ctrl+v',
  macOSCommand: 'cmd+v',
  handler: _convertUrlToLinkPreviewBlockCommandHandler,
);

KeyEventResult _convertUrlToLinkPreviewBlockCommandHandler(
  EditorState editorState,
) {
  final selection = editorState.selection;
  if (selection == null ||
      !selection.isCollapsed ||
      selection.startIndex != 0) {
    return KeyEventResult.ignored;
  }

  final node = editorState.getNodeAtPath(selection.start.path);
  if (node == null || node.type != ParagraphBlockKeys.type) {
    return KeyEventResult.ignored;
  }

  () async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final url = data?.text;
    if (url == null || !isURL(url)) {
      return pasteCommand.execute(editorState);
    }

    final transaction = editorState.transaction;
    transaction.insertNode(
      selection.start.path,
      linkPreviewNode(url: url),
    );
    await editorState.apply(transaction);
  }();

  return KeyEventResult.handled;
}

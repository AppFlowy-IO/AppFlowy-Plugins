import 'dart:io';

import 'package:flutter/material.dart';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:appflowy_editor_plugins/src/video_block/resizable_video_player.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

class VideoBlockKit {
  static void ensureInitialized() => MediaKit.ensureInitialized();
}

Node videoBlockNode({
  String? src,
  double? width,
}) {
  final attributes = {
    VideoBlockKeys.url: src,
    VideoBlockKeys.width: width ?? 320,
  };
  return Node(type: VideoBlockKeys.type, attributes: attributes);
}

// Code block menu item for selection
SelectionMenuItem videoBlockItem(
  String name, [
  IconData icon = Icons.video_file,
  List<String> keywords = const ['video', 'videoblock', 'player'],
  String? src,
]) =>
    SelectionMenuItem.node(
      getName: () => name,
      iconData: icon,
      keywords: keywords,
      nodeBuilder: (_, __) => videoBlockNode(src: src),
      replace: (_, node) => node.delta?.isEmpty ?? false,
    );

class VideoBlockKeys {
  const VideoBlockKeys._();

  static const String type = 'video';

  /// The video src. (URL to the video file)
  ///
  /// The value is a [String].
  ///
  static const String url = 'url';

  /// The height of a video block.
  ///
  /// The value is a [double].
  ///
  static const String width = 'width';

  /// The alignment of a video block.
  ///
  /// The value is a [String], accepted values are:
  /// 'left', 'right', and 'center'.
  ///
  static const String alignment = 'alignment';
}

typedef VideoBlockComponentMenuBuilder = Widget Function(
  Node node,
  VideoBlockComponentState state,
);

class VideoBlockComponentBuilder extends BlockComponentBuilder {
  VideoBlockComponentBuilder({
    super.configuration,
    this.showMenu = false,
    this.menuBuilder,
  });

  /// Whether to show the menu of this block component.
  final bool showMenu;

  final VideoBlockComponentMenuBuilder? menuBuilder;

  @override
  BlockComponentWidget build(BlockComponentContext blockComponentContext) {
    final node = blockComponentContext.node;
    return VideoBlockComponent(
      key: node.key,
      node: node,
      showActions: showActions(node),
      configuration: configuration,
      actionBuilder: (_, state) => actionBuilder(blockComponentContext, state),
      showMenu: showMenu,
      menuBuilder: menuBuilder,
    );
  }

  @override
  bool validate(Node node) => node.delta == null && node.children.isEmpty;
}

class VideoBlockComponent extends BlockComponentStatefulWidget {
  const VideoBlockComponent({
    super.key,
    required super.node,
    super.showActions,
    super.actionBuilder,
    super.configuration = const BlockComponentConfiguration(),
    this.showMenu = false,
    this.menuBuilder,
  });

  /// Whether to show the menu of this block component.
  final bool showMenu;

  final VideoBlockComponentMenuBuilder? menuBuilder;

  @override
  State<VideoBlockComponent> createState() => VideoBlockComponentState();
}

class VideoBlockComponentState extends State<VideoBlockComponent>
    with SelectableMixin, BlockComponentConfigurable {
  @override
  BlockComponentConfiguration get configuration => widget.configuration;

  @override
  Node get node => widget.node;

  final videoKey = GlobalKey();
  RenderBox? get _renderBox => context.findRenderObject() as RenderBox?;

  late final editorState = Provider.of<EditorState>(context, listen: false);

  final showActionsNotifier = ValueNotifier<bool>(false);

  bool alwaysShowMenu = false;

  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    final src = node.attributes[VideoBlockKeys.url];
    if (src == null || src.isEmpty || !_checkIfURLIsValid(src)) {
      return;
    }

    player
      ..open(Media(src))
      ..pause();

    if (PlatformExtension.isMobile) {
      alwaysShowMenu = true;
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final node = widget.node;
    final attributes = node.attributes;
    final src = attributes[VideoBlockKeys.url];
    final alignment = AlignmentExtension.fromString(
      attributes[VideoBlockKeys.alignment] ?? 'center',
    );

    final width = attributes[VideoBlockKeys.width]?.toDouble() ??
        MediaQuery.of(context).size.width;

    Widget child;
    if (src.isEmpty) {
      child = const Text('Placeholder');
    } else if (!_checkIfURLIsValid(src)) {
      child = const Text('Unsupported source');
    } else {
      child = ResizableVidePlayer(
        src: src,
        editable: editorState.editable,
        width: width,
        alignment: alignment,
        controller: controller,
        onResize: (width) {
          final transaction = editorState.transaction
            ..updateNode(node, {VideoBlockKeys.width: width});
          editorState.apply(transaction);
        },
      );
    }

    if (widget.showActions && widget.actionBuilder != null) {
      child = BlockComponentActionWrapper(
        node: node,
        actionBuilder: widget.actionBuilder!,
        child: child,
      );
    }

    if (widget.showMenu && widget.menuBuilder != null) {
      if (alwaysShowMenu) {
        child = Stack(
          children: [
            child,
            if (src.isNotEmpty == true) widget.menuBuilder!(node, this),
          ],
        );
      } else {
        child = MouseRegion(
          onEnter: (_) => showActionsNotifier.value = true,
          onExit: (_) {
            if (!alwaysShowMenu) {
              showActionsNotifier.value = false;
            }
          },
          hitTestBehavior: HitTestBehavior.opaque,
          opaque: false,
          child: ValueListenableBuilder<bool>(
            valueListenable: showActionsNotifier,
            builder: (_, value, child) => Stack(
              children: [
                child!,
                if (value && src.isNotEmpty == true)
                  widget.menuBuilder!(widget.node, this),
              ],
            ),
            child: child,
          ),
        );
      }
    }

    return child;
  }

  @override
  Position start() => Position(path: widget.node.path);

  @override
  Position end() => Position(path: widget.node.path, offset: 1);

  @override
  Position getPositionInOffset(Offset start) => end();

  @override
  bool get shouldCursorBlink => false;

  @override
  CursorStyle get cursorStyle => CursorStyle.cover;

  @override
  Rect getBlockRect({bool shiftWithBaseOffset = false}) {
    final videoBox = videoKey.currentContext?.findRenderObject();
    if (videoBox is RenderBox) {
      return Offset.zero & videoBox.size;
    }
    return Rect.zero;
  }

  @override
  Rect? getCursorRectInPosition(
    Position position, {
    bool shiftWithBaseOffset = false,
  }) {
    final rects = getRectsInSelection(Selection.collapsed(position));
    return rects.firstOrNull;
  }

  @override
  List<Rect> getRectsInSelection(
    Selection selection, {
    bool shiftWithBaseOffset = false,
  }) {
    if (_renderBox == null) {
      return [];
    }
    final parentBox = context.findRenderObject();
    final videoBox = videoKey.currentContext?.findRenderObject();
    if (parentBox is RenderBox && videoBox is RenderBox) {
      return [
        videoBox.localToGlobal(Offset.zero, ancestor: parentBox) &
            videoBox.size,
      ];
    }
    return [Offset.zero & _renderBox!.size];
  }

  @override
  Selection getSelectionInRange(Offset start, Offset end) => Selection.single(
        path: widget.node.path,
        startOffset: 0,
        endOffset: 1,
      );

  @override
  Offset localToGlobal(
    Offset offset, {
    bool shiftWithBaseOffset = false,
  }) =>
      _renderBox!.localToGlobal(offset);

  bool _checkIfURLIsValid(dynamic url) {
    if (url is! String) {
      return false;
    }

    if (url.isEmpty) {
      return false;
    }

    if (!isURL(url) && !File(url).existsSync()) {
      return false;
    }

    return true;
  }
}

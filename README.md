# AppFlowy Plugins

Powerful add-ons for the flexible and popular rich-text editor [AppFlowy Editor](https://pub.dev/packages/appflowy_editor) for Flutter.

## Available plugins

- [Code Block](https://github.com/AppFlowy-IO/appflowy-plugins/tree/main/packages/appflowy_editor_plugins/lib/src/code_block)
- [Link Preview Block](https://github.com/AppFlowy-IO/appflowy-plugins/tree/main/packages/appflowy_editor_plugins/lib/src/link_preview)
- [Video Block](https://github.com/AppFlowy-IO/appflowy-plugins/tree/main/packages/appflowy_editor_plugins/lib/src/video_block)

Looking for a plugin but cannot find it on the list? Submit a [Plugin request](https://github.com/AppFlowy-IO/AppFlowy-plugins/issues/new?assignees=&labels=&projects=&template=plugin_request.yaml&title=[Plugin%20request])!

## Melos

To make it easier to manage a federated package approach, we use [Melos](https://pub.dev/packages/melos). If you need to develop across multiple packages, you can bootstrap melos by running `melos bootstrap`.

To setup the `melos` CLI and make it globally available, run this command: `dart pub global activate melos`

Scripts available:

- `melos run analyze`: Run `dart analyze .` in all packages.
- `melos run format`: Run `dart format --set-exit-if-changed` in all packages.
- `melos run get`: Run `flutter pub get` in all packages.

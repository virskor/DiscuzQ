# clipboard_manager

simple flutter plugin to copy text to clipboard in both android and ios.

# Install

- Add `clipboard_manager` to your dependencies list in `pubspec.yaml` file
```yaml
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^0.1.2
  clipboard_manager: ^0.0.1
```
- Run `flutter packages get` from your root project

- import the package by `import 'package:clipboard_manager/clipboard_manager.dart';`


## Usage

```dart
ClipboardManager.copyToClipBoard("your text to copy").then((result) {
                        final snackBar = SnackBar(
                          content: Text('Copied to Clipboard'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {},
                          ),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      });

```

## Example

the plugin comes with an simplest example app. run it to see it in working.

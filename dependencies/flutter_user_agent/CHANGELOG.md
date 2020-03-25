# flutter_user_agent version history

## 1.2.1

* iOS user-agent database update. Specifically the iPhone XS, XR and 11 variants (thanks [@pravinarr](https://github.com/pravinarr)!)

## 1.2.0

* iOS deprecation API change.

    > ITMS-90809: Deprecated API Usage - Apple will stop accepting submissions of apps that use UIWebView APIs . See https://developer.apple.com/documentation/uikit/uiwebview for more information.
                           
  - Remove references to `UIWebView` as it's deprecated and currently stops app submissions to the App Store - [#3](https://github.com/j0j00/flutter_user_agent/issues/3) (thanks [@rodruiz](https://github.com/rodruiz)!)
  
  - The plugin will only work on iOS 8 and up.

## 1.1.0

* iOS API change for compatibility purposes.

  Change `UIWebView` (deprecated since iOS 12.0) to `WKWebView` - [#1](https://github.com/j0j00/flutter_user_agent/issues/1) (courtesy of [@Triipaxx](https://github.com/Triipaxx)!)

## 1.0.1

* API changes:
    * Make `FlutterUserAgent.init` cache user-agent properties by default, unless `force: true` is specified.
    * Add `FlutterUserAgent.getPropertyAsync` function for lazily fetching properties without having to call `FlutterUserAgent.init`.
    * Add `FlutterUserAgent.release` function for releasing all the user-agent properties temporarily statically stored in memory.
## 1.0.0

* Add flutter example to the project.

## 0.0.1

* Initial release.
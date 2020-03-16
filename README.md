# DiscuzQ Flutter Application
<p><img src="discuz/assets/images/logo.png"/>  </p> 

### 实现目标
基本上和官方版本是保持一致的，只是会增加黑暗模式，主题颜色，字体大小等设置罢了。
<p><img width="200px" src="snapshot.png"/>  </p> 
A new Flutter application for DiscuzQ. This Application is still under developing, this is an open source software.  

If you have any question about this project, follow and post an issue. I will consit to write this application.

## 还在开发和版权说明
现在还在开发，不是最终功能  
第三方APP，与Discuz无关，不代表Dz团队，仅做个人学习使用。该Flutter APP将不考虑支持Web。  
该APP现在处于开发阶段，暂时不推荐clone并编译，后续编排改动都很大，直到release前暂不要使用这些代码。  

## 一些隐藏的功能
有的时候因为不同需要，有的功能可能开发了，但是并没有直接启用，因为这些功能取决于你的后端情况或者偏好。
### HTTP2的支持
默认情况下APP没有开启HTTP2请求，如果你的站点开启了HTTP2，那么你可以使用这个特性。在./utils/request/Request.dart中找到下面的代码进行注释解除。   
```dart
/// import 'package:dio_http2_adapter/dio_http2_adapter.dart';

    /// http2支持，如果你开启了HTTP2，那么移除注释，默认情况下是不启用的
    // _dio.httpClientAdapter = Http2Adapter(
    //   ConnectionManager(
    //     idleTimeout: 10000,

    //     /// Ignore bad certificate
    //     onClientCreate: (_, clientSetting) =>
    //         clientSetting.onBadCertificate = (_) => true,
    //   ),
    // );

```

## 注意
This application dose not have released any version. checkout dev branch to get latest version or contribute it. Thanks.  
This is an third party software.  
Find API document at: https://discuz.chat/api-docs/v1/

Please add this code into your stateful widget  
```dart
@override
void setState(fn) {
    if (!mounted) {
        return;
    }
    super.setState(fn);
}

@override
void initState() {
    super.initState();
}

@override
void dispose() {
    super.dispose();
}
```

### 启动调试
你可以使用命令行开启调试，如果你使用android studio，你可以直接运行。  
```sh
cd ./discuz
flutter run
```
项目中的 ./dependencies 本地化了一些依赖，这些依赖有改动所以没有直接使用pub.dev中的进行安装。  

## 如何自定义主体颜色，字体大小
App自设计开始就设计了支持主题模式，所以你可以在lib/ui/ui.dart修改对应的参数，在lib/utils/global.dart中修改对应的参数完整定制。  
使用命令行一键生成APP的图标和启动图(todo)。

### 如何自动生成Android 和 IOS 的应用图标
我们使用了flutter_launcher_icons， 这使得你可以快速生成一个自己的App图标，但是这样一来你就不可以改变默认的工程配置。   
详细的办法参考：https://pub.dev/packages/flutter_launcher_icons   
我们已经在pubspec.yaml添加了相关配置，你需要做的就是替换 assets/images/app.png
注意，图片不能包含alpha通道否则会导致Appstore上架失败等，生成图标时，在项目目录运行命令即可自动生成，无需其他操作。   
```sh
flutter pub run flutter_launcher_icons:main
# or
# cd ./discuz
# bash icon
```

### 如何自动生成Android 和 IOS的启动图
和生成图标一样，超级简单。我们已经在pubspec.yaml添加了相关配置，你需要做的就是替换 assets/images/splash.png。然后在运行下面的命令行就可以啦！ 

```sh
flutter pub pub run flutter_native_splash:create
# or
# cd ./discuz
# bash splash
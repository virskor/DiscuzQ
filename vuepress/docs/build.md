# 快速构建一个APP
构建一个APP非常简单，只需要按照Flutter的编译方式来进行编译即可。但是需要注意的是，如果你之前没有过Flutter的开发经验，那么您可以参照下面的过程来完成构建。

## Flutter安装
你需要安装Flutter的开发环境。下载[Flutter](http://flutter.dev/)时你可以直接下载Stable，或者Beta。而我们要用到的可能是Beta，若Flutter当前的稳定版本大于V1.15，那么你可以直接使用稳定版，而无需切换到Beta版本。  
如果您下载的版本是Stable，那么请参照下面的命令行切换到Beta
```sh
flutter channel beta
```
现在，如果您是在中国国内的网络环境下使用Flutter，那么您有必要阅读下面[这些提示](https://www.jianshu.com/p/2bb9e155cc8c)来将Pub包管理工具的源切换。  
此外，在项目中的Gradle源也推荐切换，后面我们会提到。

## Clone代码
您可以到[Github](https://github.com/virskor/DiscuzQ)克隆源代码到您的本机，但请确保已经安装GIT.
```
git clone https://github.com/virskor/DiscuzQ
```
现在我们进入源代码目录，注意：项目代码在 ./DiscuzQ/discuz 目录下，其他目录不用理会，编译或者开发时参考的代码在此目录。  
安装依赖，这个过程可能漫长但取决于你的网络环境
```
cd DiscuzQ/discuz
flutter pub get
```

## 修改build.yaml
在生产或者开发时你可能需要访问不同的业务后端域名。现在你可以更改或者输入下面的信息到 ./discuz/build.yaml。但在这之前请先打开 ./discuz/build.yaml中的文件描述，来确定这些设置的作用或者关于风险的描述。   
每个项目都不可以缺少下面的配置信息，其他的信息可以忽略，或者在后面不断开发的过程中你可以自定义。  
实际上build的过程中，你可以在build script构建过程中重新生成一个build.yaml完成快速构建，这个build.yaml在生产时仅需要包含production 下配置描述，或者只选其中一个选项来覆盖APP默认BuildInfo模型的数据。  
https://self-signed.badssl.com/
```yaml
development:
  domain: https://example.chat
  appname: DiscuzQ
  ## DO NOT ENABLE THIS ITEM WHEN YOU ARE BUILD AN APPLICATION FOR YOUR USERS
  enablePerformanceOverlay: false
# 构建生产环境的APP时加载的信息
# Parameters for building prodution package
production:
  domain: https://discuz.chat
  appname: DiscuzQ
  ## DO NOT ENABLE THIS ITEM WHEN YOU ARE BUILD AN APPLICATION FOR YOUR USERS
  enablePerformanceOverlay: false
```
### HTTP2的支持
build.yaml 中有可选参数，默认情况下HTTP2将不被开启，需要更改build.yaml中的设置，例:
```yaml
production:
  # 开启HTTP2 有链接复用、头部压缩、二进制传输、服务端推送等重多特性
  # 暂时不建议开启，因Flutter HTTP2实测下来PUT 或者一些情况下，根本无法完成请求
  # 你可能会获得 flutter: HTTP/2 error: Stream error: Stream was terminated by peer (errorCode: 1). 的错误
  enableHttp2: false
  # 证书无法校验时，是否继续请求(忽略非法的证书)
  # 注意 onBadCertificate 即便没有开启 HTTP2 的支援，也会作用的
  onBadCertificate: true 
  # 当请求完成时，连接默认继续保持15000 ms(15秒)，通过idleTimeout来自定义保持时间
  http2idleTimeout: 15000
```
### 金融相关的功能
实际上，现在我们还不支援这些特性，不过预先设计您可以在Build时，抹去这些功能和您实际情况所相符。  
现在不建议开启financial。

```yaml
production:
  # 钱包，等金融数字等功能都会被隐藏
  financial: false 
```
## 如何自定义主体颜色，字体大小
App自设计开始就设计了支持主题模式，所以你可以在lib/ui/ui.dart修改对应的参数，在lib/utils/global.dart中修改对应的参数完整定制。  
使用命令行一键生成APP的图标和启动图(todo)。

## 生成应用图标
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

## 生成启动图
和生成图标一样，超级简单。我们已经在pubspec.yaml添加了相关配置，你需要做的就是替换 assets/images/splash.png。然后在运行下面的命令行就可以啦！ 

```sh
flutter pub pub run flutter_native_splash:create
# or
# cd ./discuz
# bash splas
```

## Android 编译
我们推荐使用IOS模拟器开始你的调试，如果你Build Android版本，首先你需要生成一个keystore文件，存储到 ./discuz/android/目录下，并命名为android.keystore   
接下来，将同目录下的 key.properties.example 文件修改为 key.properties 并更新里面的签名配置内容。切记不要将其提交到Git，这些签名文件是涉及安全的。其次你还可以根据需要修改gradle文件，我们默认下使用了国内的源。
如果你无法Build，那么你可能需要更改Gradle 源 pub源，关于Pub源，建议搜索 flutter China相关内容。 gradle源，则需要注意下面的信息。  
我们使用了默认的源配置，但是我们也增加了国内源，建议根据情况修改 ./discuz/andorid/build.gradle 。 你可能需要重复尝试很多次，才能正常build，这取决于你的网络情况。
```gradle
repositories {
    // maven { url 'http://maven.aliyun.com/nexus/content/groups/public' }
    // maven{ url 'http://maven.aliyun.com/nexus/content/repositories/google'}
    // maven{ url 'http://maven.aliyun.com/nexus/content/repositories/jcenter'}
    google() // 使用国内源，解除上面的注释
    jcenter()
}
```

之后运行下面的命令行，将会生成APK，便可以用来发布。当然如果有需要你还可以加固。
```
flutter build apk --release
```

## IOS编译
值得注意，IOS编译时推荐使用Xcode进行Archive后上传，这样可以自动管理签名。当然也可以build，但这个过程繁琐。
首先你需要安装pod, xcode。
之后运行下面的命令
```
cd ./discuz
flutter build ios --release --flavor production --no-codesign --verbose

cd ./discuz/ios
xcodebuild -workspace ./Runner.xcworkspace -configuration Release-production -scheme production -destination 'generic/platform=iOS' -archivePath build/ios/iphoneos/Runner.xcarchive archive -allowProvisioningUpdates

xcodebuild -exportArchive -archivePath build/ios/iphoneos/Runner.xcarchive -exportPath build/ios/iphoneos -exportOptionsPlist Runner/info.plist
```

如果使用Xcode进行编译则
```
flutter clean
flutter pub get
```
之后再Xcode中，管理签名后，直接archive即可，当然你可以直接编译
```
flutter build ios --release --no-codesign
```
直接编译不签名时，需要注意设置use_frameworks!相关处理，在搜索引擎搜索，否则这个命令行将无法产出app
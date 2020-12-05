import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:core/widgets/common/gradientText.dart';
import 'package:core/widgets/common/discuzToast.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/widgets/common/discuzButton.dart';
import 'package:core/widgets/ui/ui.dart';

class ClearCacheDialog {
  static Future<bool> build({BuildContext context}) {
    return showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => Material(
          color: Colors.transparent,
              child: const ClearCache(),
            ));
  }
}

class ClearCache extends StatefulWidget {
  const ClearCache({Key key}) : super(key: key);

  @override
  _ClearCacheState createState() => _ClearCacheState();
}

class _ClearCacheState extends State<ClearCache> {
  int _cachedEntries = 0;

  @override
  void initState() {
    super.initState();
    _getCacheSize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: 330,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: DiscuzApp.themeOf(context).backgroundColor,
            borderRadius: const BorderRadius.all(const Radius.circular(15))),
        child: _buildClearCacheView(),
      );

  /*
   * @description: get cachedSize
   * @param {type} 
   * @return: 
   * @Author: virs
   * @Date: 2019-08-26 18:15:04
   */
  void _getCacheSize() {
    int cachedImageSize = imageCache.currentSize;
    setState(() {
      _cachedEntries = cachedImageSize;
    });
  }

  /*
   * @description: build clear cache view
   * @param {type} 
   * @return: 
   * @Author: virs
   * @Date: 2019-08-26 17:28:50
   */
  Widget _buildClearCacheView() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //show cached Size,
              _cacheSize(),
              // notice Text
              _noticeText()
            ],
          ),
        ),
        _clearButton()
      ],
    );
  }

  Widget _cacheSize() => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GradientText(
            _cachedEntries == 0 ? '暂无' : _cachedEntries.toString(),
            gradient: LinearGradient(colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(.66),
              Theme.of(context).primaryColor.withOpacity(.46),
            ]),
            style: TextStyle(
                textBaseline: TextBaseline.ideographic,
                fontSize: 40,
                fontFamily: 'Roboto Condensed'),
          ),
          GradientText(
            "/个文件",
            gradient: LinearGradient(colors: [
              Colors.grey,
              Colors.grey.withOpacity(.66),
              Colors.grey.withOpacity(.46),
            ]),
            style: TextStyle(
                textBaseline: TextBaseline.ideographic,
                fontSize: 30,
                fontFamily: 'Roboto Condensed'),
          ),
        ],
      );

  Widget _noticeText() => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: <Widget>[
            const DiscuzText(
              '应用图片或数据缓存将被清空',
            ),
            const DiscuzText(
              '若下次打开可能将耗费些流量',
            ),
          ],
        ),
      );

  Widget _clearButton() => Padding(
        padding: const EdgeInsets.all(20),
        child: DiscuzButton(
          label: '立即清除',
          onPressed: () async {
            try {
              await DefaultCacheManager().emptyCache();
              imageCache.clear();
            } catch (e) {
              throw e;
            }

            DiscuzToast.toast(context: context, message: '清理完毕');
            Navigator.pop(context, true);
          },
        ),
      );
}

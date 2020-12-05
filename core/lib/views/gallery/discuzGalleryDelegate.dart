import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/widgets/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'package:core/widgets/appbar/appbarExt.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/utils/global.dart';

class DiscuzGalleryDelegate extends StatefulWidget {
  final List<String> gallery;

  const DiscuzGalleryDelegate({this.gallery});
  @override
  _DiscuzGalleryState createState() => _DiscuzGalleryState();
}

class _DiscuzGalleryState extends State<DiscuzGalleryDelegate> {
  final UniqueKey _uniqueKey = UniqueKey();

  ///
  /// 页面控制器
  ///
  final PageController _pageController = PageController();

  ///
  /// state
  /// 状态
  int _indexPage = 1;

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

    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

    _pageController.addListener(() {
      final int currentPage = _pageController.page.round() + 1;
      if (currentPage == _indexPage) {
        return;
      }

      setState(() {
        _indexPage = currentPage;
      });
    });
  }

  @override
  void dispose() {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _uniqueKey,
      backgroundColor: Colors.black,
      appBar: DiscuzAppBar(
        title: '图集',
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        elevation: 1,
        dark: true,
        actions: <Widget>[_action(context: context)],
      ),
      body: _buildBody(context: context),
    );
  }

  Widget _action({BuildContext context}) => Row(
        children: <Widget>[
          DiscuzText(
            _indexPage.toString(),
            color: DiscuzApp.themeOf(context).primaryColor,
            fontFamily: 'Roboto Condensed',
            fontWeight: FontWeight.bold,
            fontSize: DiscuzApp.themeOf(context).largeTextSize,
          ),
          DiscuzText(
            '/',
            color: Colors.white,
          ),
          DiscuzText(
            widget.gallery == null ? '0' : widget.gallery.length.toString(),
            color: Colors.white,
            fontFamily: 'Roboto Condensed',
            fontSize: DiscuzApp.themeOf(context).smallTextSize,
          ),
          const SizedBox(width: 20),
        ],
      );

  Widget _buildBody({BuildContext context}) {
    if (widget.gallery == null || widget.gallery.length == 0) {
      return const Center(
        child: DiscuzText('没有可用于查看的图片', color: Colors.white),
      );
    }

    return Container(
        child: PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) => PhotoViewGalleryPageOptions(
        imageProvider: CachedNetworkImageProvider(
          widget.gallery[index],
          headers: {"Referer": Global.domain},
        ),
        initialScale: PhotoViewComputedScale.contained * 0.8,
        heroAttributes: PhotoViewHeroAttributes(tag: index),
      ),
      itemCount: widget.gallery.length,
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes,
          ),
        ),
      ),
      //backgroundDecoration: widget.backgroundDecoration,
      pageController: _pageController,
      //onPageChanged: onPageChanged,
    ));
  }
}

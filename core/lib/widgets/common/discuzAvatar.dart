import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:core/utils/StringHelper.dart';
import 'package:core/widgets/common/discuzCachedNetworkImage.dart';
import 'package:core/providers/userProvider.dart';

class DiscuzAvatar extends StatelessWidget {
  final double size;
  final double circularRate;
  final String url;

  const DiscuzAvatar({Key key, this.size = 70, this.circularRate = 5, this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider user, Widget child) {
      ///
      /// 如果是指定url不要反悔scopedModel类型的Widget,因为头像多了将带来性能压力
      /// 注意这个要放在最上面，以避免别人的头像无法显示
      ///

      if (url != null && StringHelper.isEmpty(string: url)) {
        return _empty();
      }

      if (url != null) {
        return _cachedNetworkAvatar(url);
      }

      /// 用户头像,如果没有登录，返回一个空的
      if (user.user == null) {
        return _empty();
      }

      if (StringHelper.isEmpty(string: user.user.attributes.avatarUrl) ==
          true) {
        return _empty();
      }

      return _cachedNetworkAvatar(user.user.attributes.avatarUrl);
    });
  }

  /// 返回缓存的头像
  Widget _cachedNetworkAvatar(String avatarUrl) => ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(circularRate)),
      child: DiscuzCachedNetworkImage(
          imageUrl: avatarUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => _empty()));

  /// 用户未设置头像，刷新头像
  Widget _empty() => ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(circularRate)),
        child: Image.asset(
          'assets/images/noavatar.gif',
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
}

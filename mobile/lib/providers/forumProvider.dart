import 'package:flutter/foundation.dart';

import 'package:discuzq/models/forumModel.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
class ForumProvider with ChangeNotifier, DiagnosticableTreeMixin {
  ///
  /// forum 站点信息
  ///
  ForumModel _forum;
  ForumModel get forum => _forum;

  void updateForum(ForumModel forum) {
    _forum = forum;
    notifyListeners();
  }

  /// todo: 是否开启腾讯云验证码
  ///
  bool get isCaptchaEnabled => _forum == null
      ? false
      : (_forum.attributes.qcloud.qCloudCaptcha ?? false);

  /// todo: 是否开启腾讯短信验证码
  ///
  bool get isSMSEnabled =>
      _forum == null ? false : (_forum.attributes.qcloud.qCloudSMS ?? false);

  /// todo: 是否启用腾讯云LBS
  ///

  /// todo: 是否开启微信支付
}

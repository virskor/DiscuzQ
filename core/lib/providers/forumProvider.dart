import 'package:flutter/foundation.dart';

import 'package:core/models/forumModel.dart';

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
}

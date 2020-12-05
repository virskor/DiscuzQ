import 'package:flutter/foundation.dart';

import 'package:core/models/userModel.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
class UserProvider with ChangeNotifier, DiagnosticableTreeMixin {
  ///
  /// 已经登录的用户
  ///
  UserModel _user;
  UserModel get user => _user;
  bool get hadLogined => _user == null ? false : true;

  void updateUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void logout(){
    _user = null;
    notifyListeners();
  }
}

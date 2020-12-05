import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:core/utils/debouncer.dart';
import 'package:core/utils/global.dart';
import 'package:core/widgets/appbar/appbarExt.dart';
import 'package:core/widgets/common/discuzButton.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/widgets/common/discuzTextfiled.dart';
import 'package:core/widgets/common/discuzToast.dart';
import 'package:core/api/users.dart';
import 'package:core/models/userModel.dart';
import 'package:core/utils/authHelper.dart';
import 'package:core/providers/userProvider.dart';

class UserSignatureDelegate extends StatefulWidget {
  const UserSignatureDelegate();
  @override
  _UserSignatureDelegateState createState() => _UserSignatureDelegateState();
}

///
/// Max permitted edit length
const int _kSignatureLength = 140;

class _UserSignatureDelegateState extends State<UserSignatureDelegate> {
  ///
  /// Debouncer
  final Debouncer _debouncer = Debouncer(milliseconds: 270);

  /// Text editing controller
  final TextEditingController _controller = TextEditingController();
  ////
  /// state
  ///
  int _maxPermittedTextLength = _kSignatureLength;

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

    _initDefaultValue();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: DiscuzAppBar(
        title: '编辑个性签名',
        brightness: Brightness.light,
      ),
      body: Padding(
          padding: kBodyPaddingAll,
          child: Column(
            children: <Widget>[
              _UserSignatureNoticeBar(
                leftTextLength: _maxPermittedTextLength,
              ),
              const SizedBox(
                height: 20,
              ),
              _buildTextFiled(),
              _buildModifyButton(),
            ],
          )));

  /// Build Textfiled widget
  Widget _buildTextFiled() => DiscuzTextfiled(
        placeHolder: '请输入个性签名',
        maxLines: 10,
        maxLength: _kSignatureLength,
        controller: _controller,
        contentPadding: const EdgeInsets.all(0),
        onChanged: (String val) {
          /// 为了减少setState带来的性能损耗，所以使用debouncer减少rebuild
          _debouncer.run(() {
            ///
            /// 如果允许的长度小于0，那么就为0
            final int computeTextLengthPermitted =
                _kSignatureLength - val.length;
            setState(() {
              _maxPermittedTextLength = computeTextLengthPermitted < 0
                  ? 0
                  : computeTextLengthPermitted;
            });
          });
        },
      );

  ///
  /// Initialize user's default signature to auto complete form.
  Future<void> _initDefaultValue() async =>
      Future.delayed(Duration(milliseconds: 500)).then((_) {
        try {
          final UserModel user = context.read<UserProvider>().user;
          if (user != null && user.attributes.signature != '') {
            _controller.text = user.attributes.signature;
          }
        } catch (e) {
          throw e;
        }
      });

  ///
  /// Build modify button to modify signature
  Widget _buildModifyButton() => DiscuzButton(
        label: '提交',
        onPressed: _modify,
      );

  ///
  /// Request API to modify user's signature
  Future<void> _modify() async {
    if (_controller.text.isEmpty) {
      return DiscuzToast.toast(
          type: DiscuzToastType.failed,
          context: context,
          title: '失败',
          message: '请填写完整的签名后再提交');
    }

    final Function close = DiscuzToast.loading();

    try {
      final dynamic attributes = {"signature": _controller.text};

      final dynamic result = await UsersAPI(context: context)
          .updateProfile(attributes: attributes, context: context);

      close();

      if (result == null) {
        return;
      }

      /// 更新用户信息
      await AuthHelper.refreshUser(
          context: context, data: UserModel.fromMap(maps: result));
      DiscuzToast.toast(
        context: context,
        message: '个性签名修改成功',
        title: '成功',
      );

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } catch (e) {
      close();
      throw e;
    }
  }
}

class _UserSignatureNoticeBar extends StatefulWidget {
  _UserSignatureNoticeBar({this.leftTextLength = _kSignatureLength});

  final int leftTextLength;

  @override
  __UserSignatureNoticeBarState createState() =>
      __UserSignatureNoticeBarState();
}

class __UserSignatureNoticeBarState extends State<_UserSignatureNoticeBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const DiscuzText('我的签名'),
        DiscuzText('还能输入${widget.leftTextLength.toString()}个字')
      ],
    );
  }
}

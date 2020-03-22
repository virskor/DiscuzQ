import 'package:flutter/material.dart';

import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/states/appState.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/common/discuzAvatar.dart';
import 'package:discuzq/widgets/common/discuzLink.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/models/userModel.dart';

///
/// 用户主页顶部卡片
///
class UserHomeDelegateCard extends StatefulWidget {
  final UserModel user;

  UserHomeDelegateCard({Key key, @required this.user}) : super(key: key);

  @override
  _UserHomeDelegateCardState createState() => _UserHomeDelegateCardState();
}

class _UserHomeDelegateCardState extends State<UserHomeDelegateCard> {
  /// states
  ///
  /// follow， 意思是点击关注按钮，
  /// 如果用户点击了关注，那么就在他的已经关注的基础上加1
  /// 否则不管
  ///
  bool _followed = false;

  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) => AnimatedContainer(
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
                color: DiscuzApp.themeOf(context).backgroundColor),
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ///
                /// avatar
                Center(
                  child: Hero(
                    tag: 'heroAvatar',
                    child: DiscuzAvatar(
                      url: widget.user.avatarUrl,
                    ),
                  ),
                ),

                ///
                /// username
                const SizedBox(height: 10),
                DiscuzText(
                  widget.user.username,
                  fontSize: DiscuzApp.themeOf(context).mediumTextSize,
                  fontWeight: FontWeight.bold,
                ),

                _buildFollowsTag(state),
              ],
            ),
          ));

  ///
  /// todo:
  /// 关注
  ///
  Future<void> _requestToFollow() async {
    DiscuzToast.failed(context: context, message: '待完成');
    return;

    /// 反选
    /// 反选要在接口请求成功后再能执行
    setState(() {
      _followed = !_followed;
    });
  }

  ///
  /// 生成当前的关注数量
  /// 如果我点击了关注就加1，如果没有，就不加
  String _resetFollowedCount() =>
      (_followed == true ? widget.user.fansCount + 1 : widget.user.fansCount)
          .toString();

  ///
  /// todo:
  /// 如果是自己，那就不要显示了，如果是别人，那就显示
  /// 注意： 用户如果没有登，那么就不要显示
  /// 是否显示关注按钮
  ///
  List<Widget> _followButton(AppState state) => state.user == null
      ? <Widget>[]

      /// 用户未登录 不显示组件
      : state.user.id == widget.user.id
          ? <Widget>[]

          /// 查看的是自己 的账户，不显示关注按钮
          : <Widget>[
              const SizedBox(width: 10),
              DiscuzText(
                '|',
                color: Colors.grey,
              ),
              const SizedBox(width: 10),
              DiscuzLink(
                label: _followButtonLabel(),

                /// 动态文案
                onTap: _requestToFollow,
              )
            ];

  ///
  /// 关注按钮的文案
  /// 根据实际情况来显示关注按钮的文案，如果已经关注了，则显示取消否则关注
  ///
  String _followButtonLabel() =>
      _followed == true ? "取消关注" : widget.user.follow == 1 ? "取消关注" : "关注";

  ///
  /// 生成描述关注情况的概览
  ///
  Widget _buildFollowsTag(AppState state) => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            DiscuzText(
              '关注：${widget.user.followCount.toString()}',
              color: DiscuzApp.themeOf(context).greyTextColor,
            ),
            const SizedBox(width: 10),
            DiscuzText(
              '|',
              color: Colors.grey,
            ),
            const SizedBox(width: 10),
            DiscuzText(
              '被关注：${_resetFollowedCount()}',
              color: DiscuzApp.themeOf(context).greyTextColor,
            ),

            ///
            /// 显示关注按钮，该按钮要根据情况显示
            ///
            ..._followButton(state)
          ],
        ),
      );
}

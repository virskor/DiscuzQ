import 'package:flutter/material.dart';

import 'package:core/models/userModel.dart';
import 'package:core/widgets/ui/ui.dart';
import 'package:core/widgets/common/discuzAvatar.dart';
import 'package:core/widgets/common/discuzDivider.dart';
import 'package:core/widgets/common/discuzListTile.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/models/userFollowModel.dart';
import 'package:core/api/users.dart';

class UserFollowListTile extends StatefulWidget {
  ///
  /// 用于显示的用户
  final UserModel user;

  ///
  /// isToUser
  /// 是否查询关注用户数据
  /// 如果查询我关注的用户 isToUser == false 则查询粉丝用户数据即 fromUser
  /// 默认是true,即查询关注用户的数据
  final bool isToUser;

  ///
  /// 用户的关注模型
  final UserFollowModel userFollow;

  UserFollowListTile(
      {@required this.user,
      @required this.userFollow,
      @required this.isToUser});
  @override
  _UserFollowListTileState createState() => _UserFollowListTileState();
}

class _UserFollowListTileState extends State<UserFollowListTile> {
  /// states
  ///
  /// followed
  /// 我刚才是否关注了这个用户
  /// 注意：默认下必须为null， 当为null时意味着用户没有操作
  /// 如果在这里改为true || false 初始化。那么_buildFollowButtonLable将直接无法生成用户操作状态决定的标签
  bool _followed;

  ///
  /// 用于存储最新用户状态的
  UserModel _user = UserModel();

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
    _user = widget.user;
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///
  /// 生成按钮标题
  ///
  Widget _buildFollowButtonLable() {
    ///
    /// 优先返回本次操作的结果标签
    if (_followed != null) {
      return _followed == true
          ? const DiscuzText('取消关注')
          : const DiscuzText('关注');
    }

    /// 如果是互相关注
    if (widget.userFollow.attributes.isMutual == 1) {
      return const DiscuzText('互相关注');
    }

    /// 根据isToUser给出不同的提示
    /// isToUser是指我关注的用户
    /// 如果为true,则可以取消，否则将是关注我的用户，则可以关注他
    /// 默认下，如果对方关注了你，将优先返回 互相关注
    if (widget.isToUser == true) {
      return const DiscuzText('取消关注');
    }

    return const DiscuzText('关注');
  }

  ///
  /// 判断用户是否已经关注了
  int _follow() {
    /// _followed 初始化时 可能为null， 所以要 == true 进行判断，否则将出错
    /// 不要用if(_followed){}
    if (_followed == true) {
      return 1;
    }

    /// 互相关注，所以follow == 1
    if (widget.userFollow.attributes.isMutual == 1) {
      return 1;
    }

    /// 我关注了那个用户，所以follow == 1
    if (widget.isToUser == true) {
      return 1;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: DiscuzApp.themeOf(context).backgroundColor),
      child: Column(
        children: <Widget>[
          DiscuzListTile(
            leading: DiscuzAvatar(
              url: _user.attributes.avatarUrl,
              size: 40,
            ),
            title: DiscuzText(_user.attributes.username),
            trailing: FlatButton(
              child: _buildFollowButtonLable(),
              onPressed: () async {
                ///
                /// 关注接口发起关注时，将直受到 follow == 1 or not 来决定请求关注还是取消，
                /// 所以要新复制一个对象，保证follow是正常的
                final UserModel resetUser =
                    UserModel.copyWith(userModel: _user, follow: _follow());

                /// 请求关注接口
                final result = await UsersAPI.requestFollow(
                    context: context,
                    user: resetUser,
                    isUnfollow: _user.attributes.follow == 1);
                if (!result) {
                  return;
                }

                setState(() {
                  _followed = resetUser.attributes.follow == 1 ? false : true;
                  _user = UserModel.copyWith(
                      userModel: resetUser,
                      follow: resetUser.attributes.follow == 1 ? 0 : 1);
                });
              },
            ),
          ),
          const DiscuzDivider(
            padding: 0,
          )
        ],
      ),
    );
  }
}

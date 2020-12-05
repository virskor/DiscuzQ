import 'package:dio/dio.dart';
import 'package:core/widgets/threads/threadsDetector.dart';
import 'package:core/widgets/users/userLinkDetector.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:core/models/metaModel.dart';
import 'package:core/models/notificationModel.dart';
import 'package:core/utils/dateUtil.dart';
import 'package:core/utils/global.dart';
import 'package:core/utils/request/request.dart';
import 'package:core/utils/request/urls.dart';
import 'package:core/widgets/appbar/appbarExt.dart';
import 'package:core/widgets/common/discuzAvatar.dart';
import 'package:core/widgets/common/discuzDivider.dart';
import 'package:core/widgets/common/discuzLink.dart';
import 'package:core/widgets/common/discuzListTile.dart';
import 'package:core/widgets/common/discuzNomoreData.dart';
import 'package:core/widgets/common/discuzRefresh.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/widgets/htmRender/htmlRender.dart';
import 'package:core/widgets/skeleton/discuzSkeleton.dart';
import 'package:core/widgets/ui/ui.dart';
import 'package:core/widgets/common/discuzToast.dart';
import 'package:core/widgets/common/discuzDialog.dart';

///
/// 消息通知列表页面
///
class NotificationListDelegate extends StatefulWidget {
  final NotificationTypesItem type;

  const NotificationListDelegate({@required this.type});

  @override
  _NotificationDelegateState createState() => _NotificationDelegateState();
}

class _NotificationDelegateState extends State<NotificationListDelegate> {
  /// refresh controller
  final RefreshController _controller = RefreshController();

  ///
  /// _pageNumber
  int _pageNumber = 1;

  ///
  /// meta
  MetaModel _meta;

  ///
  /// loading
  /// 是否正在加载
  bool _loading = false;

  ///
  /// _continueToRead
  /// 是否是连续加载
  bool _continueToRead = false;

  ///
  /// 通知数据
  ///
  List<NotificationModel> _notifications = [];

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

    Future.delayed(Duration(milliseconds: 470))
        .then((_) async => await _requestData(pageNumber: 1));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DiscuzAppBar(
        title: widget.type.label,
         brightness: Brightness.light,
      ),
      body: _buildBody(context),
    );
  }

  ///
  /// 是否允许加载更多
  bool get _enablePullUp =>
      _meta == null ? false : _meta.pageCount > _pageNumber ? true : false;

  ///
  /// 生成搜索用户的组件
  ///
  Widget _buildBody(BuildContext context) => DiscuzRefresh(
        controller: _controller,
        enablePullDown: true,
        enablePullUp: _enablePullUp,
        onLoading: () async {
          if (_loading) {
            return;
          }
          await _requestData(pageNumber: _pageNumber + 1);
          _controller.loadComplete();
        },
        onRefresh: () async {
          await _requestData(pageNumber: 1);
          _controller.refreshCompleted();
        },
        child: _buildNotificationList(context),
      );

  ///
  /// 通知列表
  Widget _buildNotificationList(BuildContext context) {
    ///
    /// 骨架屏仅在初始化时加载
    ///
    if (!_continueToRead && _loading) {
      return const DiscuzSkeleton(
        isCircularImage: false,
        isBottomLinesActive: false,
      );
    }

    if (_notifications.length == 0) {
      return const DiscuzNoMoreData();
    }

    return ListView.builder(
      itemCount: _notifications.length,
      itemBuilder: (BuildContext context, index) {
        final NotificationModel n = _notifications[index];
        return Container(
            decoration: BoxDecoration(
                color: DiscuzApp.themeOf(context).backgroundColor),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  widget.type == NotificationTypes.system
                      ? const SizedBox()
                      : Container(
                          child: DiscuzListTile(
                              contentPadding: const EdgeInsets.all(0),
                              leading: GestureDetector(
                                child: DiscuzAvatar(
                                    url: n.attributes.userAvatar, size: 40),
                                onTap: () => UserLinkDetector(context: context)
                                    .showUser(uid: n.attributes.userID),
                              ),
                              title: Row(
                                children: <Widget>[
                                  DiscuzText(
                                    '${n.attributes.username}',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(width: 5),
                                  // todo 点击查看用户
                                  DiscuzText(
                                    '回复了我',
                                    color: DiscuzApp.themeOf(context)
                                        .greyTextColor,
                                  )
                                ],
                              ),
                              subtitle: DiscuzText(
                                DateUtil.formatDate(
                                    DateTime.parse(n.attributes.createdAt)
                                        .toLocal(),
                                    format: "yyyy-MM-dd HH:mm"),
                                fontSize: 14,
                                color: DiscuzApp.themeOf(context).greyTextColor,
                              ),
                              trailing: const SizedBox()),
                        ),

                  /// 仅系统通知显示标题
                  widget.type != NotificationTypes.system
                      ? const SizedBox()
                      : DiscuzText(
                          n.attributes.title,
                          fontWeight: FontWeight.bold,
                        ),

                  /// 仅系统通知显示时间
                  widget.type != NotificationTypes.system
                      ? const SizedBox()
                      : DiscuzText(
                          DateUtil.formatDate(
                              DateTime.parse(n.attributes.createdAt).toLocal(),
                              format: "yyyy-MM-dd HH:mm"),
                          fontSize: 14,
                          color: DiscuzApp.themeOf(context).greyTextColor,
                        ),

                  /// 渲染消息内容
                  /// todo: 点击到关联的帖子
                  HtmlRender(
                    html: n.attributes.postContent != ''
                        ? n.attributes.postContent
                        : n.attributes.content,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      DiscuzLink(
                          label: '查看帖子',
                          onTap: () => ThreadsDetector(context: context)
                              .showThread(
                                  threadID: n.attributes.threadID,
                                  uid: n.attributes.userID)),
                      DiscuzLink(
                        label: '回复',
                        onTap: () =>
                            DiscuzToast.show(context: context, message: '即将支持'),
                      ),
                      DiscuzLink(
                        label: '删除',
                        onTap: () async {
                          final bool deleted =
                              await _deleteNotification(id: n.id);
                          if (deleted) {
                            setState(() {
                              ///
                              /// 用户进行了删除， 隐藏当前选项
                              /// 只需要删除通知列表中的数据就可以了
                              /// 没有必要重新请求接口的
                              _notifications = _notifications
                                  .where((it) => it.id != n.id)
                                  .toList();
                            });
                          }
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  const DiscuzDivider(
                    padding: 0,
                  ),
                ],
              ),
            ));
      },
    );
  }

  ///
  /// 删除单个通知
  /// id 是要删除通知的id
  /// 需要回调删除结果，这样UI来决定是否需要删除当前选中的数据，而重新渲染UI
  Future<bool> _deleteNotification({int id}) async {
    ///
    /// 该请求忽略响应状态
    /// todo: 更新Request Error Exception
    final Function process = () async {
      final Function close = DiscuzToast.loading(context: context);

      try {
        Response _ = await Request(context: context)
            .delete(url: "${Urls.notifications}/${id.toString()}");
      } catch (e) {
        close();
        throw e;
      }

      close();

      DiscuzToast.toast(context: context, message: '删除成功');
    };

    /// 是否确认删除
    bool deleted = false;

    ///
    /// 删除前，先询问
    /// 如果删除成功，还需要隐藏当前请求删除的项目
    await DiscuzDialog.confirm(
        context: context,
        title: '提示',
        message: '确定删除吗？',
        onConfirm: () {
          process();
          deleted = true;
        });
    return Future.value(deleted);
  }

  ///
  /// 请求用户搜索结果
  Future<void> _requestData({BuildContext context, int pageNumber}) async {
    if (_loading) {
      return;
    }

    if (pageNumber == 1) {
      _notifications.clear();

      /// 要清空历史搜索数据，否则会重复渲染到UI
      setState(() {
        _continueToRead = false;
      });
    }

    final dynamic data = {
      'filter[type]': widget.type.type,
      "page[number]": pageNumber ?? _pageNumber,
      'page[limit]': Global.requestPageLimit
    };

    setState(() {
      _loading = true;
    });

    Response resp = await Request(context: context)
        .getUrl(url: Urls.notifications, queryParameters: data);
    setState(() {
      _loading = false;
    });
    final List<dynamic> notifications = resp.data['data'] ?? [];

    List<NotificationModel> notificationModel;

    try {
      ///
      /// 生成新的 _users
      /// 当底部的setState触发UI更新时，实际上 _users会重新渲染UI，所以这里不必要SetState 否则就脱裤子放屁了
      notificationModel = notifications
          .where((u) => u['type'] == 'notification')
          .map((n) => NotificationModel.fromMap(maps: n))
          .toList();
    } catch (e) {
      throw e;
    }

    setState(() {
      _loading = false;
      _pageNumber = pageNumber == null ? _pageNumber + 1 : pageNumber;
      _continueToRead = true;
      _notifications.addAll([...notificationModel]);

      /// pageNumber 在onload传入时已经自动加1
      _meta = MetaModel.fromMap(maps: resp.data['meta']);
    });
  }
}

///
/// 消息通知的类型
///
class NotificationTypes {
  ///
  /// @我的
  static const related =
      const NotificationTypesItem(label: '提到我的', type: 'related');

  ///
  /// 回复
  static const replies =
      const NotificationTypesItem(label: '回复我的', type: 'replied');

  ///
  /// 打赏我的
  static const rewarded =
      const NotificationTypesItem(label: '财务通知', type: 'rewarded');

  ///
  /// 打赏我的
  static const liked =
      const NotificationTypesItem(label: '喜欢我的', type: 'liked');

  ///
  /// 系统消息
  static const system =
      const NotificationTypesItem(label: '系统消息', type: 'system');
}

class NotificationTypesItem {
  final String type;

  final String label;

  const NotificationTypesItem({@required this.type, @required this.label});
}

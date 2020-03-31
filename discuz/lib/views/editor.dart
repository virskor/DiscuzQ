import 'package:flutter/material.dart';

import 'package:discuzq/states/appState.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/widgets/editor/discuzEditor.dart';
import 'package:discuzq/utils/device.dart';
import 'package:discuzq/widgets/common/discuzText.dart';

///
/// 发帖编辑器
/// 发帖编辑器需要调用 discuzEditor 组件进行渲染用于渲染不同编辑模式下的编辑器
/// 模式分为：发（主题，长文），编辑(主题，回复)，视频
/// 注意： 
/// 主题 不会支持markdown编辑 长文支持markdown编辑， 编辑时候也一样: todo: 如何确定编辑的是长文还是主题
/// 发送主题，或者长文，都要支持表情 图片 附件
/// 视频不会支持markdown，视频不会支持表情，附件，图片
/// 回复不会支持markdown,回复仅支持表情和图片，不支持附件
/// 
/// -------
/// 调用编辑模式，要使用DiscuzEditorDataModel.fromMap 对接口数据进行转化
/// 发布时，使用DiscuzEditorDataModel.toJson 获取用于发布的数据
/// 数据转化的内容包括
/// 表情，图片，附件，视频，分类，收费价格，编辑器content内容
/// 
/// 也就是调用编辑模式使用 const Editor(data: DiscuzEditorDataModel.fromMap(json));
/// 这样编辑器会自动调用数据编辑模式来，而接口则从新建，变为更新
/// 
/// 
class Editor extends StatefulWidget {
  const Editor();

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  ///
  /// uniqueKey
  final UniqueKey uniqueKey = UniqueKey();

  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: false,
      builder: (context, child, state) {
        final Widget notSupported =
            const Center(child: const DiscuzText('暂不开放生产环境使用'));

        return Scaffold(
          key: uniqueKey,
          appBar: DiscuzAppBar(
            title: '发布内容',
          ),
          backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
          body: Column(
            children: <Widget>[
              Expanded(
                  child: !Device.isDevelopment ? notSupported : DiscuzEditor()),
            ],
          ),
        );
      });
}

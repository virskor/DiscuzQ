import 'package:discuzq/router/route.dart';
import 'package:discuzq/views/editor.dart';
import 'package:discuzq/widgets/editor/discuzEditorInputTypes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'package:discuzq/states/appState.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/share/shareApp.dart';
import 'package:discuzq/widgets/ui/ui.dart';

class UserInterationBar extends StatefulWidget {
  const UserInterationBar();
  @override
  _UserServicesState createState() => _UserServicesState();
}

class _UserServicesState extends State<UserInterationBar> {
  @override
  Widget build(BuildContext context) => ScopedStateModelDescendant<AppState>(
      rebuildOnChange: true,
      builder: (context, child, state) => Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: DiscuzApp.themeOf(context).backgroundColor),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _UserInterationBarItem(
                  icon: 0xe8b1,
                  label: '发布主题',
                  onPressed: () => DiscuzRoute.open(
                      context: context,
                      fullscreenDialog: true,
                      shouldLogin: true,
                      widget: Editor(
                        type: DiscuzEditorInputTypes.text,
                      )),
                ),
                _UserInterationBarItem(
                  icon: SFSymbols.square_arrow_up,
                  label: '邀请朋友',
                  onPressed: () =>
                      ShareApp.show(context: context, user: state.user),
                )
              ],
            ),
          ));
}

class _UserInterationBarItem extends StatelessWidget {
  ///
  /// 图标
  final dynamic icon;

  ///
  /// 按钮的标题
  final String label;

  ///
  /// 按钮点击
  final Function onPressed;

  _UserInterationBarItem({this.icon, this.label, this.onPressed});

  @override
  Widget build(BuildContext context) => Container(
        child: FlatButton(
            onPressed: onPressed,
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DiscuzIcon(
                  icon,
                  size: 22,
                  color: DiscuzApp.themeOf(context).textColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                DiscuzText(label)
              ],
            )),
      );
}

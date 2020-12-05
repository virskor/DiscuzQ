import 'package:flutter/material.dart';

import 'package:core/widgets/appbar/appbarExt.dart';
import 'package:core/models/postModel.dart';
import 'package:core/models/threadModel.dart';
import 'package:core/utils/global.dart';
import 'package:core/widgets/common/discuzButton.dart';
import 'package:core/widgets/common/discuzText.dart';
import 'package:core/widgets/common/discuzTextfiled.dart';
import 'package:core/widgets/common/discuzToast.dart';
import 'package:core/api/reports.dart';
import 'package:core/models/userModel.dart';

enum ReportType {
  ///
  /// Report target is user
  /// Value should be 0
  homepage,

  ///
  /// Report target is thread
  /// Value is 1
  thread,

  ///
  /// Report target is post
  /// Value should be 2
  post,
}

///
/// Types
const List<Map<ReportType, int>> kReportTypes = [
  ///
  /// Report user
  {ReportType.homepage: 0},

  ///
  /// Report thread
  {ReportType.thread: 1},

  ///
  /// Report post
  {ReportType.post: 2},
];

const String _kReportNotice =
    '我们将在收到举报信息后进行核实处理(通常在24小时时效范围内)，您还可以通过关于我们来取得联系。谢谢您的支持与理解。\r\n如有必要请在举报原因中留下您的联系方式便于与您取得联系。';

class ReportsDelegate extends StatefulWidget {
  const ReportsDelegate(
      {Key key, @required this.type, this.user, this.thread, this.post})
      : super(key: key);

  ///
  /// Related Thread
  final ThreadModel thread;

  ///
  /// Related post
  final PostModel post;

  ///
  /// Related user
  final UserModel user;

  ///
  /// Type
  final ReportType type;

  @override
  _ReportsDelegateState createState() => _ReportsDelegateState();
}

class _ReportsDelegateState extends State<ReportsDelegate> {
  ///
  /// controller
  final TextEditingController _controller = TextEditingController();

  /*
   * preset reasons
   */
  final List<String> _presetReasons = [
    '广告垃圾',
    '恶意灌水',
    '违规内容',
    '重复发帖',
    '语言攻击',
    '暴恐谣言',
    '其他'
  ];

  String _selectedReason = '其他';

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
            appBar: DiscuzAppBar(
              title: '投诉举报',
              brightness: Brightness.light,
            ),
            body: ListView(
              padding: kBodyPaddingAll,
              children: <Widget>[
                const DiscuzText(
                  '请选择原因：',
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 15),
                ..._presetReasons
                    .map((String item) => RadioListTile(
                          groupValue: _selectedReason,
                          title: DiscuzText(item),
                          value: item,
                          dense: true,
                          onChanged: (String val) {
                            print(val);
                            setState(() {
                              _selectedReason = val;
                            });
                          },
                        ))
                    .toList(),
                const DiscuzText(
                  '详细的描述：',
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 15),
                _reasonEditor(),
                DiscuzButton(
                  label: '提交',
                  onPressed: _submitReport,
                ),
                const SizedBox(
                  height: 10,
                ),
                const DiscuzText(_kReportNotice)
              ],
            ),
          );

  ///
  /// Reason
  /// 举报理由
  Widget _reasonEditor() => DiscuzTextfiled(
        controller: _controller,
        placeHolder: '请输入举报的详细描述，便于我们审核',
        maxLines: 10,
        maxLength: 200,
      );

  ///
  /// 提交举报信息
  Future<void> _submitReport() async {
    if (_controller.text.isEmpty) {
      DiscuzToast.toast(
          context: context,
          type: DiscuzToastType.failed,
          title: '无法提交',
          message: '请输入原因后再提交');
      return;
    }

    /// 加载Loading
    final Function close = DiscuzToast.loading();

    try {
      final bool result = await ReportsAPI(context: context).createReports(
          type: widget.type,
          reason: "$_selectedReason - ${_controller.text}",
          userID: widget.user == null ? 0 : widget.user.id,
          threadID: widget.thread == null ? 0 : widget.thread.id,
          postID: widget.post == null ? 0 : widget.post.id);

      close();

      if (result) {
        DiscuzToast.toast(
            context: context, title: '举报成功', message: '我们已经收到您的举报');
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      close();
      throw e;
    }
  }
}

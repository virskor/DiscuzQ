import 'dart:io';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:core/utils/global.dart';
import 'package:core/widgets/common/discuzIcon.dart';
import 'package:flutter/cupertino.dart';
import 'package:core/models/attachmentsModel.dart';
import 'package:core/utils/permissionHepler.dart';
import 'package:core/utils/request/request.dart';
import 'package:core/utils/request/urls.dart';
import 'package:core/widgets/common/discuzToast.dart';
import 'package:core/providers/editorProvider.dart';

const double _imageSize = 50;

class DiscuzEditorImageUploader extends StatefulWidget {
  final Function onUploaded;
  const DiscuzEditorImageUploader({this.onUploaded});

  @override
  _DiscuzEditorImageUploaderState createState() =>
      _DiscuzEditorImageUploaderState();
}

class _DiscuzEditorImageUploaderState extends State<DiscuzEditorImageUploader> {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditorProvider>(
        builder: (BuildContext context, EditorProvider editor, Widget child) {
      ///
      /// 渲染已经上传的图片
      ///
      List<Widget> widgets = [];

      ///
      /// 生成已经上传的图片
      ///
      /// todo: 跟进问题
      /// 注意：由于attachements失去 isGallery 字段导致的 state过滤附件类型失效问题
      /// 新版接口废弃了：isGallery
      /// widgets = state.galleries
      widgets = editor.attachements
          .map<Widget>((AttachmentsModel a) => SizedBox(
                width: _imageSize,
                height: _imageSize,
                child: _DiscuzEditorImageUploaderThumb(
                  attachment: a,
                ),
              ))
          .toList();

      ///
      /// 添加按钮
      ///
      widgets.add(GestureDetector(
        onTap: () async => await _pickImage(),
        child: const _DiscuzEditorImageUploaderAddIcon(),
      ));

      ///
      /// 渲染图片组件
      return Container(
        padding: EdgeInsets.all(10),
        child: Wrap(
          children: widgets
              .map<Widget>((e) => SizedBox(
                    width: _imageSize,
                    height: _imageSize,
                    child: e,
                  ))
              .toList(),
        ),
      );
    });
  }

  ///
  /// 处理上传图片
  /// 先弹出选择框
  /// 在进行上传,上传成功后，插入缩略图，上传失败，提醒用户上传失败
  Future<void> _pickImage() async {
    final bool havePermission =
        await PermissionHelper.checkWithNotice(PermissionGroup.photos);
    if (havePermission == false) {
      return;
    }

    final File imageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      final Function close = DiscuzToast.loading(context: context);

      try {
        ///
        /// 执行上传过程
        /// todo: 增加该文件正在上传的状态
        final AttachmentsModel attachment = await _uploadImage(file: imageFile);

        close();

        if (attachment == null) {
          ///
          /// 上传失败
          /// todo: 移除该文件正在上传的状态
          /// 提醒用户正在上传
          DiscuzToast.failed(context: context, message: '上传失败');
          return;
        }

        ///
        /// 图片上传成功,state新增
        context.read<EditorProvider>().addAttachment(attachment);
        if (widget.onUploaded != null) {
          widget.onUploaded();
        }
      } catch (e) {
        close();
        throw e;
      }
    }
  }

  ///
  /// 进行图片上传并反馈上传结果
  ///
  Future<AttachmentsModel> _uploadImage({@required File file}) async {
    Response resp = await Request(context: context).uploadFile(
        url: Urls.attachments,
        name: 'file',

        ///
        ///  参数补全
        data: {
          "type": 1,
          "isGallery": 1,

          /// 是否为帖子图片

          /// 上传图集，而不是普通附件
          "order": context.read<EditorProvider>().galleries == null
              ? 0
              : context.read<EditorProvider>().galleries.length,
        },

        /// 上传头像
        file: MultipartFile.fromFileSync(file.path));
    if (resp == null) {
      return Future.value(null);
    }

    return Future.value(AttachmentsModel.fromMap(maps: resp.data['data']));
  }
}

///
/// 已经上传的图片，缩略图
/// 删除图片时，将重构editor state，
class _DiscuzEditorImageUploaderThumb extends StatelessWidget {
  final AttachmentsModel attachment;

  _DiscuzEditorImageUploaderThumb({this.attachment});
  @override
  Widget build(BuildContext context) {
    return Consumer<EditorProvider>(
        builder: (BuildContext context, EditorProvider editor, Widget child) {
      return Container(
        margin: const EdgeInsets.only(right: 5, top: 5),
        child: Container(
          width: _imageSize,
          height: _imageSize,
          decoration: BoxDecoration(
            border: Border(
                top: Global.border,
                right: Global.border,
                left: Global.border,
                bottom: Global.border),
          ),
          padding: const EdgeInsets.all(0),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              ///
              /// 图片缩略
              ///
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Image.network(
                  attachment.attributes.thumbUrl,
                  width: _imageSize,
                  height: _imageSize,
                  headers: {"Referer": Global.domain},
                  fit: BoxFit.cover,
                ),
              ),

              ///
              /// 删除图片的按钮
              ///
              Positioned(
                right: 2,
                top: 2,
                child: SizedBox(
                  width: 15,
                  height: 15,
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white),
                      child: const DiscuzIcon(
                        CupertinoIcons.minus_circle_fill,
                        size: 15,
                        color: Colors.redAccent,
                      ),
                    ),
                    onTap: () => editor.removeAttachment(attachment.id),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

///
/// 点击上传的按钮
/// 注意，只是生成一个静态的按钮，不处理上传点击相关事件的绑定
class _DiscuzEditorImageUploaderAddIcon extends StatelessWidget {
  const _DiscuzEditorImageUploaderAddIcon();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: _imageSize,
      height: _imageSize,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Center(
        child: DiscuzIcon(Icons.add),
      ),
    );
  }
}

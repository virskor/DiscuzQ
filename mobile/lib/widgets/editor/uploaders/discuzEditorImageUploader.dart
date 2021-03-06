import 'dart:io';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

import 'package:discuzq/utils/global.dart';
import 'package:discuzq/widgets/common/discuzIcon.dart';
import 'package:flutter/cupertino.dart';
import 'package:discuzq/models/attachmentsModel.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/urls.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:discuzq/providers/editorProvider.dart';
import 'package:discuzq/widgets/common/discuzCachedNetworkImage.dart';
import 'package:discuzq/widgets/common/discuzDialog.dart';
import 'package:discuzq/api/attachments.dart';

const double _imageSize = 100;

class DiscuzEditorImageUploader extends StatefulWidget {
  final Function onUploaded;
  const DiscuzEditorImageUploader({this.onUploaded});

  @override
  _DiscuzEditorImageUploaderState createState() =>
      _DiscuzEditorImageUploaderState();
}

class _DiscuzEditorImageUploaderState extends State<DiscuzEditorImageUploader> {
  final CancelToken _cancelToken = CancelToken();

  /// 选择的图片
  List<Asset> _pikcerImages = List<Asset>();

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
    _cancelToken.cancel();
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
        child: Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widgets
                  .map<Widget>((e) => SizedBox(
                        width: _imageSize,
                        height: _imageSize,
                        child: e,
                      ))
                  .toList(),
            ),
          ),
        ),
      );
    });
  }

  ///
  /// 处理上传图片
  /// 先弹出选择框
  /// 在进行上传,上传成功后，插入缩略图，上传失败，提醒用户上传失败
  Future<void> _pickImage() async {
    if (await Permission.photos.request().isDenied ||
        await Permission.camera.request().isDenied) {
      await showDialog(
          context: context,
          child: DiscuzDialog(
            title: "设置",
            message: "请设置并允许访问您的相册和相机来继续选择要发布的图片",
            isCancel: true,
            onConfirm: () {
              openAppSettings();
            },
          ));
      return;
    }

    try {
      _pikcerImages = await MultiImagePicker.pickImages(
        maxImages: 20,
        enableCamera: true,
        selectedAssets: _pikcerImages,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: const MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    if (_pikcerImages == null || _pikcerImages.length == 0) {
      return;
    }

    //// 上传图片
    /// 等待图片上传
    /// 上传图片结束后，将数据构造为delta
    List<File> files = List();

    await Future.forEach(_pikcerImages, (Asset asset) async {
      String path = await FlutterAbsolutePath.getAbsolutePath(asset.identifier);

      /// 压缩图片
      File compressedFile = await FlutterNativeImage.compressImage(path,
          quality: 60, percentage: 60);

      files.add(compressedFile);
    });

    /// 要上传的文件列表
    if (files.isEmpty) {
      return;
    }

    final Function close = DiscuzToast.loading(context: context);

    await Future.forEach(files, (File file) async {
      if (file != null) {
        try {
          ///
          /// 执行上传过程
          /// todo: 增加该文件正在上传的状态
          final AttachmentsModel attachment = await _uploadImage(file: file);
          if (attachment == null) {
            ///
            /// 上传失败
            /// todo: 移除该文件正在上传的状态
            /// 提醒用户正在上传
            DiscuzToast.failed(context: context, message: '上传图片失败');
            return;
          }

          ///
          /// 图片上传成功,state新增
          context.read<EditorProvider>().addAttachment(attachment);
          if (widget.onUploaded != null) {
            widget.onUploaded();
          }
        } catch (e) {
          DiscuzToast.failed(context: context, message: '上传图片失败');
          throw e;
        }
      }
    });

    _pikcerImages.clear();

    close();
  }

  ///
  /// 进行图片上传并反馈上传结果
  ///
  Future<AttachmentsModel> _uploadImage({@required File file}) async {
    Response resp = await Request(context: context).uploadFile(_cancelToken,
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
        child: Container(
          width: _imageSize,
          height: _imageSize,
          decoration: const BoxDecoration(
            border: const Border(
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
              DiscuzCachedNetworkImage(
                imageUrl: attachment.attributes.thumbUrl,
                width: _imageSize,
                height: _imageSize,
                fit: BoxFit.cover,
              ),

              ///
              /// 删除图片的按钮
              ///
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                left: 0,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: GestureDetector(
                    child: const DiscuzIcon(
                      CupertinoIcons.trash,
                      size: 22,
                      color: Colors.grey,
                    ),
                    onTap: () async {
                      final Function close = DiscuzToast.loading(context: context);

                      /// 请求从服务端删除不用于发布的图片
                      try {
                        await AttachmentsApi(context: context)
                            .remove(null, id: attachment.id);
                        close();
                      } catch (e) {
                        close();
                      }
                      editor.removeAttachment(attachment.id);
                    },
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
      decoration: const BoxDecoration(
          borderRadius: const BorderRadius.all(const Radius.circular(10))),
      child: const Center(
        child: const DiscuzIcon(Icons.add),
      ),
    );
  }
}

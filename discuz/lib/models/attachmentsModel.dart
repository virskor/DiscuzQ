import 'dart:convert';

import 'package:flutter/material.dart';

///
/// 附件模型
class AttachmentsModel {
  ///
  /// id
  ///
  final int id;

  ///
  /// 附件类型
  ///
  final int type;

  ///
  /// 关联数据
  ///
  final AttachmentsAttributesModel attributes;

  const AttachmentsModel({this.id = 0, this.type = 0, this.attributes});

  ///
  /// fromMap
  /// 转换模型
  ///
  static AttachmentsModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return AttachmentsModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return AttachmentsModel(
        id: data['id'] == null
            ? 0
            : data['id'].runtimeType == String
                ? int.tryParse(data['id'])
                : data['id'],
        type: data['type'] == null
            ? 0
            : data['type'].runtimeType == String
                ? int.tryParse(data['type'])
                : data['type'],
        attributes: data['attributes'] == null
            ? const AttachmentsAttributesModel()
            : AttachmentsAttributesModel.fromMap(maps: data['attributes']));
  }
}

class AttachmentsAttributesModel {
  ///
  /// 是否为图集
  /// isGallery
  final bool isGallery;

  ///
  /// 是否为远端数据
  /// isRemote
  final bool isRemote;

  ///
  /// 图片地址
  /// url
  final String url;

  ///
  /// 文件名称
  /// attachment
  final String attachment;

  ///
  /// 拓展名
  /// extension(由于dart保留了关键字 ，所以使用extensions)
  final String extensions;

  ///
  /// 文件名称
  /// fileName
  final String fileName;

  ///
  /// 文件路径
  /// filePath
  final String filePath;

  ///
  /// 文件大小
  /// fileSize
  final int fileSize;

  ///
  /// 文件类型
  /// fileType
  final String fileType;

  ///
  /// 缩略图地址
  /// thumbUrl
  final String thumbUrl;

  const AttachmentsAttributesModel(
      {this.isGallery = false,
      this.isRemote = false,
      this.url = '',
      this.attachment = '',
      this.filePath = '',
      this.fileType = '',
      this.thumbUrl = '',
      this.fileSize = 0,
      this.extensions = '',
      this.fileName = ''});

  ///
  /// fromMap
  /// 转换模型
  ///
  static AttachmentsAttributesModel fromMap({@required dynamic maps}) {
    ///
    /// 返回一个空的模型，如果为空的话
    ///
    if (maps == null) {
      return const AttachmentsAttributesModel();
    }

    dynamic data = maps;

    /// 数据来自json
    if (maps.runtimeType == String) {
      data = jsonDecode(data);
    }

    return AttachmentsAttributesModel(
      fileSize: data['fileSize'] == null
          ? 0
          : data['fileSize'].runtimeType == String
              ? int.tryParse(data['fileSize'])
              : data['fileSize'],
      isGallery: data['isGallery'] ?? false,
      isRemote: data['isRemote'] ?? false,
      url: data['url'] ?? '',
      attachment: data['attachment'] ?? '',
      filePath: data['filePath'] ?? '',
      fileType: data['fileType'] ?? '',
      thumbUrl: data['thumbUrl'] ?? '',
      extensions: data['extension'] ?? '',
      /// 要注意接口返回的数据其实是extension
      fileName: data['fileName'] ?? '',
    );
  }
}

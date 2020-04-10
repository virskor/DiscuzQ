import 'dart:convert';

import 'package:discuzq/widgets/editor/formaters/discuzEditorData.dart';

///
/// 将编辑器的数据，转化为用于提交的Json数据
class DiscuzEditorDataFormater {
  const DiscuzEditorDataFormater();

  ///
  /// 转化数据
  /// 将 DiscuzEditorData转化为json用于提交
  /// 数据处理时，会对应提交的格式转化
  static Future<dynamic> toJSON(DiscuzEditorData data) async {
    /// 未选择分类
    if (data.relationships.category.id == 0) {
      return;
    }

    List<dynamic> attachments = const [];

    if (data.relationships != null &&
        data.relationships.attachments.length > 0) {
      attachments = data.relationships.attachments
          .map<dynamic>((it){
            return {
                /// ... attachment model to dynamic
                /// {
                ///     "type":"attachments",
                ///     "id":"1367"
                /// }
                "type": "attachments",
                "id": it.id.toString(),
              };
          })
          .toList();
    }

    dynamic rebuild = {
      "type": data.type,
      "attributes": {
        "content": data.attributes.content,
        "captcha_rand_str": data.attributes.captchaRandSTR,
        "captcha_ticket": data.attributes.captchaTicket,
        "type": data.attributes.type,
      },
      "relationships": {
        "category": {
          "data": {
            "id": data.relationships.category.id.toString(),
            "type": data.relationships.category.type
          }
        },
        "attachments": {"data": attachments}
      }
    };

    return jsonEncode({"data": rebuild});
  }

  ///
  /// 将数据转化为 DiscuzEditorData
  static Future<dynamic> fromJSON(dynamic data) async {}
}

import 'dart:convert';

import 'package:discuzq/models/captchaModel.dart';
import 'package:discuzq/widgets/editor/formaters/discuzEditorData.dart';

///
/// 将编辑器的数据，转化为用于提交的Json数据
class DiscuzEditorDataFormater {
  const DiscuzEditorDataFormater();

  ///
  /// 转化数据
  /// 将 DiscuzEditorData转化为json用于提交
  /// 数据处理时，会对应提交的格式转化
  /// CaptchaModel 是可选的，只有用户站点开启了云端验证码才可用
  static Future<dynamic> toJSON(DiscuzEditorData data,
      {CaptchaModel captcha}) async {
    /// 未选择分类
    if (data.relationships.category.id == 0) {
      return;
    }

    List<dynamic> attachments = const [];

    if (data.relationships != null &&
        data.relationships.attachments.length > 0) {
      attachments = data.relationships.attachments.map<dynamic>((it) {
        return {
          /// ... attachment model to dynamic
          /// {
          ///     "type":"attachments",
          ///     "id":"1367"
          /// }
          "type": "attachments",
          "id": it.id.toString(),
        };
      }).toList();
    }

    dynamic rebuild = {
      "type": data.type,
      "attributes": {
        "content": data.attributes.content,
        ///
        /// 验证码仅在用户开启了验证码功能后进行覆盖编辑器的值
        /// 
        "captcha_rand_str":
            captcha == null ? data.attributes.captchaRandSTR : captcha.randSTR,
        "captcha_ticket":
            captcha == null ? data.attributes.captchaTicket : captcha.ticket,
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

import 'package:core/models/captchaModel.dart';
import 'package:core/widgets/editor/formaters/discuzEditorData.dart';

///
/// 将编辑器的数据，转化为用于提交的Json数据
class DiscuzEditorDataFormater {
  const DiscuzEditorDataFormater();

  ///
  /// 转化数据
  /// 将 DiscuzEditorData转化为json用于提交
  /// 数据处理时，会对应提交的格式转化
  /// CaptchaModel 是可选的，只有用户站点开启了云端验证码才可用
  ///
  /// isBuildForCreatingPost 是可选项目，默认为False
  /// 当 isBuildForCreatingPost 为false时，会过滤掉 非回复下必填的字段
  /// 当 isBuildForCreatingPost 为true时 会过滤掉 非发帖下必填的字段
  ///
  static Future<dynamic> toDynamic(DiscuzEditorData data,
      {CaptchaModel captcha, bool isBuildForCreatingPost = false}) async {
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

    Map<String, dynamic> relationships = {
      "attachments": {"data": attachments},
    };

    ///
    /// 回复模式的时候，是没有分类的奥
    /// 如果用户选择了分类，其实说明就不是回复，那么就给他补上
    if (!isBuildForCreatingPost) {
      relationships.addAll({
        "category": data.relationships.category == null
            ? null
            : {
                "data": {
                  "id": data.relationships.category.id.toString(),
                  "type": data.relationships.category.type
                }
              },
      });
    }

    ///
    /// 回复模式时，需要补全的数据
    /// 发布则不需要生成
    ///
    if (isBuildForCreatingPost) {
      relationships.addAll({
        "thread": data.relationships.thread == null
            ? null
            : {
                "data": {
                  "id": data.relationships.thread.id.toString(),
                  "type": "threads"
                }
              },
      });
    }

    Map<String, dynamic> attributes = {
      "content": data.attributes.content,

      ///
      /// 验证码仅在用户开启了验证码功能后进行覆盖编辑器的值
      ///
    };

    if (!isBuildForCreatingPost) {
      attributes.addAll({
        "free_words": 0,
      });
    }

    ///
    /// 补全验证码信息
    if (captcha != null) {
      attributes.addAll({
        "captcha_rand_str":
            captcha == null ? data.attributes.captchaRandSTR : captcha.randSTR,
        "captcha_ticket":
            captcha == null ? data.attributes.captchaTicket : captcha.ticket,
      });
    }

    /// 长文模式补全标题
    if (data.attributes.type == EditorDataPostType.typeLongContent) {
      attributes.addAll({
        "title": data.attributes.title,
      });
    }

    ///
    /// 发布的时候会带入该数据
    ///
    if (!isBuildForCreatingPost) {
      attributes.addAll({
        "type": data.attributes.type,
      });
    }

    ///
    /// 回复模式时需要关联PostID
    /// 但是注意：
    /// 回复主题的时候，是不需要要的！
    ///
    if (isBuildForCreatingPost) {
      attributes.addAll({"replyId": data.attributes.replyId.toString()});
    }

    ///
    /// 生成用于提交的数据
    /// todo: 优化整个生成数据的过程
    ///

    return {
      "data": {
        ///
        ///发布的时候是thread 回复的时候是post
        ///
        "type": data.type,
        "attributes": attributes,
        "relationships": relationships
      }
    };
  }

  ///
  /// 将数据转化为 DiscuzEditorData
  static Future<dynamic> fromJSON(dynamic data) async {}
}

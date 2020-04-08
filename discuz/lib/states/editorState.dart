import 'package:discuzq/models/attachmentsModel.dart';
import 'package:discuzq/states/scopedState.dart';

class EditorState extends StateModel {
  List<AttachmentsModel> _attachements = [];
  get attachements => _attachements;

  ///
  /// 添加编辑器已经上传的附件模型
  ///
  void addAttachment(AttachmentsModel addAttachment) {
    if(addAttachment == null){
      return;
    }
    _attachements.add(addAttachment);
    notifyListeners();
  }

  ///
  /// 删除指定的附件模型
  /// 根据ID进行删除
  void removeAttachment(int id) {
    _attachements = _attachements.where((a) => a.id != id).toList();
    notifyListeners();
  }

  ///
  /// 清空已经上传的附件模型
  ///
  void clearAttachments() {
    _attachements.clear();
    notifyListeners();
  }
}

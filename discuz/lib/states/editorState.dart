import 'package:discuzq/models/attachmentsModel.dart';
import 'package:discuzq/models/categoryModel.dart';
import 'package:discuzq/states/scopedState.dart';

class EditorState extends StateModel {
  ///
  /// 如果你要操作附件的数据，你要更新的是这个变量
  List<AttachmentsModel> _attachements = [];

  ///
  /// 用户编辑过程中，选中的分类
  /// 
  CategoryModel _category;
  CategoryModel get category => _category;
  void updateCategory(CategoryModel cat) {
    ///
    /// 过滤选中的无效数据
    if (cat == null || cat.id == 0) {
      return;
    }
    _category = cat;
    ///
    /// 这里不需要 调用notifyListeners 来重构UI
    /// 因为这个状态，不参与UI的渲染
    /// 
  }


  ///
  /// 注意，我想告诉你
  /// _attachements将包含附件！附件和图片的模型是一样的，所以如果你要访的数据，我想不直接是attachements
  /// 如果是这样 访问 galleries 你会得到图片 访问 files 你会得到上传的附件
  ///
  List<AttachmentsModel> get attachements => _attachements;

  ///
  /// 访问图片数据
  ///
  List<AttachmentsModel> get galleries =>
      _attachements.where((a) => a.attributes.isGallery).toList();


  ///
  /// 访问上传的附件文件数据
  ///
  List<AttachmentsModel> get files =>
      _attachements.where((a) => !a.attributes.isGallery).toList();

  ///
  /// 访问上传的附件数据
  ///

  ///
  /// 添加编辑器已经上传的附件模型
  ///
  void addAttachment(AttachmentsModel addAttachment) {
    if (addAttachment == null) {
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

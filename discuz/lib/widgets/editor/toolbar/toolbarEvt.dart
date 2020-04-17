enum ToolbarEvt {
  ///
  /// 用户点击输入表情
  ///
  emoji,

  ///
  /// 用户点击插入图片
  ///
  image,

  ///
  /// 用户点击插入附件
  ///
  attachment,

  ///
  /// 用户点击插入formar_bold 粗体
  ///
  formatBold,

  ///
  /// 用户点击插入斜体
  /// 
  formatItalic,

  ///
  /// 用户点击插入 Head
  ///
  formatHead,

  ///
  /// 用户点击插入引用
  /// 
  formatQuote,

  ///
  /// 插入列表 不带数字符
  /// 
  formatListDash,

  ///
  /// 插入列表Number
  /// 
  formatListNumber,

  ///
  /// 插入超链接
  /// 
  formatUrl,
}

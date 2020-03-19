class TypeUnreadNotifications {
  ///
  /// replied
  /// 未读回复消息数
  ///
  final int replied;

  ///
  /// liked
  /// 未读点赞消息数
  ///
  final int liked;

  ///
  /// rewarded
  /// 未读打赏消息数
  ///
  final int rewarded;

  ///
  /// system
  /// 未读系统消息
  ///
  final int system;

  ///
  /// 未读消息数量模型
  /// 
  const TypeUnreadNotifications(
      {this.replied = 0, this.liked = 0, this.rewarded = 0, this.system});
}

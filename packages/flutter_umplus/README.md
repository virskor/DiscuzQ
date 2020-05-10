# flutter_umplus

一个简单的友盟 umeng app+ 统计，其他几个库的坑都踩过了，吸收了它们的优点，建议大家用这个库。

**目前遇到的问题：**

- dispose 在Android有点问题，需要再测试一下，友盟必须在beginPageView和endPageView配对才算有效。如果有人知道如何解决欢迎fork。

## Getting Started

| Init        |                                                              |
| ----------- | ------------------------------------------------------------ |
| key         | 友盟AppKey                                                   |
| channel     | 渠道；空字符串或者null，iOS默认为AppStore，Android字段从AnroidMainfest.xml的UMENG_CHANNEL读取 |
| reportCrash | 是否报告错误                                                 |
| logEnable   | 是否启用日志                                                 |
| encrypt     | 是否启用加密                                                 |

### Usage

初始化

```
FlutterUmplus.init(
    'Your umeng appkey',
    channel: 'Your channel',
    reportCrash: false,
    logEnable: true,
    encrypt: true,
);
```

页面统计需要在你自己的State基类上重写

```Dart

  static List<BaseState> _STATES = [];
  static Map<BaseState, bool> _STATE_VISIBLE = {};

  static void _state_push(BaseState state) {
    if (!_STATES.contains(state)) {
      if (_STATES.length > 0) {
        var pre = _STATES.last;
        if (_STATE_VISIBLE[pre]) {
          _STATE_VISIBLE[pre] = false;
          pre.onHide();
        }
      }

      _STATES.add(state);
      _STATE_VISIBLE[state] = true;
      state.onShow();
    }
  }

  static void _state_leave(BaseState state) {
    if (_STATES.contains(state)) {
      if (_STATE_VISIBLE[state]) {
        _STATE_VISIBLE[state] = false;
        state.onHide();
      }
    }
  }

  static void _state_remove(state) {
    if (_STATES.contains(state)) {
      var ix = _STATES.indexOf(state);
      _STATES.remove(state);
      _STATE_VISIBLE.remove(state);
      if (ix > 0) {
        var pre = _STATES[ix - 1];
        if (!_STATE_VISIBLE[pre]) {
          _STATE_VISIBLE[pre] = true;
          pre.onShow();
        }
      }
    }
  }

  void onShow() {
    // print('life onShow ${runtimeType.toString()}');
    FlutterUmplus.beginPageView(runtimeType.toString());
  }

  void onHide() {
    // print('life onHide ${runtimeType.toString()}');
    FlutterUmplus.endPageView(runtimeType.toString());
  }

  @override
  void initState() {
    _state_push(this);
    super.initState();
  }

  @override
  void deactivate() {
    _state_leave(this);
    super.deactivate();
  }

  @override
  void dispose() {
    _state_remove(this);
    super.dispose();
  }
```

事件埋点

```
FlutterUmplus.event('eventName', label: 'eventLabel');
```

[仓库地址](https://github.com/ygmpkk/flutter_umplus)

## LICENSE

MIT

import 'package:flutter/material.dart';

import 'package:core/models/emojiModel.dart';
import 'package:core/widgets/emoji/emojiSync.dart';
import 'package:core/widgets/common/discuzCachedNetworkImage.dart';

class EmojiSwiper extends StatefulWidget {
  ///
  /// 请求插入表情
  /// onInsert(EmojiModel emoji) => null
  final Function onInsert;

  EmojiSwiper({this.onInsert});
  @override
  _EmojiSwiperState createState() => _EmojiSwiperState();
}

class _EmojiSwiperState extends State<EmojiSwiper> {
  ///
  /// states
  /// Emoji list
  List<EmojiModel> _emojis = [];

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
    Future.delayed(Duration.zero).then((_) async {
      List<EmojiModel> emojis = await EmojiSync().getEmojis(
        context: context,
      );

      ///
      /// 其实一般情况下都会有emoji的，只不怕一万就怕万一
      if (emojis.length > 0) {
        setState(() {
          _emojis = emojis;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        decoration: BoxDecoration(color: Colors.transparent),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Wrap(
              children: _emojis
                  .map<Widget>((e) => IconButton(
                        icon: DiscuzCachedNetworkImage(
                          imageUrl: e.attributes.url,
                        ),
                        onPressed: () {
                          if (widget.onInsert == null) {
                            return;
                          }

                          widget.onInsert(e);
                        },
                      ))
                  .toList(),
            ),
          ),
        ));
  }
}

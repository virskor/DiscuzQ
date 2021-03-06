import 'package:discuzq/widgets/common/discuzLogo.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:flutter/material.dart';

const double _kIconSize = 40;

class LogoLeading extends StatelessWidget {
  const LogoLeading({Key key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          const DiscuzAppLogo(
            width: _kIconSize,
            height: _kIconSize,
            transparent: true,
            circular: 4,
          ),
        ],
      ),
    );
  }
}

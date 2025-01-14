import 'package:flutter/material.dart';

class IconButtonWithDropdown extends StatelessWidget {
  const IconButtonWithDropdown(
      {super.key,
      required this.popupMenuEntryList,
      required this.icon,
      this.style});

  final List<PopupMenuEntry<String>> popupMenuEntryList;
  final Icon icon;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      style: style,
      icon: icon,
      itemBuilder: (BuildContext context) {
        return popupMenuEntryList;
      },
    );
  }
}

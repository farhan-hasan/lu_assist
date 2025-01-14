import 'package:flutter/material.dart';

class SharedAppbar extends StatelessWidget implements PreferredSizeWidget {
  const SharedAppbar(
      {super.key,
      this.title,
      this.leadingWidget,
      this.trailingWidgets,
      this.titleSpacing});

  final Widget? title;
  final List<Widget>? trailingWidgets;
  final Widget? leadingWidget;
  final double? titleSpacing;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: titleSpacing ?? null,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: title ?? null,
      leading: leadingWidget ?? null,
      actions: trailingWidgets ?? null,
    );
  }
}

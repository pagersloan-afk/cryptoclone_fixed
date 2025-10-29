import 'package:flutter/material.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final Widget? title;
  final List<Widget>? actions;
  final bool hideBackButton;
  final VoidCallback? onBackButtonPressed;
  final Widget? leadingIcon;

  const BasicAppbar({
    super.key,
    this.backgroundColor,
    this.title,
    this.actions,
    this.hideBackButton = false,
    this.onBackButtonPressed,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the leading widget based on parameters
    Widget? leadingWidget;
    if (!hideBackButton) {
      leadingWidget =
          leadingIcon ??
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBackButtonPressed ?? () => Navigator.of(context).pop(),
          );
    }

    return AppBar(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      elevation: 0,
      centerTitle: true,
      title: title,
      leading: leadingWidget,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

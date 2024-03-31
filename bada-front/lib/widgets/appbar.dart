import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino icons for the iOS back arrow

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(CupertinoIcons.back), // iOS style back arrow
        onPressed: () => Navigator.of(context).pop(), // Pop the current route
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Define the AppBar's height
}

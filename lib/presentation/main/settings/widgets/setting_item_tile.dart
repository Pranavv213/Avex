import 'package:flutter/material.dart';

class SettingListTile extends StatelessWidget {
  const SettingListTile({super.key, this.icon, this.title});

  final String? title;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title!,
        textAlign: TextAlign.left,
        style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 18,
            letterSpacing: 0,
            fontWeight: FontWeight.normal,
            height: 1),
      ),
      leading: Icon(icon),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 18,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_project/presentation/main/settings/widgets/setting_item_tile.dart';
import 'package:test_project/presentation/main/settings/widgets/user_account_info_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              UserAccountInfoTile(),
              SizedBox(height: 80),
              SettingListTile(
                title: "Recovery Kit",
                icon: Icons.settings,
              ),
              SettingListTile(
                title: "Connections",
                icon: Icons.people_outline,
              ),
              SettingListTile(
                title: "Notifications",
                icon: Icons.notifications_outlined,
              ),
              SettingListTile(
                title: "Invite a friend",
                icon: Icons.person_add_outlined,
              ),
              SettingListTile(
                title: "Request a feature",
                icon: Icons.settings_outlined,
              ),
              SettingListTile(
                title: "Customer Support",
                icon: Icons.support_agent_outlined,
              )
            ],
          ),
        ),
      ),
    );
  }
}

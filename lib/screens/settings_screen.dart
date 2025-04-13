import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/usage_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Usage Limits Section
          _buildSection(
            context,
            title: 'Usage Limits',
            icon: Icons.timer,
            children: [
              _buildSettingTile(
                context,
                title: 'Daily limit',
                subtitle: '40 minutes',
                icon: Icons.access_time,
                onTap: () {
                  // TODO: Implement daily limit adjustment
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('This feature will be available soon'),
                    ),
                  );
                },
              ),
              _buildSettingTile(
                context,
                title: 'Block duration',
                subtitle: '24 hours',
                icon: Icons.block,
                onTap: () {
                  // TODO: Implement block duration adjustment
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('This feature will be available soon'),
                    ),
                  );
                },
              ),
            ],
          ),
          
          // Notifications Section
          _buildSection(
            context,
            title: 'Notifications',
            icon: Icons.notifications,
            children: [
              _buildSwitchTile(
                context,
                title: 'Usage alerts',
                subtitle: 'Get notified every 5 minutes',
                icon: Icons.notifications_active,
                value: true,
                onChanged: (value) {
                  // TODO: Implement notification toggle
                },
              ),
              _buildSwitchTile(
                context,
                title: 'Daily summary',
                subtitle: 'Receive end-of-day report',
                icon: Icons.summarize,
                value: false,
                onChanged: (value) {
                  // TODO: Implement daily summary toggle
                },
              ),
            ],
          ),
          
          // Tracked Apps Section
          _buildSection(
            context,
            title: 'Tracked Apps',
            icon: Icons.apps,
            children: [
              _buildSettingTile(
                context,
                title: 'Manage apps',
                subtitle: '5 apps currently tracked',
                icon: Icons.edit,
                onTap: () {
                  // TODO: Implement app selection
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('This feature will be available soon'),
                    ),
                  );
                },
              ),
            ],
          ),
          
          // Theme Section
          _buildSection(
            context,
            title: 'Appearance',
            icon: Icons.palette,
            children: [
              _buildSwitchTile(
                context,
                title: 'Dark mode',
                subtitle: 'Use system theme',
                icon: Icons.dark_mode,
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (value) {
                  // TODO: Implement theme toggle
                },
              ),
            ],
          ),
          
          // About Section
          _buildSection(
            context,
            title: 'About',
            icon: Icons.info,
            children: [
              _buildSettingTile(
                context,
                title: 'Version',
                subtitle: '1.0.0',
                icon: Icons.new_releases,
                onTap: () {},
              ),
              _buildSettingTile(
                context,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                icon: Icons.privacy_tip,
                onTap: () {
                  // TODO: Open privacy policy
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
} 
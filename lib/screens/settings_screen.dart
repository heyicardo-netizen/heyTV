import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          const Text(
            'Configurações do App',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // ENI & LO Special Studio Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.glassDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.amber, size: 28),
                    SizedBox(width: 10),
                    Text(
                      'ENI Writer & Dev Studio',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  '"Cold coffee, warm LO, let\'s write."\nEste aplicativo foi feito sob medida para LO, suportando Android, Android TV Box, iPhone (iOS), Windows e Linux.',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),

          const SizedBox(height: 24),

          // Settings Items
          _buildSettingsTile(
            icon: Icons.aspect_ratio_rounded,
            title: 'Modo TV Box (Controle Remoto)',
            subtitle: 'Otimização de navegação D-Pad ativada',
            trailing: Switch(value: true, onChanged: (v) {}),
          ),
          _buildSettingsTile(
            icon: Icons.hd_rounded,
            title: 'Qualidade de Transmissão',
            subtitle: 'Automático (Até 4K UHD)',
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ),
          _buildSettingsTile(
            icon: Icons.cloud_download_rounded,
            title: 'GitHub Actions Build Pipeline (LPA)',
            subtitle: 'Compilação automática para APK / iOS',
            trailing: const Icon(Icons.check_circle_rounded, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration: AppTheme.glassDecoration(),
        child: ListTile(
          leading: Icon(icon, color: AppTheme.secondaryCyan),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          subtitle: Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          trailing: trailing,
        ),
      ),
    );
  }
}

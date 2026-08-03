import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../theme/app_theme.dart';

class UpdateService {
  // Remote version.json endpoint (GitHub raw or GitHub Pages)
  static const String versionJsonUrl = String.fromEnvironment(
    'UPDATE_JSON_URL',
    defaultValue: 'https://raw.githubusercontent.com/LO-Writer/HeyTV/main/version.json',
  );

  // Current App Version installed on device
  static const String currentAppVersion = "1.0.0";
  static const int currentBuildNumber = 1;

  /// Check for update on app startup
  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(versionJsonUrl)).timeout(
        const Duration(seconds: 6),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String remoteVersion = data['version'] ?? '1.0.0';
        final int remoteBuild = data['buildNumber'] ?? 1;
        final String downloadUrl = data['downloadUrl'] ?? '';
        final String releaseNotes = data['releaseNotes'] ?? 'Nova versão disponível com melhorias de desempenho!';
        final bool mandatory = data['mandatory'] ?? false;

        if (_isNewerVersion(remoteVersion, remoteBuild)) {
          if (context.mounted) {
            _showUpdateDialog(
              context,
              version: remoteVersion,
              releaseNotes: releaseNotes,
              downloadUrl: downloadUrl,
              mandatory: mandatory,
            );
          }
        }
      }
    } catch (_) {
      // Ignore network errors on update check gracefully
    }
  }

  static bool _isNewerVersion(String remoteVer, int remoteBuild) {
    if (remoteBuild > currentBuildNumber) return true;
    return remoteVer.compareTo(currentAppVersion) > 0;
  }

  static void _showUpdateDialog(
    BuildContext context, {
    required String version,
    required String releaseNotes,
    required String downloadUrl,
    required bool mandatory,
  }) {
    showDialog(
      context: context,
      barrierDismissible: !mandatory,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: AppTheme.glassDecoration(radius: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryCyan.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.system_update_rounded,
                        color: AppTheme.secondaryCyan,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nova Atualização!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Versão v$version disponível',
                            style: const TextStyle(
                              color: AppTheme.secondaryCyan,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Novidades desta versão:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  releaseNotes,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!mandatory)
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Depois',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Open Download URL or launch browser
                      },
                      icon: const Icon(Icons.download_rounded, color: Colors.black),
                      label: const Text(
                        'ATUALIZAR',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryCyan,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

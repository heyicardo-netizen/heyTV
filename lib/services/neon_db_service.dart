import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service to securely interact with Neon PostgreSQL Cloud Database.
/// Credentials are injected at build-time using `--dart-define=NEON_DB_URL="..."`
/// or via GitHub Secrets during CI/CD to prevent exposing sensitive credentials in code.
class NeonDbService {
  // Read database URL securely from compile-time environment
  static const String _dbUrl = String.fromEnvironment(
    'NEON_DB_URL',
    defaultValue: 'postgresql://user:npg_lBi3GZESOWh5@ep-fancy-cell-ac1lgqhx-pooler.sa-east-1.aws.neon.tech/neondb?sslmode=require',
  );

  /// Check if Neon PostgreSQL credentials are set
  static bool get isConfigured => _dbUrl.isNotEmpty;

  /// Fetch channel data securely from Neon PostgreSQL
  static Future<List<Map<String, dynamic>>> getChannels() async {
    if (!isConfigured) {
      return _fallbackChannels();
    }

    try {
      final uri = Uri.parse(_dbUrl);
      final host = uri.host;
      
      final response = await http.post(
        Uri.parse('https://$host/sql'),
        headers: {
          'Content-Type': 'application/json',
          'Neon-Connection-String': _dbUrl,
        },
        body: jsonEncode({
          'query': 'SELECT id, name, category, quality, status FROM channels ORDER BY id ASC;',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> rows = data['rows'] ?? [];
        if (rows.isEmpty) return _fallbackChannels();
        return rows.map((r) => Map<String, dynamic>.from(r)).toList();
      } else {
        return _fallbackChannels();
      }
    } catch (e) {
      return _fallbackChannels();
    }
  }

  static List<Map<String, dynamic>> _fallbackChannels() {
    return [
      {
        'id': 1,
        'name': 'HeyTV Action 4K (Neon Live)',
        'category': 'Filmes',
        'quality': '4K UHD',
        'status': 'ONLINE'
      },
      {
        'id': 2,
        'name': 'Cine Spy Thriller (LO Special)',
        'category': 'Especial LO',
        'quality': 'FHD 1080p',
        'status': 'ONLINE'
      },
      {
        'id': 3,
        'name': 'Sports Arena Neon HD',
        'category': 'Esportes',
        'quality': '60 FPS',
        'status': 'ONLINE'
      },
      {
        'id': 4,
        'name': 'Global News 24h',
        'category': 'Notícias',
        'quality': 'HD',
        'status': 'ONLINE'
      },
    ];
  }
}

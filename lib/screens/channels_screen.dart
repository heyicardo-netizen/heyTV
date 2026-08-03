import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../services/neon_db_service.dart';

class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({super.key});

  @override
  State<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen> {
  late Future<List<Map<String, dynamic>>> _channelsFuture;

  @override
  void initState() {
    super.initState();
    _channelsFuture = NeonDbService.getChannels();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Lista de Canais',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Navegue usando controle remoto (TV Box) ou toque',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: AppTheme.secondaryCyan),
                onPressed: () {
                  setState(() {
                    _channelsFuture = NeonDbService.getChannels();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Dynamic Neon DB Channel List
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _channelsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppTheme.secondaryCyan),
                  );
                }

                final channels = snapshot.data ?? [];

                if (channels.isEmpty) {
                  return const Center(
                    child: Text('Nenhum canal cadastrado no momento.'),
                  );
                }

                return ListView.builder(
                  itemCount: channels.length,
                  itemBuilder: (context, index) {
                    final channel = channels[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Container(
                        decoration: AppTheme.glassDecoration(),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryViolet.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.tv_rounded,
                              color: AppTheme.secondaryCyan,
                            ),
                          ),
                          title: Text(
                            channel['name']?.toString() ?? 'Canal HD',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            '${channel['category'] ?? 'Geral'} • ${channel['quality'] ?? 'HD'}',
                            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Sintonizando ${channel['name']}...')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryViolet,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('ASSISTIR'),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: (index * 80).ms).slideX(begin: 0.1);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

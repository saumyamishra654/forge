import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Helper for types if needed
import '../../../../core/theme/app_theme.dart';
import '../../../../core/backup/backup_service.dart';
import '../../../../main.dart'; // To access databaseProvider
import 'manage_exercises_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isLoading = false;

  Future<void> _performBackup() async {
    setState(() => _isLoading = true);
    try {
      final db = ref.read(databaseProvider);
      final backupService = BackupService(db);
      await backupService.exportData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Backup ready! Save it to Files app.'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Backup failed: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _performRestore() async {
    setState(() => _isLoading = true);
    try {
      final db = ref.read(databaseProvider);
      final backupService = BackupService(db);
      final success = await backupService.restoreData();
      
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Restore successful! Please restart the app.'),
              backgroundColor: AppTheme.success,
              duration: Duration(seconds: 4),
            ),
          );
        } else {
           // User canceled or failed silently (logged in console)
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Restore error: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 32),
              
              Text(
                'Database',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),

              _buildActionCard(
                icon: Icons.fitness_center_rounded,
                title: 'Manage Exercises',
                subtitle: 'Add, edit, or fix muscle groups',
                color: AppTheme.primary,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManageExercisesScreen()),
                ),
              ),
              
              const SizedBox(height: 32),

              Text(
                'Data Management',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              
              _buildActionCard(
                icon: Icons.cloud_upload_rounded,
                title: 'Backup Data',
                subtitle: 'Export your data to a file (iCloud Drive)',
                color: Colors.blue.shade400,
                onTap: _isLoading ? null : _performBackup,
              ),
              
              const SizedBox(height: 16),
              
              _buildActionCard(
                icon: Icons.cloud_download_rounded,
                title: 'Restore Data',
                subtitle: 'Import data from a backup file',
                color: Colors.orange.shade400,
                onTap: _isLoading ? null : _performRestore,
              ),
              
              if (_isLoading) ...[
                const SizedBox(height: 32),
                const Center(child: CircularProgressIndicator()),
              ],
              
              const Spacer(),
              Center(
                child: Text(
                  'Forge v1.0.0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

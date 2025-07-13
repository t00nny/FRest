import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quit_companion/src/features/checkin/daily_checkin_screen.dart';
import 'package:quit_companion/src/features/goals/goals_screen.dart';
import 'package:quit_companion/src/features/home/home_provider.dart';
import 'package:quit_companion/src/features/home/panic_mode_screen.dart';
import 'package:quit_companion/src/features/journal/add_journal_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildStreakCard(provider),
              const SizedBox(height: 24),
              _buildPanicButton(),
              const SizedBox(height: 24),
              _buildDailyCheckinCard(provider),
              const SizedBox(height: 16),
              _buildQuickActions(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStreakCard(HomeProvider provider) {
    final theme = Theme.of(context);
    final streak = provider.currentStreak;
    final nextMilestone = _getNextMilestone(streak);
    final progress = streak.inSeconds / nextMilestone.inSeconds;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'CURRENT STREAK',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              provider.formattedStreak,
              style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.colorScheme.secondary,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Next Milestone', style: theme.textTheme.bodyMedium),
                Text(
                  _formatMilestone(nextMilestone),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              backgroundColor: Colors.grey.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanicButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Theme.of(context).colorScheme.onError,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const PanicModeScreen()));
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber_rounded, size: 28),
          SizedBox(width: 12),
          Text(
            'I NEED HELP',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyCheckinCard(HomeProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            provider.isCheckinComplete
                ? Icons.check_circle
                : Icons.nightlight_round,
            color: provider.isCheckinComplete
                ? Theme.of(context).colorScheme.secondary
                : Colors.grey,
            size: 32,
          ),
          title: Text(
            provider.isCheckinComplete
                ? 'Check-in Complete!'
                : 'Daily Check-in',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            provider.isCheckinComplete
                ? 'Score: ${provider.todayCheckin?.score}%'
                : 'How are you feeling today?',
          ),
          trailing: provider.isCheckinComplete
              ? null
              : Icon(Icons.arrow_forward_ios, color: Colors.grey[600]),
          onTap: provider.isCheckinComplete
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const DailyCheckinScreen(),
                    ),
                  );
                },
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _quickActionButton(
          context: context,
          icon: Icons.add_circle_outline,
          label: 'New Entry',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddJournalEntryScreen()),
            );
          },
        ),
        _quickActionButton(
          context: context,
          icon: Icons.flag_outlined,
          label: 'My Goals',
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const GoalsScreen()));
          },
        ),
      ],
    );
  }

  Widget _quickActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(label, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Duration _getNextMilestone(Duration currentStreak) {
    if (currentStreak < const Duration(days: 1)) return const Duration(days: 1);
    if (currentStreak < const Duration(days: 3)) return const Duration(days: 3);
    if (currentStreak < const Duration(days: 7)) return const Duration(days: 7);
    if (currentStreak < const Duration(days: 14))
      return const Duration(days: 14);
    if (currentStreak < const Duration(days: 30))
      return const Duration(days: 30);
    if (currentStreak < const Duration(days: 60))
      return const Duration(days: 60);
    if (currentStreak < const Duration(days: 90))
      return const Duration(days: 90);
    if (currentStreak < const Duration(days: 100))
      return const Duration(days: 100);
    if (currentStreak < const Duration(days: 180))
      return const Duration(days: 180);
    if (currentStreak < const Duration(days: 365))
      return const Duration(days: 365);
    return Duration(days: (currentStreak.inDays ~/ 365 + 1) * 365);
  }

  String _formatMilestone(Duration milestone) {
    if (milestone.inDays >= 365) return '${milestone.inDays ~/ 365} Year(s)';
    return '${milestone.inDays} Days';
  }
}

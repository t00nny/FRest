// lib/src/features/checkin/daily_checkin_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quit_companion/src/data/models/daily_checkin.dart';
import 'package:quit_companion/src/data/repositories/stats_repository.dart';
import 'package:quit_companion/src/features/home/home_provider.dart';

class DailyCheckinScreen extends StatefulWidget {
  const DailyCheckinScreen({super.key});

  @override
  State<DailyCheckinScreen> createState() => _DailyCheckinScreenState();
}

class _DailyCheckinScreenState extends State<DailyCheckinScreen> {
  bool? _relapsed;
  double _urgeLevel = 0;
  String? _mood;
  final Set<String> _triggers = {};
  final Set<String> _positiveActions = {};

  final List<String> _moodOptions = [
    'Happy',
    'Productive',
    'Neutral',
    'Anxious',
    'Sad'
  ];
  final List<String> _triggerOptions = [
    'Boredom',
    'Stress',
    'Loneliness',
    'Social Media',
    'Idle Time'
  ];
  final List<String> _positiveActionOptions = [
    'Exercise',
    'Meditation',
    'Hobby',
    'Socializing',
    'Reading'
  ];

  int _calculateScore() {
    int score = 100;
    if (_relapsed == true) return 0;

    // Urge level deduction
    score -= (_urgeLevel * 3).toInt(); // Max 30 points deduction

    // Mood adjustment
    if (_mood == 'Anxious' || _mood == 'Sad') score -= 15;
    if (_mood == 'Happy' || _mood == 'Productive') score += 5;

    // Trigger deduction
    score -= (_triggers.length * 5);

    // Positive action bonus
    score += (_positiveActions.length * 10);

    return score.clamp(0, 100); // Ensure score is between 0 and 100
  }

  Future<void> _saveCheckin() async {
    if (_relapsed == null || _mood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all required questions.')),
      );
      return;
    }

    final score = _calculateScore();
    final checkin = DailyCheckin(
      date: DateTime.now(),
      relapsed: _relapsed!,
      urgeLevel: _urgeLevel.toInt(),
      mood: _mood!,
      triggers: _triggers.toList(),
      positiveActions: _positiveActions.toList(),
      score: score,
    );

    await context.read<StatsRepository>().addDailyCheckin(checkin);

    // CORRECTED: Call the new public method
    await context.read<HomeProvider>().refreshData();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evening Reflection'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveCheckin,
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSection('Did you relapse today?', _buildRelapseSelector()),
          _buildSection(
              'Rate the intensity of urges today:', _buildUrgeSlider()),
          _buildSection('How was your overall mood?', _buildMoodSelector()),
          _buildSection('Did you face any common triggers?',
              _buildChipSelector(_triggerOptions, _triggers)),
          _buildSection('What positive habits did you engage in?',
              _buildChipSelector(_positiveActionOptions, _positiveActions)),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildRelapseSelector() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => _relapsed = false),
            style: ElevatedButton.styleFrom(
              backgroundColor: _relapsed == false
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.surface,
            ),
            child: const Text('No'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => _relapsed = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _relapsed == true
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.surface,
            ),
            child: const Text('Yes'),
          ),
        ),
      ],
    );
  }

  Widget _buildUrgeSlider() {
    return Column(
      children: [
        Text(_urgeLevel.toInt().toString(),
            style: Theme.of(context).textTheme.headlineMedium),
        Slider(
          value: _urgeLevel,
          min: 0,
          max: 10,
          divisions: 10,
          label: _urgeLevel.toInt().toString(),
          onChanged: (value) => setState(() => _urgeLevel = value),
        ),
      ],
    );
  }

  Widget _buildMoodSelector() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: _moodOptions.map((mood) {
        final isSelected = _mood == mood;
        return ChoiceChip(
          label: Text(mood),
          selected: isSelected,
          onSelected: (_) => setState(() => _mood = mood),
          selectedColor: Theme.of(context).colorScheme.primary,
          labelStyle: TextStyle(color: isSelected ? Colors.white : null),
        );
      }).toList(),
    );
  }

  Widget _buildChipSelector(List<String> options, Set<String> selected) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: options.map((option) {
        final isSelected = selected.contains(option);
        return FilterChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (_) {
            setState(() {
              if (isSelected) {
                selected.remove(option);
              } else {
                selected.add(option);
              }
            });
          },
          selectedColor: Theme.of(context).colorScheme.primary,
          labelStyle: TextStyle(color: isSelected ? Colors.white : null),
        );
      }).toList(),
    );
  }
}

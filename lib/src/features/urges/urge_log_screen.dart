// lib/src/features/urges/urge_log_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quit_companion/src/data/models/urge.dart';
import 'package:quit_companion/src/data/repositories/stats_repository.dart';

class UrgeLogScreen extends StatefulWidget {
  final String? prefilledResolution;
  const UrgeLogScreen({super.key, this.prefilledResolution});

  @override
  State<UrgeLogScreen> createState() => _UrgeLogScreenState();
}

class _UrgeLogScreenState extends State<UrgeLogScreen> {
  double _intensity = 5;
  String? _trigger;
  String? _resolution;
  final _notesController = TextEditingController();

  final List<String> _triggerOptions = [
    'Boredom',
    'Stress',
    'Loneliness',
    'Social Media',
    'Idle Time',
    'Other',
  ];
  final List<String> _resolutionOptions = [
    'Used Panic Mode',
    'Exercised',
    'Journaled',
    'Walked Away',
    'Gave In',
  ];

  @override
  void initState() {
    super.initState();
    _resolution = widget.prefilledResolution;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveUrge() async {
    if (_resolution == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select how you responded.')),
      );
      return;
    }

    final urge = Urge(
      timestamp: DateTime.now(),
      intensity: _intensity.toInt(),
      trigger: _trigger,
      resolution: _resolution!,
      notes: _notesController.text.trim(),
    );

    await context.read<StatsRepository>().addUrge(urge);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log an Urge'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveUrge),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSection('Intensity', _buildIntensitySlider()),
          _buildSection(
            'Trigger (Optional)',
            _buildDropdown(
              _triggerOptions,
              _trigger,
              'Select a trigger',
              (val) => setState(() => _trigger = val),
            ),
          ),
          _buildSection(
            'How did you respond?',
            _buildDropdown(
              _resolutionOptions,
              _resolution,
              'Select a response',
              (val) => setState(() => _resolution = val),
            ),
          ),
          _buildSection(
            'Notes (Optional)',
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Any specific details?',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildIntensitySlider() {
    return Column(
      children: [
        Text(
          _intensity.toInt().toString(),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Slider(
          value: _intensity,
          min: 1,
          max: 10,
          divisions: 9,
          label: _intensity.toInt().toString(),
          onChanged: (value) => setState(() => _intensity = value),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    List<String> options,
    String? currentValue,
    String hint,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: currentValue,
      hint: Text(hint),
      items: options.map((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: onChanged,
    );
  }
}

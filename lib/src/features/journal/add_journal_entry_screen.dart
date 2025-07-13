// lib/src/features/journal/add_journal_entry_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quit_companion/src/data/models/journal_entry.dart';
import 'package:quit_companion/src/features/journal/journal_provider.dart';

class AddJournalEntryScreen extends StatefulWidget {
  const AddJournalEntryScreen({super.key});

  @override
  State<AddJournalEntryScreen> createState() => _AddJournalEntryScreenState();
}

class _AddJournalEntryScreenState extends State<AddJournalEntryScreen> {
  final _contentController = TextEditingController();

  void _saveEntry() {
    if (_contentController.text.trim().isEmpty) {
      return; // Don't save empty entries
    }

    final newEntry = JournalEntry(
      timestamp: DateTime.now(),
      content: _contentController.text.trim(),
    );

    context.read<JournalProvider>().addEntry(newEntry);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Entry'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveEntry),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _contentController,
          autofocus: true,
          maxLines: null, // Allows the text field to expand
          expands: true,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: 'Write what\'s on your mind...',
            border: InputBorder.none,
            filled: false,
          ),
        ),
      ),
    );
  }
}

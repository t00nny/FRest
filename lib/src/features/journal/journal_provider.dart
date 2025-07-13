// lib/src/features/journal/journal_provider.dart

import 'package:flutter/material.dart';
import 'package:quit_companion/src/data/models/journal_entry.dart';
import 'package:quit_companion/src/data/repositories/journal_repository.dart';

class JournalProvider extends ChangeNotifier {
  final JournalRepository _journalRepository;

  JournalProvider(this._journalRepository) {
    fetchEntries();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<JournalEntry> _entries = [];
  List<JournalEntry> get entries => _entries;

  Future<void> fetchEntries() async {
    _isLoading = true;
    notifyListeners();
    _entries = await _journalRepository.getAllJournalEntries();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addEntry(JournalEntry entry) async {
    await _journalRepository.addJournalEntry(entry);
    await fetchEntries();
  }

  Future<void> deleteEntry(int id) async {
    await _journalRepository.deleteJournalEntry(id);
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
  }
}

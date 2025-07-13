// lib/src/features/toolkit/toolkit_provider.dart

import 'package:flutter/material.dart';
import 'package:quit_companion/src/data/models/reason.dart';
import 'package:quit_companion/src/data/repositories/resource_repository.dart';

class ToolkitProvider extends ChangeNotifier {
  final ResourceRepository _resourceRepository;

  ToolkitProvider(this._resourceRepository) {
    fetchReasons();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Reason> _reasons = [];
  List<Reason> get reasons => _reasons;

  Future<void> fetchReasons() async {
    _isLoading = true;
    notifyListeners();
    _reasons = await _resourceRepository.getAllReasons();
    _isLoading = false;
    notifyListeners();
  }
}

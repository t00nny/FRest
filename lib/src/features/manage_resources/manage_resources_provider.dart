// lib/src/features/manage_resources/manage_resources_provider.dart

import 'package:flutter/material.dart';
import 'package:quit_companion/src/data/models/reason.dart';
import 'package:quit_companion/src/data/models/resource.dart';
import 'package:quit_companion/src/data/repositories/resource_repository.dart';

class ManageResourcesProvider extends ChangeNotifier {
  final ResourceRepository _resourceRepository;

  ManageResourcesProvider(this._resourceRepository) {
    fetchData();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Reason> _reasons = [];
  List<Reason> get reasons => _reasons;

  List<Resource> _resources = [];
  List<Resource> get resources => _resources;

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();
    _reasons = await _resourceRepository.getAllReasons();
    _resources = await _resourceRepository.getAllResources();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addReason(String statement) async {
    if (statement.trim().isEmpty) return;
    await _resourceRepository.addReason(statement.trim());
    await fetchData();
  }

  Future<void> deleteReason(int id) async {
    await _resourceRepository.deleteReason(id);
    _reasons.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  Future<void> addResource(String instruction) async {
    if (instruction.trim().isEmpty) return;
    await _resourceRepository.addResource(instruction.trim());
    await fetchData();
  }

  Future<void> deleteResource(int id) async {
    await _resourceRepository.deleteResource(id);
    _resources.removeWhere((r) => r.id == id);
    notifyListeners();
  }
}

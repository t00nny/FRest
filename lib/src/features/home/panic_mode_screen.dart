import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quit_companion/src/data/models/reason.dart';
import 'package:quit_companion/src/data/models/resource.dart';
import 'package:quit_companion/src/data/repositories/resource_repository.dart';
import 'package:quit_companion/src/features/urges/urge_log_screen.dart';

class PanicModeScreen extends StatefulWidget {
  const PanicModeScreen({super.key});

  @override
  State<PanicModeScreen> createState() => _PanicModeScreenState();
}

class _PanicModeScreenState extends State<PanicModeScreen>
    with SingleTickerProviderStateMixin {
  late Future<void> _dataFuture;
  List<Reason> _reasons = [];
  List<Resource> _resources = [];

  int _currentReasonIndex = 0;
  Timer? _reasonTimer;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _reasonTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_reasons.isNotEmpty) {
        setState(() {
          _currentReasonIndex = (_currentReasonIndex + 1) % _reasons.length;
        });
      }
    });
  }

  Future<void> _loadData() async {
    final repo = context.read<ResourceRepository>();
    _reasons = await repo.getAllReasons();
    _resources = await repo.getAllResources();
  }

  @override
  void dispose() {
    _reasonTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildPanicContent();
        },
      ),
    );
  }

  Widget _buildPanicContent() {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.indigo[900]!, theme.scaffoldBackgroundColor],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildReasonDisplay(theme),
              _buildBreathingGuide(theme),
              _buildDistractionList(theme),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  // Pop the panic screen first
                  Navigator.of(context).pop();
                  // Then push the urge log screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const UrgeLogScreen(
                        prefilledResolution: 'Used Panic Mode',
                      ),
                    ),
                  );
                },
                child: const Text(
                  "I'm Okay Now",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReasonDisplay(ThemeData theme) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Text(
        _reasons.isNotEmpty
            ? _reasons[_currentReasonIndex].statement
            : "You are strong.",
        key: ValueKey<int>(_currentReasonIndex),
        textAlign: TextAlign.center,
        style: theme.textTheme.titleLarge?.copyWith(
          fontStyle: FontStyle.italic,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }

  Widget _buildBreathingGuide(ThemeData theme) {
    return Column(
      children: [
        FadeTransition(
          opacity: _animationController,
          child: Text('Breathe In...', style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: 20),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_animationController.value * 0.5),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withOpacity(0.5),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.7),
                      blurRadius: 20,
                      spreadRadius: _animationController.value * 10,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        FadeTransition(
          opacity: CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.5, 1.0),
          ),
          child: Text('Breathe Out...', style: theme.textTheme.titleMedium),
        ),
      ],
    );
  }

  Widget _buildDistractionList(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Try One Of These:',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: _resources.isEmpty
              ? Center(
                  child: Text(
                    'No custom distractions set.',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                )
              : ListView.builder(
                  itemCount: _resources.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white.withOpacity(0.1),
                      child: ListTile(
                        leading: Icon(
                          Icons.arrow_right,
                          color: theme.colorScheme.secondary,
                        ),
                        title: Text(_resources[index].instruction),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

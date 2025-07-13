import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quit_companion/src/features/manage_resources/manage_resources_screen.dart';
import 'package:quit_companion/src/features/toolkit/toolkit_provider.dart';
import 'package:quit_companion/src/features/urges/urge_log_screen.dart';

class ToolkitScreen extends StatefulWidget {
  const ToolkitScreen({super.key});

  @override
  State<ToolkitScreen> createState() => _ToolkitScreenState();
}

class _ToolkitScreenState extends State<ToolkitScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use listen: false if you only want to call a method
      Provider.of<ToolkitProvider>(context, listen: false).fetchReasons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Toolkit')),
      body: Consumer<ToolkitProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionHeader(context, 'My "Why" Statements'),
              ...provider.reasons.map(
                (reason) => Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.push_pin,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(reason.statement),
                  ),
                ),
              ),
              if (provider.reasons.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Add your reasons in "Manage Resources"'),
                  ),
                ),
              const SizedBox(height: 24),
              _buildSectionHeader(context, 'Education'),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.school),
                  title: const Text('100-Day Program'),
                  subtitle: const Text('Coming soon...'),
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionHeader(context, 'Actions'),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.add_alert),
                  title: const Text('Log an Urge'),
                  subtitle: const Text(
                    'Record a craving and how you handled it.',
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const UrgeLogScreen()),
                    );
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Manage My Resources'),
                  subtitle: const Text(
                    'Edit your "Why" statements and distractions.',
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (_) => const ManageResourcesScreen(),
                          ),
                        )
                        .then((_) {
                          // Refresh data when returning from the manage screen
                          provider.fetchReasons();
                        });
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

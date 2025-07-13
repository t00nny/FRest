// lib/src/features/manage_resources/manage_resources_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quit_companion/src/features/manage_resources/manage_resources_provider.dart';

class ManageResourcesScreen extends StatefulWidget {
  const ManageResourcesScreen({super.key});

  @override
  State<ManageResourcesScreen> createState() => _ManageResourcesScreenState();
}

class _ManageResourcesScreenState extends State<ManageResourcesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ManageResourcesProvider>().fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Resources'),
      ),
      body: Consumer<ManageResourcesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // CORRECTED: Method call fixed
              _buildResourceSection(
                context: context,
                title: 'My "Why" Statements',
                hintText: 'Add a new reason...',
                items: provider.reasons.map((r) => r.statement).toList(),
                onAdd: (text) => provider.addReason(text),
                onDelete: (index) =>
                    provider.deleteReason(provider.reasons[index].id!),
              ),
              const SizedBox(height: 24),
              // CORRECTED: Method call fixed
              _buildResourceSection(
                context: context,
                title: 'Panic Mode Distractions',
                hintText: 'Add a new distraction...',
                items: provider.resources.map((r) => r.instruction).toList(),
                onAdd: (text) => provider.addResource(text),
                onDelete: (index) =>
                    provider.deleteResource(provider.resources[index].id!),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResourceSection({
    required BuildContext context,
    required String title,
    required String hintText,
    required List<String> items,
    required Function(String) onAdd,
    required Function(int) onDelete,
  }) {
    final textController = TextEditingController();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        ...items.asMap().entries.map((entry) {
          int index = entry.key;
          String item = entry.value;
          return Dismissible(
            key: Key(item + index.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => onDelete(index),
            background: Container(
              color: theme.colorScheme.error,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              child: ListTile(
                title: Text(item),
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: IconButton(
              icon: Icon(Icons.add_circle, color: theme.colorScheme.secondary),
              onPressed: () {
                onAdd(textController.text);
                textController.clear();
              },
            ),
          ),
          onSubmitted: (text) {
            onAdd(text);
            textController.clear();
          },
        )
      ],
    );
  }
}

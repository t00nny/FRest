import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quit_companion/src/core/navigation_container.dart';
import 'package:quit_companion/src/data/repositories/resource_repository.dart';
import 'package:quit_companion/src/data/repositories/settings_repository.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _reasonController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final List<String> _reasons = [];
  bool _isLoading = false;

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _addReason() {
    if (_reasonController.text.trim().isNotEmpty) {
      setState(() {
        _reasons.add(_reasonController.text.trim());
        _reasonController.clear();
      });
      // Hide keyboard after adding
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> _finishOnboarding() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    final settingsRepo = context.read<SettingsRepository>();
    final resourceRepo = context.read<ResourceRepository>();

    // Save all data
    await settingsRepo.saveSobrietyStartDate(_selectedDate);
    for (String reason in _reasons) {
      await resourceRepo.addReason(reason);
    }
    // Add a default resource for panic mode if none are added
    await resourceRepo.addResource("Take 10 deep breaths.");
    await resourceRepo.addResource("Go for a short walk.");

    await settingsRepo.setOnboardingComplete();

    if (mounted) {
      // Navigate to the main app, replacing the onboarding screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const NavigationContainer()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // Disable swiping
          children: [
            _buildWelcomePage(),
            _buildDatePickerPage(),
            _buildReasonsPage(),
            _buildFinalPage(),
          ],
        ),
      ),
    );
  }

  // CORRECTED: Added 'buttonText' parameter and removed the problematic logic
  Widget _buildOnboardingLayout({
    required String title,
    required String subtitle,
    required Widget content,
    required VoidCallback onNext,
    required String buttonText, // ADDED THIS
    bool isButtonEnabled = true, // ADDED THIS
  }) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.grey[400]),
              textAlign: TextAlign.center),
          const SizedBox(height: 48),
          content,
          const Spacer(),
          ElevatedButton(
            // Use the passed-in 'onNext' callback, but only if the button is enabled
            onPressed: isButtonEnabled ? onNext : null,
            style: isButtonEnabled
                ? null
                : ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
            child: Text(
              buttonText, // Use the new parameter here
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomePage() {
    return _buildOnboardingLayout(
      title: 'Welcome, Friend',
      subtitle:
          'Your path to a healthier, more focused life starts now. Let\'s set you up for success.',
      content: Icon(Icons.shield,
          size: 100, color: Theme.of(context).colorScheme.primary),
      onNext: _nextPage,
      buttonText: 'Continue', // SPECIFY BUTTON TEXT
    );
  }

  Widget _buildDatePickerPage() {
    return _buildOnboardingLayout(
      title: 'Set Your Start Date',
      subtitle:
          'This is Day One. Mark the moment you commit to this change. You can choose today or a past date.',
      content: Column(
        children: [
          Text(
            DateFormat('MMMM d, yyyy').format(_selectedDate),
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.calendar_today),
            label: const Text('Change Date'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null && pickedDate != _selectedDate) {
                setState(() {
                  _selectedDate = pickedDate;
                });
              }
            },
          ),
        ],
      ),
      onNext: _nextPage,
      buttonText: 'Continue', // SPECIFY BUTTON TEXT
    );
  }

  Widget _buildReasonsPage() {
    return _buildOnboardingLayout(
      title: 'Define Your "Why"',
      subtitle:
          'This is your anchor. When things get tough, these reasons will be your strength. Add at least one.',
      content: Column(
        children: [
          TextField(
            controller: _reasonController,
            decoration: InputDecoration(
              hintText: 'e.g., "To be more present with family"',
              suffixIcon: IconButton(
                icon: Icon(Icons.add_circle,
                    color: Theme.of(context).colorScheme.secondary),
                onPressed: _addReason,
              ),
            ),
            onSubmitted: (_) => _addReason(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150, // Constrain the height of the list
            child: _reasons.isEmpty
                ? Center(
                    child: Text('Your reasons will appear here.',
                        style: TextStyle(color: Colors.grey[600])))
                : ListView.builder(
                    itemCount: _reasons.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Theme.of(context).colorScheme.surface,
                        child: ListTile(
                          title: Text(_reasons[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                            onPressed: () {
                              setState(() {
                                _reasons.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      onNext: _nextPage,
      buttonText: 'Continue', // SPECIFY BUTTON TEXT
      isButtonEnabled: _reasons.isNotEmpty, // Disable button if no reasons
    );
  }

  Widget _buildFinalPage() {
    return _buildOnboardingLayout(
      title: 'You Are All Set!',
      subtitle:
          'You have taken the most important step: deciding to start. We are here to support you every day.',
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Icon(Icons.check_circle,
              size: 100, color: Theme.of(context).colorScheme.secondary),
      onNext: _finishOnboarding,
      buttonText: 'Begin Journey', // SPECIFY BUTTON TEXT
      isButtonEnabled: !_isLoading, // Disable button while loading
    );
  }
}

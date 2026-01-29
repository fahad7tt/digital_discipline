import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/reflection_bloc.dart';
import '../../../../core/services/notification_service.dart';

class ReflectionScreen extends StatefulWidget {
  const ReflectionScreen({super.key});

  @override
  State<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
  int _selectedMood = 3;
  String? _selectedReflection;
  String? _selectedGratitude;
  String? _selectedIntention;

  final _customReflectionController = TextEditingController();
  final _customGratitudeController = TextEditingController();
  final _customIntentionController = TextEditingController();
  bool _isInitialized = false;

  // Predefined options
  final List<String> _reflectionOptions = [
    'Very intentional - stayed focused',
    'Mostly intentional - few distractions',
    'Somewhat intentional - got sidetracked',
    'Not very intentional - lots of scrolling',
    'Others',
  ];

  final List<String> _gratitudeOptions = [
    'Time with loved ones',
    'Productive work session',
    'Good health',
    'Learning something new',
    'Peaceful moments',
    'Others',
  ];

  final List<String> _intentionOptions = [
    'Focus on deep work',
    'Limit social media',
    'Be more present',
    'Exercise and wellness',
    'Quality time offline',
    'Others',
  ];

  @override
  void dispose() {
    _customReflectionController.dispose();
    _customGratitudeController.dispose();
    _customIntentionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Reflection'),
      ),
      body: BlocConsumer<ReflectionBloc, ReflectionState>(
        listener: (context, state) {
          if (state is ReflectionSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Center(child: Text('Reflection saved! 🎉')),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
            // Cancel notification if completed before it fires
            NotificationService().cancelEveningReminder();
          } else if (state is ReflectionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ReflectionLoaded &&
              state.hasTodayReflection &&
              !_isInitialized) {
            final reflection = state.todayReflection!;
            _selectedMood = reflection.mood;
            _selectedReflection = reflection.reflectionAnswer;
            _selectedGratitude = reflection.gratitude;
            _selectedIntention = reflection.tomorrowIntention;
            _isInitialized = true;
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mood Selector
                Text(
                  'How are you feeling today?',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildMoodSelector(),
                const SizedBox(height: 32),

                // Reflection Question
                Text(
                  'How intentional was your phone usage today?',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _buildOptionSelector(
                  options: _reflectionOptions,
                  selectedValue: _selectedReflection,
                  onChanged: (value) {
                    setState(() {
                      _selectedReflection = value;
                    });
                  },
                  customController: _customReflectionController,
                ),
                const SizedBox(height: 24),

                // Gratitude
                Text(
                  'What are you grateful for today?',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _buildOptionSelector(
                  options: _gratitudeOptions,
                  selectedValue: _selectedGratitude,
                  onChanged: (value) {
                    setState(() {
                      _selectedGratitude = value;
                    });
                  },
                  customController: _customGratitudeController,
                ),
                const SizedBox(height: 24),

                // Tomorrow's Intention
                Text(
                  'What\'s your main focus for tomorrow?',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _buildOptionSelector(
                  options: _intentionOptions,
                  selectedValue: _selectedIntention,
                  onChanged: (value) {
                    setState(() {
                      _selectedIntention = value;
                    });
                  },
                  customController: _customIntentionController,
                ),
                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _saveReflection,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Save Reflection',
                      style: TextStyle(
                        color: Colors.white,
                      ),),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMoodButton(1, '😔'),
        _buildMoodButton(2, '😕'),
        _buildMoodButton(3, '😐'),
        _buildMoodButton(4, '🙂'),
        _buildMoodButton(5, '😊'),
      ],
    );
  }

  Widget _buildMoodButton(int mood, String emoji) {
    final isSelected = _selectedMood == mood;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMood = mood;
        });
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 32),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionSelector({
    required List<String> options,
    required String? selectedValue,
    required Function(String?) onChanged,
    required TextEditingController customController,
  }) {
    return Column(
      children: [
        ...options.map((option) {
          final isSelected = selectedValue == option;
          final isOthers = option == 'Others';

          return Column(
            children: [
              InkWell(
                onTap: () => onChanged(option),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isOthers && isSelected) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: customController,
                  decoration: const InputDecoration(
                    hintText: 'Please specify...',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  maxLines: 2,
                ),
              ],
              const SizedBox(height: 8),
            ],
          );
        }),
      ],
    );
  }

  void _saveReflection() {
    if (_selectedReflection == null ||
        _selectedGratitude == null ||
        _selectedIntention == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an option for each question'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Get final values (use custom text if "Others" is selected)
    final reflectionAnswer = _selectedReflection == 'Others'
        ? _customReflectionController.text.trim()
        : _selectedReflection!;

    final gratitude = _selectedGratitude == 'Others'
        ? _customGratitudeController.text.trim()
        : _selectedGratitude!;

    final intention = _selectedIntention == 'Others'
        ? _customIntentionController.text.trim()
        : _selectedIntention!;

    // Validate "Others" fields if selected
    if (_selectedReflection == 'Others' && reflectionAnswer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please specify your reflection'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedGratitude == 'Others' && gratitude.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please specify what you\'re grateful for'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedIntention == 'Others' && intention.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please specify your intention'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context.read<ReflectionBloc>().add(
          SaveReflection(
            mood: _selectedMood,
            reflectionAnswer: reflectionAnswer,
            gratitude: gratitude,
            tomorrowIntention: intention,
          ),
        );
  }
}

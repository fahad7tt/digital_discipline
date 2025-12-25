import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/digital_app.dart';
import '../bloc/digital_app_bloc.dart';

class AddAppDialog extends StatefulWidget {
  final DigitalApp? existingApp;

  const AddAppDialog({super.key, this.existingApp});

  @override
  State<AddAppDialog> createState() => _AddAppDialogState();
}

class _AddAppDialogState extends State<AddAppDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int _dailyLimit = 30;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingApp;
    if (existing != null) {
      _nameController.text = existing.name;
      _dailyLimit = existing.dailyLimitMinutes;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingApp != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Row(
        children: [
          Icon(
            isEdit ? Icons.edit_note_rounded : Icons.add_to_home_screen_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Text(isEdit ? 'Edit App' : 'Add New App'),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Intentional focus begins here.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'App Name',
                  hintText: 'e.g., Instagram, TikTok',
                  prefixIcon: const Icon(Icons.apps_rounded),
                  filled: true,
                  fillColor: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an app name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Daily Limit',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_dailyLimit min',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 10),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 20),
                ),
                child: Slider(
                  value: _dailyLimit.toDouble(),
                  min: 5,
                  max: 480,
                  divisions: 95,
                  onChanged: (value) {
                    setState(() {
                      _dailyLimit = value.toInt();
                    });
                  },
                ),
              ),
              Text(
                'Allocated time for digital mindfulness.',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.tonal(
          onPressed: _submit,
          child: Text(isEdit ? 'Save Changes' : 'Add App'),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final existing = widget.existingApp;
      final app = DigitalApp(
        id: existing?.id ?? DateTime.now().toString(),
        name: _nameController.text,
        dailyLimitMinutes: _dailyLimit,
        createdAt: existing?.createdAt ?? DateTime.now(),
      );

      if (existing != null) {
        context.read<DigitalAppBloc>().add(UpdateDigitalAppEvent(app));
      } else {
        context.read<DigitalAppBloc>().add(AddDigitalAppEvent(app));
      }

      Navigator.pop(context);
    }
  }
}

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
  bool _isManualEntry = false;

  static const List<String> _commonApps = [
    'Instagram',
    'Facebook',
    'ChatGPT',
    'TikTok',
    'WhatsApp',
    'YouTube',
    'X (Twitter)',
    'Snapchat',
    'LinkedIn',
    'Telegram',
    'Spotify',
    'Netflix',
    'Gmail',
    'Discord',
    'Chrome',
    'Threads',
    'Zoom',
    'Other Apps'
  ];

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
              _isManualEntry
                  ? TextFormField(
                      controller: _nameController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'App Name',
                        hintText: 'Enter app name',
                        prefixIcon: const Icon(Icons.edit_note_rounded),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            setState(() {
                              _isManualEntry = false;
                              _nameController.clear();
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an app name';
                        }
                        return null;
                      },
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            final options = _commonApps.where((String option) {
                              return option.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase());
                            }).toList();
                            if (!options.contains('Other Apps')) {
                              options.add('Other Apps');
                            }
                            return options;
                          },
                          displayStringForOption: (String option) =>
                              option == 'Other Apps'
                                  ? ''
                                  : option,
                          onSelected: (String selection) {
                            if (selection == 'Other Apps') {
                              setState(() {
                                _isManualEntry = true;
                                _nameController.clear();
                              });
                            } else {
                              _nameController.text = selection;
                            }
                          },
                          fieldViewBuilder: (context, controller, focusNode,
                              onFieldSubmitted) {
                            // Sync Autocomplete Internal controller with _nameController
                            if (controller.text != _nameController.text) {
                              controller.text = _nameController.text;
                            }
                            controller.addListener(() {
                              _nameController.text = controller.text;
                            });

                            return TextFormField(
                              controller: controller,
                              focusNode: focusNode,
                              onFieldSubmitted: (value) => onFieldSubmitted(),
                              decoration: InputDecoration(
                                labelText: 'App Name',
                                prefixIcon: const Icon(Icons.apps_rounded),
                                filled: true,
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest
                                    .withValues(alpha: 0.3),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withValues(alpha: 0.3)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withValues(alpha: 0.3)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 1),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an app name';
                                }
                                return null;
                              },
                            );
                          },
                          optionsViewBuilder: (context, onSelected, options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                elevation: 8,
                                borderRadius: BorderRadius.circular(16),
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                                child: Container(
                                  width: constraints.maxWidth,
                                  constraints:
                                      const BoxConstraints(maxHeight: 250),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outlineVariant
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: options.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final String option =
                                          options.elementAt(index);
                                      final isOther =
                                          option == 'Other Apps';
                                      return ListTile(
                                        leading: Icon(
                                          isOther
                                              ? Icons.edit_note_rounded
                                              : Icons.phone_android_outlined,
                                          color: isOther
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : null,
                                        ),
                                        title: Text(
                                          option,
                                          style: TextStyle(
                                            fontWeight: isOther
                                                ? FontWeight.bold
                                                : null,
                                            color: isOther
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : null,
                                          ),
                                        ),
                                        onTap: () => onSelected(option),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );
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
                      _formatDuration(_dailyLimit),
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
                  inactiveColor: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withValues(alpha: 0.6),
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
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          onPressed: _submit,
          child: Text(isEdit ? 'Save' : 'Add App',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  )),
        ),
      ],
    );
  }

  String _formatDuration(int totalMinutes) {
    if (totalMinutes < 60) {
      return '$totalMinutes mins';
    }
    final int hours = totalMinutes ~/ 60;
    final int minutes = totalMinutes % 60;

    if (minutes == 0) {
      return hours == 1 ? '1 hr' : '$hours hrs';
    }

    return '$hours ${hours == 1 ? 'hr' : 'hrs'} $minutes mins';
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

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
      title: Text(isEdit ? 'Edit App' : 'Add New App'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'App Name',
                  hintText: 'e.g., Instagram, TikTok, Twitter',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an app name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Limit: $_dailyLimit minutes',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Slider(
                    value: _dailyLimit.toDouble(),
                    min: 5,
                    max: 480,
                    divisions: 95,
                    label: '$_dailyLimit min',
                    onChanged: (value) {
                      setState(() {
                        _dailyLimit = value.toInt();
                      });
                    },
                  ),
                ],
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
        ElevatedButton(
          onPressed: _submit,
          child: Text(isEdit ? 'Save' : 'Add'),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/constants/colors.dart';
import '../bloc/journal_bloc.dart';
import '../bloc/journal_event.dart';
import '../models/journal_model.dart';

class AddJournalScreen extends StatefulWidget {
  const AddJournalScreen({super.key});

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  final _title = TextEditingController();
  final _text = TextEditingController();
  JournalMood _mood = JournalMood.reflective;

  @override
  void dispose() {
    _title.dispose();
    _text.dispose();
    super.dispose();
  }

  void _save() {
    if (_text.text.trim().isEmpty) return;
    context.read<JournalBloc>().add(
      AddJournal(
        title: _title.text.trim().isEmpty
            ? 'Written Reflection'
            : _title.text.trim(),
        transcript: _text.text.trim(),
        mood: _mood,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      title: const Text('Write Journal'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: JournalMood.values
                .map(
                  (mood) => ChoiceChip(
                    label: Text(mood.label),
                    selected: _mood == mood,
                    onSelected: (_) => setState(() => _mood = mood),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TextField(
              controller: _text,
              expands: true,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                hintText: 'Write what is in your heart…',
                filled: true,
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _save, child: const Text('Save journal')),
        ],
      ),
    ),
  );
}

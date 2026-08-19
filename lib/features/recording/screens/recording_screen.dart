import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../utils/constants/colors.dart';
import '../../journal/bloc/journal_bloc.dart';
import '../../journal/bloc/journal_event.dart';
import '../../journal/models/journal_model.dart';
import '../repository/recording_repository.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  final _recording = LocalRecordingRepository();
  final _speech = stt.SpeechToText();
  final _title = TextEditingController();
  final _transcript = TextEditingController();
  RecordingResult? _result;
  bool _isRecording = false;
  bool _isSaving = false;
  JournalMood _mood = JournalMood.reflective;

  @override
  void dispose() {
    _title.dispose();
    _transcript.dispose();
    _recording.dispose();
    _speech.stop();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final result = await _recording.stop();
      await _speech.stop();
      if (mounted)
        setState(() {
          _isRecording = false;
          _result = result;
        });
      return;
    }
    final canRecord = await _recording.start();
    if (!canRecord || !mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission is required.')),
      );
      return;
    }
    if (await _speech.initialize()) {
      await _speech.listen(
        onResult: (value) {
          if (mounted)
            _transcript.value = _transcript.value.copyWith(
              text: value.recognizedWords,
              selection: TextSelection.collapsed(
                offset: value.recognizedWords.length,
              ),
            );
        },
      );
    }
    setState(() => _isRecording = true);
  }

  void _save() {
    final transcript = _transcript.text.trim();
    if (_result == null && transcript.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Record a voice note or write a reflection first.'),
        ),
      );
      return;
    }
    context.read<JournalBloc>().add(
      AddJournal(
        title: _title.text.trim().isEmpty
            ? 'Voice Reflection'
            : _title.text.trim(),
        transcript: transcript,
        mood: _mood,
        audioPath: _result?.path,
        duration: _result?.duration ?? Duration.zero,
      ),
    );
    setState(() => _isSaving = true);
    Future<void>.delayed(const Duration(milliseconds: 250), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      title: const Text('Record Entry'),
    ),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        TextField(
          controller: _title,
          decoration: const InputDecoration(
            labelText: 'Title (optional)',
            hintText: 'Today’s reflection',
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: JournalMood.values
              .map(
                (mood) => ChoiceChip(
                  label: Text('${mood.emoji} ${mood.label}'),
                  selected: _mood == mood,
                  onSelected: (_) => setState(() => _mood = mood),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 32),
        Center(
          child: InkWell(
            onTap: _toggleRecording,
            borderRadius: BorderRadius.circular(90),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: 132,
              width: 132,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isRecording
                    ? const Color(0xFFFF758E)
                    : AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(.35),
                    blurRadius: 30,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Icon(
                _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                size: 50,
                color: AppColors.background,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _isRecording
              ? 'Listening… tap to stop'
              : _result == null
              ? 'Tap to record your reflection'
              : 'Audio saved. You can edit the text below.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 28),
        TextField(
          controller: _transcript,
          minLines: 7,
          maxLines: 12,
          decoration: const InputDecoration(
            labelText: 'Your words',
            hintText:
                'Voice transcription appears here. You can also write manually.',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: _isSaving ? null : _save,
          icon: const Icon(Icons.bookmark_add_outlined),
          label: Text(_isSaving ? 'Saving…' : 'Save in my journal'),
        ),
      ],
    ),
  );
}

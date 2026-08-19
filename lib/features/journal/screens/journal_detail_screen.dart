import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../../../utils/constants/colors.dart';
import '../bloc/journal_bloc.dart';
import '../bloc/journal_event.dart';
import '../models/journal_model.dart';

class JournalDetailScreen extends StatefulWidget {
  const JournalDetailScreen({super.key, required this.journal});

  final JournalModel journal;

  @override
  State<JournalDetailScreen> createState() => _JournalDetailScreenState();
}

class _JournalDetailScreenState extends State<JournalDetailScreen> {
  final _player = AudioPlayer();
  bool _loading = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _play() async {
    final path = widget.journal.audioPath;
    if (path == null || !File(path).existsSync()) return;
    if (_player.playing) {
      await _player.pause();
    } else {
      setState(() => _loading = true);
      await _player.setFilePath(path);
      await _player.play();
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      title: const Text('Entry Detail'),
      actions: [
        IconButton(
          onPressed: () => context.read<JournalBloc>().add(
            ToggleFavorite(widget.journal.id),
          ),
          icon: Icon(
            widget.journal.isFavorite ? Icons.favorite : Icons.favorite_border,
          ),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary,
                child: IconButton(
                  onPressed: widget.journal.hasAudio ? _play : null,
                  icon: Icon(
                    _loading
                        ? Icons.hourglass_top
                        : _player.playing
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: AppColors.background,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.journal.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.journal.hasAudio
                          ? '${widget.journal.duration.inSeconds}s audio reflection'
                          : 'Written reflection',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.primaryLight),
              const SizedBox(width: 8),
              Text(
                'Mood: ${widget.journal.mood.label}',
                style: const TextStyle(color: AppColors.primaryLight),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          '${widget.journal.createdAt.day}/${widget.journal.createdAt.month}/${widget.journal.createdAt.year}',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        Text(
          widget.journal.transcript.isEmpty
              ? 'No transcription available. You can still listen to your original voice note.'
              : widget.journal.transcript,
          style: const TextStyle(
            fontSize: 17,
            height: 1.72,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    ),
  );
}

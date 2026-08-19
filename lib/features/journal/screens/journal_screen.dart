import 'package:echo_ink/features/journal/models/journal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/constants/colors.dart';
import '../bloc/journal_bloc.dart';
import '../bloc/journal_state.dart';
import 'journal_detail_screen.dart';
import 'add_journal_screen.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      title: const Text('Library'),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddJournalScreen()),
      ),
      icon: const Icon(Icons.edit),
      label: const Text('Write'),
    ),
    body: BlocBuilder<JournalBloc, JournalState>(
      builder: (context, state) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search entries',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('All Entries')),
                Chip(label: Text('This Week')),
                Chip(label: Text('Favorites ♥')),
              ],
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'YOUR JOURNAL',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: state.journals.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, index) {
                  final journal = state.journals[index];
                  return ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JournalDetailScreen(journal: journal),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    tileColor: AppColors.surface,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.surfaceElevated,
                      child: Text(journal.mood.emoji),
                    ),
                    title: Text(
                      journal.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      journal.transcript.isEmpty
                          ? 'Voice note'
                          : journal.transcript,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(
                      journal.isFavorite
                          ? Icons.favorite
                          : journal.hasAudio
                          ? Icons.play_circle_outline
                          : Icons.chevron_right,
                      color: AppColors.primaryLight,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

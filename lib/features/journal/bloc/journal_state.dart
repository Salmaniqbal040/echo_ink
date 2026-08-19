import 'package:equatable/equatable.dart';
import '../models/journal_model.dart';
enum JournalStatus { initial, loading, ready, recording, processing, failure }
class JournalState extends Equatable { const JournalState({this.journals = const [], this.status = JournalStatus.initial, this.selectedMood = JournalMood.reflective}); final List<JournalModel> journals; final JournalStatus status; final JournalMood selectedMood; JournalState copyWith({List<JournalModel>? journals, JournalStatus? status, JournalMood? selectedMood}) => JournalState(journals: journals ?? this.journals, status: status ?? this.status, selectedMood: selectedMood ?? this.selectedMood); @override List<Object> get props => [journals, status, selectedMood]; }

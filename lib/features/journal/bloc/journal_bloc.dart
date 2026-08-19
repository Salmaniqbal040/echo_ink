import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/journal_model.dart';
import '../repository/journal_repository.dart';
import 'journal_event.dart';
import 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> { JournalBloc(this._repository) : super(const JournalState()) { on<LoadJournals>(_onLoad); on<AddJournal>(_onAdd); on<SelectMood>((event, emit) => emit(state.copyWith(selectedMood: event.mood))); on<DeleteJournalRequested>(_onDelete); on<ToggleFavorite>(_onFavorite); } final JournalRepository _repository;
  Future<void> _onLoad(LoadJournals event, Emitter<JournalState> emit) async { emit(state.copyWith(status: JournalStatus.loading)); emit(state.copyWith(journals: await _repository.getJournals(), status: JournalStatus.ready)); }
  Future<void> _onAdd(AddJournal event, Emitter<JournalState> emit) async { await _repository.addJournal(JournalModel(id: DateTime.now().microsecondsSinceEpoch.toString(), title: event.title, transcript: event.transcript, createdAt: DateTime.now(), mood: event.mood, duration: event.duration, audioPath: event.audioPath)); emit(state.copyWith(journals: await _repository.getJournals(), status: JournalStatus.ready)); }
  Future<void> _onDelete(DeleteJournalRequested event, Emitter<JournalState> emit) async { await _repository.deleteJournal(event.id); emit(state.copyWith(journals: await _repository.getJournals())); }
  void _onFavorite(ToggleFavorite event, Emitter<JournalState> emit) => emit(state.copyWith(journals: [for (final journal in state.journals) journal.id == event.id ? journal.copyWith(isFavorite: !journal.isFavorite) : journal])); }

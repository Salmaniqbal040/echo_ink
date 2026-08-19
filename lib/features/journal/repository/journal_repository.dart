import 'package:hive_ce/hive.dart';
import '../models/journal_model.dart';
abstract class JournalRepository { Future<List<JournalModel>> getJournals(); Future<void> addJournal(JournalModel journal); Future<void> deleteJournal(String id); }
class HiveJournalRepository implements JournalRepository { HiveJournalRepository(this._box); final Box<dynamic> _box; @override Future<void> addJournal(JournalModel journal) => _box.put(journal.id, journal.toMap()); @override Future<void> deleteJournal(String id) => _box.delete(id); @override Future<List<JournalModel>> getJournals() async { final journals = _box.values.map((value) => JournalModel.fromMap(Map<dynamic, dynamic>.from(value as Map))).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt)); return journals; } }

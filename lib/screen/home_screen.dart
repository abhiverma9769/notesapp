import 'package:JaiShreeRam/screen/view_note_screen.dart';
import 'package:flutter/material.dart';

import '../model/note_model.dart';
import '../serives/database_helper.dart';
import 'add_edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  bool _showActions = false;
  int _selectedIndex = -1;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _searchController.addListener(_filterNotes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    final notes = await _databaseHelper.getNotes();
    setState(() {
      _notes = notes;
      _filteredNotes = notes;
    });
  }

  void _filterNotes() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredNotes = _notes.where((note) {
        return note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query);
      }).toList();
    });
  }

  String _formatDateTime(String datetime) {
    final DateTime dt = DateTime.parse(datetime);
    final now = DateTime.now();

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }

    return '${dt.day}/${dt.month}/${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar:  AppBar(
    backgroundColor: Colors.white,
      elevation: 1,
      title: _isSearching
          ? TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search notes...',
          hintStyle: TextStyle(color: Colors.black54),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.black),
      )
          : const Text(
        'NotesApp',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isSearching ? Icons.close : Icons.search,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              if (_isSearching) {
                _isSearching = false;
                _searchController.clear();
                _filteredNotes = _notes; // Reset list
              } else {
                _isSearching = true;
              }
            });
          },
        ),
      ],
    ),

    body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _filteredNotes.isEmpty
            ? const Center(child: Text('No notes found.'))
            : ListView.builder(
          itemCount: _filteredNotes.length,
          itemBuilder: (context, index) {
            final note = _filteredNotes[index];
            final color = Color(int.parse(note.color));

            return GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewNoteScreen(note: note),
                  ),
                );
                _loadNotes();
              },
              onLongPress: () {
                setState(() {
                  _showActions = true;
                  _selectedIndex = index;
                });
              },
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16, right: 10),
                    constraints: const BoxConstraints(minHeight: 120),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          note.content,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _formatDateTime(note.datetime),
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  if (_showActions && _selectedIndex == index)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.white),
                              onPressed: () async {
                                setState(() => _showActions = false);
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddEditNoteScreen(note: note),
                                  ),
                                );
                                _loadNotes();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.white),
                              onPressed: () async {
                                await _databaseHelper
                                    .deleteNote(note.id!);
                                setState(() => _showActions = false);
                                _loadNotes();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditNoteScreen(),
            ),
          );
          _loadNotes();
        },
        backgroundColor: const Color(0xFF50C878),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

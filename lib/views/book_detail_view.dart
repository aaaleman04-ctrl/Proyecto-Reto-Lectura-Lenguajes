import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookDetailView extends StatefulWidget {
  final String bookId;

  const BookDetailView({super.key, required this.bookId});

  @override
  State<BookDetailView> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailView> {
  final TextEditingController _pagesController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;
  
  String title = '';
  String author = '';
  String? imageUrl;
  String status = 'Pendiente';
  int totalPages = 0;
  int pagesRead = 0;
  int totalReadingTime = 0; // en segundos

  @override
  void initState() {
    super.initState();
    _loadBookData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pagesController.dispose();
    super.dispose();
  }

  Future<void> _loadBookData() async {
    try {
      // Obtener userId del usuario actual (necesitas implementar esto según tu auth)
      String userId = 'YOUR_USER_ID'; // Reemplazar con el userId real
      
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('books')
          .doc(widget.bookId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          title = data['title'] ?? '';
          author = data['author'] ?? '';
          imageUrl = data['imageUrl'];
          status = data['status'] ?? 'Pendiente';
          totalPages = data['totalPages'] ?? 0;
          pagesRead = data['pagesRead'] ?? 0;
          totalReadingTime = data['totalReadingTime'] ?? 0;
          _pagesController.text = pagesRead.toString();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: $e')),
      );
    }
  }

  void _startStopTimer() {
    if (_isRunning) {
      _timer?.cancel();
      _saveReadingTime();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _seconds++;
        });
      });
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  Future<void> _saveReadingTime() async {
    try {
      String userId = 'YOUR_USER_ID'; // Reemplazar con el userId real
      
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('books')
          .doc(widget.bookId)
          .update({
        'totalReadingTime': totalReadingTime + _seconds,
      });
      
      setState(() {
        totalReadingTime += _seconds;
        _seconds = 0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar tiempo: $e')),
      );
    }
  }

  Future<void> _updatePagesRead() async {
    final newPages = int.tryParse(_pagesController.text) ?? pagesRead;
    
    if (newPages < 0 || newPages > totalPages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Número de páginas inválido')),
      );
      return;
    }

    try {
      String userId = 'YOUR_USER_ID'; // Reemplazar con el userId real
      
      String newStatus = status;
      if (newPages == totalPages) {
        newStatus = 'Finalizado';
      } else if (newPages > 0) {
        newStatus = 'En progreso';
      } else {
        newStatus = 'Pendiente';
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('books')
          .doc(widget.bookId)
          .update({
        'pagesRead': newPages,
        'status': newStatus,
      });

      setState(() {
        pagesRead = newPages;
        status = newStatus;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Progreso actualizado')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: $e')),
      );
    }
  }

  String _formatTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = totalPages > 0 ? (pagesRead / totalPages) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguimiento de Lectura'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con imagen y título
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: imageUrl != null && imageUrl!.isNotEmpty
                          ? Image.network(
                              imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.book, size: 60),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.book, size: 60),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    author,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progreso del libro
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Progreso',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${(progress * 100).toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 10,
                            borderRadius: BorderRadius.circular(5),
                            backgroundColor: Colors.grey[300],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$pagesRead de $totalPages páginas',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Cronómetro
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Cronómetro de Lectura',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _formatTime(_seconds),
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _startStopTimer,
                                icon: Icon(
                                  _isRunning ? Icons.pause : Icons.play_arrow,
                                ),
                                label: Text(
                                  _isRunning ? 'Pausar' : 'Iniciar',
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tiempo total: ${_formatTime(totalReadingTime)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Actualizar páginas leídas
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Actualizar Progreso',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _pagesController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Páginas leídas',
                              border: const OutlineInputBorder(),
                              suffixText: '/ $totalPages',
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _updatePagesRead,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: const Text('Guardar Progreso'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
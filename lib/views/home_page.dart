import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Importar tus archivos
// import 'widgets/book_card.dart';
// import 'dialogs/add_book_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reto de Lectura'),
        actions: [
          // Botón para agregar libro
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Llamar al bottom sheet
              showAddBookDialog(context);
            },
            tooltip: 'Agregar libro',
          ),
        ],
      ),
      body: user == null
          ? const Center(
              child: Text('No has iniciado sesión'),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .doc(user.uid)
                  .collection('books')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final books = snapshot.data?.docs ?? [];

                if (books.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tienes libros aún',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Presiona el botón + para agregar tu primer libro',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            showAddBookDialog(context);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Agregar Libro'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    // Información del reto
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Reto 12 Libros al Año',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${books.length}',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                ' / 12',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            books.length < 12
                                ? 'Puedes agregar ${12 - books.length} libro${12 - books.length == 1 ? '' : 's'} más'
                                : '¡Has completado tu lista!',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Lista de libros
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          final data = book.data() as Map<String, dynamic>;

                          return BookCard(
                            bookId: book.id,
                            title: data['title'] ?? 'Sin título',
                            author: data['author'] ?? 'Autor desconocido',
                            imageUrl: data['imageUrl'],
                            status: data['status'] ?? 'Pendiente',
                            totalPages: data['totalPages'] ?? 0,
                            pagesRead: data['pagesRead'] ?? 0,
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

// Esta es la clase BookCard (deberías tenerla en un archivo separado)
class BookCard extends StatelessWidget {
  final String bookId;
  final String title;
  final String author;
  final String? imageUrl;
  final String status;
  final int totalPages;
  final int pagesRead;

  const BookCard({
    super.key,
    required this.bookId,
    required this.title,
    required this.author,
    this.imageUrl,
    required this.status,
    required this.totalPages,
    required this.pagesRead,
  });

  Color _getStatusColor() {
    switch (status) {
      case 'Finalizado':
        return Colors.green;
      case 'En progreso':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = totalPages > 0 ? (pagesRead / totalPages) : 0.0;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navegar a la pantalla de detalle
          // context.push('/book-detail/$bookId');
        },
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 180,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Container(
                  width: 120,
                  color: Colors.grey[300],
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.book,
                              size: 60,
                              color: Colors.grey,
                            );
                          },
                        )
                      : const Icon(
                          Icons.book,
                          size: 60,
                          color: Colors.grey,
                        ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            author,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 12,
                                color: _getStatusColor(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getStatusColor(),
                                ),
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$pagesRead / $totalPages páginas (${(progress * 100).toStringAsFixed(0)}%)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Función para mostrar el diálogo (deberías tenerla en add_book_dialog.dart)
void showAddBookDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const AddBookDialog(),
  );
}

// Placeholder del AddBookDialog
class AddBookDialog extends StatelessWidget {
  const AddBookDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: const Text('Formulario para agregar libro'),
    );
  }
}
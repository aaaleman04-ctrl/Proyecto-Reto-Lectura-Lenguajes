import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBookDialog extends StatefulWidget {
  const AddBookDialog({super.key});

  @override
  State<AddBookDialog> createState() => _AddBookDialogState();
}

class _AddBookDialogState extends State<AddBookDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _totalPagesController = TextEditingController();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _imageUrlController.dispose();
    _totalPagesController.dispose();
    super.dispose();
  }

  Future<void> _addBook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String userId = 'YOUR_USER_ID'; // Reemplazar con el userId real
      
      // Verificar que no tenga más de 12 libros
      final booksSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('books')
          .get();

      if (booksSnapshot.docs.length >= 12) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ya has alcanzado el límite de 12 libros para el reto'),
            ),
          );
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Agregar el libro
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('books')
          .add({
        'title': _titleController.text.trim(),
        'author': _authorController.text.trim(),
        'imageUrl': _imageUrlController.text.trim(),
        'status': 'Pendiente',
        'totalPages': int.parse(_totalPagesController.text),
        'pagesRead': 0,
        'totalReadingTime': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Libro agregado exitosamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar libro: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle para el bottom sheet
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                const Text(
                  'Agregar Nuevo Libro',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Completa la información del libro para tu reto de lectura',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),

                // Campo Título
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título del libro *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.book),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa el título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo Autor
                TextFormField(
                  controller: _authorController,
                  decoration: const InputDecoration(
                    labelText: 'Autor *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa el autor';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo URL de imagen
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'URL de la portada (opcional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.image),
                    hintText: 'https://ejemplo.com/portada.jpg',
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),

                // Campo Total de páginas
                TextFormField(
                  controller: _totalPagesController,
                  decoration: const InputDecoration(
                    labelText: 'Total de páginas *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa el total de páginas';
                    }
                    final pages = int.tryParse(value);
                    if (pages == null || pages <= 0) {
                      return 'Ingresa un número válido mayor a 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Botones
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _addBook,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text('Agregar'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Función helper para mostrar el bottom sheet desde cualquier parte
void showAddBookDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const AddBookDialog(),
  );
}
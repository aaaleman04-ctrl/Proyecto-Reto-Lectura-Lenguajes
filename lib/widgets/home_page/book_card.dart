import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookCard extends StatelessWidget {
  final String bookId;
  final String title;
  final String author;
  final String? imageUrl;
  final String status; // "Pendiente", "En progreso", "Finalizado"
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          context.push('/book-detail/$bookId');
        },
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 180,
          child: Row(
            children: [
              // Imagen del libro
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
              // Información del libro
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
                          // Chip de estado
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
                          // Barra de progreso
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int totalBooks = 0;
  int booksFinished = 0;
  int booksInProgress = 0;
  int booksPending = 0;
  int totalPages = 0;
  int totalMinutesRead = 0;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final booksSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('books')
          .get();

      int finished = 0;
      int inProgress = 0;
      int pending = 0;
      int pages = 0;
      int minutes = 0;

      for (var doc in booksSnapshot.docs) {
        final data = doc.data();
        final status = data['status'] ?? 'Pendiente';
        
        if (status == 'Finalizado') {
          finished++;
        } else if (status == 'En progreso') {
          inProgress++;
        } else {
          pending++;
        }

        pages += (data['pagesRead'] ?? 0) as int;
        minutes += ((data['totalReadingTime'] ?? 0) / 60).round() as int;
      }

      setState(() {
        totalBooks = booksSnapshot.docs.length;
        booksFinished = finished;
        booksInProgress = inProgress;
        booksPending = pending;
        totalPages = pages;
        totalMinutesRead = minutes;
      });
    } catch (e) {
      print('Error loading statistics: $e');
    }
  }

  Future<void> _signOut() async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (shouldSignOut == true) {
      await _auth.signOut();
      // Navegar a la pantalla de login
      // context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final progress = totalBooks > 0 ? (booksFinished / 12) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con información del usuario
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.displayName ?? 'Usuario',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      fontSize: 14,
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
                  // Progreso del reto
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Reto 12 Libros',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${(progress * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 12,
                            borderRadius: BorderRadius.circular(6),
                            backgroundColor: Colors.grey[300],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '$booksFinished de 12 libros completados',
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

                  // Estadísticas
                  const Text(
                    'Estadísticas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Grid de estadísticas
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _buildStatCard(
                        'Total de Libros',
                        totalBooks.toString(),
                        Icons.book,
                        Colors.blue,
                      ),
                      _buildStatCard(
                        'Finalizados',
                        booksFinished.toString(),
                        Icons.check_circle,
                        Colors.green,
                      ),
                      _buildStatCard(
                        'En Progreso',
                        booksInProgress.toString(),
                        Icons.schedule,
                        Colors.orange,
                      ),
                      _buildStatCard(
                        'Pendientes',
                        booksPending.toString(),
                        Icons.pending,
                        Colors.grey,
                      ),
                      _buildStatCard(
                        'Páginas Leídas',
                        totalPages.toString(),
                        Icons.pages,
                        Colors.purple,
                      ),
                      _buildStatCard(
                        'Minutos de Lectura',
                        totalMinutesRead.toString(),
                        Icons.timer,
                        Colors.red,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Opciones
                  Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Editar Perfil'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // Implementar edición de perfil
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Función en desarrollo'),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text('Configuración'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // Implementar configuración
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Función en desarrollo'),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.info_outline),
                          title: const Text('Acerca de'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            showAboutDialog(
                              context: context,
                              applicationName: 'Reto de Lectura',
                              applicationVersion: '1.0.0',
                              applicationLegalese: '© 2024 Reto de Lectura',
                              children: [
                                const SizedBox(height: 16),
                                const Text(
                                  'Una aplicación para motivarte a leer 12 libros al año.',
                                ),
                              ],
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                          title: const Text(
                            'Cerrar Sesión',
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: _signOut,
                        ),
                      ],
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

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
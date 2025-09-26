import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../vistamodelos/home_viewmodel.dart';

/// Vista principal con diseño original - Sistema de diagnóstico cardiovascular
class HomeVista extends StatefulWidget {
  const HomeVista({super.key});

  @override
  State<HomeVista> createState() => _HomeVistaState();
}

class _HomeVistaState extends State<HomeVista> {
  @override
  void initState() {
    super.initState();
    // Inicializar datos del usuario al cargar la vista
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().inicializarDatos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8DC), // Fondo crema como en las imágenes
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con imagen de fondo y bienvenida como en la imagen original
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.orange.shade800,
                    Colors.orange.shade600,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Imagen de fondo médico (simulada con iconos)
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.3,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/medical_bg.jpg'), // Si tienes la imagen
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 150,
                          color: Colors.white30,
                        ),
                      ),
                    ),
                  ),
                  // Contenido del header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // Botón de atrás y configuración
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => context.go('/login'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.menu, color: Colors.white),
                              onPressed: () => _mostrarDialogoSalir(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Bienvenida con email del usuario
                        Consumer<HomeViewModel>(
                          builder: (context, viewModel, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Bienvenido',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  'usuario@gmail.com', // Cambiamos esto por dato fijo por ahora
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        // Título principal
                        const Text(
                          'Bienvenido A Salud Del\nCorazón',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const Text(
                          'Tu aliado en la prevención y diagnóstico de enfermedades cardíacas',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Contenido principal
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección "Enfermedades Cardíacas Comunes" como en la imagen
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enfermedades Cardíacas\nComunes',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Infarto de Miocardio',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'También conocido como ataque al corazón, ocurre cuando se interrumpe el flujo sanguíneo al corazón, causando daño o muerte del tejido cardíaco.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Arritmia',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Alteración del ritmo cardíaco, lo que significa que el corazón late demasiado lento o de manera irregular.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Botones de navegación principales como en la imagen
                  _buildBotonNavegacion(
                    context,
                    'Diagnóstico',
                    Icons.favorite,
                    Colors.orange.shade700,
                    '/diagnostico',
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildBotonNavegacion(
                    context,
                    'Panel de Administrador',
                    Icons.admin_panel_settings,
                    Colors.grey.shade600,
                    '/admin',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotonNavegacion(
    BuildContext context,
    String titulo,
    IconData icono,
    Color color,
    String ruta,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icono,
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => context.go(ruta),
      ),
    );
  }

  /// Muestra el diálogo de confirmación para cerrar sesión
  void _mostrarDialogoSalir(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Está seguro que desea cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<HomeViewModel>().cerrarSesion();
                context.go('/login');
              },
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
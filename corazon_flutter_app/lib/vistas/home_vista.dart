import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../vistamodelos/home_viewmodel.dart';

/// Vista principal del sistema de diagnóstico cardiovascular
/// 
/// Proporciona el menú principal con opciones diferenciadas según el tipo de usuario:
/// - Pacientes: Acceso a diagnóstico, resultados y configuración
/// - Administradores: Panel de administración adicional
/// 
/// Integrado con HomeViewModel para manejo de estado y lógica de negocio
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
      appBar: AppBar(
        title: const Text(
          'Diagnóstico Cardiovascular',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _mostrarDialogoSalir(context),
          ),
        ],
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.estaCargando) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E86AB)),
              ),
            );
          }

          if (viewModel.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${viewModel.error}',
                    style: TextStyle(
                      color: Colors.red[600],
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.inicializarDatos(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2E86AB), Color(0xFFA23B72)],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Saludo personalizado
                    _construirSaludo(viewModel),
                    const SizedBox(height: 30),
                    
                    // Opciones del menú principal
                    Expanded(
                      child: _construirOpcionesMenu(context, viewModel),
                    ),
                    
                    // Información adicional
                    _construirInformacionAdicional(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Construye el saludo personalizado para el usuario
  Widget _construirSaludo(HomeViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.favorite,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          Text(
            'Bienvenido${viewModel.esAdmin ? ' Administrador' : ''}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (viewModel.nombreUsuario.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              viewModel.nombreUsuario,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Construye las opciones del menú según el tipo de usuario
  Widget _construirOpcionesMenu(BuildContext context, HomeViewModel viewModel) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: viewModel.opcionesMenu
          .map((opcion) => _construirTarjetaOpcion(context, opcion))
          .toList(),
    );
  }

  /// Construye una tarjeta individual para cada opción del menú
  Widget _construirTarjetaOpcion(BuildContext context, Map<String, dynamic> opcion) {
    return GestureDetector(
      onTap: () => _navegarA(context, opcion['ruta'] as String),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              opcion['icono'] as IconData,
              size: 48,
              color: const Color(0xFF2E86AB),
            ),
            const SizedBox(height: 12),
            Text(
              opcion['titulo'] as String,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E86AB),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              opcion['descripcion'] as String,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Construye información adicional en la parte inferior
  Widget _construirInformacionAdicional() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.white70,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Sistema de diagnóstico cardiovascular con inteligencia artificial',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Navega a la ruta especificada
  void _navegarA(BuildContext context, String ruta) {
    context.go(ruta);
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
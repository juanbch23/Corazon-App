import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vistamodelos/admin_viewmodel.dart';

/// Vista del panel administrativo del sistema cardiovascular
/// 
/// Proporciona funcionalidades administrativas incluyendo:
/// - Gestión de pacientes y usuarios
/// - Visualización de estadísticas del sistema
/// - Administración de diagnósticos realizados
/// - Configuración del sistema
/// 
/// Integrada con AdminViewModel para manejo de estado y lógica administrativa
class AdminVista extends StatefulWidget {
  const AdminVista({super.key});

  @override
  State<AdminVista> createState() => _AdminVistaState();
}

class _AdminVistaState extends State<AdminVista>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Cargar datos administrativos al inicializar la vista
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminViewModel>().cargarDatosAdmin();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Panel Administrativo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2E86AB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => context.read<AdminViewModel>().cargarDatosAdmin(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(
              icon: Icon(Icons.dashboard),
              text: 'Dashboard',
            ),
            Tab(
              icon: Icon(Icons.people),
              text: 'Pacientes',
            ),
            Tab(
              icon: Icon(Icons.medical_services),
              text: 'Diagnósticos',
            ),
            Tab(
              icon: Icon(Icons.settings),
              text: 'Sistema',
            ),
          ],
        ),
      ),
      body: Consumer<AdminViewModel>(
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
                    onPressed: () => viewModel.cargarDatosAdmin(),
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
            child: TabBarView(
              controller: _tabController,
              children: [
                _construirTabDashboard(viewModel),
                _construirTabPacientes(viewModel),
                _construirTabDiagnosticos(viewModel),
                _construirTabSistema(viewModel),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Construye la pestaña del dashboard con estadísticas generales
  Widget _construirTabDashboard(AdminViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tarjetas de estadísticas principales
          _construirTarjetasEstadisticas(viewModel),
          const SizedBox(height: 25),
          
          // Gráfico de diagnósticos recientes
          _construirSeccionGraficos(viewModel),
          const SizedBox(height: 25),
          
          // Actividad reciente
          _construirActividadReciente(viewModel),
        ],
      ),
    );
  }

  /// Construye las tarjetas de estadísticas principales
  Widget _construirTarjetasEstadisticas(AdminViewModel viewModel) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _construirTarjetaEstadistica(
          titulo: 'Total Pacientes',
          valor: viewModel.estadisticas['totalPacientes']?.toString() ?? '0',
          icono: Icons.people,
          color: const Color(0xFF4CAF50),
        ),
        _construirTarjetaEstadistica(
          titulo: 'Diagnósticos Hoy',
          valor: viewModel.estadisticas['diagnosticosHoy']?.toString() ?? '0',
          icono: Icons.medical_services,
          color: const Color(0xFF2196F3),
        ),
        _construirTarjetaEstadistica(
          titulo: 'Riesgo Alto',
          valor: viewModel.estadisticas['riesgoAlto']?.toString() ?? '0',
          icono: Icons.warning,
          color: const Color(0xFFF44336),
        ),
        _construirTarjetaEstadistica(
          titulo: 'Sistema Activo',
          valor: '${viewModel.estadisticas['uptime'] ?? '0'}h',
          icono: Icons.check_circle,
          color: const Color(0xFF9C27B0),
        ),
      ],
    );
  }

  /// Construye una tarjeta individual de estadística
  Widget _construirTarjetaEstadistica({
    required String titulo,
    required String valor,
    required IconData icono,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Icon(icono, size: 40, color: color),
          const SizedBox(height: 8),
          Text(
            valor,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Construye la sección de gráficos
  Widget _construirSeccionGraficos(AdminViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bar_chart, color: Color(0xFF2E86AB)),
              SizedBox(width: 8),
              Text(
                'Diagnósticos por Categoría',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E86AB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Aquí iría un gráfico real - por ahora mostramos datos textuales
          _construirGraficoSimulado(viewModel),
        ],
      ),
    );
  }

  /// Construye un gráfico simulado con barras de progreso
  Widget _construirGraficoSimulado(AdminViewModel viewModel) {
    final categorias = [
      {'nombre': 'Riesgo Bajo', 'valor': 65, 'color': Colors.green},
      {'nombre': 'Riesgo Medio', 'valor': 25, 'color': Colors.orange},
      {'nombre': 'Riesgo Alto', 'valor': 10, 'color': Colors.red},
    ];

    return Column(
      children: categorias.map((categoria) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  categoria['nombre'] as String,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Expanded(
                flex: 3,
                child: LinearProgressIndicator(
                  value: (categoria['valor'] as int) / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    categoria['color'] as Color,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${categoria['valor']}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Construye la sección de actividad reciente
  Widget _construirActividadReciente(AdminViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.history, color: Color(0xFF2E86AB)),
              SizedBox(width: 8),
              Text(
                'Actividad Reciente',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E86AB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...viewModel.actividadReciente.map((actividad) {
            return _construirItemActividad(actividad);
          }).toList(),
        ],
      ),
    );
  }

  /// Construye un item individual de actividad
  Widget _construirItemActividad(Map<String, dynamic> actividad) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _obtenerColorActividad(actividad['tipo']),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  actividad['descripcion'] ?? '',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  actividad['timestamp'] ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Obtiene el color según el tipo de actividad
  Color _obtenerColorActividad(String? tipo) {
    switch (tipo) {
      case 'diagnostico':
        return Colors.blue;
      case 'registro':
        return Colors.green;
      case 'error':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Construye la pestaña de gestión de pacientes
  Widget _construirTabPacientes(AdminViewModel viewModel) {
    return Column(
      children: [
        // Barra de búsqueda y filtros
        _construirBarraBusquedaPacientes(viewModel),
        
        // Lista de pacientes
        Expanded(
          child: _construirListaPacientes(viewModel),
        ),
      ],
    );
  }

  /// Construye la barra de búsqueda para pacientes
  Widget _construirBarraBusquedaPacientes(AdminViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: viewModel.buscarPacientes,
        decoration: InputDecoration(
          hintText: 'Buscar pacientes...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  /// Construye la lista de pacientes
  Widget _construirListaPacientes(AdminViewModel viewModel) {
    if (viewModel.pacientesFiltrados.isEmpty) {
      return const Center(
        child: Text(
          'No se encontraron pacientes',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: viewModel.pacientesFiltrados.length,
      itemBuilder: (context, index) {
        final paciente = viewModel.pacientesFiltrados[index];
        return _construirTarjetaPaciente(paciente);
      },
    );
  }

  /// Construye una tarjeta individual de paciente
  Widget _construirTarjetaPaciente(Map<String, dynamic> paciente) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF2E86AB),
          child: Text(
            (paciente['nombre'] as String? ?? '').isNotEmpty
                ? (paciente['nombre'] as String)[0].toUpperCase()
                : '?',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          '${paciente['nombre'] ?? ''} ${paciente['apellidos'] ?? ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${paciente['email'] ?? 'N/A'}'),
            Text('Edad: ${paciente['edad'] ?? 'N/A'} años'),
            Text('Último diagnóstico: ${paciente['ultimoDiagnostico'] ?? 'Nunca'}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _manejarAccionPaciente(value, paciente),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'ver',
              child: Text('Ver Historial'),
            ),
            const PopupMenuItem(
              value: 'editar',
              child: Text('Editar'),
            ),
            const PopupMenuItem(
              value: 'eliminar',
              child: Text('Eliminar'),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  /// Maneja las acciones sobre un paciente
  void _manejarAccionPaciente(String accion, Map<String, dynamic> paciente) {
    switch (accion) {
      case 'ver':
        // Implementar vista de historial
        _mostrarSnackBar('Abriendo historial de ${paciente['nombre']}');
        break;
      case 'editar':
        // Implementar edición de paciente
        _mostrarSnackBar('Editando paciente ${paciente['nombre']}');
        break;
      case 'eliminar':
        _confirmarEliminacionPaciente(paciente);
        break;
    }
  }

  /// Confirma la eliminación de un paciente
  void _confirmarEliminacionPaciente(Map<String, dynamic> paciente) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text(
          '¿Está seguro que desea eliminar al paciente ${paciente['nombre']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AdminViewModel>().eliminarPaciente(paciente['id']);
              _mostrarSnackBar('Paciente eliminado');
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la pestaña de diagnósticos
  Widget _construirTabDiagnosticos(AdminViewModel viewModel) {
    return Center(
      child: Text(
        'Gestión de Diagnósticos\n(En desarrollo)',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Construye la pestaña de configuración del sistema
  Widget _construirTabSistema(AdminViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _construirTarjetaConfiguracion(
            titulo: 'Configuración del Modelo IA',
            descripcion: 'Ajustar parámetros del modelo de diagnóstico',
            icono: Icons.psychology,
            onTap: () => _mostrarSnackBar('Configuración de IA'),
          ),
          const SizedBox(height: 16),
          _construirTarjetaConfiguracion(
            titulo: 'Base de Datos',
            descripcion: 'Gestionar respaldos y mantenimiento',
            icono: Icons.storage,
            onTap: () => _mostrarSnackBar('Configuración de BD'),
          ),
          const SizedBox(height: 16),
          _construirTarjetaConfiguracion(
            titulo: 'Logs del Sistema',
            descripcion: 'Ver registros y eventos del sistema',
            icono: Icons.list_alt,
            onTap: () => _mostrarSnackBar('Logs del sistema'),
          ),
          const SizedBox(height: 16),
          _construirTarjetaConfiguracion(
            titulo: 'Usuarios Administradores',
            descripcion: 'Gestionar permisos de administración',
            icono: Icons.admin_panel_settings,
            onTap: () => _mostrarSnackBar('Gestión de admins'),
          ),
        ],
      ),
    );
  }

  /// Construye una tarjeta de configuración
  Widget _construirTarjetaConfiguracion({
    required String titulo,
    required String descripcion,
    required IconData icono,
    required VoidCallback onTap,
  }) {
    return Container(
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
      child: ListTile(
        leading: Icon(icono, color: const Color(0xFF2E86AB), size: 30),
        title: Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(descripcion),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  /// Muestra un SnackBar con el mensaje especificado
  void _mostrarSnackBar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';

class PanelAdministracion extends StatefulWidget {
  const PanelAdministracion({super.key});

  @override
  State<PanelAdministracion> createState() => _PanelAdministracionState();
}

class _PanelAdministracionState extends State<PanelAdministracion> {
  final ApiService _servicioApi = ApiService();
  
  List<dynamic> _pacientes = [];
  bool _estaCargando = true;
  String? _mensajeError;

  @override
  void initState() {
    super.initState();
    _cargarPacientes();
  }

  Future<void> _cargarPacientes() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final respuesta = await _servicioApi.obtenerPacientesAdmin(
        username: authProvider.username
      );
      setState(() {
        _pacientes = respuesta['pacientes'] ?? [];
        _estaCargando = false;
      });
    } catch (e) {
      setState(() {
        _mensajeError = 'Acceso no autorizado o error al cargar datos: $e';
        _estaCargando = false;
      });
    }
  }

  String _formatearFecha(String? fecha) {
    if (fecha == null || fecha.isEmpty) return "Sin registros";
    
    try {
      final fechaObj = DateTime.parse(fecha);
      return '${fechaObj.day}/${fechaObj.month}/${fechaObj.year} ${fechaObj.hour}:${fechaObj.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return "Sin registros";
    }
  }

  void _verHistorial(String pacienteId) {
    context.push('/admin/diagnosticos/$pacienteId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin'),
        ),
      ),
      body: _estaCargando
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando pacientes...'),
                ],
              ),
            )
          : _mensajeError != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          size: 80,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error de Acceso',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.red.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _mensajeError!,
                          style: TextStyle(
                            color: Colors.red.shade500,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => context.go('/home'),
                          child: const Text('Volver al Inicio'),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Título con icono
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.admin_panel_settings,
                            size: 32,
                            color: Colors.orange.shade600,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Gestión de Pacientes',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Card con estadísticas
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '${_pacientes.length}',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade600,
                                  ),
                                ),
                                const Text('Pacientes Registrados'),
                              ],
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.orange.shade300,
                            ),
                            Column(
                              children: [
                                Text(
                                  '${_pacientes.where((p) => p[4] > 0).length}',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade600,
                                  ),
                                ),
                                const Text('Con Diagnósticos'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tabla de pacientes
                      if (_pacientes.isEmpty)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 80,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No hay pacientes registrados',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Card(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Usuario')),
                                DataColumn(label: Text('Nombre')),
                                DataColumn(label: Text('Total Diagnósticos')),
                                DataColumn(label: Text('Último Diagnóstico')),
                                DataColumn(label: Text('Acción')),
                              ],
                              rows: _pacientes.map((paciente) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(paciente[1] ?? '')),
                                    DataCell(Text('${paciente[2] ?? ''} ${paciente[3] ?? ''}')),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _obtenerColorDiagnosticos(paciente[4]),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '${paciente[4]}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(Text(_formatearFecha(paciente[5]))),
                                    DataCell(
                                      ElevatedButton.icon(
                                        onPressed: () => _verHistorial(paciente[0].toString()),
                                        icon: const Icon(Icons.history, size: 16),
                                        label: const Text('Ver Historial'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange.shade600,
                                          foregroundColor: Colors.white,
                                          minimumSize: const Size(120, 32),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }

  Color _obtenerColorDiagnosticos(int cantidad) {
    if (cantidad == 0) return Colors.grey.shade400;
    if (cantidad <= 5) return Colors.orange.shade600;
    if (cantidad <= 10) return Colors.orange.shade600;
    return Colors.red.shade600;
  }
}

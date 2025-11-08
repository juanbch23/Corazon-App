import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';

class ResultadosScreen extends StatefulWidget {
  final Map<String, dynamic>? diagnosticoData;
  
  const ResultadosScreen({super.key, this.diagnosticoData});

  @override
  State<ResultadosScreen> createState() => _ResultadosScreenState();
}

class _ResultadosScreenState extends State<ResultadosScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? diagnostico;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.diagnosticoData != null) {
      diagnostico = widget.diagnosticoData;
      isLoading = false;
    } else {
      _cargarResultados();
    }
  }

  Future<void> _cargarResultados() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await _apiService.obtenerResultados(
        username: authProvider.username
      );
      setState(() {
        diagnostico = response['diagnostico'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar resultados: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _obtenerTextoRiesgo(int nivel) {
    switch (nivel) {
      case 0:
        return 'Bajo';
      case 1:
        return 'Medio';
      case 2:
        return 'Alto';
      default:
        return 'Desconocido';
    }
  }

  Color _obtenerColorRiesgo(int nivel) {
    switch (nivel) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _obtenerMensajeRiesgo(int nivel) {
    switch (nivel) {
      case 0:
        return '¡Estás en buen estado!';
      case 1:
        return 'Precaución: cuida tus hábitos';
      case 2:
        return '¡Alerta! Riesgo alto, consulta urgente';
      default:
        return 'Estado desconocido';
    }
  }

  List<String> _obtenerRecomendaciones(int nivel) {
    switch (nivel) {
      case 0:
        return [
          'Continúa con tus hábitos saludables',
          'Realiza chequeos médicos anuales',
          'Mantén una dieta equilibrada',
          'Ejercítate regularmente'
        ];
      case 1:
        return [
          'Mejora tu dieta y reduce grasas saturadas',
          'Aumenta la actividad física gradualmente',
          'Consulta a un especialista en cardiología',
          'Reduce el consumo de sal y azúcar',
          'Controla tu peso corporal'
        ];
      case 2:
        return [
          'Consulta urgentemente con un cardiólogo',
          'Necesitas atención médica inmediata',
          'Evita esfuerzos físicos intensos',
          'Toma medicación según prescripción médica',
          'Realiza seguimiento médico frecuente'
        ];
      default:
        return ['Consulta con un profesional médico'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text('Resultados del Diagnóstico'),
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  if (authProvider.isAdmin) {
                    context.go('/admin');
                  } else {
                    context.go('/home');
                  }
                },
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando resultados...'),
                ],
              ),
            )
          : diagnostico != null
              ? _buildResultados()
              : _buildSinResultados(),
    );
  }

  Widget _buildResultados() {
    final riesgo = diagnostico!['riesgo'] as int;
    final confianza = (diagnostico!['confianza'] as double) * 100;
    final fechaString = diagnostico!['fecha'] as String?;
    final fecha = fechaString != null ? DateTime.parse(fechaString) : DateTime.now();
    final color = _obtenerColorRiesgo(riesgo);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card principal con el gráfico y resultados
          Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Título con icono
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assessment,
                        size: 32,
                        color: Colors.orange.shade600,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Tu Diagnóstico',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Gráfico circular de confianza
                  SizedBox(
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            startDegreeOffset: -90,
                            sectionsSpace: 2,
                            centerSpaceRadius: 70,
                            sections: [
                              PieChartSectionData(
                                value: confianza,
                                color: color,
                                radius: 20,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                value: 100 - confianza,
                                color: Colors.grey.shade200,
                                radius: 15,
                                showTitle: false,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${confianza.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                            Text(
                              'Confianza',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nivel de riesgo
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite,
                              color: color,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Nivel de Riesgo: ${_obtenerTextoRiesgo(riesgo)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _obtenerMensajeRiesgo(riesgo),
                          style: TextStyle(
                            fontSize: 16,
                            color: color,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Fecha del diagnóstico
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Fecha: ${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Card de recomendaciones
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: Colors.amber.shade600,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Recomendaciones',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ..._obtenerRecomendaciones(riesgo).map((recomendacion) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: color,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              recomendacion,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Botones de acción
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/diagnostico'),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Nuevo Diagnóstico'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return OutlinedButton.icon(
                      onPressed: () {
                        if (authProvider.isAdmin) {
                          context.go('/admin');
                        } else {
                          context.go('/home');
                        }
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Inicio'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange.shade600,
                        side: BorderSide(color: Colors.orange.shade600),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSinResultados() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_late,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Sin Resultados',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aún no has realizado ningún diagnóstico.',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/diagnostico'),
              icon: const Icon(Icons.medical_services),
              label: const Text('Realizar Diagnóstico'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
